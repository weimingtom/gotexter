package Effects {
  import flash.text.TextField;
  import gs.TweenMax;
  import gs.easing.*;
  import GoTexter;
  import Effects.Effect;
  import flash.display.DisplayObject;
  import flash.display.BitmapData;

  public class DecodeBlur extends Effect {
    
    public static function process(goText:GoTexter, params_obj:Object):void {
      params_obj = setDefaults(params_obj);
      if (!params_obj.valid || goText.unit != "chars") {
        trace(goText.unit);
        return;
      }
      
      params_obj.tween_fn = params_obj.out ? TweenMax.to : TweenMax.from;
      
      // Dereference targets to save time
      var i:Number = params_obj.index;
      var textFields:Array = goText.textFields;
      var delay:Number = params_obj.delay;
      var items:Array = goText.items;
      var decodeSteps:Number = params_obj.decodeSteps;
      var blur_obj:Object = {blurX:10, blurY:10, quality:3};
      
      // If this char is an empty space, skip it.
      if (textFields[i].text == " ") {
        return;
      }
      
      // If there's a delay, delay
      if (delay > 0) {
        if (!params_obj.out) {
          // If we're transitioning in, make the delayed character invisible
          items[i].alpha = 0;
        }
        
        // Reset delay so we don't delay infinitly
        params_obj.delay = 0;
        TweenMax.to(items[i],
                    delay,
                    { onComplete: process,
                      onCompleteParams:[goText, params_obj]});
                      
        // If we're delaying, don't do the decode stuff below here
        return;
      }
                            
      // Set decode Count, if not present
      if (params_obj.decodeCount == undefined) {
        // Make sure it's visible
        items[i].alpha = 1;
        params_obj.decodeCount = decodeSteps;
        params_obj.originalChar_str = textFields[i].text;
        params_obj.tween_fn(items[i],
                            params_obj.duration, 
                            { alpha:0,
                              blurFilter:blur_obj,
                              ease:params_obj.ease,
                              delay:params_obj.delay,
                              onComplete:params_obj.callback});
      } else {
        params_obj.decodeCount--;
      }
      
      if (params_obj.decodeCount > 0) {
        // If we're still decoding, decode
        //textFields[i].text = String.fromCharCode(textFields[i].text.charCodeAt(0) + 2);
        textFields[i].text = String.fromCharCode(randRange(33, 126));
        TweenMax.to(items[i],
                    params_obj.duration / decodeSteps,
                    { onComplete:process,
                      onCompleteParams:[goText, params_obj]});
      } else {
        // Otherwise, quit
        textFields[i].text = params_obj.originalChar_str;
        if (params_obj.out) {
          items[i].alpha = 0;
        }
        if (params_obj.callback != null) {
          params_obj.callback();
        }
      }
      
      if (goText.bitmapBuffering) {
        var bd:BitmapData = goText.bitmapDatas[i];
        bd.fillRect(bd.rect, 0);
        bd.draw(textFields[i]);
      }
    }
  }
}