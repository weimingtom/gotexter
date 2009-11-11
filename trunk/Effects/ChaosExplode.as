package Effects {
  import gs.TweenMax;
  import gs.easing.*;
  import GoTexter;
  import Effects.Effect;
  import flash.display.DisplayObject;
  import flash.display.BitmapData;

  public class ChaosExplode extends Effect {
    public static function process(goText:GoTexter, params_obj:Object):void {
      params_obj = setDefaults(params_obj);
      if (!params_obj.valid) {
        return;
      }
      var char_do:DisplayObject = goText.items[params_obj.index];
      
      params_obj.tween_fn = params_obj.out ? TweenMax.to : TweenMax.from;
      
			if (!params_obj.explode) {
			  params_obj.explode = true;
			  params_obj.originalX = char_do.x;
			  params_obj.originalY = char_do.y;
			  var newScale:Number = randRange(-3, 3);
        params_obj.tween_fn(char_do, 
                 params_obj.duration, 
                 { alpha:0,
                   scaleX:newScale,
                   scaleY:newScale,
                   rotation:randRange(-180, 180),
                   x:(char_do.x + randRange(-2 * char_do.width, 2 * char_do.width)), 
                   y:(char_do.y - randRange(-2 * char_do.height, 2 * char_do.height)),
                   blurFilter:{blurX:5, blurY:5, quality:3},
                   ease:params_obj.ease,
                   delay:params_obj.delay,
                   onComplete:process,
                   onCompleteParams:[goText, params_obj]});
      } else {
        char_do.x = params_obj.originalX;
        char_do.y = params_obj.originalY;        
        if (params_obj.callback != null) {
          params_obj.callback();
        }
      }
    }
  }
}