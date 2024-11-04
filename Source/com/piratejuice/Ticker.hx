package com.piratejuice;

import flash.display.Sprite;
import flash.events.Event;
import flash.Lib.getTimer;

import com.piratejuice.events.TickerEvent;

class Ticker extends Sprite {
	
	private var lastUpdate:Float;
	private var accumulated:Float;
	
	public var delay:Float;
	public var isRunning:Bool;
	
	public function new(d:Float = 16.667):Void {
		
		super();
		
		isRunning = false;
		delay = d;
	}
	
	public function start():Void {
		
		isRunning = true;
		lastUpdate = getTimer();
		accumulated = 0;
		addEventListener(Event.ENTER_FRAME, tick);
	}
	
	public function stop():Void	{
		
		removeEventListener(Event.ENTER_FRAME, tick);
		isRunning = false;
	}
	
	private function tick(event:Event):Void {
		
		var deltaTime:Float = calculateDeltaTime();
		
		if (isRunning) {
			
			//accumulated += deltaTime;
			
			//while (accumulated >= delay) {
			
				//accumulated -= delay;
				dispatchEvent(new TickerEvent(delay));
			//}
		}
	}
	
	private function calculateDeltaTime():Float {
		
		var currTime:Float = getTimer();
		var deltaTime:Float = currTime - lastUpdate;
		lastUpdate = currTime;
		
		return deltaTime;
	}
}