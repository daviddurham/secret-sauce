package com.piratejuice.vfx;

import com.piratejuice.Vector3D;
import flash.geom.Point;
import openfl.Assets;
import flash.display.Sprite;
import flash.display.Bitmap;

import com.piratejuice.BitmapSprite;

class Particle extends Sprite {
	
	// lifespan and fade values
	public var life:Float;
	public var maxLife:Float;
	public var fade:Float;
	
	// rotation rate
	public var rot:Float;
	
	// scaling rate
	public var scalingX:Float;
	public var scalingY:Float;
	
	// animated
	public var isAnimated:Bool;
	
	// graphics
	public var bmp:Bitmap;
	public var anim:BitmapSprite;
	
	public var pos:Vector3D;
	public var vel:Vector3D;
	
	public function new(asset:String, frames:Int = 1, w:Int = 0, h:Int = 0, animDelay:Int = 1):Void {
		
		super();
		
		pos = new Vector3D();
		vel = new Vector3D();
		
		mouseEnabled = mouseChildren = false;
		
		// use animated bitmap sprite
		if (frames > 1) {
			
			isAnimated = true;
			
			anim = new BitmapSprite(asset, frames, w, h);
			anim.setInterval(animDelay);
			anim.x = -anim.width / 2;
			anim.y = -anim.height / 2;
			addChild(anim);
		}
		// use static bitmap
		else {
			
			isAnimated = false;
			
			bmp = new Bitmap(Assets.getBitmapData(asset));
			bmp.x = -bmp.width / 2;
			bmp.y = -bmp.height / 2;
			addChild(bmp);
		}
	}
	
	public function reset():Void {
		
		if (isAnimated) {
			
			anim.gotoFrame(0);
		}
	}
	
	public function update():Void {
		
		if (isAnimated) anim.update();
	}
}