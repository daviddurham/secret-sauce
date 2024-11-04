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
	
	public var isLeftDown:Bool = false;
	public var isRightDown:Bool = false;
	
	public var acc:Vector2D;
	public var vel:Vector2D;
	public var dir:Vector2D;	
	
	public var speed:Float = 0;
	public var maxSpeed:Float = 1.8;//12;
	
	private var cameraVector:Vector2D;
	
	private var control:Float = 1;

	public var radius:Int = 3;

	public var camera:Camera3D;

	public var cat:Mesh;

	
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
		model.scaleX = model.scaleY = model.scaleZ = 0.333;
		holder.addChild(model);

		newMaterial = new TextureMaterial(_id == 1 ? Cast.bitmapTexture("assets/car_test_blue.png") : Cast.bitmapTexture("assets/car_test_red.png"), false);
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
		model.addChild(cat);
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
		
		speed = 0;
		//accel = 0.001;
		
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
		
			//x += 0.1;
			//z -= 0.1;
		}
	}
}