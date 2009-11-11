package Effects {
  import flash.text.TextField;
  import gs.TweenLite;
  import gs.easing.*;
  import GoTexter;
  import flash.display.DisplayObject;
  import flash.display.BitmapData;
  import Effects.Effect;

  public class Fade extends Effect {
    public static function process(goText:GoTexter, params_obj:Object):void {
      params_obj = setDefaults(params_obj);
      
      if (!params_obj.valid) {
        return;
      }

      params_obj.tween_fn = params_obj.out ? TweenLite.to : TweenLite.from;
      
      var char_do:DisplayObject = goText.items[params_obj.index];

      params_obj.tween_fn(char_do,
                          params_obj.duration, 
                          {alpha: 0,
                           ease: params_obj.ease,
                           delay: params_obj.delay,
                           onComplete: params_obj.callback});
    } 
  }
}