package Effects {
  import flash.text.TextField;
  import gs.TweenMax;
  import gs.easing.*;
  import GoTexter;
  import Effects.Effect;
  import flash.display.DisplayObject;
  import flash.display.BitmapData;

  public class SoftExplode extends Effect {
    
    public static function process(goText:GoTexter, params_obj:Object):void {
      params_obj = setDefaults(params_obj);
      if (!params_obj.valid) {
        return;
      }
      params_obj.tween_fn = params_obj.out ? TweenMax.to : TweenMax.from;
      var char_do:DisplayObject = goText.items[params_obj.index];
      
      params_obj.tween_fn(char_do, 
               params_obj.duration, 
               { alpha:0,
                 scaleX:2,
                 scaleY:2,
                 /*x:(char_do.x - char_do.width / 2), 
                 y:(char_do.y - char_do.height / 2),*/
                 blurFilter:{blurX:10, blurY:10, quality:3},
                 ease:params_obj.ease,
                 delay:params_obj.delay,
                 onComplete:params_obj.callback});
    }
  }
}