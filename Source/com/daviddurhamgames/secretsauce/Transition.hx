package com.daviddurhamgames.secretsauce;

import openfl.Assets;
import openfl.display.PixelSnapping;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.events.Event;
import motion.Actuate;

class Transition extends Sprite {
	
	private var _bmp:Bitmap;
	private var _isHidden:Bool;
	
	public function new(w:Int = 1760, h:Int = 720):Void {
		
		super();
		
		_bmp = new Bitmap(Assets.getBitmapData("assets/black.png"), PixelSnapping.ALWAYS);
		_bmp.width = w;
		_bmp.height = h;
		_bmp.y = 0;
		
		addChild(_bmp);
		
		visible = false;
	}
	
	public function start(isHidden:Bool = false):Void {
		
		if (isHidden) {
			
			_bmp.alpha = 1.0;
			_isHidden = true;
		}
		else {
			
			// animate in
			Actuate.tween(_bmp, 1, { alpha: 1 } ).onComplete(onHide);
		}
		
		visible = true;
	}
	
	private function onHide():Void {
		
		_isHidden = true;
		dispatchEvent(new Event("transition_in"));
	}
	
	public function reveal():Void {
		
		if (_isHidden) {
			
			_isHidden = false;
			
			// animate out
			Actuate.tween(_bmp, 1, { alpha: 0 } ).onComplete(onShow);
		}
	}
	
	private function onShow():Void {
		
		visible = false;
		
		dispatchEvent(new Event("transition_out"));
	}
}