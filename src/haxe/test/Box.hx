enum Display {
  block;
  none;
  inline;
}

enum Position {
  relative;
  absolute;
  fixed;
}

class FourSides {
  dynamic var top    : Float = 0;
  dynamic var left   : Float = 0;
  dynamic var bottom : Float = 0;
  dynamic var right  : Float = 0;
}

enum BorderStyle {
  solid;
}

class Border {
  dynamic var width : FourSides = new FourSides();
  dynamic var color : FourSides = new FourSides();
  
  dynamic var topStyle    : BorderStyle = BorderStyle.solid;
  dynamic var leftStyle   : BorderStyle = BorderStyle.solid;
  dynamic var bottomStyle : BorderStyle = BorderStyle.solid;
  dynamic var rightStyle  : BorderStyle = BorderStyle.solid;
}

class Box extends DisplayObjectContainer, impelements FourSides {
  dynamic var display  : Display     = Display.none;
  dynamic var position : Position    = Position.static;
  
  dynamic var margin  : FourSides = new FourSides();
  dynamic var padding : FourSides = new FourSides();
  
  dynamic var border  : Border = new Border();
}
