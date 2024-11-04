package com.piratejuice;

class Vector2D {

	/* Constants */
	
	private var D180_OVER_PI:Float;
	private var PI_OVER_D180:Float;
	
	
	/* Variables */
	
	public var x:Float;
	public var y:Float;
	
	
	/* Constructor */
	
	public function new(vx:Float = 0, vy:Float = 0):Void {
		
		D180_OVER_PI = 180 / Math.PI;
		PI_OVER_D180 = Math.PI / 180;
		
		x = vx;
		y = vy;
	}
	
	public function addVector(v:Vector2D):Void {
		
		x += v.x;
		y += v.y;
	}
	
	public function scale(s:Float):Void {
		
		x *= s;
		y *= s;
	}
	
	public function magnitude():Float {
		
		return Math.sqrt((x * x) + (y * y));
	}
	
	public function normalize():Void {
		
		var len:Float = magnitude();
		
		x = x / len;
		y = y / len;
	}
	
	public function dot(v:Vector2D):Float {
		
		var dp:Float = (x * v.x) + (y * v.y);
		return dp;
	}
	
	public function vector(ang:Float):Void	{
		
		x = Math.sin(ang * PI_OVER_D180);
		y = -Math.cos(ang * PI_OVER_D180);
	}
	
	public function angle():Float {
	
		//trace(x + ", " + y);
		var r:Float = Math.atan2(-y, -x);
		//trace(r);
		var d:Float = Math.round(r * D180_OVER_PI);
		//trace(d);
		// subtract 90 to orient angle correctly
		d -= 90;
		
		// lock value to within 1 to 360 range
		if (d > 360) d -= 360;
		if (d <= 0) d = 360 + d;
		
		return d;
	}
}