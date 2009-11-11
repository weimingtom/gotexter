package {
  import flash.display.MovieClip;
  import flash.text.Font;
  import flash.events.MouseEvent;
  
  import GoTexter;
  import Effects.*;
  import Transitions.*;
  
  public class Example extends MovieClip {
    private var _helloWorld:GoTexter;
    private var _helvetica:Font = new Helvetica();
    
    public function Example():void {
      _helloWorld = new GoTexter("Hello World!", _helvetica.fontName, 32, 0x000000);
      _helloWorld.justification = "center";
      _helloWorld.build();
      
      _helloWorld.x = stage.stageWidth / 2 - _helloWorld.width / 2;
      _helloWorld.y = stage.stageHeight / 2 - _helloWorld.height / 2;
      
      _helloWorld.inTx = AscendingCascade;
      _helloWorld.outTx = DescendingCascade;
      
      _helloWorld.inFx = _helloWorld.outFx = ChaosExplode;
      
      _helloWorld.buttonMode = true;
      _helloWorld.addEventListener(MouseEvent.CLICK, clicked);
      
      
      addChild(_helloWorld);
      _helloWorld.txIn(1);
    }
    
    private function clicked(event:MouseEvent):void {
      _helloWorld.txOut(1);
    }
  }
}