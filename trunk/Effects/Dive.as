package Effects {
  import flash.text.TextField;
  import gs.TweenMax;
  import gs.easing.*;
  import GoTexter;
  import Effects.Effect;
  import flash.display.DisplayObject;
  import flash.display.BitmapData;

  public class Dive extends Effect {        
    public static function process(goText:GoTexter, params_obj:Object):void {
      params_obj = setDefaults(params_obj);
      if (!params_obj.valid) {
        return;
      }
    
      var char_do:DisplayObject = goText.items[params_obj.index];
      
      params_obj.tween_fn = params_obj.out ? TweenMax.to : TweenMax.from;
      
      params_obj.tween_fn(char_do, 
                  params_obj.duration, 
                  { alpha:0,
                    rotation:180,
                    /*x:(char_do.x + char_do.width), 
                    y:(char_do.y + char_do.height),*/
                    x:char_do.x,
                    y:char_do.y,
                    bezier:[{x:char_do.x + char_do.width, y:char_do.y},
                            {x:char_do.x, y:char_do.y + char_do.height},
                            {x:char_do.x - char_do.width, y:char_do.y},
                            {x:char_do.x, y:char_do.y - char_do.height},
                            {x:char_do.x + char_do.width, y:char_do.y}],
                    blurFilter:{blurX:10, blurY:10, quality:3},
                    ease:params_obj.ease,
                    delay:params_obj.delay,
                    onComplete:params_obj.callback})
    }
  }
}