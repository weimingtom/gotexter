package Effects {
  import flash.text.TextField;
  import gs.TweenMax;
  import gs.easing.*;
  import GoTexter;
  import Effects.Effect;
  import flash.display.DisplayObject;
  import flash.display.BitmapData;

  public class SpinFall extends Effect{
    /*
    public static function back(goText:GoTexter, params_obj:Object):void {
      params_obj.back = true;
      spinFall(goText, params_obj);
    }*/
    
    public static function process(goText:GoTexter, params_obj:Object):void {
      params_obj = setDefaults(params_obj);
      if (!params_obj.valid) {
        return;
      }
      params_obj.tween_fn = params_obj.out ? TweenMax.to : TweenMax.from;
      var char_do:DisplayObject = goText.items[params_obj.index];
      
      var scale:Number = params_obj.back ? randRange(.25, .5) : randRange(2, 4);
      var rotate:Number = randRange(1, 3) == 1 ? 360 : -360;
      
      params_obj.tween_fn(char_do, 
               params_obj.duration, 
               { alpha:0,
                 scaleX:scale,
                 scaleY:scale,
                 rotation:rotate,
                 blurFilter:{blurX:10, blurY:10, quality:3},
                 ease:params_obj.ease,
                 delay:params_obj.delay,
                 onComplete:params_obj.callback});
    }
  }
}