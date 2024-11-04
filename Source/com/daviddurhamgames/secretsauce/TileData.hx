package com.daviddurhamgames.secretsauce;

import com.daviddurhamgames.secretsauce.ObjectData;

class TileData {
	
	public var id:Int;
	public var asset:String;
	public var assetRotation:Int = 0;

	public var objects:Array<ObjectData>;
	
	public function new(tileId:Int, tileAsset:String, rotation:Int, obj:Array<ObjectData>) {
		
		id = tileId;
        asset = tileAsset;
		assetRotation = rotation;

		objects = obj;
    }
}