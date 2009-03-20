import Box;
import Stylesheet;
import flash.display.MovieClip;

class Document {
  dynamic var box : MovieClip;

  public function new(box) {
    this.box = box;
  }
}

class Node {
  dynamic public var box : Box;
  dynamic public var document   : Document;
  dynamic public var parentNode : Node;
  dynamic public var childNodes : Array<Node>;
    
  public function new(document) {
    this.childNodes = [];
    this.document = document;
    this.box = new Box();
  }
  
  public function append(node:Node) {
    if(node.parentNode != null) node.parentNode.removeChild(node);
    node.parentNode = this;
    this.childNodes.push(node);
    this.box.addChild(node.box);
    this.reflow();
  }
  
  public function removeChild(node:Node) {
    node.parentNode = null;
    this.childNodes = this.childrenWithout(node);
    this.box.removeChild(node.box);
    this.reflow();
  }
  
  public function appendTo(node:Node) {
    node.append(this);
  }
  
  public function siblings() {
    return this.parentNode.childrenWithout(this);
  }
  
  private function childrenWithout(node:Node) {
    var without = [];
    for(child in this.childNodes) if (child != node) without.push(child);
    return without;
  }

  private function reflow() {
    // TODO
  }
}

