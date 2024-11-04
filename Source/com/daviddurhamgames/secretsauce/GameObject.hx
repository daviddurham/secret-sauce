package com.daviddurhamgames.secretsauce;

import away3d.primitives.CylinderGeometry;
import away3d.materials.ColorMaterial;
import away3d.primitives.CubeGeometry;
import away3d.primitives.PlaneGeometry;
import away3d.entities.Mesh;
import away3d.containers.ObjectContainer3D;
import away3d.materials.TextureMaterial;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.display.PixelSnapping;
import openfl.Assets;
import flash.Lib;

import com.piratejuice.Vector2D;

class GameObject extends ObjectContainer3D {
	
	public var objectID:Int = 0;
	
	// optional graphical content
	public var sprite:Bitmap;
	
	// collision dimensions
	public var cWidth:Float = 0;
	public var cHeight:Float = 0;
	public var cRadius:Float = 0;
	public var collisionType:String = "none";

	public var vel:Vector2D;
	
	public function new(type:String = "", model:ObjectContainer3D = null, r:Int = 16):Void {
		
		super();
		
		vel = new Vector2D();
		
		/*
		if (type == "waypoint") {
			
			// for debug...
			var mat = new ColorMaterial(0xff00ff);
			mat.bothSides = true;
						
			var wp = new Mesh(new CylinderGeometry(8, 8, 2, 8, 1, false, false), mat);
			wp.y = 1;
			addChild(wp);
		}
		else if (type == "track") {

			// for debug...
			var mat = new ColorMaterial(0x00ffff);
			mat.bothSides = true;
						
			var tr = new Mesh(new CylinderGeometry(r, r, 2, 8, 1, false, false), mat);
			tr.y = 1;
			addChild(tr);
		}
		*/
		

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