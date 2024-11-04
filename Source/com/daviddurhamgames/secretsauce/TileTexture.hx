package com.daviddurhamgames.secretsauce;

import away3d.textures.Anisotropy;
import away3d.materials.TextureMaterial;
import away3d.utils.*;

class TileTexture {
	
	public var name:String;
	public var material:TextureMaterial;
	
	public function new(asset:String, skin:String = "default") {
		
		name = asset;
        material = new TextureMaterial(Cast.bitmapTexture("assets/tiles/" + skin + "/" + asset + ".png"), false);
		material.bothSides = false;
        material.mipmap = false;
        //material.anisotropy = Anisotropy.NONE;
    }

    public function cleanUp() {

        material.dispose();
        material = null;

        name = null;
    }
}