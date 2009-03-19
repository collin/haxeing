import flash.Lib;
import flash.display.Sprite;
import flash.display.MovieClip;
import flash.events.MouseEvent;


class Application {
    static function main() {
        var mc = flash.Lib.current;
        var sp = new Sprite();
        var g = sp.graphics;
        
        g.beginFill(0xFF0000);
        g.moveTo(0, 0);
        g.lineTo(50,0);
        g.lineTo(50,50);
        g.lineTo(0,50);
        g.endFill();
        
        mc.addChild(sp);
        
        sp.addEventListener("mouseDown", function() {
          sp.startDrag();
        });
        
        sp.addEventListener("mouseUp", function() {
          sp.stopDrag();
        });
    }
}
