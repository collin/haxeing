import Box;
import Stylesheet;
import flash.display.Sprite;
import haxe.Resource;

class AbstractNode {
  dynamic public var childNodes : Array<AbstractNode>;
  dynamic public var box : Sprite;
  public var tagName       : String;  
  dynamic public var id    : String;
  dynamic public var klass : String;
  
  dynamic public var styles : List<Style>;
  
  public function append(node:Node) {
    node.remove();
    node.parentNode = this;
    this.childNodes.push(node);
    this.box.addChild(node.box);
    this.reflow();
  }

  private function childrenWithout(node:Node) {
    var without = [];
    for(child in this.childNodes) if (child != node) without.push(child);
    return without;
  }

  public function removeChild(node:Node) {
    node.parentNode = null;
    this.childNodes = this.childrenWithout(node);
    this.box.removeChild(node.box);
    this.reflow();
  }

  public function new() {
    this.tagName = "";
    this.id      = "";
    this.klass   = "";
    this.childNodes = [];
  }

  private function reflow() {
    // TODO
  }
}

class Document extends AbstractNode {
  dynamic public var stylesheet : Stylesheet;

  public function new(box) {
    super();
    this.stylesheet = new Stylesheet();
    this.box = box;
    this.tagName = "document";
  }
  
  public static function fromResource(box, resourceName) {
    return Document.fromXmlString(box, Resource.getString(resourceName));
  }
  
  public static function fromXmlString(box, xmlString) {
    return Document.fromXml(box, Xml.parse(xmlString).firstElement());    
  }
  
  public static function fromXml(box, xml:Xml) {
    var document = new Document(box);
    for(child in xml.elements()) {
      document.append(Node.fromXml(document, child));
    }
    return document;
  }
}

class Node extends AbstractNode {
  dynamic public var document   : Document;
  dynamic public var parentNode : AbstractNode;
    
  public static function fromXml(document, xmlNode:Xml) {
    var node = new Node(document, xmlNode.nodeName);
    for(child in xmlNode.elements()) node.append(Node.fromXml(document, child));
    return node;
  }
    
  public function new(document, tagName) {
    super();
    this.document = document;
    this.box = new Box();
    this.tagName = tagName;
  }

  public function remove() {
    if(this.parentNode != null) this.parentNode.removeChild(this);
  }

  public function appendTo(node:Node) {
    node.append(this);
  }
    
  public function siblings() {
    return this.parentNode.childrenWithout(this);
  }
}

