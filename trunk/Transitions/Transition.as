package Transitions {
  
  public class Transition {
    
    public static function randRange(start:Number, end:Number):Number {
      return ((end - start) * Math.random()) + start;
    }
  }
}