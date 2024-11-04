package com.piratejuice.events;
	
import flash.events.Event;

class TickerEvent extends Event {
	
	public static var TICK:String = "tick";

	public var interval:Float;
	
	public function new(i:Float) {
		
		super(TICK, false, false);
		interval = i;
	}
}