package Transitions {
  import flash.text.TextField;
  import flash.display.DisplayObject;
  
  import gs.TweenMax;
  import gs.easing.*;
  import GoTexter;
  
  import Transitions.Transition;
  
  public class Random extends Transition {

    public static function process(out:Boolean, goText:GoTexter):void {      
      var i:Number;
      //var engine_fn:Function = out ? goText.outFx_fn : goText.inFx_fn;
      var engine_fn:Function = out ? goText.outFx.process : goText.inFx.process;
      var duration:Number = goText.duration / 2;
      var delay:Number = 0;
      var delayDelta:Number = duration / goText.items.length;

      goText.reset();
      
      // Create an array of indices -- Man I wish I could write this
      // part in python
      var indices_arr:Array = new Array();
      for (i = 0; i < goText.items.length; i++) {
        indices_arr.push(i);
      }      

      while (indices_arr.length > 0) {
        i = randRange(0, indices_arr.length - 1);
        
        if (indices_arr.length == 1) {
          engine_fn(goText, {'out':out, 'index':indices_arr[i], 'duration':duration,
                             'ease':goText.ease, 'delay':delay, 'callback':goText.callback})
        } else {
          engine_fn(goText, {'out':out, 'index':indices_arr[i], 'duration':duration,
                             'ease':goText.ease, 'delay':delay})
        }

        delay += delayDelta;
        indices_arr.splice(i, 1);
      }
    }
    
    private static function randRange(start:uint, end:uint):uint {
      return Math.floor(((end - start) * Math.random()) + start);
    }
  }
  
}