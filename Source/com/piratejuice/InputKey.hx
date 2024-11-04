package com.piratejuice;

/** 
*	InputKey Class used in InputManager
*	@author David Durham
* 
* 	Original AS3 version 2010
* 	Ported to Haxe 2013
* 
*	Stores key name, code and state
*/

class InputKey {
	
	public var name:String;
	public var code:Int;
	public var down:Bool;		
	
	public function new(kName:String, kCode:Int, kDown:Bool = false):Void {
		
		name = kName;
		code = kCode;
		down = kDown;
	}
}