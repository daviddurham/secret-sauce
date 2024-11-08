package com.daviddurhamgames.secretsauce;

import openfl.geom.Point;

class ObjectData {
	
	public var id:Int;
	public var pos:Point;
	
	public var radius:Int;

	public function new(objId:Int, posX:Float, posY:Float, r:Int = 128) {
		
		id = objId;

		// NOTE: converting original 512px tile positions
		// to new 64px tile position by dividing by 8
        pos = new Point(posX, posY);

		// optional radius
		radius = r;
    }
}