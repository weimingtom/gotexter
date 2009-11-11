package Transitions {
  import flash.text.TextField;
  import flash.display.DisplayObject;
  
  import gs.TweenMax;
  import gs.easing.*;
  import GoTexter;
  
  import Transitions.Transition;
  
  public class DescendingCascade extends Transition {

    public static function process(out:Boolean, goText:GoTexter):void {
      var i:Number;
      //var engine_fn:Function = out ? goText.outFx_fn : goText.inFx_fn;
      var engine_fn:Function = out ? goText.outFx.process : goText.inFx.process;
      var duration:Number = goText.duration / 2;
      var delay:Number = 0;
      var delayDelta:Number = duration / goText.items.length;

      goText.reset();

      for (i = goText.items.length - 1; i >= 0; i--) {        
        if (i == goText.items.length - 1) {
          engine_fn(goText, {'out':out, 'index':i, 'duration':duration,
                             'ease':goText.ease, 'delay':delay, 'callback':goText.callback})
        } else {
          engine_fn(goText, {'out':out, 'index':i, 'duration':duration,
                             'ease':goText.ease, 'delay':delay})
        }

        delay += delayDelta;
      }

    }

  }
  
}