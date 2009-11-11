package Effects {
  import flash.text.TextField;
  import gs.TweenMax;
  import gs.easing.*;
  import GoTexter;
  import Effects.Effect;
  import flash.display.DisplayObject;
  import flash.display.BitmapData;

  public class Pop extends Effect {
  
    public static function process(goText:GoTexter, params_obj:Object):void {
      params_obj = setDefaults(params_obj);
      if (!params_obj.valid) {
        return;
      }
      params_obj.tween_fn = params_obj.out ? TweenMax.to : TweenMax.from;
      var char_do:DisplayObject = goText.items[params_obj.index];
      
			if (params_obj.pop || (!params_obj.out && !params_obj.pop)) {
			  params_obj.pop = true;
        params_obj.tween_fn( char_do, 
                             params_obj.duration * .1, 
                             { alpha:0,
                               scaleX:4,
                               scaleY:4,
                               blurFilter:{blurX:20, blurY:20, quality:3},
                               ease:params_obj.ease,
                               delay:params_obj.delay,
                               onComplete:params_obj.callback});
		  } else {
		    params_obj.pop = true;
        params_obj.tween_fn( char_do, 
                             params_obj.duration * .9, 
                             { glowFilter:{alpha:1, blurX:20, blurY:20, 
                                           color:0x000000, strength:1, 
                                           quality:3},
                               ease:params_obj.ease,
                               delay:params_obj.delay,
                               onComplete:process,
                               onCompleteParams:[goText, params_obj]});
      }
    }
  
  }
}