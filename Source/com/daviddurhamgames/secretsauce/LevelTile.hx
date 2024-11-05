package com.daviddurhamgames.secretsauce;
	
import away3d.materials.methods.ShadowMapMethodBase;
import away3d.materials.lightpickers.StaticLightPicker;
import away3d.containers.ObjectContainer3D;
import away3d.primitives.PlaneGeometry;
import away3d.entities.Mesh;
import away3d.materials.TextureMaterial;

class LevelTile extends ObjectContainer3D {
	
	public static var WIDTH:Int = 16;
	public static var HEIGHT:Int = 16;
	
	private var mesh:Mesh;
	
	public function new(material:TextureMaterial, model:ObjectContainer3D = null):Void {
		
		super();

		if (model != null) {

			var obj:ObjectContainer3D = cast(model.clone(), ObjectContainer3D);
			obj.scaleX = obj.scaleY = obj.scaleZ = 4;
			addChild(obj);
		}
		else {

			mesh = new Mesh(new PlaneGeometry(LevelTile.WIDTH, LevelTile.HEIGHT), material);
			// flat tiles don't need to cast shadows
			mesh.castsShadows = false;
			addChild(mesh);
		}
	}

	public function setLightPicker(lightPicker:StaticLightPicker, shadowMapMethod:ShadowMapMethodBase):Void {

		if (mesh != null) {

			mesh.material.lightPicker = lightPicker;
			cast(mesh.material, TextureMaterial).shadowMethod = shadowMapMethod;
		}
	}
}