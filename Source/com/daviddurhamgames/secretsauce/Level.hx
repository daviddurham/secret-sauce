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
	
	private var _tileData:Array<TileData> = [	new TileData(0, "kitchen_floor", 0, []),

												new TileData(1, "tile_grass", 0, []),
												new TileData(2, "tile_grass", 0, []),
												new TileData(3, "straight_horizontal", 0, []),
												
												
												new TileData(4, "kitchen_floor", 1, []),
												new TileData(5, "kitchen_floor", 2, []),
												new TileData(6, "kitchen_floor", 3, []),
												
												// wall
												new TileData(7, "kitchen_floor", 0, [new ObjectData(2, 0, 0)]),
												
												// counter
												new TileData(8, "kitchen_floor", 0, [new ObjectData(3, 0, 0)]),

												// pot
												new TileData(9, "kitchen_floor", 0, [new ObjectData(4, 0, 0)]),

												// grill
												new TileData(10, "kitchen_floor", 0, [new ObjectData(5, 0, 0)]),

												// box
												new TileData(11, "kitchen_floor", 0, [new ObjectData(6, 0, 2)])
											];
																	
	// default level map data
	private var _levelMap:Array<Array<Int>> = [	[7, 7, 7, 7, 7],
												[7, 8, 8, 8, 0],
												[7, 8, 0, 0, 0],
												[7, 8, 1, 0, 0],
												[7, 7, 0, 0, 0]	];
												
												
	private var _levelOrder:Array<Array<Int>>;
	
	// tree positions within a tile
	private var trees:Array<Array<Array<Float>>> = [ [	[0.3, 0.5]	],
												 	 [ 	[0.6, 0.7]	],
												  	 [	[0.9, 0.5]	],
												  	 [	[0.8, 0.8]	],
												  	 []	];
 
	private var _codeString:String = "";
	
	public function new(world:World, models:Array<ObjectContainer3D>, skin:String = "default", map:Array<Array<Int>> = null) {
		
		_world = world;
		_models = models;
		_skin = skin;

		tileTextures = [

			new TileTexture("kitchen_floor", _skin),
			new TileTexture("straight_horizontal", _skin),
			new TileTexture("tile_grass", _skin)
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
				
				// trees and stuff on blank tiles
				if (tileData.id == 1) {
					
					var treePattern:Int = Math.floor(Math.random() * trees.length);
					var len:Int = trees[treePattern].length;

					for (t in 0...len) {
						
						var tree:GameObject = new GameObject("", cast(_models[1].clone(), ObjectContainer3D));
						tree.x = (TILE_WIDTH * i) - (0.5 * TILE_WIDTH) + (TILE_WIDTH * trees[treePattern][t][0]);
						tree.z = (-TILE_HEIGHT * j) - (0.5 * -TILE_HEIGHT) + (-TILE_HEIGHT * trees[treePattern][t][1]);

						tree.rotationY = 360 * Math.random();
						
						var treeSize:Float = 4 + Math.floor(Math.random() * 2);
						tree.scaleX = tree.scaleY = tree.scaleZ = treeSize;
						tree.setCollisionType("circle", treeSize);
						
						_world.addObstacle(tree);
					}
				}

				for (obj in tileData.objects) {
					
					
					switch(obj.id) {
							
						// cone
						case 1:
							
							var object:GameObject = new GameObject("", cast(_models[2].clone(), ObjectContainer3D));
							object.x = (TILE_WIDTH * i) + obj.pos.x - (TILE_WIDTH / 2);
							object.y = 1;
							object.z = (-TILE_HEIGHT * j) + obj.pos.y + (TILE_HEIGHT / 2);

							object.scaleX = object.scaleY = object.scaleZ = 0.6;

							object.setCollisionType("circle", 0.3);
							_world.addCone(object);

						// wall
						case 2:
							
							var object:GameObject = new GameObject("wall", cast(_models[3].clone(), ObjectContainer3D));
							object.x = (TILE_WIDTH * i) + obj.pos.x;
							object.y = 0;
							object.z = (-TILE_HEIGHT * j) + obj.pos.y;

							object.scaleX = object.scaleY = object.scaleZ = 4;

							object.setCollisionType("aabb", TILE_WIDTH, TILE_HEIGHT);
							_world.addObstacle(object);

						// counter
						case 3:
							
							var object:GameObject = new GameObject("counter", cast(_models[4].clone(), ObjectContainer3D));
							object.x = (TILE_WIDTH * i) + obj.pos.x;
							object.y = 0;
							object.z = (-TILE_HEIGHT * j) + obj.pos.y;

							object.scaleX = object.scaleY = object.scaleZ = 4;

							object.setCollisionType("aabb", TILE_WIDTH, TILE_HEIGHT);
							_world.addObstacle(object);

						// pot
						case 4:
							
							var object:GameObject = new GameObject("pot", cast(_models[5].clone(), ObjectContainer3D));
							object.x = (TILE_WIDTH * i) + obj.pos.x;
							object.y = 0;
							object.z = (-TILE_HEIGHT * j) + obj.pos.y;

							object.scaleX = object.scaleY = object.scaleZ = 4;

							object.setCollisionType("aabb", TILE_WIDTH, TILE_HEIGHT);
							_world.addObstacle(object);

						// grill
						case 5:
							
							var object:GameObject = new GameObject("grill", cast(_models[6].clone(), ObjectContainer3D));
							object.x = (TILE_WIDTH * i) + obj.pos.x;
							object.y = 0;
							object.z = (-TILE_HEIGHT * j) + obj.pos.y;

							object.scaleX = object.scaleY = object.scaleZ = 4;

							object.setCollisionType("aabb", TILE_WIDTH, TILE_HEIGHT);
							_world.addObstacle(object);

						// box
						case 6:
							
							var object:GameObject = new GameObject("box", cast(_models[7].clone(), ObjectContainer3D));
							object.x = (TILE_WIDTH * i) + obj.pos.x;
							object.y = 0;
							object.z = (-TILE_HEIGHT * j) + obj.pos.y;

							object.scaleX = object.scaleY = object.scaleZ = 4;

							object.setCollisionType("aabb", TILE_WIDTH, TILE_HEIGHT * 0.75);
							_world.addObstacle(object);
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