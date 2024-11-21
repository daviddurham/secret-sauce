package com.piratejuice;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.filters.ColorMatrixFilter;
import openfl.geom.Rectangle;
import openfl.geom.Point;
import openfl.Assets;

class BitmapText extends Sprite {
	
	private var charSize:Int = 64;
	
	public var letterSpacing:Int = 42;
	private var lineSpacing:Int = 80;
	
	// the font spritesheet
	public var font:BitmapData;
	
	// print text to this
	public var page:Bitmap;
	
	// current string
	public var content:String;
	
	public function new(w:Int, h:Int, fontBmp:String = "assets/font_1.png", size:Int = 64, spacing:Int = 42, leading:Int = 80, isBlack:Bool = false):Void {
		
		super();
		
		charSize = size;
		letterSpacing = spacing;
		lineSpacing = leading;

		mouseEnabled = mouseChildren = false;
		
		font = Assets.getBitmapData(fontBmp);
		page = new Bitmap(new BitmapData(w, h, true, 0x00ffffff), null, true);
		
		addChild(page);

		if (isBlack) {

			var matrix:Array<Float> = [

				0, 0, 0, 0, 0, // red channel
				0, 0, 0, 0, 0, // green channel
				0, 0, 0, 0, 0, // blue channel
				0, 0, 0, 1, 0  // alpha channel (no change)
			];

			var filter:ColorMatrixFilter = new ColorMatrixFilter(matrix);
			
			// apply the filter to the bitmap
			page.filters = [filter];
		}
	}
	
	public function clear():Void {
		
		content = "";
		page.bitmapData.fillRect(page.bitmapData.rect, 0x00ffffff);
	}
	
	public function printText(text:String):Void {
		
		clear();
		content = text = text.toUpperCase();
		
		var len = text.length;
		
		var offsetY:Int = 0;
		var offsetX:Int = -letterSpacing;
		
		var val:Int = Std.int(charSize * (32 / charSize));
		
		for (i in 0...len) {
			
			var srcX:Int = ((text.charCodeAt(i) - val) % 10) * charSize;
			var srcY:Int = Math.floor((text.charCodeAt(i) - val) / 10) * charSize;
			
			offsetX += letterSpacing;
			
			if (text.charAt(i - 1) == " ") {
				
				// find next space
				var nextSpace:Int = text.indexOf(" ", i + 1);
				if (nextSpace == -1) nextSpace = len - 1;
				
				var dist:Int = nextSpace - i;
				
				if (offsetX + (letterSpacing * dist) > page.width) {
					
					offsetX = 0;
					offsetY += lineSpacing;
				}
			}
			
			page.bitmapData.copyPixels(font, new Rectangle(srcX, srcY, charSize, charSize), new Point(offsetX, offsetY), null, null, true);
		}
	}
}