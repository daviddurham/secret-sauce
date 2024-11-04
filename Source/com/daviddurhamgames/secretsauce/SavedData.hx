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
			
			case "vintage_filter":
				
				return object.data.vintage_filter;

			case "screen_controls":
				
				return object.data.screen_controls;

			case "hat_type":
				
				return object.data.hat_type;

			case "sfx_volume":
				
				return object.data.sfx_volume;

			case "music_volume":
				
				return object.data.music_volume;

			case "test":
				
				return object.data.test;
				
			case "progress_1":
				
				return object.data.progress_1;
				
			case "progress_2":
				
				return object.data.progress_2;
		}
		
		return "";
	}
	
	public function save(key:String, value:String):Void {
		
		switch(key) {
			
			case "vintage_filter":
				
				object.data.vintage_filter = value;

			case "screen_controls":
				
				object.data.screen_controls = value;

			case "hat_type":
				
				object.data.hat_type = value;

			case "sfx_volume":
				
				object.data.sfx_volume = value;

			case "music_volume":
				
				object.data.music_volume = value;

			case "test":
				
				object.data.test = value;
				
			case "progress_1":
				
				object.data.progress_1 = value;
				
			case "progress_2":
				
				object.data.progress_2 = value;
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
		save("vintage_filter", "1");
		save("screen_controls", "1");
		save("hat_type", "1");
		
		save("test", "default");
		
		save("progress_1", "-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1");
		save("progress_2", "-1,-1,-1,-1,-1,-1,-1,-1,-1,-1");
	}
}