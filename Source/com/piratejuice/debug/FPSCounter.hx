package com.piratejuice.debug;

import flash.events.Event;
import flash.display.Sprite;
import flash.system.System;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFieldAutoSize;
import flash.Lib;

/**
 * Framerate counter shows FPS as text
 * @author David Durham
 */

class FPSCounter extends Sprite {
	
	private var last:Int;
	private var ticks:Int;
	private var tf:TextField;
	
	public function new(xPos:Int = 0, yPos:Int = 0, colour:Int = 0x000000) {
		
		super();
		
		last = Lib.getTimer();
		ticks = 0;
		
		x = xPos;
		y = yPos;
		
		tf = new TextField();
		
		var format:TextFormat = new TextFormat("_sans", 24);
		tf.defaultTextFormat = format;

		tf.textColor = colour;
		tf.text = "0 FPS\n0 MB";
		tf.selectable = false;
		tf.autoSize = TextFieldAutoSize.LEFT;
		addChild(tf);
		
		addEventListener(Event.ENTER_FRAME, tick);
	}

	private function tick(event:Event):Void {
		
		ticks++;
		
		var now:Int = Lib.getTimer();
		var delta:Int = now - last;
		
		if (delta >= 1000) {
			
			var fps:Float = ticks / delta * 1000;
			tf.text = Std.string(fps).substr(0, 4);
			
			//var mem:Float = System.totalMemory / 1024 / 1024;
			//tf.appendText("\n" + Std.string(mem).substr(0, 4) + " MB");
			
			ticks = 0;
			last = now;
		}
	}
}