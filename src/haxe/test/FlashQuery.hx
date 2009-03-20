import flash.display.DisplayObjectContainer;

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
