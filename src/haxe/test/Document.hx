import Box;
import Stylesheet;
import flash.display.MovieClip;

class AbstractNode {
  dynamic public var childNodes : Array<AbstractNode>;
}

class Document extends AbstractNode {
  dynamic var box : MovieClip;
  dynamic public var stylesheet : Stylesheet;

  public function new(box) {
    this.stylesheet = new Stylesheet();
    this.box = box;
  }
  
  public static function fromXml(box, xml:Xml) {
    var document = new Document(box);

    for(child in xml.elements()) 
      document.childNodes.push(Node.fromXml(document, child));
    return document;
  }
}

class Node extends AbstractNode {
  dynamic public var box : Box;
  dynamic public var document   : Document;
  dynamic public var parentNode : Node;
  public var tagName : String;
    
  public static function fromXml(document, xmlNode:Xml) {
    var node = new Node(document, xmlNode.nodeName);
    for(child in xmlNode.elements())
      node.childNodes.push(Node.fromXml(document, child));
      
    return node;
  }
    
  public function new(document, tagName) {
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

