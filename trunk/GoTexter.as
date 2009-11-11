package {
  // Flash API
  import flash.display.MovieClip;
  import flash.text.TextField;
  import flash.text.TextFormat;
  import flash.text.AntiAliasType;
  import flash.text.TextFieldAutoSize;
  import flash.display.BitmapData;
  import flash.display.Bitmap;
  import flash.display.DisplayObjectContainer;
  import flash.display.DisplayObject;
  
  import Transitions.Together;
  import Effects.Fade;
  
  // Greensock's TweenMax
  import gs.TweenMax;
  import gs.easing.Linear;
  
  /**
   * This class is the wrapper and control for all text effects.
   */
  public class GoTexter extends MovieClip {
    private var _text:String;
    private var _textFormat:TextFormat;
    private var _fontName:String;
    private var _fontSize:Number;
    private var _fontColor:Object;
    //private var bold:Boolean = false;

    // Units
    private var _textElements:Array;
    public var textFields:Array;
    public var characters:Array;
    public var lines:Array;
    public var words:Array;
    
    // Points to the active set of items (chars, words, or lines)
    public var items:Array;
    
    // Which unit to use
    public var unit:String = "chars";
    
    // Bitmap buffering
    public var bitmapBuffering:Boolean = true;
    public var bitmaps:Array;
    public var bitmapDatas:Array;
    
    // Drawing and animation Defaults
    public var inTx:Class = Together;
    public var outTx:Class = Together;
    public var inFx:Class = Fade;
    public var outFx:Class = Fade;
    public var duration:Number = 5;
    public var ease:Function;
    public var justification:String = "center";
    
    public var callback:Function = null;
    
    private var debugOutline:Boolean = false;
    
    public var debugMode:Boolean = false;
            
    /**
     * This constructor stores the string, font, and pixel size.  It then
     * creates the text with those attributes.  Newlines must be represented
     * by either the \r character or the \n character--but not both!
     *
     * @param _text The content of the text to effect
     * @param _fontName The name of the embedded font
     * @param _fontSize The pixel size of the font
     * @param build If true, the constructor will build the text object right away
     */
    public function GoTexter(_text:String, _fontName:String, _fontSize:Number,
                           _fontColor:Object = null, buildImmediately:Boolean = false):void {
      this._text = _text;
      this._fontName = _fontName;
      this._fontSize = _fontSize;
      
      // The ease in and out default to Linear.easeNone
      // This is not a constant and must be set here
      ease = Linear.easeNone;
      
      _textFormat = new TextFormat();
      reformat(_fontName, _fontSize, _fontColor);
            
      if (buildImmediately) {
        build();
      }
    }
    
    public function set text(text:String):void {
      _text = text;
    }
    
    public function get text():String {
      return _text;
    }
    
    public function reformat(_fontName:String = null, _fontSize:Number = -1, _fontColor:Object = null):void {
      this._fontName = _fontName == null ? this._fontName : _fontName;
      this._fontSize = _fontSize == -1 ? this._fontSize : _fontSize;
      this._fontColor = _fontColor == null ? this._fontColor : _fontColor;
      //this.bold = bold == null ? this.bold : bold;
      
      //trace("bold:", this.bold);
      
      _textFormat.font = _fontName;
      _textFormat.size = _fontSize;
      _textFormat.color = _fontColor;
      //_textFormat.bold = false;
      
      //trace("Formatted: " + _textFormat.font + ", " + _textFormat.size + ", " + _textFormat.color);
    }
    
    public function animateBy(unit:String):void {
      this.unit = unit;
      
      setUnits();
    }
    
    private function setUnits():void {
      switch (unit) {
        case "char":
        case "chars":
        case "characters":
          items = characters;
          break;
        case "word":
        case "words":
          items = words;
          break;
        case "line":
        case "lines":
          items = lines;
          break;
        default:
          items = characters;
      }
    }
    
    /**
     * This function builds a three dimensional array of the text.  Array
     * hierarchy is as folows: Lines -> Words -> Characters.  Newlines are
     * dropped.
     */
    public function explodeText():void {
      var i:Number;
      var j:Number;
      var k:Number;
      var temp:Array;
      
      // Switch between \n, \r, or a single line
      // Prequisite: The text should only contain \r or \n, but not both
      if (_text.search('\r') != -1) {
        // Split at \r
        _textElements = _text.split('\r');
      } else if (_text.search('\n') != -1) {
        // Split at \n
        _textElements = _text.split('\n');        
      } else {
        // Don't split
        _textElements = new Array(_text);
      }
      
      // Walk the lines
      for (i = 0; i < _textElements.length; i++) {
        
        // Split the words and walk each
        _textElements[i] = _textElements[i].split(' ');
        for (j = 0; j < _textElements[i].length; j++) {
          temp = new Array();
          
          // Walk the characters
          for (k = 0; k < _textElements[i][j].length; k++) {
            if (_textElements[i][j].charAt(k) == '\r' || _textElements[i][j].charAt(k) == '\n') {
              // Don't add extra line breaks
              continue;
            }
            
            // Add the character
            temp.push(_textElements[i][j].charAt(k));
          }
          
          if (j < _textElements[i].length - 1) {
            // If not the last word, add a space
            temp.push(" ");
          }
          
          // Store these characters as a word
          _textElements[i][j] = temp;
        }
      }
    }
    
    public function debugDump():void {
      var i:Number;
      var j:Number;
      var k:Number;
      
      // Trace the text array
      trace(_textElements);
      for (i = 0; i < _textElements.length; i++) {
        trace('Line ' + (i + 1) + '/' + _textElements.length + ':');
        for (j = 0; j < _textElements[i].length; j++) {
          trace(' Word ' + (j + 1) + '/' + _textElements[i].length + ':');
          for (k = 0; k < _textElements[i][j].length; k++) {
            trace("  Letter " + (k + 1) + '/' + _textElements[i][j].length + ': ' + _textElements[i][j][k]);
          }
        }
      }
    }
    
    /**
     * Actually build or rebuild the text objects
     */
    public function build():void {      
      explodeText();
      if (debugMode) {
        debugDump();
      }
      
      var i:Number;
      var j:Number;
      var k:Number;
      var l:Number;
      
      var line:Number = 0;
      var word:Number = 0;
      var character:Number = 0;
      
      var xOffset:Number = 0;
      var yOffset:Number = 0;
     
      // Clear anything existing
      clear();
      
      // Create a new arrays to store the objects
      characters = new Array();
      textFields = new Array();
      lines = new Array();
      words = new Array();
      
      if (bitmapBuffering) {
        bitmapDatas = new Array();
        bitmaps = new Array();
      }      
      
      for (i = 0; i < _textElements.length; i++) {
        lines.push(new MovieClip());
        lines[line].name = "line" + line;      
        
        for (j = 0; j < _textElements[i].length; j++) {
          words.push(new MovieClip());
          words[word].name = "word" + word;
          
          for (k = 0; k < _textElements[i][j].length; k++) {
            buildTextField(_textElements[i][j][k]);
            textFields[character].name = "tf" + character;
            
            // Build the character's DisplayObject
            if (bitmapBuffering) {
              buildBitmapChar();
            } else {
              buildChar();
            }
            
            characters[character].name = "char" + character;
            words[word].addChild(characters[character]);
            
            // Position the character
            positionChar(k, character);
            
            character++;
          }
                    
          // Reposition all characters, so the word is centered in it's MC
          centerItems(characters, character - _textElements[i][j].length, character, words[word].width / 2);
          
          // Add the word, position it, and increment the words
          lines[line].addChild(words[word]);          
          positionWord(j, word);          
          word++;
        }
        
        // Reposition all words, so the line is centered in it's MC
        centerItems(words, word - _textElements[i].length, word, lines[line].width / 2);
        
        // Add this line and increment the lines
        addChild(lines[line]);                
        line++;
      }
      
      // Justify the text
      justify();
      
      // Set the units to animate by
      setUnits();
    }
    
    private function centerItems(items:Array, start:Number, end:Number, xOffset:Number):void {
      var i:Number;
      
      for (i = start; i < end; i++) {
        items[i].x -= xOffset;
      }
    }
    
    private function positionChar(item:Number, character:Number):void {
      if (item == 0) {
        // First character
        characters[character].x = characters[character].width / 2;
        characters[character].y = 0;
      } else {
        // Not first character
        characters[character].x = characters[character - 1].x + textFields[character - 1].textWidth / 2 + textFields[character].textWidth / 2;
        characters[character].y = 0;
      }
    }
    
    private function positionWord(item:Number, word:Number):void {
      if (item == 0) {
        // First word
        words[word].x = words[word].width / 2;
        words[word].y = 0;
      } else {  
        // Not first word
        words[word].x = words[word - 1].x + words[word - 1].width / 2 + words[word].width / 2;
        words[word].y = 0;
      }
    }
    
    private function justify():void {
      switch (justification) {
        case "left":
        case "Left":
          justifyLeft();
          break;
        case "right":  
        case "Right":
          justifyRight();
          break;
        case "center":  
        case "Center":
          justifyCenter();
          break;
        default:
          break;
      }
    }
    
    private function justifyLeft():void {
      var line:Number = 0;
      for (line = 0; line < lines.length; line++) {
        if (line == 0) {
          lines[line].x = lines[line].width / 2;
          lines[line].y = lines[line].height / 2;
        } else {
          lines[line].x = lines[line].width / 2;
          lines[line].y = lines[line - 1].y + _textFormat.size;
        }
      }
    }
    
    private function justifyRight():void {
      var right:Number = 0;
      var line:Number = 0;
      
      right = maxLineWidth();
      
      for (line = 0; line < lines.length; line++) {
        if (line == 0) {
          lines[line].x = right - lines[line].width / 2;
          lines[line].y = lines[line].height / 2;
        } else {
          lines[line].x = right - lines[line].width / 2;
          lines[line].y = lines[line - 1].y + _textFormat.size;
        }
      }
    }
    
    private function justifyCenter():void {
      var center:Number = 0;
      var line:Number = 0;
      
      center = maxLineWidth() / 2;
      
      for (line = 0; line < lines.length; line++) {
        if (line == 0) {
          lines[line].x = center;//lines[line].width / 2;
          lines[line].y = lines[line].height / 2;
        } else {
          lines[line].x = center;//lines[line].width / 2;
          lines[line].y = lines[line - 1].y + _textFormat.size;
        }
      }
    }
    
    private function maxLineWidth():Number {
      var maxSize:Number = 0;
      var line:Number = 0;
      
      maxSize = lines[0].width;
      for (line = 1; line < lines.length; line++) {
        if (maxSize < lines[line].width) {
          maxSize = lines[line].width;
        }
      }
      
      return maxSize;      
    }
    
    /**
     * Actually build the TextField.
     */
    private function buildTextField(char_str:String):void {
      var j:Number = textFields.length;
      
      // Create the TextField and assign our custom format
      textFields.push(new TextField());
      textFields[j].defaultTextFormat = _textFormat;
      
      textFields[j].embedFonts = true;
      
      // Set some basic properties
      textFields[j].background = false;
      textFields[j].autoSize = TextFieldAutoSize.LEFT;
      
      // Bitmaps don't support embedded fonts with AntiAliasType.ADVANCED
      // Apparently: Workaround is to wrap textfield into movieclip
      // textFields[j].antiAliasType = AntiAliasType.ADVANCED;
      textFields[j].antiAliasType = AntiAliasType.NORMAL;
      
      // Actually assign the text
      //textFields[j].text = _text.charAt(i);
      textFields[j].text = char_str;
    }
    
    /**
     * Actually build the character object using a <code>Bitmap</code>.
     */
    private function buildBitmapChar():void {  
      var i:Number = bitmapDatas.length;
      
      // Create a BitmapData object and draw the character on it    
      bitmapDatas.push(new BitmapData(textFields[i].width, textFields[i].height, true, 0x000000));
      bitmapDatas[i].draw(textFields[i]);
      
      // Use that BitmapData object to create a bitmap
      bitmaps.push(new Bitmap(bitmapDatas[i]));
      
      // Create a new MovieClip for the character object and add the 
      // Bitmap to its display list
      characters.push(new MovieClip());
      characters[i].addChild(bitmaps[i]);
      
      // Position the Bitmap on the MovieClip so the character is
      // registered at the center
      bitmaps[i].x = 0 - bitmaps[i].width / 2;
      bitmaps[i].y = 0 - bitmaps[i].height / 2;
    }
    
    /**
     * Actually build the character object.
     */
    private function buildChar():void {
      var i:Number = characters.length;
      
      // Create the MovieClip and add the TextField to its display list
      characters.push(new MovieClip());
      characters[i].addChild(textFields[i]);
      
      // Position the TextField on the MovieClip so the character is
      // registered at the center
      textFields[i].x = 0 - textFields[i].textWidth / 2;
      textFields[i].y = 0 - textFields[i].textHeight / 2;      
    }
    
    /**
     * Clear all existing TextField objects
     */
    private function clear():void {
      
      if (characters == null) {
        return;
      }
      
      for (var i:uint = 0; i < lines.length; i++) {
        removeChild(lines[i]);
      }
      
      // May need to expunge arrays as well
    }
    
    /**
     * Transition the text.  If <code>txOut_fn</code> is not set, nothing will
     * happen.
     *
     * @param out  If <code>true</code> the text will be transitioned out.  Otherwise
     *                  it will be transitioned in.
     * @param duration The length, in seconds, of the transition
     * @param ease The easing function to use in stead of what's set in <code>txOutEase_fn</code>
     */
    private function tx(out:Boolean, duration:Number = -1, ease:Function = null):void {
      //var tx_fn:Function = out ? txOut_fn : txIn_fn;
      //var fx_fn:Function = out ? fxOut_fn : fxIn_fn;
      
      var txProcess:Function = out ? outTx.process : inTx.process;
            
      if (txProcess == null) {
        return;
      }
      
      this.duration = duration == -1 ? this.duration : duration;
      this.ease = ease == null ? this.ease : ease;
      
      //tx_fn(this);
      txProcess(out, this);
    }
    
    /**
     * Transition out the text.  If <code>txOut_fn</code> is not set, nothing will
     * happen.
     *
     * @param duration The length, in seconds, of the transition
     * @param ease The easing function to use in stead of what's set in <code>txOutEase_fn</code>
     */
    public function txOut(duration:Number = -1, ease:Function = null, delay:Number = 0):void {
      tx(true, duration, ease);
    }
    
    /**
     * Transition in the text.  If <code>txOut_fn</code> is not set, nothing will
     * happen.
     *
     * @param duration The length, in seconds, of the transition
     * @param ease The easing function to use in stead of what's set in <code>txOutEase_fn</code>
     */
    public function txIn(duration:Number = -1, ease:Function = null, delay:Number = 0):void {
      tx(false, duration, ease);
    }
  
    /**
     * Outline this MovieClip.  If it's already been outlined, then clear the
     * outline.
     */
    private function outline():void {
      if (debugOutline) {
        clearOutline();
        debugOutline = false;
      } else {
        graphics.clear();
        graphics.lineStyle(2);
        graphics.drawRect(0, 0, width, height);
        debugOutline = true;
      }
    }
    
    /**
     * Clear the outline.
     */
    private function clearOutline():void {
        graphics.clear();
    }
    
    public function reset(alpha:Number = 1):void {
      var i:Number = 0;

      for (i = 0; i < characters.length; i++) {
        characters[i].alpha = alpha;
        characters[i].filters = new Array();
        characters[i].scaleX = characters[i].scaleY = 1;
        characters[i].rotation = 0;
      }
      
      for (i = 0; i < words.length; i++) {
        words[i].alpha = alpha;
        words[i].filters = new Array();
        words[i].scaleX = words[i].scaleY = 1;
        words[i].rotation = 0;
      }
      
      for (i = 0; i < lines.length; i++) {
        lines[i].alpha = alpha;
        lines[i].filters = new Array();
        lines[i].scaleX = lines[i].scaleY = 1;
        lines[i].rotation = 0;
      }
    }
  }
}