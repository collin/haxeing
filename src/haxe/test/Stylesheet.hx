import haxe.Resource;
import Document;
import Box;

class Selector {
  private static var ID      = ~/^#([A-Za-z\-_0-9]+)/;
  private static var CLASS   = ~/^\.([a-z\-_]+)/i;
  private static var CHILD   = ~/^>/i;
  private static var ELEMENT = ~/^[a-z\-_]+/i;
  
  private dynamic var chain : Array<SelectorPart>;
  
  public function new() {
    this.chain = [];
  }
  
  public function inspect() {
    trace(this.chain);
  }
  
  public function idSelector(match) {
    this.chain.push(new IdSelector(match));
  }
  
  public function classSelector(match) {
    this.chain.push(new ClassSelector(match));
  }
  
  public function childSelector() {
    this.chain.push(new ChildSelector());
  }
  
  public function elementSelector(match) {
    this.chain.push(new ElementSelector(match));
  }

  public function matchDocument(doc : Document) {
    return this.chain[0].matchDocument(doc);
  }

//FIXME only checks single-node selectors  
  public function matchNode(node : Node) {
    if(this.chain[0].matchNode(node)) return false;    
    return true;
  }
  
  public static function create(string) {
    string = Selector.trim(string);
    var selector = new Selector();
    for(chunk in string.split(" ")) {
      if(ID.match(chunk))      selector.idSelector(ID.matched(1));
      if(CLASS.match(chunk))   selector.classSelector(CLASS.matched(1));
      if(CHILD.match(chunk))   selector.childSelector();
      if(ELEMENT.match(chunk)) selector.elementSelector(ELEMENT.matched(0));
    }
    return selector;
  }
  
  private static function trim(string) {
    string = ~/^[ ]+/.replace(string, "");
    string = ~/[ ]+$/.replace(string, "");
    return string;
  }
}

interface SelectorPart {
  public function matchNode(node:AbstractNode):Bool {}
  public function matchDocument(document:AbstractNode):Array<AbstractNode> {}
}

class IdSelector implements SelectorPart {
  dynamic var id : String;
  public function new(id) {
    this.id = id;
  }
  
  public function matchNode(node:AbstractNode) {
    return node.id == this.id;
  }
  
  public function matchDocument(document:AbstractNode) {
    var matched = [];
    for(element in document.childNodes) {
      if(this.matchNode(element)) matched.push(element);
      matched.concat(this.matchDocument(element));
    }
    return matched;
  }
}

class ClassSelector implements SelectorPart {
  dynamic var klass : String;
  public function new(klass) {
    this.klass = klass;
  }
  
  public function matchNode(node:AbstractNode) {
    return node.klass == this.klass;
  }
  
  public function matchDocument(document:AbstractNode) {
    var matched = [];
    for(element in document.childNodes) {
      if(this.matchNode(element)) matched.push(element);
      matched.concat(this.matchDocument(element));
    }
    return matched;
  }  
}

class ElementSelector implements SelectorPart {
  dynamic var tagName : String;
  public function new(tagName) {
    this.tagName = tagName;
  }
  
  public function matchNode(node:AbstractNode) {
    return node.tagName == this.tagName;
  }
  
  public function matchDocument(document:AbstractNode) {
    var matched = [];
    for(element in document.childNodes) {
      if(this.matchNode(element)) matched.push(element);
      matched = matched.concat(this.matchDocument(element));
    }
    return matched;
  }  
}


class ChildSelector implements SelectorPart {
  public function new() {}
  
  public function matchNode(node:AbstractNode) {
    return false;
  }
  
  public function matchDocument(document:AbstractNode) {
    return [];
  }
}

class Rule {
  public dynamic var styles : Array<Style>;
  public var selector : Selector;
  public function new(selector, styles) {
    this.selector = Selector.create(selector);
    this.styles   = styles;
  }
}

class Value {
  static var PERCENT = ~/([\d]+)%/;
  static var PIXELS  = ~/([\d]+)px/;
  static var COLOR   = ~/#([\d]{6})/;
  static var FOURSIDES = ~/([\d])px ([\d])px ([\d])px ([\d])px/;

  dynamic public var pixels  : Float;
  dynamic public var percent : Float;
  
  dynamic public var position : Dynamic;
  dynamic public var display  : Dynamic;  
  
  dynamic public var topWidth    : Float;
  dynamic public var rightWidth  : Float;
  dynamic public var bottomWidth : Float;
  dynamic public var leftWidth   : Float;
  
  dynamic public var topColor    : Int;
  dynamic public var rightColor  : Int;
  dynamic public var bottomColor : Int;
  dynamic public var leftColor   : Int;
  
  dynamic public var color : Int;
  
  dynamic public var top    : Float;
  dynamic public var right  : Float;
  dynamic public var bottom : Float;
  dynamic public var left   : Float;
    
  public function new() {}
    
  public static function parseMeasure(measure:String) {
    var value = new Value();
    
    if(Value.PERCENT.match(measure)) 
      value.percent = Std.parseFloat(Value.PERCENT.matched(1));
      
    if(Value.PIXELS.match(measure))  
      value.pixels = Std.parseFloat(Value.PIXELS.matched(1));
      
    return value;
  }
  
  public static function parseColor(color:String) {
    var value = new Value();
    if(Value.COLOR.match(color)) 
      value.color = Std.parseInt(Value.COLOR.matched(1));
    return value;
  }
  
  public static function parseFourSides(sides:String) {
    var value = new Value();
    if(Value.FOURSIDES.match(sides)) {
      value.top    = Std.parseFloat(Value.FOURSIDES.matched(1));
      value.right  = Std.parseFloat(Value.FOURSIDES.matched(2));
      value.bottom = Std.parseFloat(Value.FOURSIDES.matched(3));
      value.left   = Std.parseFloat(Value.FOURSIDES.matched(4));
    }
    return value;
  }
  
  public static function parsePosition(position:String) {
    var value = new Value();
    switch(position) {
      case "static":   value.position = Position.STATIC;
      case "fixed":    value.position = Position.FIXED;
      case "relative": value.position = Position.RELATIVE;
      case "absolute": value.position = Position.ABSOLUTE;
    }
    return value;
  }
  
  public static function parseDisplay(display:String) {
    var value = new Value();
    switch(display) {
      case "none":   value.position = Display.NONE;
      case "block":  value.position = Display.BLOCK;
      case "inline": value.position = Display.INLINE;
    }
    return value;
  }
  
  public static function parseBorderStyle(borderStyle:String) {
    var value = new Value();
    return value;
  }
  
  public static function parseUrl(url:String) {
    var value = new Value();
    return value; 
  }
}

class Style {
  public var value    : Value;

  public function new() {}

  public static function create(property:String, value:String) {
    value = Style.trim(value);
    var style : Dynamic;
    
    switch(Style.trim(property)) {
      case "width":             style = new WidthStyle(value);
      case "height":            style = new HeightStyle(value);
      case "border":            style = new BorderStyle(value);
      case "margin":            style = new MarginStyle(value);
      case "padding":           style = new PaddingStyle(value);
      case "background-color":  style = new BackgroundColorStyle(value);
      case "background-image":  style = new BackgroundImageStyle(value);
      case "position":          style = new PositionStyle(value);
      case "display":           style = new DisplayStyle(value);
      case "top":               style = new TopStyle(value);
      case "right":             style = new RightStyle(value);
      case "bottom":            style = new BottomStyle(value);
      case "left":              style = new LeftStyle(value);
      default:                  style = new Style();
    }
    
    return style;
  }

  public function inspect() {
    trace("["+Std.string(type(this))+"|"+this.value+"]");
  }

  public static function trim(string) {
    string = ~/^[ ]+/.replace(string, "");
    string = ~/[ ]+$/.replace(string, "");
    return string;
  }
}

class WidthStyle extends Style {
  public function new(width:String) {
    super();
    this.value = Value.parseMeasure(width);
  }
  
  public function applyStyle(box:Box) {
    if(Std.is(this.value.percent, Float))
      box.dimensions.setWidth(this.value.percent);
    else
      box.dimensions.setWidth(this.value.pixels);    
  }
}

class HeightStyle extends Style {
  public function new(height:String) {
    super();
    this.value = Value.parseMeasure(height);
  }
  
  public function applyStyle(box:Box) {
    if(Std.is(this.value.percent, Float))
      box.dimensions.setHeight(this.value.percent);
    else
      box.dimensions.setHeight(this.value.pixels);    
  }
}

class BorderStyle extends Style {
  public function new(border:String) {
    super();
    this.value = Value.parseBorderStyle(border);
  }
  
  public function applyStyle(box:Box) {
    var bbw = box.border.width;
    bbw.setTop(    this.value.topWidth);
    bbw.setRight(  this.value.rightWidth);
    bbw.setBottom( this.value.bottomWidth);
    bbw.setLeft(   this.value.leftWidth);
    
    var bbc = box.border.color;
    bbc.setTop(    this.value.topColor);
    bbc.setRight(  this.value.rightColor);
    bbc.setBottom( this.value.bottomWidth);
    bbc.setLeft(   this.value.leftWidth);
  }
}

class MarginStyle extends Style {
  public function new(margin:String) {
    super();
    this.value = Value.parseFourSides(margin);
  }
  
  public function applyStyle(box:Box) {
    var bm = box.margin;
    bm.setTop(    this.value.top);
    bm.setRight(  this.value.right);
    bm.setBottom( this.value.bottom);
    bm.setLeft(   this.value.left);
  }
}

class PaddingStyle extends Style {
  public function new(padding:String) {
    super();
    this.value = Value.parseFourSides(padding);
  }
  
  public function applyStyle(box:Box) {
    var bm = box.margin;
    bm.setTop(    this.value.top);
    bm.setRight(  this.value.right);
    bm.setBottom( this.value.bottom);
    bm.setLeft(   this.value.left);
  }
}

class BackgroundColorStyle extends Style {
  public function new(color:String) {
    super();
    this.value = Value.parseColor(color);
  }
  
  public function applyStyle(box:Box) {
    box.backgroundColor = this.value.color;
  }
}

class BackgroundImageStyle extends Style {
  public function new(image:String) {
    super();
    this.value = Value.parseUrl(image);
  }
  
  public function applyStyle(box:Box) {
    trace("BackgroundImage Unimplemented :(");
  }
}

class PositionStyle extends Style {
  public function new(position:String) {
    super();
    this.value = Value.parsePosition(position);  
  }
  
  public function applyStyle(box:Box) {
    box.position = this.value.position;
  }
}

class DisplayStyle extends Style {
  public function new(display:String) {
    super();
    this.value = Value.parseDisplay(display);
  }
  
  public function applyStyle(box:Box) {
    box.display = this.value.display();
  }
}

class TopStyle extends Style {
  public function new(top:String) {
    super();
    this.value = Value.parseMeasure(top);
  }
  
  public function applyStyle(box:Box) {
    box.offset.setTop(this.value.pixels);
  }
}

class RightStyle extends Style {
  public function new(right:String) {
    super();
    this.value = Value.parseMeasure(right);
  }
  
  public function applyStyle(box:Box) {
    box.offset.setRight(value.pixels);
  }
}

class BottomStyle extends Style {
  public function new(bottom:String) {
    super();
    this.value = Value.parseMeasure(bottom);
  }
  
  public function applyStyle(box:Box) {
    box.offset.setBottom(value.pixels);
  }
}

class LeftStyle extends Style {
  public function new(left:String) {
    super();
    this.value = Value.parseMeasure(left);
  }
  
  public function applyStyle(box:Box) {
    box.offset.setLeft(value.pixels);
  }
}

class Stylesheet {
  
  public dynamic var rules : Array<Rule>;
  
  public function new() {
    this.rules = [];
  }
  
  
  public function inspect() {
    var inspection = "";
  }
  
  public function parse(css) {
    var parsed = new Parser(css);
    this.rules = this.rules.concat(parsed.rules);
  }
  
  public function parseResource(resourceName) {
    this.parse(Resource.getString(resourceName));
  }
}

class Parser {
  static var CHUNKER  = ~/[a-zA-Z.#>,: ]+\{[0-9a-z\-:; ]+\}/g;
  static var SELECTOR = ~/^[a-zA-Z.#>,: ]+/;
  static var RULES    = ~/\{([#0-9a-z\-:; ]+?)\}/;
  static var RULE     = ~/;/g;
  static var PROPERTY = ~/:/g;
  
  dynamic var css    : String;
  dynamic var chunks : Array<String>;

  public dynamic var rules : Array<Rule>;

  public function new(css) {
    this.css = (~/\n/g).replace(css, "");
    this.rules = [];
    var styles = [];
    this.chunkCSS();
    var selector;
    var _rules;
    var splitRules;
    var keyValue;

    // OMG SO SORRY
    for(chunk in this.chunks) {
      if(SELECTOR.match(chunk)) {
        selector = SELECTOR.matched(0);

        if(RULES.match(chunk)) {
          _rules = RULES.matched(1);
          splitRules = RULE.split(_rules);
      
          for(rule in splitRules) {

            if(!(~/^[ ]+$/).match(rule)) {
              keyValue = PROPERTY.split(rule);
              styles.push(Style.create(keyValue[0], keyValue[1]));
            }
          }
        }
        this.rules.push(new Rule(selector, styles));
      }
    }
  }
  
  private function chunkCSS() {
    this.chunks = CHUNKER.split(this.css);
  }  
}

