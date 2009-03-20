package css {
  class Rule {
    public function new() {
    
    }
  }
  
  class Style {
    public function new() {
    
    }
  }
  
  class Stylesheet {
    
    dynamic var styles = Array<Style>;
    
    public function new() {
    
    }
    
    static function parse(css) {
      parsed = new Parser(css);
    }
    
    static function
  }
  
  class Parser {
    const CHUNKER  = /[a-zA-Z.#>,: ]+\{[0-9a-z\-:; ]+\}/g;
    const SELECTOR = /^[a-zA-Z.#>,: ]+/;
    const RULES    = /\{([0-9a-z\-:; ]+)\}/;
    const RULE     = /;/
    const PROPERTY = /:/
    
    dynamic var css    : String;
    dynamic var chunks : Array<String>;
    dynamic var styles : Array<Style>;
 
    public function new(css) {
      this.css = css;
      this.styles = [];
      this.chunkCSS();  
      this.chunks.forEach(function(chunk){
        var selector = chunk.match(SELECTOR)[0];
        var rules    = (chunk.match(RULES)[1] || "").split(RULE);
        
      }, this);
    }
    
    public function chunkCSS() {
      var chunks = this.css.match(CHUNKER);
      if(chunks) this.chunks = chunks;
      else       this.chunks = [];
    }
  }
}
