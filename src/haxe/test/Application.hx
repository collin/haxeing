import flash.Lib;
import flash.display.Sprite;
import flash.display.MovieClip;
import flash.display.Shape;
import flash.events.MouseEvent;
import FlashQuery;
import Document;
import haxe.Resource;

class Application {
  static function _(query=null) {
    return new FlashQuery(query);
  }


  static function main() {    
    var doc = Document.fromResource(flash.Lib.current, "document.xml");
    trace("\n"+Resource.getString("stylesheet.css"));
    doc.stylesheet.parseResource("stylesheet.css");
    trace('loaded stylsheet');
    trace(doc.stylesheet.rules);
    for(rule in doc.stylesheet.rules) {
      trace(rule.selector);
      for(style in rule.styles) {
        style.inspect();
      }
    }
    
/*    var g = flash.Lib.current.getChildAt(1).graphics;*/
/*    var sp = doc.childNodes[0];      */
/*    var g = sp.box.graphics;*/
      
/*    var sp = new Sprite();*/
/*    var g = sp.graphics;*/
/*    g.beginFill(0xFF0000);*/
/*    g.moveTo(0, 0);*/
/*    g.lineTo(50,0);*/
/*    g.lineTo(50,50);*/
/*    g.lineTo(0,50);*/
/*    g.endFill();*/
/*    trace("what");*/
    
/*    flash.Lib.current.addChild(sp.box);    */
/*    _().append(sp.box);*/
/*    */
/*    _(sp)*/
/*      .mouseDown(function() {*/
/*        sp.startDrag();*/
/*      })*/
/*      .mouseUp(function() {*/
/*        sp.stopDrag();*/
/*      });*/
  }
}
