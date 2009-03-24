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
  public dynamic var top    : Float;
  public dynamic var left   : Float;
  public dynamic var bottom : Float;
  public dynamic var right  : Float;

  dynamic var box    : Box;

  public function new(box) {
    this.top    = 0;
    this.left   = 0;
    this.bottom = 0;
    this.right  = 0;
    this.box    = box;
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

class Offset extends FourSides {
  public function new(box) {
    super(box);
  }
}

class Margin extends FourSides {
  public function new(box) {
    super(box);
  }
}

class Padding extends FourSides {
  public function new(box) {
    super(box);
  }
}

enum BorderStyles {
  SOLID;
}

class Border {
  public dynamic var width : FourSides;
  public dynamic var color : FourSides;
  
  dynamic var topStyle    : BorderStyles;
  dynamic var leftStyle   : BorderStyles;
  dynamic var bottomStyle : BorderStyles;
  dynamic var rightStyle  : BorderStyles;
  
  dynamic var box : Box;
  
  public function new(box) {
    this.width = new FourSides(box);
    this.color = new FourSides(box);
    
    this.box = box;
    
    this.topStyle    = BorderStyles.SOLID;
    this.leftStyle   = BorderStyles.SOLID;
    this.bottomStyle = BorderStyles.SOLID;
    this.rightStyle  = BorderStyles.SOLID;
  }
}

class Dimensions {
  private dynamic var width  : Float;
  private dynamic var height : Float;
  
  private var box : Box;
  
  public function new(box) {
    this.box = box;
  }
  
  public function setWidth(size) {
    this.width = size;
    return size; 
  }
  
  public function setHeight(size) {
    this.height = size;
    return size; 
  }
}

class Box extends Sprite {
  public dynamic var display  : Display;
  public dynamic var position : Position;
  
  public dynamic var offset  : FourSides;
  public dynamic var margin  : FourSides;
  public dynamic var padding : FourSides;  
  public dynamic var border  : Border;

  public dynamic var dimensions : Dimensions;
  public dynamic var backgroundColor : Int;

  public function new() {
    super();

    this.display  = Display.BLOCK;
    this.position = Position.STATIC;
    
    this.offset  = new Offset(this);
    this.margin  = new Margin(this);
    this.padding = new Padding(this);
    this.border  = new Border(this);
 
    this.dimensions = new Dimensions(this);
  } 
}
