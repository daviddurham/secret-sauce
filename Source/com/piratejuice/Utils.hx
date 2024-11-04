package com.piratejuice;

/**
 * @author David Durham
 */

class Utils {
	
	public static function boolToInt(val:Bool):Int {
		
		return (val) ? 1 : 0;
	}
	
	public static function existsInArray(array:Array<Dynamic>, item):Bool {
		
		for (i in array) {
			
			if (i == item) return true;
		}
		
		return false;
	}
	
	public static function removeFromArray(array:Array<Dynamic>, item):Void {
		
		var len:Int = array.length;
		
		for (i in 0...len) {
			
			if (array[i] == item) {
				
				array.splice(i, 1);
				break;
			}
		}
	}
	
	public static function shuffle(list:Array<Dynamic>):Array<Dynamic> {
		
		// firstly create a destination list
		var a:Array<Dynamic> = [];
		
		// now pull random elements out of the source list
		var len:Int = list.length;
		
		for (i in 0...len) {
			
			var r:Int = Math.floor((Math.random() * list.length));
			a.push(list[r]);
			list.splice(r, 1);
		}
		
		// copy back
		for (j in 0...len) {
			
			list[j] = a[j];
		}
		
		return list;
	}
}