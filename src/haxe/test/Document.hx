import Box;

class Document {
  dynamic var box;

  public function new() {
    this.box = flash.Lib.current();
  }
}

class Node {
  dynamic var box : Box;
  dynamic var document   : Document;
  dynamic var parentNode : Node;
  dynamic var childNodes : Array<Node>;
    
  public function new(document) {
    this.document = document;
    this.box = Box.new();
  }
  
  public function append(node) {
    if(!node.parentNode == null) node.parentNode.removeChild(node);
    node.parentNode = this;
    this.childNodes.push(node);
    this.reflow();
  }
  
  public function appendTo(node) {
    node.append(this);
  }
  
  public function removeChild(node) {
    node.parentNode = null;
    this.childNodes = this.childrenWithout(node);
    this.reflow();
  }
  
  public function siblings() {
    return this.parentNode.childrenWithout(self);
  }
  
  private function childrenWithout(node) {
    return this.childNodes.filter(function(child) {
      return child != node;
    });
  }

  private function reflow() {
    // TODO
  }
}

