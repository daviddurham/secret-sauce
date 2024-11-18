package com.daviddurhamgames.secretsauce;

import openfl.display.Sprite;

import away3d.materials.methods.ShadowMapMethodBase;
import away3d.materials.lightpickers.StaticLightPicker;
import away3d.containers.ObjectContainer3D;
import away3d.containers.Scene3D;

import com.daviddurhamgames.secretsauce.LevelTile;
import com.piratejuice.vfx.ScreenShake;

class World {
	
	// game graphics container
	public var scene:ObjectContainer3D;
	
	// floor does not need to be sorted
	public var floor:ObjectContainer3D;
	
	// sortable objects
	public var level:ObjectContainer3D;
	
	// ref to light picker
	public var lightPicker:StaticLightPicker;
	public var shadowMapMethod:ShadowMapMethodBase;

	// object lists
	public var tiles:Array<LevelTile>;
	public var objects:Array<ObjectContainer3D>;
	public var hotspots:Array<GameObject>;
	public var obstacles:Array<GameObject>;
	public var cones:Array<GameObject>;
	
	// pickups
	//public var pickups:Array<Pickup>;
	
	// vfx
	private var _shake:ScreenShake;
	
	var rect:Sprite;
	
	public function new(holder:Scene3D, lp:StaticLightPicker, smm:ShadowMapMethodBase):Void {
		
		if (lp != null) {

			lightPicker = lp;
		}

		if (smm != null) {

			shadowMapMethod = smm;
		}

		// create scene
		scene = new ObjectContainer3D();
		holder.addChild(scene);
		
		floor = new ObjectContainer3D();
		scene.addChild(floor);
				
		level = new ObjectContainer3D();
		scene.addChild(level);
		
		tiles = new Array<LevelTile>();
		objects = new Array<ObjectContainer3D>();
		hotspots = new Array<GameObject>();

		obstacles = new Array<GameObject>();
		cones = new Array<GameObject>();
		
		_shake = new ScreenShake();
		_shake.setReduction(0.8);
	}
	
	public function add(obj:ObjectContainer3D):Void {
		
		level.addChild(obj);
		objects.push(obj);
	}
	
	public function remove(obj:ObjectContainer3D):Void {
		
		level.removeChild(obj);
		
		var len:Int = objects.length;
		
		for (i in 0...len) {
			
			if (objects[i] == obj) {
				
				objects.splice(i, 1);
				break;
			}
		}
		
		obj = null;
	}
	
	public function removeAllObjects():Void {
		
		var len:Int = objects.length;
		
		for (i in 0...len) {
			
			level.removeChild(objects[0]);
			objects[0] = null;
			objects.splice(0, 1);
		}
	}
	
	public function addObstacle(obstacle:GameObject):Void {

		add(obstacle);		
		obstacles.push(obstacle);
	}

	public function removeObstacle(obstacle:GameObject):Void {
		
		var len:Int = obstacles.length;
		
		for (i in 0...len) {
			
			if (obstacles[i] == obstacle) {
				
				obstacles.splice(i, 1);
				break;
			}
		}
		
		remove(obstacle);
	}

	// hotspots are interactive zones
	public function addHotspot(hotspot:GameObject):Void {
		
		add(hotspot);		
		hotspots.push(hotspot);
	}
	
	public function removeHotspot(hotspot:GameObject):Void {
		
		var len:Int = hotspots.length;
		
		for (i in 0...len) {
			
			if (hotspots[i] == hotspot) {
				
				hotspots.splice(i, 1);
				break;
			}
		}
		
		remove(hotspot);
	}


	// cones are any object that can be knocked around
	public function addCone(cone:GameObject):Void {
		
		add(cone);		
		cones.push(cone);
	}
	
	public function removeCone(cone:GameObject):Void {
		
		var len:Int = cones.length;
		
		for (i in 0...len) {
			
			if (cones[i] == cone) {
				
				cones.splice(i, 1);
				break;
			}
		}
		
		remove(cone);
	}
	
	public function addTile(tile:LevelTile):Void {
		
		tile.setLightPicker(lightPicker, shadowMapMethod);

		floor.addChild(tile);
		tiles.push(tile);
	}
	
	public function removeTile(tile:LevelTile):Void {
		
		floor.removeChild(tile);
		
		var len:Int = tiles.length;
		
		for (i in 0...len) {
			
			if (tiles[i] == tile) {
				
				tiles.splice(i, 1);
				break;
			}
		}
		
		tile = null;
	}
	
	public function removeAllTiles():Void {
		
		var len:Int = tiles.length;
		
		for (i in 0...len) {
			
			floor.removeChild(tiles[0]);
			tiles[0] = null;
			tiles.splice(0, 1);
		}
	}
	
	public function removeAll():Void {
		
		obstacles.splice(0, obstacles.length);
		cones.splice(0, cones.length);
		
		removeAllTiles();
		removeAllObjects();
	}	
	

	/* Screenshake */
	
	public function shake(pDx:Float, pDy:Float):Void {
		
		//_shake.shake(pDx, pDy, scene);
	}
	
	
	/* Update */
	
	public function update():Void {
		
		for (cone in cones) {

			// move based on current vel
			cone.x += cone.vel.x;
			cone.z -= cone.vel.y;
			
			cone.rotationX += cone.vel.x * 5;
			cone.rotationZ += cone.vel.y * 5;
			
			// reduce vel
			cone.vel.scale(0.96);
		}

		for (hotspot in hotspots) {
			
			hotspot.update();
		}

		/*
		for (obstacle in obstacles) {
			
			obstacle.update();
		}
		
		_shake.update();
		*/
	}
}