import flash.display.Sprite;

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

  dynamic var box    : Box;

  public function new(box) {
    this.top    = 0;
    this.left   = 0;
    this.bottom = 0;
    this.right  = 0;
    this.box    = box;
  }
}

class Offset extends FourSides {
  public function new(box) {
    super(box);
  }
  
  public function setTop(value:Float)    {
    this.top = value;
    return value;
  }
  
  public function setLeft(value:Float)   {
    this.left = value;
    return value;
  }
  
  public function setBottom(value:Float) {
    this.bottom = value;
    return value;
  }
  
  public function setRight(value:Float)  {
    this.right = value;
    return value;
  }
}

class Margin extends FourSides {
  public function new(box) {
    super(box);
  }
  
  public function setTop(value:Float)    {
    this.top = value;
    return value;
  }
  
  public function setLeft(value:Float)   {
    this.left = value;
    return value;
  }
  
  public function setBottom(value:Float) {
    this.bottom = value;
    return value;
  }
  
  public function setRight(value:Float)  {
    this.right = value;
    return value;
  }
}

class Padding extends FourSides {
  public function new(box) {
    super(box);
  }
  
  public function setTop(value:Float)    {
    this.top = value;
    return value;
  }
  
  public function setLeft(value:Float)   {
    this.left = value;
    return value;
  }
  
  public function setBottom(value:Float) {
    this.bottom = value;
    return value;
  }
  
  public function setRight(value:Float)  {
    this.right = value;
    return value;
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
  
  dynamic var box : Box;
  
  public function new(box) {
    this.width = new FourSides(box);
    this.color = new FourSides(box);
    
    this.box = box;
    
    this.topStyle    = BorderStyle.SOLID;
    this.leftStyle   = BorderStyle.SOLID;
    this.bottomStyle = BorderStyle.SOLID;
    this.rightStyle  = BorderStyle.SOLID;
  }
}

class Box extends Sprite {
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
    
    this.offset  = new Offset(this);
    this.margin  = new Margin(this);
    this.padding = new Padding(this);
    this.border  = new Border(this);
    
    this.width  = 0;
    this.height = 0;  
  } 
}
