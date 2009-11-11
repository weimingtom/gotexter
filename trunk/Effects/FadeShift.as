package Effects {
  import flash.text.TextField;
  import gs.TweenMax;
  import gs.easing.*;   
  import GoTexter;
  import flash.display.DisplayObject;
  import flash.display.BitmapData;
  import Effects.Effect;

  public class FadeShift extends Effect {
     
    public static function fadeShiftTopDown(goText:GoTexter, params_obj:Object):void {
      params_obj = Common.setDefaults(params_obj);
      if (!params_obj.valid) {
        return;
      }
      var char_do:DisplayObject = goText.items[params_obj.index];
      
      var dy:Number = goText.textFields[0].defaultTextFormat.size / 2;
      
      var newY:Number;
      if (params_obj.out) {
        newY = char_do.y + dy;
      } else {
        newY = char_do.y - dy;
      }
      
			if (!params_obj.explode) {
			  params_obj.explode = true;
			  params_obj.originalY = char_do.y;
        params_obj.tween_fn(char_do, 
                 params_obj.duration, 
                 { alpha:0,
                   y:newY,
                   ease:params_obj.ease,
                   delay:params_obj.delay,
                   onComplete:fadeShiftTopDown,
                   onCompleteParams:[goText, params_obj]});
      } else {
        char_do.y = params_obj.originalY;        
        if (params_obj.callback != null) {
          params_obj.callback();
        }
      }
    }
    
    public static function fadeShiftBottomUp(goText:GoTexter, params_obj:Object):void {
      params_obj = Common.setDefaults(params_obj);
      if (!params_obj.valid) {
        return;
      }
      var char_do:DisplayObject = goText.items[params_obj.index];
      
      var dy:Number = goText.textFields[0].defaultTextFormat.size / 2;
      
      var newY:Number;
      if (params_obj.out) {
        newY = char_do.y - dy;
      } else {
        newY = char_do.y + dy;
      }
      
			if (!params_obj.explode) {
			  params_obj.explode = true;
			  params_obj.originalY = char_do.y;
        params_obj.tween_fn(char_do, 
                 params_obj.duration, 
                 { alpha:0,
                   y:newY,
                   ease:params_obj.ease,
                   delay:params_obj.delay,
                   onComplete:fadeShiftBottomUp,
                   onCompleteParams:[goText, params_obj]});
      } else {
        char_do.y = params_obj.originalY;        
        if (params_obj.callback != null) {
          params_obj.callback();
        }
      }
    }
    
    public static function fadeShiftRightLeft(goText:GoTexter, params_obj:Object):void {
      params_obj = Common.setDefaults(params_obj);
      if (!params_obj.valid) {
        return;
      }
      var char_do:DisplayObject = goText.items[params_obj.index];
      
      var dx:Number = goText.textFields[0].defaultTextFormat.size / 2;
      
      var newX:Number;
      if (params_obj.out) {
        newX = char_do.x + dx;
      } else {
        newX = char_do.x - dx;
      }
      
			if (!params_obj.explode) {
			  params_obj.explode = true;
			  params_obj.originalX = char_do.x;
        params_obj.tween_fn(char_do, 
                 params_obj.duration, 
                 { alpha:0,
                   x:newX,
                   ease:params_obj.ease,
                   delay:params_obj.delay,
                   onComplete:fadeShiftRightLeft,
                   onCompleteParams:[goText, params_obj]});
      } else {
        char_do.x = params_obj.originalX;        
        if (params_obj.callback != null) {
          params_obj.callback();
        }
      }
    }
    
    public static function fadeShiftLeftRight(goText:GoTexter, params_obj:Object):void {
      params_obj = Common.setDefaults(params_obj);
      if (!params_obj.valid) {
        return;
      }
      var char_do:DisplayObject = goText.items[params_obj.index];
      
      var dx:Number = goText.textFields[0].defaultTextFormat.size / 2;
      
      var newX:Number;
      if (params_obj.out) {
        newX = char_do.x - dx;
      } else {
        newX = char_do.x + dx;
      }
      
			if (!params_obj.explode) {
			  params_obj.explode = true;
			  params_obj.originalX = char_do.x;
        params_obj.tween_fn(char_do, 
                 params_obj.duration, 
                 { alpha:0,
                   x:newX,
                   ease:params_obj.ease,
                   delay:params_obj.delay,
                   onComplete:fadeShiftLeftRight,
                   onCompleteParams:[goText, params_obj]});
      } else {
        char_do.x = params_obj.originalX;        
        if (params_obj.callback != null) {
          params_obj.callback();
        }
      }
    }
  }
}