package com.daviddurhamgames.secretsauce;

import away3d.materials.TextureMaterial;
import away3d.containers.ObjectContainer3D;
import away3d.utils.*;

import com.daviddurhamgames.secretsauce.World;

class Level {
	
	// tile dimensions
	private var TILE_WIDTH:Int = 16;
	private var TILE_HEIGHT:Int = 16;
	
	// ref to the world
	private var _world:World;

	// ref to loaded models
	private var _models:Array<ObjectContainer3D>;

	// skin used
	private var _skin:String = "default";
	
	private var tileTextures:Array<TileTexture>;

	private var circleShadowTexture:TextureMaterial;
	private var rectangleShadowTexture:TextureMaterial;
	
	private var _tileData:Array<TileData> = [	new TileData(0, "kitchen_floor", 0, []),	//blank
												new TileData(1, "straight_horizontal", 0, [new ObjectData(0, 0, 0), new ObjectData(0, 128, 0), new ObjectData(0, 256, 0), new ObjectData(0, -128, 0),    new ObjectData(1, 475, 432), new ObjectData(1, 402, 432), new ObjectData(1, 329, 432), new ObjectData(1, 256, 432), new ObjectData(1, 183, 432), new ObjectData(1, 110, 432), new ObjectData(1, 36, 432), new ObjectData(1, 475, 80), new ObjectData(1, 402, 80), new ObjectData(1, 329, 80), new ObjectData(1, 256, 80), new ObjectData(1, 183, 80), new ObjectData(1, 110, 80), new ObjectData(1, 36, 80), new ObjectData(2, 256, 72), new ObjectData(2, 256, 440), new ObjectData(7, 256, 168), new ObjectData(7, 256, 344)]), //straight H
												new TileData(2, "straight_horizontal", 1, [new ObjectData(0, 0, 0), new ObjectData(0, 0, 128), new ObjectData(0, 0, 256), new ObjectData(0, 0, -128),    new ObjectData(1, 80, 475), new ObjectData(1, 80, 402), new ObjectData(1, 80, 329), new ObjectData(1, 79, 256), new ObjectData(1, 79, 183), new ObjectData(1, 79, 110), new ObjectData(1, 79, 36), new ObjectData(1, 432, 475), new ObjectData(1, 432, 402), new ObjectData(1, 432, 329), new ObjectData(1, 431, 256), new ObjectData(1, 431, 183), new ObjectData(1, 431, 110), new ObjectData(1, 431, 36), new ObjectData(2, 440, 256), new ObjectData(2, 72, 256), new ObjectData(7, 168, 256), new ObjectData(7, 344, 256)]), //straight V
												
												// basic corners (br, bl, tl, tr)
												new TileData(3, "corner_tl", 0, [new ObjectData(0, 0, -256), new ObjectData(0, 16, -162), new ObjectData(0, 74, -74), new ObjectData(0, 162, -16), new ObjectData(0, 256, 0),     new ObjectData(1, 432, 479), new ObjectData(1, 183, 236), new ObjectData(1, 139, 296), new ObjectData(1, 110, 356), new ObjectData(1, 91, 418), new ObjectData(1, 81, 480), new ObjectData(1, 480, 431), new ObjectData(1, 480, 81), new ObjectData(1, 418, 90), new ObjectData(1, 354, 112), new ObjectData(1, 292, 143), new ObjectData(1, 232, 186), new ObjectData(2, 474, 474), new ObjectData(2, 190, 190), new ObjectData(7, 384, 384), new ObjectData(7, 240, 240)]),	//corner (r)
												new TileData(4, "corner_tl", 1, [new ObjectData(0, 0, -256), new ObjectData(0, -16, -162), new ObjectData(0, -74, -74), new ObjectData(0, -162, -16), new ObjectData(0, -256, 0),     new ObjectData(1, 32, 432), new ObjectData(1, 275, 183), new ObjectData(1, 215, 139), new ObjectData(1, 155, 110), new ObjectData(1, 93, 91), new ObjectData(1, 31, 81), new ObjectData(1, 80, 480), new ObjectData(1, 430, 480), new ObjectData(1, 421, 418), new ObjectData(1, 399, 354), new ObjectData(1, 368, 292), new ObjectData(1, 325, 232), new ObjectData(2, 38, 474), new ObjectData(2, 322, 190), new ObjectData(7, 128, 384), new ObjectData(7, 272, 240)]),
												new TileData(5, "corner_tl", 2, [new ObjectData(0, 0, 256), new ObjectData(0, -16, 162), new ObjectData(0, -74, 74), new ObjectData(0, -162, 16), new ObjectData(0, -256, 0),        new ObjectData(1, 79, 32), new ObjectData(1, 328, 275), new ObjectData(1, 372, 215), new ObjectData(1, 401, 155), new ObjectData(1, 420, 93), new ObjectData(1, 430, 31), new ObjectData(1, 31, 80), new ObjectData(1, 31, 430), new ObjectData(1, 93, 421), new ObjectData(1, 157, 399), new ObjectData(1, 219, 368), new ObjectData(1, 279, 325), new ObjectData(2, 37, 38), new ObjectData(2, 322, 322)]),	//(j)
												new TileData(6, "corner_tl", 3, [new ObjectData(0, 0, 256), new ObjectData(0, 16, 162), new ObjectData(0, 74, 74), new ObjectData(0, 162, 16), new ObjectData(0, 256, 0),       new ObjectData(1, 479, 79), new ObjectData(1, 236, 328), new ObjectData(1, 296, 372), new ObjectData(1, 356, 401), new ObjectData(1, 418, 420), new ObjectData(1, 480, 430), new ObjectData(1, 431, 31), new ObjectData(1, 81, 31), new ObjectData(1, 90, 93), new ObjectData(1, 112, 157), new ObjectData(1, 143, 219), new ObjectData(1, 186, 279), new ObjectData(2, 473, 37), new ObjectData(2, 190, 322)]),	//(L)												
											];
																	
	// default level map data
	private var _levelMap:Array<Array<Int>> = [	[0, 0, 0, 0, 0],
												[0, 3, 1, 4, 0],
												[0, 2, 0, 2, 0],
												[0, 6, 1, 5, 0],
												[0, 0, 0, 0, 0]	];
												
												
	private var _levelOrder:Array<Array<Int>>;
	
	// tree positions within a tile
	private var trees:Array<Array<Array<Float>>> = [ [	[0.3, 0.5], [0.8, 0.7]	],
												 	 [	[0.4, 0.4], [0.6, 0.7]	],
												  	 [	[0.1, 0.3], [0.6, 0.9], [0.9, 0.5], [0.2, 0.8]	],
												  	 [	[0.2, 0.9], [0.8, 0.8]	],
												  	 []	];
 
	private var _codeString:String = "";
	
	public function new(world:World, models:Array<ObjectContainer3D>, skin:String = "default", map:Array<Array<Int>> = null) {
		
		_world = world;
		_models = models;
		_skin = skin;

		tileTextures = [

			new TileTexture("kitchen_floor", _skin),
			new TileTexture("straight_horizontal", _skin),
			new TileTexture("corner_tl", _skin)
		];
		
		circleShadowTexture = new TextureMaterial(Cast.bitmapTexture("assets/shadow_circle.png"), false, false, false);
		circleShadowTexture.bothSides = false;
		circleShadowTexture.alphaBlending = true;
        
		rectangleShadowTexture = new TextureMaterial(Cast.bitmapTexture("assets/shadow_circle.png"), false, false, false);
		rectangleShadowTexture.bothSides = false;
		rectangleShadowTexture.alphaBlending = true;

		_levelMap = map;
	}
	
	public function createLevel(isOverview:Bool = false):Void {
		
		buildLevel(_levelMap, isOverview);
	}
		
	public function buildLevel(map:Array<Array<Int>>, isOverview:Bool = false):Void {
		
		var tileset:String = "tiles";
		var count:Int = 0;
		
		// build level
		for (i in 0...map[0].length) {
			
			for (j in 0...map.length) {
				
				var tileData:TileData = null;
				var asset:String = "";

				var model:ObjectContainer3D = null;
				var modelRotation:Int = 0;
				
				for (td in _tileData) {
					
					if (td.id == map[j][i]) {
						
						tileData = td;
						break;
					}
				}

				// get the texture
				var tileTexture = null;

				for (texture in tileTextures) {

					if (texture.name == tileData.asset) {

						tileTexture = texture;
						break;
					}
				}

				if (tileTexture != null) {
				
					var tile:LevelTile = new LevelTile(tileTexture.material);
					tile.rotationY = (tileData.assetRotation * 90);
					
					tile.x = TILE_WIDTH * i;
					tile.z = -TILE_HEIGHT * j;
					_world.addTile(tile);
				}
				
				/*
				// trees and stuff on blank tiles
				if (tileData.id == 0) {
					
					var treePattern:Int = Math.floor(Math.random() * trees.length);
					var len:Int = trees[treePattern].length;

					for (t in 0...len) {
						
						var tree:GameObject = new GameObject("", cast(_models[1].clone(), ObjectContainer3D));
						tree.x = (TILE_WIDTH * i) - (0.5 * TILE_WIDTH) + (TILE_WIDTH * trees[treePattern][t][0]);
						tree.z = (-TILE_HEIGHT * j) - (0.5 * -TILE_HEIGHT) + (-TILE_HEIGHT * trees[treePattern][t][1]);

						tree.rotationY = 360 * Math.random();
						
						var treeSize:Float = (4 + Math.floor(Math.random() * 2));
						
						// larger 'non-realistic' trees on overview
						if (isOverview) {
							
							treeSize = treeSize * 2;
						}
						
						tree.scaleX = tree.scaleY = tree.scaleZ = treeSize;
						tree.setCollisionType("circle", treeSize);
						
						_world.addObstacle(tree);
					}
				}
				*/

				for (obj in tileData.objects) {
					
					
					switch(obj.id) {
							
						// bollard / cone
						case 1:
							
							if (!isOverview) {

								var object:GameObject = new GameObject("", cast(_models[2].clone(), ObjectContainer3D));
								object.x = (TILE_WIDTH * i) + obj.pos.x - (TILE_WIDTH / 2);
								object.y = 1;
								object.z = (-TILE_HEIGHT * j) - obj.pos.y + (TILE_HEIGHT / 2);

								object.scaleX = object.scaleY = object.scaleZ = 0.6;

								object.setCollisionType("circle", 0.3);
								_world.addCone(object);
							}
					}
				}
				
				count++;
			}
		}
	}
	
	public function clearLevel():Void {
		
		_world.removeAll();
	}
	
	public function getLevelMap():Array<Array<Int>> {
		
		return _levelMap;
	}
	
	public function cleanUp():Void {
		
		
	}
}