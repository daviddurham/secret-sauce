package com.piratejuice;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.display.PixelSnapping;
import flash.events.Event;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.Lib;

import openfl.Assets;

class BitmapSprite extends Sprite {
	
	// spritesheet
	private var spriteBmpData:BitmapData;
	
	// cache data
	private static var cachedData:Map<String, Array<BitmapData>>;
	
	// an empty bitmap
	private var finalSpriteBmp:Bitmap;
	private var spriteAnimation:Array<BitmapData>;

	// width of the spitesheet
	private var totalWidth:Int = 0;
	
	// store the current frame number for blitting
	private var frameNum:Int;
	
	// anchor point, is usually 0,0
	private var point:Point;
	
	// the section of the image that we need
	private var rect:Rectangle;
	
	// number of frames
	private var len:Int;
	
	// animating?
	private var isRunning:Bool;

	// interval
	private var interval:Int;
	private var count:Int;
	
	// animation list
	private var animations:Array<BitmapSpriteAnimation>;
	
	private var currentAnim:String;
	private var animStart:Int;
	private var animEnd:Int;
	private var animNext:String;
	
	public function new(spritesheet:String, frames:Int = 1, w:Int = 32, h:Int = 32, isMouseEnabled:Bool = false, isSmoothing:Bool = true):Void {
		
		super();
		
		// instantiate cached data
		if (cachedData == null) cachedData = new Map<String, Array<BitmapData>>();
		
		frameNum = 0;
		point = new Point(0, 0);
		rect = new Rectangle(0, 0, w, h);
		
		len = frames;
		
		if (!cachedData.exists(spritesheet)) {
			
			spriteAnimation = new Array<BitmapData>();
			spriteBmpData = Assets.getBitmapData(spritesheet);
			
			totalWidth = spriteBmpData.width;
			
			var x:Int = 0;
			var y:Int = 0;
			
			for (i in 0...len) {
			
				x = 0;
				y = 0;
				
				// shift the rectangle position of 32 every frame, for 3 frames in loop.
				//rect.x = w * i;
				
				x = i * w;
				
				while (x >= totalWidth) {
					
					x -= totalWidth;
					y += h;
				}
				
				rect.x = x;
				rect.y = y;
				
				var bmpData:BitmapData = new BitmapData(w, h);
				bmpData.copyPixels(spriteBmpData, rect, point);
				
				// create a new BitmapData in the Array
				spriteAnimation.push(bmpData);
			}
			
			cachedData.set(spritesheet, spriteAnimation);
		}
		else {
			
			spriteAnimation = cachedData.get(spritesheet);
		}
		
		// create bitmap and add to display list
		finalSpriteBmp = new Bitmap();
		finalSpriteBmp.smoothing = isSmoothing;
		finalSpriteBmp.pixelSnapping = PixelSnapping.ALWAYS;
		addChild(finalSpriteBmp);
		
		// fill it's bitmapData with an image w x h
		finalSpriteBmp.bitmapData = new BitmapData(w, h);
		
		if (len > 1) isRunning = true;
		else isRunning = false;
		
		mouseChildren = false;
		mouseEnabled = isMouseEnabled;
		
		interval = 2;
		count = interval;
		
		animations = [];
		currentAnim = "";
		animStart = 0;
		animEnd = len;
		animNext = "";
	}
	
	public function offset(px:Int = 0, py:Int = 0):Void {
		
		finalSpriteBmp.x = px;
		finalSpriteBmp.y = py;
	}

	public function addAnimation(aName:String, aStart:Int = 1, aEnd:Int = 1, aNext:String = ""):Void {
		
		animations.push(new BitmapSpriteAnimation(aName, aStart, aEnd, aNext));
	}
	
	public function setAnimation(aName:String):Void {
		
		for (i in animations) {
			
			if (i.name == aName) {
				
				currentAnim = i.name;
				animStart = i.start;
				animEnd = i.end;
				animNext = i.next;
				
				gotoFrame(animStart);
				break;
			}
		}
	}
	
	public function start():Void {
		
		if (len > 1) isRunning = true;
	}
	
	public function stop():Void {
		
		isRunning = false;
	}
	
	public function gotoFrame(f:Int):Void {
		
		frameNum = f;
		if (frameNum >= len) frameNum = len - 1;
		
		finalSpriteBmp.bitmapData = spriteAnimation[frameNum];
	}
	
	public function setInterval(val:Int):Void {
		
		interval = val;
	}
	
	public function update():Void {
		
		if (isRunning) {
			
			if (count-- <= 0) {
				
				if (++frameNum >= animEnd) {
					
					dispatchEvent(new Event(Event.COMPLETE));
					
					if (animNext != "") {
						
						setAnimation(animNext);
					}
					else frameNum = animStart;
				}
				
				finalSpriteBmp.bitmapData = spriteAnimation[frameNum];
				count = interval;
			}
		}
	}
}