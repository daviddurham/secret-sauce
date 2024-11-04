package com.piratejuice;
	
import flash.media.Sound;
import openfl.Assets;

import com.piratejuice.Audio;

class TextPrintout {
	
	private var fullText:String;
	private var displayText:String;
	private var displayChars:Int;
	private var count:Int;
	private var interval:Int;
	
	private var sfx:Audio;
	
	public function new(str:String, inter:Int = 1):Void {
		
		fullText = str;
		interval = inter;
		
		//sfx = new Audio(Assets.getSound("assets/audio/text.wav"), 0);
		
		reset();
	}
	
	public function setText(str:String):Void {
		
		reset();
		fullText = str;
		trace(fullText);
	}
	
	public function getText():String {
		
		return displayText;
	}
	
	public function reset():Void {
		
		count = 0;
		
		displayText = "";
		displayChars = 0;
	}
	
	public function showAll():Void {
		
		displayChars = fullText.length;
		displayText = fullText;
		
		//sfx.stop();
	}
	
	public function update():Void {
		
		count++;
		
		if (count >= interval) {
			
			count = 0;
			
			if (displayChars < fullText.length) {
				
				//if (displayChars == 0) sfx.play();
				
				displayChars++;
				displayText = fullText.substr(0, displayChars);
			}
			else {
				
				//sfx.stop();
			}
		}
	}
}