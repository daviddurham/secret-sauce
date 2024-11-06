package com.daviddurhamgames.secretsauce;

import away3d.materials.ColorMaterial;
import away3d.cameras.Camera3D;
import away3d.containers.ObjectContainer3D;
import away3d.materials.lightpickers.StaticLightPicker;
import away3d.materials.TextureMaterial;
import away3d.primitives.*;
import away3d.utils.*;
import away3d.entities.Mesh;
import openfl.events.Event;
import openfl.geom.Point;

import com.piratejuice.Vector2D;

class Player extends ObjectContainer3D {
	
	private var PI_OVER_180:Float;
	private var D180_OVER_PI:Float;
	
	public var cId:Int = 0;

	public var holder:ObjectContainer3D;
	public var model:ObjectContainer3D;
	public var material:TextureMaterial;
	public var newMaterial:TextureMaterial;

	// states
	public var isGo:Bool = true;
	public var isActive:Bool = true;
	public var isJumping:Bool = false;
	public var isFalling:Bool = false;

	public var velY:Float = 0;
	public var velRot:Float = 0.1;
	
	public var isLeft:Bool = false;
	public var isRight:Bool = false;
	public var isUp:Bool = false;
	public var isDown:Bool = false;
	
	public var acc:Vector2D;
	public var vel:Vector2D;
	public var dir:Vector2D;	
	
	private var cameraVector:Vector2D;
	
	private var control:Float = 1;

	public var radius:Int = 5;

	public var camera:Camera3D;

	public var cat:Mesh;

	public var xSpeed:Float = 0;
	public var zSpeed:Float = 0;
	
	public function new(_id:Int, _model:ObjectContainer3D, _cam:Camera3D = null, code:String = "0000"):Void {
		
		super();

		cId = _id;

		camera = _cam;
		
		PI_OVER_180 = Math.PI / 180;
		D180_OVER_PI = 180 / Math.PI;
				
		dir = new Vector2D();
		acc = new Vector2D();
		vel = new Vector2D();

		// hold model in another container to make rotations work
		holder = new ObjectContainer3D();
		addChild(holder); 

		// draw car 
		model = new ObjectContainer3D();
		model.y = 0;
		model.scaleX = model.scaleY = model.scaleZ = 1.25;//0.333;
		holder.addChild(model);

		newMaterial = new TextureMaterial(_id == 1 ? Cast.bitmapTexture("assets/robochef.png") : Cast.bitmapTexture("assets/robochef.png"), false);
		//newMaterial.alphaThreshold = 1;
		//newMaterial.lightPicker = lightPicker;
		newMaterial.mipmap = false;
		updateMaterials(model, _model, newMaterial);

		material = new TextureMaterial(Cast.bitmapTexture("assets/cat.png"), false);
		material.alphaThreshold = 1;
		//material.lightPicker = lightPicker;
		material.mipmap = false;
		material.bothSides = false;

		cat = new Mesh(new PlaneGeometry(9, 12), material);
		cat.x = 0;
		cat.y = 18;
		cat.z = -3;
		cat.rotationX = -90;
		//model.addChild(cat);
	}

	private function updateMaterials(m:ObjectContainer3D, object:ObjectContainer3D, material:TextureMaterial):Void {

		if (object is Mesh) {

			var mesh:Mesh = cast(object, Mesh);
			mesh.material = material;

			m.addChild(new Mesh(mesh.geometry, material));
		}
	
		for (child in object._children) {

			//if (child is ObjectContainer3D) {

				updateMaterials(m, cast(child, ObjectContainer3D), material);
			//}
		}
	}

	public function setLightPicker(lightPicker:StaticLightPicker):Void {

		newMaterial.lightPicker = lightPicker;
		material.lightPicker = lightPicker;
	}
	
	public function setActive(flag:Bool):Void {
		
		isActive = false;
	}
	
	public function reset(next:Int = 0, r:Float = 0):Void {
		
		visible = true;
		
		model.rotationX = 0;
		model.rotationZ = 0;

		setControl(1);
		
		isJumping = false;
		isFalling = false;
		
		velY = 0;
		y = 0;
		
		dir.x = dir.y = 0;
		acc.x = acc.y = 0;
		vel.x = vel.y = 0;
	}
	
	public function jump():Void {
		
		velY = -6;
		isJumping = true;
		setControl(0.5);
	}
	
	public function setControl(c:Float = 1):Void {
		
		control = c;
	}
	
	public function update():Void {
		
		if (isActive) {
		
			var xSlowdown:Float = 1;
			var zSlowdown:Float = 1;

			if (isDown) {

				dir.y = -1;

				if (zSpeed > -0.5) {

					zSpeed -= 0.03;
				}
				else {
					
					zSpeed = -0.5;
				}
			}
			else if (isUp) {

				dir.y = 1;

				if (zSpeed < 0.5) {

					zSpeed += 0.03;
				}
				else {
					
					zSpeed = 0.5;
				}
			}
			else {

				if (zSpeed != 0) {

					zSpeed *= 0.8;
				}
				
				if (Math.abs(zSpeed) < 0.05) {

					zSpeed = 0;
				}
			}

			if (isLeft) {

				dir.x = 1;

				if (xSpeed > -0.5) {

					xSpeed -= 0.03;
				}
				else {
					
					xSpeed = -0.5;
				}
			}
			else if (isRight) {

				dir.x = -1;

				if (xSpeed < 0.5) {

					xSpeed += 0.03;
				}
				else {
					
					xSpeed = 0.5;
				}
			}
			else {

				if (xSpeed != 0) {

					xSpeed *= 0.8;
				}
				
				if (Math.abs(xSpeed) < 0.05) {

					xSpeed = 0;
				}
			}

			var multiplier:Float = 1;
			
			if (xSpeed != 0 && zSpeed != 0) {

				multiplier = 0.7;
			}

			x += xSpeed * multiplier;
			z += zSpeed * multiplier;
			
			if ((isRight || isLeft) && (!isUp && !isDown)) {

				dir.y = 0;
			}

			if ((!isRight && !isLeft) && (isUp || isDown)) {

				dir.x = 0;
			}

			var targetAngle:Float = dir.angle();
			
			model.rotationX = Math.max(Math.abs(xSpeed), Math.abs(zSpeed)) * 15;
			holder.rotationY += D180_OVER_PI * Math.atan2((Math.cos(holder.rotationY * PI_OVER_180) * Math.sin(targetAngle * PI_OVER_180) - Math.sin(holder.rotationY * PI_OVER_180) * Math.cos(targetAngle * PI_OVER_180)), (Math.sin(holder.rotationY * PI_OVER_180) * Math.sin(targetAngle * PI_OVER_180) + Math.cos(holder.rotationY * PI_OVER_180) * Math.cos(targetAngle * PI_OVER_180))) / 8;
	
		}
	}
}