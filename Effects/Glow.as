package Effects {
  import flash.text.TextField;
  import gs.TweenMax;
  import gs.easing.*;
  import GoTexter;
  import Effects.Effect;
  import flash.display.DisplayObject;
  import flash.display.BitmapData;

  public class Glow extends Effect {
    /*
    public static function back(goText:GoTexter, params_obj:Object) {
      params_obj.back = true;
      spinFall(goText, params_obj);
    }
    */   
    
    public static function process(goText:GoTexter, params_obj:Object):void {
      params_obj = setDefaults(params_obj);
      if (!params_obj.valid) {
        return;
      }
      params_obj.tween_fn = params_obj.out ? TweenMax.to : TweenMax.from;
      
      var char_do:DisplayObject = goText.items[params_obj.index];
      
      var color_obj:Object = goText.textFields[0].defaultTextFormat.color;
      
      if (params_obj.glow) {
        // Outgoing Step 2
        params_obj.tween_fn( char_do, 
                             params_obj.duration / 2, 
                             { alpha:0,
                               ease:params_obj.ease,
                               delay:params_obj.delay,
                               onComplete:params_obj.callback});        
      } else {
        // Outgoing Step 1
        params_obj.glow = true;
        params_obj.tween_fn( char_do, 
                             params_obj.duration / 2, 
                             { glowFilter:{ alpha:1, blurX:10, blurY:10, color:color_obj, 
                                            strength:1, quality:3},
                               ease:params_obj.ease,
                               delay:params_obj.delay,
                               onComplete: process,
                               onCompleteParams:[goText, params_obj]});
      }
                 
               
    }
  }
}