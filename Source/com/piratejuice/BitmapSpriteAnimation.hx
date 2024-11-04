package com.piratejuice;

class BitmapSpriteAnimation {
	
	public var name:String;
	
	public var start:Int;
	public var end:Int;
	
	public var next:String;
	
	public function new(aName:String, aStart:Int = 1, aEnd:Int = 1, aNext:String = ""):Void {
		
		name = aName;
		
		start = aStart;
		end = aEnd;
		
		next = aNext;
	}
}