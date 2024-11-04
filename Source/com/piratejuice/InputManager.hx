package com.piratejuice;

import flash.display.Stage;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.EventDispatcher;
import flash.Lib;

import com.piratejuice.InputKey;

/**
*	InputManager Class
*	@author David Durham 
*	
* 	Original AS3 Version 2010
* 	Ported to Haxe NME 2013
* 	
* 	Manage key states for a custom list of keys
*	Example Usage:
*
*	// create InputManager instance
*	var test:InputManager = new InputManager();
*	
*	// create a key with a name and keycode
*	test.addKey("fire", 90);
*	
*	// return true if key is down (false if up)
*	if (test.keyDown("fire"));
*/

class InputManager extends EventDispatcher {
	
	// reference to the stage
	private var stage:Stage;
	
	// control key list
	private var keys:Array<InputKey>;
	
	// listener functions
	private var funcs:Array<Dynamic>;
	private var upFuncs:Array<Dynamic>;
	
	// enabled flag
	public var isEnabled:Bool;
	
	
	/* CONSTRUCTOR */
	
	public function new(stageRef:Stage):Void {
		
		super();
		
		// save ref. to stage
		stage = stageRef;
		
		// initialize key list
		keys = [];
		
		// listener functions
		funcs = [];
		upFuncs = [];
		
		// add keyboard event listeners
		stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
		stage.addEventListener(KeyboardEvent.KEY_UP, keyReleased);
		
		isEnabled = true;
	}
	
	public function cleanUp():Void {
		
		isEnabled = false;
		
		stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
		stage.removeEventListener(KeyboardEvent.KEY_UP, keyReleased);
		
		keys.splice(0, keys.length);
		keys = null;
		
		funcs.splice(0, funcs.length);
		funcs = null;
		
		upFuncs.splice(0, upFuncs.length);
		upFuncs = null;
		
		stage = null;
	}
	
	
	/* Interface */
	
	public function addKey(keyName:String, keyCode:Int):Bool {
		
		for (i in keys) {
			
			if (i.name == keyName) {
				
				// name already exists - update associated key code
				i.code = keyCode;
				i.down = false;
				return true;
			}
			
			if (i.code == keyCode) {
				
				// keycode already assigned!
				Lib.trace("Keycode already assigned to " + i.name);
				return false;
			}
		}
		
		// new key
		keys.push(new InputKey(keyName, keyCode, false));
		return true;
	}
	
	public function keyDown(keyName:String):Bool {
		
		if (!isEnabled) return false;
		
		for (i in keys) {
			
			if (i.name == keyName) {
				
				return i.down;
			}
		}
		
		return false;
	}
	
	
	/* Adds a 'listener' */
	
	public function onKey(keyName:String, eventName:String):Void {
		
		for (i in 0...keys.length) {
			
			if (keys[i].name == keyName) {
				
				funcs[i] = eventName;
				break;
			}
		}
	}
	
	public function onKeyUp(keyName:String, eventName:String):Void {
		
		for (i in 0...keys.length) {
			
			if (keys[i].name == keyName) {
				
				upFuncs[i] = eventName;
				break;
			}
		}
	}
	
	
	/* Keyboard Event Handlers */
	
	private function keyPressed(event:KeyboardEvent):Void {
		
		if (!isEnabled) return;
		
		// set key states true
		for (i in 0...keys.length) {
			
			if (Std.int(event.keyCode) == keys[i].code) {
				
				if (keys[i].down) return;
				keys[i].down = true;
				
				//if (funcs != null) {
					
					dispatchEvent(new Event(funcs[i]));
				//}
			}
		}
	}
	
	private function keyReleased(event:KeyboardEvent):Void {
		
		if (!isEnabled) return;
		
		// set key states false
		for (i in 0...keys.length) {
			
			if (Std.int(event.keyCode) == keys[i].code) {
				
				if (!keys[i].down) return;
				keys[i].down = false;
				
				dispatchEvent(new Event(upFuncs[i]));
			}
		}
	}
}