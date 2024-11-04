package com.daviddurhamgames.secretsauce;

import com.piratejuice.Vector2D;
import flash.display.Sprite;
import openfl.geom.Point;
import motion.Actuate;
import motion.easing.Quad;

class Camera {
	
	// scene dimensions
	private var halfWidth:Int;
	private var halfHeight:Int;
	
	// camera 'look at' point
	public var lookAtX:Float;
	public var lookAtY:Float;
	
	// movement damping
	private var damping:Int;
	
	// camera zoom
	private var zoom:Float = 1;
	private var rZoom:Float = 1;
	
	// tweening
	public var isTweening:Bool = false;
	public var isZooming:Bool = false;
	private var tween:Sprite;
	
	// move to moving point
	// (tweening only really works for static objects)
	public var isMoving:Bool = false;
	private var moveTarget:Car;
	private var moveSpeed:Float = 0;
	private var moveVector:Vector2D;
	
	
	public function new(w:Int = 1280, h:Int = 720, d:Int = 20):Void {
		
		halfWidth = Std.int(w / 2);
		halfHeight = Std.int(h / 2);
		
		// movement damping
		damping = d;
		
		tween = new Sprite();
		
		moveVector = new Vector2D();
	}
	
	public function lookAt(cx:Float = 0, cy:Float = 0):Void {
		
		lookAtX = cx;
		lookAtY = cy;
	}
	
	public function tweenTo(tx:Float, ty:Float, seconds:Float):Void {
		
		isMoving = false;
		isTweening = true;
		
		Actuate.tween(tween, seconds, {x: tx, y: ty}).onComplete(onTweenComplete);
	}
	
	private function onTweenComplete():Void {
		
		isTweening = false;
	}
	
	public function tweenZoom(z:Float, seconds:Float):Void {
		
		isZooming = true;
		
		Actuate.tween(tween, seconds, {x: z}).onComplete(onTweenZoomComplete);// .ease(Quad.easeInOut);
	}
	
	public function onTweenZoomComplete():Void {
		
		isZooming = false;
	}
	
	public function moveTo(target:Car, speed:Float):Void {
		
		isTweening = false;
		isMoving = true;
		
		moveTarget = target;
		moveSpeed = speed;
	}
	
	public function snapTo(scene:Sprite, cx:Float = 0, cy:Float = 0):Void {
		
		lookAtX = cx;
		lookAtY = cy;
		
		//scene.x = halfWidth - lookAtX;
		//scene.y = halfHeight - lookAtY;
		scene.x = ((halfWidth * rZoom) - lookAtX) * zoom;
		scene.y = ((halfHeight * rZoom) - lookAtY) * zoom;		
	}
	
	public function setZoom(factor:Float = 1.0, snap:Bool = false):Void {
		
		zoom = factor;
		rZoom = 1 / zoom;
	}
	
	public function snapZoom(scene:Sprite, factor:Float = 1.0):Void {
		
		zoom = factor;
		rZoom = 1 / zoom;
		
		scene.scaleX = zoom;
		scene.scaleY = zoom;
	}
	
	public function update(scene:Sprite):Void {
		
		var damp:Int = damping;
		
		if (isTweening) {
			
			lookAtX = tween.x;
			lookAtY = tween.y;
			
			damp = 1;
		}
		else if (isZooming) {
			
			zoom = tween.x;
			rZoom = 1 / zoom;
		}
		else {
			
			tween.x = lookAtX;
			tween.y = lookAtY;
		}
		
		if (isMoving) {
			
			moveVector.x = moveTarget.x - lookAtX;
			moveVector.y = moveTarget.y - lookAtY;
			moveVector.normalize();
			
			lookAtX += moveVector.x * moveSpeed;
			lookAtY += moveVector.y * moveSpeed;
			
			if (Math.abs(lookAtX - moveTarget.x) < 5 && Math.abs(lookAtY - moveTarget.y) < 5) {
				
				isMoving = false;
			}
		}
		
		scene.scaleX += (zoom - scene.scaleX) / damping;
		scene.scaleY += (zoom - scene.scaleY) / damping;
		
		scene.x += ((((halfWidth * rZoom) - lookAtX) * zoom) - scene.x) / damping;
		scene.y += ((((halfHeight * rZoom) - lookAtY) * zoom) - scene.y) / damping;		
	}
}