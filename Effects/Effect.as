package Effects {
  import gs.easing.*;

  public class Effect {
    /**
     * Accepted object parameters:
     *
     * index:Number
     * goText:GoTexter
     * duration:Number
     * ease:Function
     * delay:Number = 0
     * callback:Function = null
     */
    private static const defaults:Array = [ {'name':'out', 'default':false, 'forceDefault':[null]},
                                            {'name':'ease', 'default':false, 'forceDefault':[null]},
                                            {'name':'delay', 'default':0, 'forceDefault':[null]},
                                            {'name':'decodeSteps', 'default':15, 'forceDefault':[null]}];
    
    public static function setDefaults(params_obj:Object):Object {
      // Check for required elements      
      if (params_obj.hasOwnProperty('index') &&
          params_obj.hasOwnProperty('duration')) {
        params_obj.valid = true;
      } else {
        params_obj.valid = false;
      }
      
      var i:uint;
      var j:uint;
      for (i = 0; i < defaults.length; i++) {
        if (!params_obj.hasOwnProperty(defaults[i].name)) {
          // Parameter doesn't exist
          params_obj[defaults[i].name] = defaults[i].default;
        } else if (defaults[i].forceDefault.length > 0){
          // Parameter does exist, let's check it's value against any force
          // default values
          for (j = 0; j < defaults[i].forceDefault.length; j++) {
            if (params_obj[defaults[i].name] == defaults[i].forceDefault[j]) {
              params_obj[defaults[i].name] = defaults[i].default;
            }
          }
        }
      }
      
      //params_obj.tween_fn = params_obj.out ? TweenMax.to : TweenMax.from;    
      
      return params_obj;
    }
    
    public static function randRange(start:Number, end:Number):Number {
      return ((end - start) * Math.random()) + start;
    }
  }
}