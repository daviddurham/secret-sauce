package com.daviddurhamgames.secretsauce;
	
import openfl.events.MouseEvent;
import com.piratejuice.Vector2D;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.Shape;
import openfl.Assets;
import openfl.events.Event;
import openfl.events.TouchEvent;
import openfl.display.Stage;

class TouchController extends Sprite {
    	
    public var screen:Sprite;
        
	public var p1AreaL:Sprite;
	public var p1AreaR:Sprite;
    
	private var numberOfPlayers:Int = 1;

    public var isEnabled:Bool = true;

	public var isP1LeftDown:Bool = false;
	public var isP1RightDown:Bool = false;


    public function new(stage:Stage, players:Int = 1):Void {
	
        super();

		numberOfPlayers = players;
				
        p1AreaL = new Sprite();
        p1AreaL.graphics.beginFill(0x00ff00, 0);
        p1AreaL.graphics.drawRect(	0,
									0,
									Main.maxWidth * 0.5,
									Main.maxHeight);
        addChild(p1AreaL);

		p1AreaR = new Sprite();
        p1AreaR.graphics.beginFill(0xff00ff, 0);
        p1AreaR.graphics.drawRect(	Main.maxWidth * 0.5, 
									0, 
									Main.maxWidth * 0.5, 
									Main.maxHeight);
        addChild(p1AreaR);

		#if windows
		
			// mouse events for windows testing
			p1AreaL.addEventListener(MouseEvent.MOUSE_DOWN, onP1LDown);
			p1AreaL.addEventListener(MouseEvent.MOUSE_UP, onP1LUp);

			p1AreaR.addEventListener(MouseEvent.MOUSE_DOWN, onP1RDown);
			p1AreaR.addEventListener(MouseEvent.MOUSE_UP, onP1RUp);
		#else

			p1AreaL.addEventListener(TouchEvent.TOUCH_BEGIN, onP1LDown);
			p1AreaL.addEventListener(TouchEvent.TOUCH_END, onP1LUp);

			p1AreaR.addEventListener(TouchEvent.TOUCH_BEGIN, onP1RDown);
			p1AreaR.addEventListener(TouchEvent.TOUCH_END, onP1RUp);
		#end
	}

	private function onP1LDown(event:/*Touch*/Event = null) {

		//dispatchEvent(new Event("p1_left_down"));
		isP1LeftDown = true;
	}

	private function onP1LUp(event:/*Touch*/Event = null) {
		
		//dispatchEvent(new Event("p1_left_up"));
		isP1LeftDown = false;
	}

	private function onP1RDown(event:/*Touch*/Event = null) {

		//dispatchEvent(new Event("p1_right_down"));
		isP1RightDown = true;
	}

	private function onP1RUp(event:/*Touch*/Event = null) {
		
		//dispatchEvent(new Event("p1_right_up"));
		isP1RightDown = false;
	}

    public function setEnabled(flag:Bool):Void {

    }

	public function reset():Void {
		
	}

	public function onResize():Void {

		p1AreaL.graphics.clear();
        p1AreaL.graphics.beginFill(0x00ff00, 0);
        p1AreaL.graphics.drawRect(	0,
									0,
									Main.maxWidth * 0.5,
									Main.maxHeight);
		p1AreaR.graphics.clear();
        p1AreaR.graphics.beginFill(0xff00ff, 0);
        p1AreaR.graphics.drawRect(	Main.maxWidth * 0.5, 
									0, 
									Main.maxWidth * 0.5, 
									Main.maxHeight);
	}
}