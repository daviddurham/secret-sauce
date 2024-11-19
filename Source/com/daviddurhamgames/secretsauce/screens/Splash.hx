package com.daviddurhamgames.secretsauce.screens;

import openfl.display.MovieClip;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.Assets;

import motion.Actuate;

class Splash extends Sprite {
	
	// game running flag
	private var isRunning:Bool;
		
	// hold everything in this
	private var holder:Sprite;
	
	// background
	private var _bg:Bitmap;

	// intro animation	
	private var anim:MovieClip;
	
	public function new() {
		
		super();
		addEventListener(Event.ADDED_TO_STAGE, init);
	}

	private function init(event:Event) {
		
		removeEventListener(Event.ADDED_TO_STAGE, init);
		
		isRunning = true;
		
		// all screen elements contained in this
		holder = new Sprite();
		addChild(holder);
		
		anim = Assets.getMovieClip("game:SplashScreenAnim");
		anim.x = (Main.maxWidth / 2);
		anim.y = (Main.maxHeight / 2);
		anim.addFrameScript(119, onAnimationComplete);
		holder.addChild(anim);
		
		// ensure we have focus
		stage.focus = stage;
		mouseEnabled = false;
	}
	
	private function onAnimationComplete():Void {
		
		anim.stop();
		Actuate.timer(0.25).onComplete(onComplete);
		//onComplete(null);
	}
	
	private function onComplete(event:Event = null):Void {
		
		cleanUp();
		dispatchEvent(new Event("init_menu"));
	}
	
	public function cleanUp():Void {
		
		holder.removeChild(_bg);
		_bg = null;
		
		holder.removeChild(anim);
		anim = null;
		
		removeChild(holder);
		holder = null;
	}
}