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
  
  override public function set top(value:Float)    {
  }
  
  override public function set left(value:Float)   {
  }
  
  override public function set bottom(value:Float) {
  }
  
  override public function set right(value:Float)  {
  }
}

class Margin extends FourSides {
  public function new(box) {
    super(box);
  }
  
  override public function set top(value:Float)    {
  }
  
  override public function set left(value:Float)   {
  }
  
  override public function set bottom(value:Float) {
  }
  
  override public function set right(value:Float)  {
  }
}

class Padding extends FourSides {
  public function new(box) {
    super(box);
  }
  
  override public function set top(value:Float)    {
  }
  
  override public function set left(value:Float)   {
  }
  
  override public function set bottom(value:Float) {
  }
  
  override public function set right(value:Float)  {
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
    this._display  = Display.BLOCK;
    this._position = Position.STATIC;
    
    this._offset  = new Offset(this);
    this._margin  = new Margin(this);
    this._padding = new Padding(this);
    this._border  = new Border();
    
    this.width  = 0;
    this.height = 0;
  }
}
