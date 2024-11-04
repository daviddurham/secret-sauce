package com.piratejuice.vfx;

import flash.display.Sprite;

class ScreenShake {

	// shake properties
	private var dx:Float;
	private var dy:Float;
	private var f:Float;
	private var r:Float;
	
	// reference to shake clip
	private var clip:Sprite;
	
	// original position of clip
	private var sx:Float = 0;
	private var sy:Float = 0;
	
	// shaking flag
	private var isShaking:Bool;
	
	public function new():Void {
		
		// default initial settings
		dx = 0;
		dy = 0;
		f = 1;
		
		// default reduction
		r = 0.5;
		
		// initially not shaking
		isShaking = false;
		
		// clear reference
		clip = null;
	}

	public function shake(pDx:Float, pDy:Float, pClip:Sprite):Void {
		
		// only shake if not already shaking
		if (!isShaking) {
			
			// reference supplied clip
			clip = pClip;
			
			// save original position
			sx = clip.x;
			sy = clip.y;
			
			// set shake properties
			dx = pDx;
			dy = pDy;
			f = 1;
			
			isShaking = true;
		}
	}

	public function setReduction(pR:Float):Void {
		
		r = pR;
	}

	public function update():Void {
		
		// update if shaking
		if (isShaking) {
			
			// update clip position
			clip.x = sx + (dx * f);	
			clip.y = sy + (dy * f);	
			
			// reduce shake factor
			f *= (-1 * r);
		
			// has the shaker come to rest
			if (Math.abs(f) < 0.1) {
			
				// stop shaking
				isShaking = false;
				
				// reset position
				clip.x = sx;
				clip.y = sy;
			}
		}
	}
}