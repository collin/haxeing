import haxe.Resource;
import Document;

class Selector {
  private static var ID      = ~/^#([A-Za-z\-_0-9]+)/;
  private static var CLASS   = ~/^\.([a-z\-_]+)/i;
  private static var CHILD   = ~/^>/i;
  private static var ELEMENT = ~/^[a-z\-_]+/i;
  
  private dynamic var chain : Array<SelectorPart>;
  
  public function new() {
    this.chain = [];
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
      matched.concat(this.matchDocument(element));
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

class Style {
  static var PERCENT = ~/([\d]+)%/;
  static var PIXELS  = ~/([\d]+)px/;

  public var property : String;
  public var value    : Value;
  
  public function new(property, value) {
    this.property = this.trim(property);
    this.value    = this.trim(value);
  }

  public function inspect() {
    trace("["+this.property+"|"+this.value+"]");
  }

  public function trim(string) {
    string = ~/^[ ]+/.replace(string, "");
    string = ~/[ ]+$/.replace(string, "");
    return string;
  }
}

class WidthStyle extends Style {
  public function new(width:String) {
    this.value = Value.parseMeasure(width);
  }
  
  public function applyStyle(node:AbstractNode) {
    if(this.value.percent)
      node.width = this.value.percent * node.parentNode.width;
    else
      node.width = this.value.pixels;    
  }
}

class HeightStyle extends Style {
  public function new(height:String) {
    this.value = Value.parseMeasure(height);
  }
  
  public function applyStyle(box:Box) {
    if(this.value.percent)
      box.height = this.value.percent * box.parentNode.height;
    else
      box.height = this.value.pixels;    
  }
}

class BorderStyle extends Style {
  public function new(border:String) {
    this.value = Value.parseBorderStyle(border);
  }
  
  public function applyStyle(box:Box) {
    var bbw = box.border.width;
    bbw.top    = this.value.topWidth;
    bbw.right  = this.value.rightWidth;
    bbw.bottom = this.value.bottomWidth;
    bbw.left   = this.value.leftWidth;
    
    var bbc = box.border.color;
    bbc.top    = this.value.topColor;
    bbc.right  = this.value.rightColor;
    bbc.bottom = this.value.bottomWidth;
    bbc.left   = this.value.leftWidth;
  }
}

class MarginStyle extends Style {
  public function new(margin:String) {
    this.value = Value.parseFourSides(margin);
  }
  
  public function applyStyle(box:Box) {
    var bm = box.margin;
    bm.top    = this.value.top;
    bm.right  = this.value.right;
    bm.bottom = this.value.bottom;
    bm.left   = this.value.left;
  }
}

class PaddingStyle extends Style {
  public function new(padding:String) {
    this.value = Value.parseFourSides(margin);
  }
  
  public function applyStyle(box:Box) {
    var bm = box.margin;
    bm.top    = this.value.top;
    bm.right  = this.value.right;
    bm.bottom = this.value.bottom;
    bm.left   = this.value.left;
  }
}

class BackgroundColorStyle extends Style {
  public function new(color:String) {
    this.value = Value.parseColor(color);
  }
  
  public function applyStyle(box:Box) {
    box.opaqueBackground = this.value.color;
  }
}

class BackgroundImageStyle extends Style {
  public function new(image:String) {
    this.value = Value.parseUrl(image);
  }
  
  public function applyStyle(box:Box) {
    trace("BackgroundImage Unimplemented :(");
  }
}

class PositionStyle extends Style {
  public function new(position:String) {
    this.value = Value.parsePosition(position);  
  }
  
  public function applyStyle(box:Box) {
    box.position = this.value.position;
  }
}

class DisplayStyle extends Style {
  public function new(display:String) {
    this.value = value.parseDisplay(display);
  }
  
  public function applyStyle(box:Box) {
    box.display = this.value.display();
  }
}

class TopStyle extends Style {
  public function new(top:String) {
    this.value = Value.parseMeasure(top);
  }
  
  public function applyStyle(box:Box) {
    box.offset.top = this.value.pixels;
  }
}

class RightStyle extends Style {
  public function new(right:String) {
    this.value = Value.parseMeasure(right);
  }
  
  public function applyStyle(box:Box) {
    box.offset.right = value.pixels;
  }
}

class BottomStyle extends Style {
  public function new(bottom:String) {
    this.value = Value.parseMeasure(bottom);
  }
  
  public function applyStyle(box:Box) {
    box.offset.bottom = value.pixels;
  }
}

class LeftStyle extends Style {
  public function new(left:String) {
    this.value = Value.parseMeasure(left);
  }
  
  public function applyStyle(box:Box) {
    box.offset.left = value.pixels;
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
              styles.push(new Style(keyValue[0], keyValue[1]));
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

