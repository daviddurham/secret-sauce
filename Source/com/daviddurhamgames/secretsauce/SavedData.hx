package com.daviddurhamgames.secretsauce;

import openfl.net.SharedObject;

class SavedData {

	private var object:SharedObject;
	
	public function new() {
		
		object = SharedObject.getLocal("saved_data");
		
		if (object.data.test == null) {
			
			reset();
		}
	}
	
	public function load(key:String):String {
		
		switch(key) {
			
			case "pixel_filter":
				
				return object.data.pixel_filter;

			case "screen_controls":
				
				return object.data.screen_controls;

			case "sfx_volume":
				
				return object.data.sfx_volume;

			case "music_volume":
				
				return object.data.music_volume;

			case "test":
				
				return object.data.test;
				
			case "progress":
				
				return object.data.progress_1;
		}
		
		return "";
	}
	
	public function save(key:String, value:String):Void {
		
		switch(key) {
			
			case "pixel_filter":
				
				object.data.vintage_filter = value;

			case "screen_controls":
				
				object.data.screen_controls = value;

			case "sfx_volume":
				
				object.data.sfx_volume = value;

			case "music_volume":
				
				object.data.music_volume = value;

			case "test":
				
				object.data.test = value;
				
			case "progress":
				
				object.data.progress_1 = value;
		}
		
		object.flush();
	}
	
	public function clear():Void {
		
		// clear all data
		object.clear();
		object.flush();
		
		reset();
	}
	
	public function reset():Void {
		
		// set default vaules
		save("sfx_volume", "1");
		save("music_volume", "1");
		save("pixel_filter", "1");
		save("screen_controls", "1");
		
		save("test", "default");
		
		// day, target, current
		save("progress", "0,1,1,1,2,2,2");
	}
}