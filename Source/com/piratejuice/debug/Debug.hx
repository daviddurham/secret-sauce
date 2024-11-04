package com.piratejuice.debug;

import flash.events.Event;
import flash.display.Sprite;
import flash.system.System;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFieldAutoSize;
import flash.Lib;

class Debug extends Sprite {
	
	private static var tf:TextField;
	
	public function new(xPos:Int = 0, yPos:Int = 0, colour:Int = 0xffffff) {
		
		super();
		
		x = xPos;
		y = yPos;
		
		tf = new TextField();
		
		var format:TextFormat = new TextFormat("_sans", 6);
		tf.defaultTextFormat = format;
		
		tf.textColor = colour;
		tf.text = "";
		tf.selectable = true;
		tf.autoSize = TextFieldAutoSize.LEFT;
		addChild(tf);
	}

	public static function log(message:String) {
		
		tf.text += message;
		tf.text += "\n";
	}
}