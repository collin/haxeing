import Array;

class Rule {
  public function new(selector, syles) {
  
  }
}

class Style {
  public function new(property, value) {
  
  }
}

class Stylesheet {
  
  dynamic var styles : Array<Style>;
  
  public function new() {
  
  }
  
  static function parse(css) {
    var parsed = new Parser(css);
  }
}

class Parser {
  static var CHUNKER  = ~/[a-zA-Z.#>,: ]+\{[0-9a-z\-:; ]+\}/g;
  static var SELECTOR = ~/^[a-zA-Z.#>,: ]+/;
  static var RULES    = ~/\{([0-9a-z\-:; ]+)\}/;
  static var RULE     = ~/;/;
  static var PROPERTY = ~/:/;
  
  dynamic var css    : String;
  dynamic var chunks : Array<String>;
  dynamic var styles : Array<Style>;

  public function new(css) {
    this.css = css;
    this.styles = [];
    this.chunkCSS();  
    this.chunks.map(function(chunk){
      var selector = chunk.match(SELECTOR)[0];
      var rules    = (chunk.match(RULES)[1] || "")
        .split(RULE).map(function(rule) {
          var split = rule.split(PROPERTY);
          return new Rule(split[0], split[1]);
        });
      return new Style(selector, rules);
    });
  }
  
  public function chunkCSS() {
    var chunks = this.css.match(CHUNKER);
    if(chunks) this.chunks = chunks;
    else       this.chunks = [];
  }
}

