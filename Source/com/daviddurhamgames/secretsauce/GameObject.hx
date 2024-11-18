package com.daviddurhamgames.secretsauce;

import away3d.primitives.CylinderGeometry;
import away3d.materials.ColorMaterial;
import away3d.primitives.CubeGeometry;
import away3d.primitives.PlaneGeometry;
import away3d.entities.Mesh;
import away3d.containers.ObjectContainer3D;
import away3d.materials.TextureMaterial;
import openfl.display.Bitmap;
import openfl.Assets;
import openfl.Lib;

import com.piratejuice.Vector2D;

class GameObject extends ObjectContainer3D {
	
	public var objectID:Int = 0;
		
	// collision dimensions
	public var cWidth:Float = 0;
	public var cHeight:Float = 0;
	public var cRadius:Float = 0;
	public var collisionType:String = "none";

	public var vel:Vector2D;
	
	public function new(type:String = "", model:ObjectContainer3D = null, id:Int = 0):Void {
		
		super();
		
		objectID = id;
		vel = new Vector2D();
		
		if (type == "hotspot") {
			
			// for debug...
			var mat = new ColorMaterial(0xff00ff);
			mat.bothSides = true;
						
			var h = new Mesh(new CylinderGeometry(Main.TILE_SIZE / 2, Main.TILE_SIZE / 2, 2, 8, 1, false, false), mat);
			h.y = 1;
			addChild(h);
		}		

		if (model != null) {

			addChild(model);
		}		
	}

	public function setCollisionType(type:String, dimension1:Float, dimension2:Float = 0) {

		collisionType = type;

		if (type == "circle") {

			cRadius = dimension1;
		}
		else if (type == "aabb") {

			cWidth = dimension1;
			cHeight = dimension2;
		}
	}

	public function update():Void {
		
		
	}
}