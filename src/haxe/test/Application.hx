import flash.Lib;
import flash.display.Sprite;
import flash.display.MovieClip;
import flash.display.Shape;
import flash.events.MouseEvent;
import FlashQuery;
import Box;
import haxe.Resource;


class Application {
  static function _(query=null) {
    return new FlashQuery(query);
  }


  static function main() {
    var sp = new Sprite();
    var g = sp.graphics;

    var x = Xml.parse(Resource.getString("document.xml")).firstElement();
    
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
