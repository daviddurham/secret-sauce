package com.piratejuice;

import com.piratejuice.Vector2D;

class Collisions {
	
	
	/* Sphere / Circle Collisions */
	
	public static function sphereCollision(s1x:Float, s1y:Float, s1z:Float, s1r:Float, s2x:Float, s2y:Float, s2z:Float, s2r:Float):Bool {
		
		var dx:Float = s2x - s1x;
		var dy:Float = s2y - s1y;
		var dz:Float = s2z - s1z;
		
		// sum of diffs squared <= sum of radii squared = collision
		if ((dx * dx) + (dy * dy) + (dz * dz) <= (s1r + s2r) * (s1r + s2r)) {
			
			return true;
		}
		
		return false;		
	}
	
	public static function circleCollision(ax:Float, ay:Float, ar:Float, bx:Float, by:Float, br:Float):Float {
		
		var diffX:Float = bx - ax;
		var diffY:Float = by - ay;
		
		return ((diffX * diffX) + (diffY * diffY) - (ar + br) * (ar + br));
	}
	
	/* 2D AABB vs AABB Collision */
	
	public static function AABBCollision(ax:Float, ay:Float, aw:Float, ah:Float, bx:Float, by:Float, bw:Float, bh:Float):Vector2D {
		
		// minimum translation distance vector
		var mtd:Vector2D = new Vector2D(0, 0);
		
		// bounding values of A
		var aMinX:Float = ax - (0.5 * aw);
		var aMaxX:Float = ax + (0.5 * aw);
		var aMinY:Float = ay - (0.5 * ah);
		var aMaxY:Float = ay + (0.5 * ah);
		
		// bounding values of B
		var bMinX:Float = bx - (0.5 * bw);
		var bMaxX:Float = bx + (0.5 * bw);
		var bMinY:Float = by - (0.5 * bh);
		var bMaxY:Float = by + (0.5 * bh);
		
		// bounds are not in contact - no collision
		if (aMinX > bMaxX || aMaxX < bMinX || aMinY > bMaxY || aMaxY < bMinY) {
			
			// return zero vector
			return mtd;
		}
		
		var left:Float  = bMinX - aMaxX;
		var right:Float = bMaxX - aMinX;
		
		var top:Float   = bMinY - aMaxY;
		var bottom:Float = bMaxY - aMinY;
		
		// get MTD for all axes
		if (Math.abs(left) < right)	mtd.x = left;
		else mtd.x = right;
		
		if (Math.abs(top) < bottom) mtd.y = top;
		else mtd.y = bottom;
		
		// zero axes except smallest value, first compare x and y
		if (Math.abs(mtd.x) > Math.abs(mtd.y)) mtd.x = 0;
		else mtd.y = 0;
		
		// return MTD
		return mtd;
	}
	
	/* 2D AABB 'Quick Collision Check' (true/false) */
	
	public static function isAABBCollision(ax:Float, ay:Float, aw:Float, ah:Float, bx:Float, by:Float, bw:Float, bh:Float):Bool {
		
		// bounding values of A
		var aMinX:Float = ax - (0.5 * aw);
		var aMaxX:Float = ax + (0.5 * aw);
		var aMinY:Float = ay - (0.5 * ah);
		var aMaxY:Float = ay + (0.5 * ah);
		
		// bounding values of B
		var bMinX:Float = bx - (0.5 * bw);
		var bMaxX:Float = bx + (0.5 * bw);
		var bMinY:Float = by - (0.5 * bh);
		var bMaxY:Float = by + (0.5 * bh);
		
		// bounds are not in contact - no collision
		if (aMinX > bMaxX || aMaxX < bMinX || aMinY > bMaxY || aMaxY < bMinY) {
			
			// return zero vector
			return false;
		}
		
		return true;
	}
	
	/* Point vs AABB */
	
	public static function pointAABBCollision(ax:Float, ay:Float, bx:Float, by:Float, bw:Float, bh:Float):Bool {
		
		// bounding values of B
		var bMinX:Float = bx - (0.5 * bw);
		var bMaxX:Float = bx + (0.5 * bw);
		var bMinY:Float = by - (0.5 * bh);
		var bMaxY:Float = by + (0.5 * bh);
		
		// bounds are not in contact - no collision
		if (ax > bMaxX || ax < bMinX || ay > bMaxY || ay < bMinY) {
			
			return false;
		}
		
		return true;
	}
	
	public static function circleAABBCollision(ax:Float, ay:Float, ar:Float, bx:Float, by:Float, bw:Float, bh:Float):Bool {
		
		var minX:Float = bx - (0.5 * bw);
		var maxX:Float = bx + (0.5 * bw);
		var minY:Float = by - (0.5 * bh);
		var maxY:Float = by + (0.5 * bh);
		
		var squareDist:Float = 0.0;
		
		if (ax < minX) {
			
			squareDist += (minX - ax) * (minX - ax);
		}
		if (ax > maxX) {
			
			squareDist += (ax - maxX) * (ax - maxX);
		}
		
		if (ay < minY) {
			
			squareDist += (minY - ay) * (minY - ay);
		}
		
		if (ay > maxY) {
			
			squareDist += (ay - maxY) * (ay - maxY);
		}
		
		return squareDist <= ar * ar;
	}
	
	public static function circleInsideAABB(ax:Float, ay:Float, ar:Float, bx:Float, by:Float, bw:Float, bh:Float):Bool {
		
		if (ax + ar > bx + (bw / 2)) {
			
			// outside on the right
			return false;
		}
		
		if (ax - ar < bx - (bw / 2)) {
			
			// outside on the left
			return false;
		}
		
		if (ay + ar > by + (bh / 2)) {
			
			// outside at the bottom
			return false;
		}
		
		if (ay - ar < by - (bh / 2)) {
			
			// outside at the top
			return false;
		}
		
		// circle is completely inside AABB
		return true;
	}
}