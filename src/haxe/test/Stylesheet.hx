import haxe.Resource;

class Selector {
  private static var ID      = ~/^#([A-Za-z\-_0-9]+)/;
  private static var CLASS   = ~/^\.([a-z\-_]+)/i;
  private static var CHILD   = ~/^>/i;
  private static var ELEMENT = ~/^\.[a-z\-_]+/i;
  
  private dynamic var chain : Array<Dynamic>;
  
  public function new() {
    this.chain = [];
  }
  
  public function create(string) {
  
  }
  
  protected function idSelector(match) {}
  
  protected function classSelector(match) {}
  
  protected function childSelector(match) {}
  
  protected function elementSelector(id) {}
  
  private static function parse(string) {
    string = Slector.trim(string);
    var selector = new Selector();
    for(chunk in string.split(" ")) {
      if(ID.match(chunk))      selector.idSelector(ID);
      if(CLASS.match(chunk))   selector.classSelector(CLASS);
      if(CHILD.match(chunk))   selector.childSelector();
      if(ELEMENT.match(chunk)) selector.elementSelector();
    }
  }
  
  private static function trim(string) {
    string = ~/^[ ]+/.replace(string, "");
    string = ~/[ ]+$/.replace(string, "");
    return string;
  }
}

class IdSelector {}
class ClassSelector {}
class ElementSelector {}
class ChildSelector {}

class Rule {
  public dynamic var styles : Array<Style>;
  public var selector : String;
  public function new(selector, styles) {
    this.selector = selector;
    this.styles   = styles;
  }
}

class Style {
  public var property : String;
  public var value    : String;
  
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
    this.rules.concat(parsed.rules);
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
            keyValue = PROPERTY.split(rule);
            styles.push(new Style(keyValue[0], keyValue[1]));
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

