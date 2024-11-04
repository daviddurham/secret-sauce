package com.piratejuice;

class Vector3D {

	/* Constants */
	
	private var D180_OVER_PI:Float;
	private var PI_OVER_D180:Float;
	
	
	/* Variables */
	
	public var x:Float;
	public var y:Float;
	public var z:Float;
	
	
	/* Constructor */
	
	public function new(vx:Float = 0, vy:Float = 0, vz:Float = 0) {
		
		D180_OVER_PI = 180 / Math.PI;
		PI_OVER_D180 = Math.PI / 180;
		
		x = vx;
		y = vy;
		z = vz;
	}

	
	/* Interface */
	
	// add another vector to this one
	public function addVector(v:Vector3D):Void {
		
		x += v.x;
		y += v.y;
		z += v.z;
	}
	
	// multiply vector
	public function scale(s:Float):Void {
		
		x *= s;
		y *= s;
		z *= s;
	}
	
	// get the vector length
	public function magnitude():Float {
		
		return Math.sqrt((x * x) + (y * y) + (z * z));
	}
	
	public function normalize():Void {
		
		var len:Float = magnitude();
		
		x = x / len;
		y = y / len;
		z = z / len;
	}
	
	// dot product
	public function dot(v:Vector3D):Float {
		
		var dp:Float = (x * v.x) + (y * v.y) + (z * v.z);
		return dp;
	}
	
	// angle between two vectors
	public function angle(v:Vector3D):Float {
		
		var dp:Float = dot(v);
		
		var len1:Float = magnitude();
		var len2:Float = v.magnitude();
		
		//cos(ang) = dp / (len1 * len2);
		return 0;
	}
	
	public function vector(ang:Float):Void {
		
		x = Math.sin(ang * PI_OVER_D180);
		z = -Math.cos(ang * PI_OVER_D180);
	}
}