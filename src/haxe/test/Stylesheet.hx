class Selector {
  public function new() {
  
  }
}

class Rule {
  public dynamic var styles : Array<Style>;
  public var selector : String;
  public function new(selector, styles) {
    this.selector = selector;
    this.styles = styles;
  }
}

class Style {
  public var property : String;
  public var value    : String;
  
  public function new(property, value) {
    this.property = property;
    this.value    = value;
  }
}

class Stylesheet {
  
  public dynamic var rules : Array<Rule>;
  
  public function new() {
    this.rules = [];
  }
  
  public function parse(css) {
    var parsed = new Parser(css);
    this.rules.concat(parsed.rules);
  }
}

class Parser {
  static var CHUNKER  = ~/[a-zA-Z.#>,: ]+\{[0-9a-z\-:; ]+\}/g;
  static var SELECTOR = ~/^[a-zA-Z.#>,: ]+/;
  static var RULES    = ~/\{([0-9a-z\-:; ]+)\}/;
  static var RULE     = ~/;/g;
  static var PROPERTY = ~/:/g;
  
  dynamic var css    : String;
  dynamic var chunks : Array<String>;
  public dynamic var rules : Array<Rule>;

  public function new(css) {
    this.css = css;
    this.rules = [];
    var styles = [];
    this.chunkCSS();
    var selector;
    var _rules;
    var splitRules;
    var keyValue;
    
    // OMG SO SORRY
    for(chunk in this.chunks) {
      SELECTOR.match(chunk);
      selector = SELECTOR.matched(1);
      
      if(selector != null) {
        RULES.match(chunk);
        _rules = RULES.matched(1);
      
        if(_rules != null) {
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

