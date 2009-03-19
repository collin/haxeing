import flash.Lib;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.display.MovieClip;
import flash.display.Shape;
import flash.events.MouseEvent;

class FlashQuery {
  static  var root = flash.Lib.current;
  private var items : Array<DisplayObjectContainer>;
  
  public function new(item) {
    this.items = [];
    if(item == null) this.items.push(FlashQuery.root);
    else this.items.push(item);
  }
  
  public function each(fn) {
    for(item in this.items) fn(item);
    return this;
  }
  
  public function append(object) {
    return this.each(function(item) {
      item.addChild(object);
    });
  }
  
  public function bind(eventName:String, handler) { 
    this.each(function(item) {
      item.addEventListener(eventName, handler);
    });
    return this;
  }
  
  public function click(handler) {
    return this.bind('click', handler);
  }
  
  public function mouseDown(handler) {
    return this.bind('mouseDown', handler);
  }
  
  public function mouseUp(handler) {
    return this.bind('mouseUp', handler);
  }
}

class Application {
  static function _(query=null) {
    return new FlashQuery(query);
  }

  static function main() {
    var sp = new Sprite();
    var g = sp.graphics;
    
    g.beginFill(0xFF0000);
    g.moveTo(0, 0);
    g.lineTo(50,0);
    g.lineTo(50,50);
    g.lineTo(0,50);
    g.endFill();
    
    _().append(sp);
    
    _(sp)
      .mouseDown(function() {
        sp.startDrag();
      })
      .mouseUp(function() {
        sp.stopDrag();
      });
  }
}
