package Transitions {
  import flash.text.TextField;
  import flash.display.DisplayObject;
  
  import GoTexter;
  import Transitions.Transition;
  
  public class Together extends Transition {
    public static function process(out:Boolean, goText:GoTexter):void {  
      var i:Number;
      //var engine_fn:Function = out ? goText.fxOut_fn : goText.fxIn_fn;
      var engine_fn:Function = out ? goText.outFx.process : goText.inFx.process;

      goText.reset();
      
      for (i = 0; i < goText.items.length; i++) {
        if (i == goText.items.length - 1) {
          engine_fn(goText, {'out':out, 'index':i, 'duration':goText.duration,
                             'ease':goText.ease, 'callback':goText.callback})      
        } else {
          engine_fn(goText, {'out':out, 'index':i, 'duration':goText.duration,
                             'ease':goText.ease})
        }
      }
    }

  }
  
}