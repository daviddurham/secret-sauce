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
	public var newMaterial:TextureMaterial;

	// states
	public var isActive:Bool = true;
	public var isJumping:Bool = false;

	public var holding = null;
	//public var holdingObjectMaterial:TextureMaterial;
	public var holdingObject:GameObject;

	public var alert:Mesh;
	//public var isAlerted:Bool = false;
	public var alertCooldown:Float = 0;

	public var velY:Float = 0;
	public var velRot:Float = 0.1;
	
	public var isLeft:Bool = false;
	public var isRight:Bool = false;
	public var isUp:Bool = false;
	public var isDown:Bool = false;
	
	public var xSpeed:Float = 0;
	public var zSpeed:Float = 0;
	public var maxSpeed:Float = 0.5;

	public var dir:Vector2D;	

	public var radius:Int = 5;

	public var camera:Camera3D;

	public var isMovingTo:Bool = false;
	public var targetPositionX:Float;
	public var targetPositionZ:Float;
	public var moveCallback = null;

	public var detectionRadius:Float = 18;
	public var detectionOffset:Float = -18;
	
	public function new(_id:Int, _model:ObjectContainer3D, _cam:Camera3D = null):Void {
		
		super();

		cId = _id;

		camera = _cam;
		
		PI_OVER_180 = Math.PI / 180;
		D180_OVER_PI = 180 / Math.PI;
				
		dir = new Vector2D(0, -1);
		
		// hold model in another container to make rotations work
		holder = new ObjectContainer3D();
		holder.rotationY = dir.angle();
		addChild(holder);

		// draw character
		var scale:Float = _id == 1 ? 1.1 : 1.4;

		model = new ObjectContainer3D();
		model.y = 0;
		model.scaleX = model.scaleY = model.scaleZ = scale;//1.25;
		holder.addChild(model);

		newMaterial = new TextureMaterial(_id == 1 ? Cast.bitmapTexture("assets/robochef.png") : Cast.bitmapTexture("assets/robodad.png"), false);
		//newMaterial.alphaThreshold = 1;
		//newMaterial.lightPicker = lightPicker;
		newMaterial.mipmap = false;
		updateMaterials(model, _model, newMaterial);

		/*
		holdingObjectMaterial = new TextureMaterial(Cast.bitmapTexture("assets/ingredient1.png"), false);
		holdingObjectMaterial.alphaThreshold = 1;
		//holdingObjectMaterial.lightPicker = lightPicker;
		holdingObjectMaterial.mipmap = false;
		holdingObjectMaterial.bothSides = true;

		holdingObject = new Mesh(new PlaneGeometry(4, 4), holdingObjectMaterial);
		holdingObject.x = 0;
		holdingObject.y = 11.6;
		holdingObject.z = 0;
		holdingObject.rotationX = -90;
		holdingObject.visible = false;
		model.addChild(holdingObject);
		*/

		var alertMaterial:TextureMaterial = new TextureMaterial(Cast.bitmapTexture("assets/alert.png"), false);
		alertMaterial.alphaThreshold = 1;
		//alertMaterial.lightPicker = lightPicker;
		alertMaterial.mipmap = false;
		alertMaterial.bothSides = true;

		alert = new Mesh(new PlaneGeometry(8, 8), alertMaterial);
		alert.x = 0;
		alert.y = 14;
		alert.z = 0;
		alert.rotationX = -90;
		alert.visible = false;
		model.addChild(alert);

		// for debug...
		/*
		var mat = new ColorMaterial(0xff00ff);
		mat.bothSides = true;
		var h = new Mesh(new CylinderGeometry(15, 15, 2, 16, 1, false, false), mat);
		h.y = 1;
		h.z = -18;
		model.addChild(h);
		*/

		//var g = new Mesh(new CylinderGeometry(25, 25, 2, 16, 1, false, false), mat);
		//g.y = 1;
		//model.addChild(g);
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
		//holdingObjectMaterial.lightPicker = lightPicker;
	}
	
	public function setActive(flag:Bool):Void {
		
		isActive = false;
	}
	
	public function reset(next:Int = 0, r:Float = 0):Void {
		
		visible = true;
		
		model.rotationX = 0;
		model.rotationZ = 0;
				
		velY = 0;
		y = 0;
		
		dir.x = 0;
		dir.y = -1;

		holder.rotationY = dir.angle();
	}

	public function setRotation(dirX:Float, dirZ:Float):Void {

		dir.x = dirX;
		dir.y = dirZ;

		holder.rotationY = dir.angle();
	}
	
	public function setMaxSpeed(max:Float = 0.5):Void {

		maxSpeed = max;
	}

	public function collectIngredient(ingredient:Ingredient, object:GameObject):Void {

		holding = ingredient;

		//holdingObjectMaterial.texture = Cast.bitmapTexture(ingredient.image/*"assets/leaf.png"*/);
		//holdingObject.material = holdingObjectMaterial;

		//holdingObject.visible = true;

		holdingObject = object;
		object.x = 0;
		object.y = 10;
		object.z = 0;
		object.scaleX = object.scaleX / 1.1;
		object.scaleY = object.scaleY / 1.1;
		object.scaleZ = object.scaleZ / 1.1;
		object.rotationY = 90;
		object.visible = true;
		model.addChild(object);
	}

	public function dropIngredient():Void {

		//model.removeChild(holdingObject);
		//holdingObject.visible = false;
		//holdingObject.y = 10;
		
		holding = null;
	}

	public function moveToPosition(px:Float, pz:Float, callback):Void {

		isUp = false;
		isDown = false;
		isLeft = false;
		isRight = false;

		if (px < x) {

			isLeft = true;
		}
		else if (px > x) {

			isRight = true;
		}

		if (pz < z) {
		
			isDown = true;
		}
		else if (pz > z) {
		
			isUp = true;
		}

		targetPositionX = px;
		targetPositionZ = pz;

		isMovingTo = true;

		if (callback != null) {
		
			moveCallback = callback;
		}
		else {

			moveCallback = null;
		}
	}

	public function jump():Void {
		
		velY = -6;
		isJumping = true;
	}
	
	public function update():Void {
		
		if (isActive) {

			// for npcs...
			if (alertCooldown > 0) {


			}
			else {
				
				if (isMovingTo) {

					if (x > targetPositionX - 1 && x < targetPositionX + 1) {

						isLeft = false;
						isRight = false;
					}

					if (z > targetPositionZ - 1 && z < targetPositionZ + 1) {

						isUp = false;
						isDown = false;
					}

					// target reached
					if (x > targetPositionX - 1 && x < targetPositionX + 1 &&
						z > targetPositionZ - 1 && z < targetPositionZ + 1) {

						isMovingTo = false;

						// target reached
						if (moveCallback != null) {
							
							moveCallback();
						}
					}
				}
			
				if (isDown) {

					dir.y = -1;

					if (zSpeed > -maxSpeed) {

						zSpeed -= 0.03;
					}
					else {
						
						zSpeed = -maxSpeed;
					}
				}
				else if (isUp) {

					dir.y = 1;

					if (zSpeed < maxSpeed) {

						zSpeed += 0.03;
					}
					else {
						
						zSpeed = maxSpeed;
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

					if (xSpeed > -maxSpeed) {

						xSpeed -= 0.03;
					}
					else {
						
						xSpeed = -maxSpeed;
					}
				}
				else if (isRight) {

					dir.x = -1;

					if (xSpeed < maxSpeed) {

						xSpeed += 0.03;
					}
					else {
						
						xSpeed = maxSpeed;
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
			}

			var targetAngle:Float = dir.angle();
			
			model.rotationX = Math.max(Math.abs(xSpeed), Math.abs(zSpeed)) * 15;
			holder.rotationY += D180_OVER_PI * Math.atan2((Math.cos(holder.rotationY * PI_OVER_180) * Math.sin(targetAngle * PI_OVER_180) - Math.sin(holder.rotationY * PI_OVER_180) * Math.cos(targetAngle * PI_OVER_180)), (Math.sin(holder.rotationY * PI_OVER_180) * Math.sin(targetAngle * PI_OVER_180) + Math.cos(holder.rotationY * PI_OVER_180) * Math.cos(targetAngle * PI_OVER_180))) / 8;
	
			//holdingObject.rotationY = -holder.rotationY;
			alert.rotationY = -holder.rotationY;
		}
	}
}