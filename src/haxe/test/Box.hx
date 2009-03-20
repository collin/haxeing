import flash.display.DisplayObjectContainer;

enum Display {
  BLOCK;
  NONE;
  INLINE;
}

enum Position {
  RELATIVE;
  ABSOLUTE;
  FIXED;
  STATIC;
}

class FourSides {
  dynamic var top    : Float;
  dynamic var left   : Float;
  dynamic var bottom : Float;
  dynamic var right  : Float;

  public function new() {
    this.top    = 0;
    this.left   = 0;
    this.bottom = 0;
    this.right  = 0;
  }
}

enum BorderStyle {
  SOLID;
}

class Border {
  dynamic var width : FourSides;
  dynamic var color : FourSides;
  
  dynamic var topStyle    : BorderStyle;
  dynamic var leftStyle   : BorderStyle;
  dynamic var bottomStyle : BorderStyle;
  dynamic var rightStyle  : BorderStyle;
  
  public function new() {
    this.width = new FourSides();
    this.color = new FourSides();
    
    this.topStyle    = BorderStyle.SOLID;
    this.leftStyle   = BorderStyle.SOLID;
    this.bottomStyle = BorderStyle.SOLID;
    this.rightStyle  = BorderStyle.SOLID;
  }
}

class Box extends DisplayObjectContainer {
  dynamic var display  : Display;
  dynamic var position : Position;
  
  dynamic var offset  : FourSides;
  dynamic var margin  : FourSides;
  dynamic var padding : FourSides;  
  dynamic var border  : Border;


  public function new() {
    super();
    this.display  = Display.BLOCK;
    this.position = Position.STATIC;
    
    this.offset  = new FourSides();
    this.margin  = new FourSides();
    this.padding = new FourSides();
    this.border  = new Border();
    
    this.width  = 0;
    this.height = 0;
  }
}
