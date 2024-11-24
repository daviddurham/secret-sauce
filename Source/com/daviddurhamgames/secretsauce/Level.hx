package com.daviddurhamgames.secretsauce;

import away3d.materials.TextureMaterial;
import away3d.containers.ObjectContainer3D;
import away3d.primitives.PlaneGeometry;
import away3d.entities.Mesh;
import away3d.utils.*;

import com.daviddurhamgames.secretsauce.World;

class Level {
	
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

												// recipe
												new TileData(5, "kitchen_floor", 0, [new ObjectData(3, 0, 0)]),

												// reviews
												new TileData(6, "kitchen_floor", 0, [new ObjectData(7, 0, 0), new ObjectData(10, 0, -4, 12)]),
												
												// wall
												new TileData(7, "", 0, [new ObjectData(2, 0, 0)]),
												
												// counter
												new TileData(8, "kitchen_floor", 0, [new ObjectData(3, 0, 0)]),

												// pot
												new TileData(9, "kitchen_floor", 0, [new ObjectData(4, 0, 0), new ObjectData(10, 0, -4, 11)]),

												// grill
												new TileData(10, "kitchen_floor", 0, [new ObjectData(5, 0, 0)]),

												// boxes
												new TileData(11, "kitchen_floor", 0, [new ObjectData(6, 0, 2, 1), new ObjectData(10, 0, -2, 1)]),
												new TileData(12, "kitchen_floor", 0, [new ObjectData(6, 0, 2, 2), new ObjectData(10, 0, -2, 2)]),
												new TileData(13, "kitchen_floor", 0, [new ObjectData(6, 0, 2, 3), new ObjectData(10, 0, -2, 3)]),
												new TileData(14, "kitchen_floor", 0, [new ObjectData(6, 0, 2, 4), new ObjectData(10, 0, -2, 4)]),
												new TileData(15, "kitchen_floor", 0, [new ObjectData(6, 0, 2, 5), new ObjectData(10, 0, -2, 5)]),
												new TileData(16, "kitchen_floor", 0, [new ObjectData(6, 0, 2, 6), new ObjectData(10, 0, -2, 6)]),
												new TileData(17, "kitchen_floor", 0, [new ObjectData(6, 0, 2, 7), new ObjectData(10, 0, -2, 7)]),
												new TileData(18, "kitchen_floor", 0, [new ObjectData(6, 0, 2, 8), new ObjectData(10, 0, -2, 8)]),
												new TileData(19, "kitchen_floor", 0, [new ObjectData(6, 0, 2, 9), new ObjectData(10, 0, -2, 9)]),
												new TileData(20, "kitchen_floor", 0, [new ObjectData(6, 0, 2, 10), new ObjectData(10, 0, -2, 10)]),

												new TileData(21, "kitchen_floor", 0, [new ObjectData(8, 0, 0)]),

												// wall alt
												new TileData(22, "", 0, [new ObjectData(11, 0, 0)]),
												new TileData(23, "", 0, [new ObjectData(12, 0, 0)]),
												new TileData(24, "", 0, [new ObjectData(13, 0, 0)]),

												// barrier
												new TileData(25, "kitchen_floor", 0, [new ObjectData(14, 0, 0)])
											];
																	
	// default level map data
	private var _levelMap:Array<Array<Int>> = [	[0, 0],
												[0, 0],	];												
												
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
					
					tile.x = Main.TILE_SIZE * i;
					tile.z = -Main.TILE_SIZE * j;
					_world.addTile(tile);
				}
				
				// trees and stuff on blank tiles
				/*
				if (tileData.id == 1) {
					
					var treePattern:Int = Math.floor(Math.random() * trees.length);
					var len:Int = trees[treePattern].length;

					for (t in 0...len) {
						
						var tree:GameObject = new GameObject("", cast(_models[1].clone(), ObjectContainer3D));
						tree.x = (Main.TILE_SIZE * i) - (0.5 * Main.TILE_SIZE) + (Main.TILE_SIZE * trees[treePattern][t][0]);
						tree.z = (-Main.TILE_SIZE * j) - (0.5 * -Main.TILE_SIZE) + (-Main.TILE_SIZE * trees[treePattern][t][1]);

						tree.rotationY = 360 * Math.random();
						
						var treeSize:Float = 2 + Math.floor(Math.random() * 2);
						tree.scaleX = tree.scaleY = tree.scaleZ = treeSize;
						tree.setCollisionType("circle", treeSize);
						
						_world.addObstacle(tree);
					}
				}
				*/

				for (obj in tileData.objects) {
					
					switch(obj.id) {
							
						// cone
						case 1:
							
							var object:GameObject = new GameObject("", cast(_models[2].clone(), ObjectContainer3D));
							object.x = (Main.TILE_SIZE * i) + obj.pos.x - (Main.TILE_SIZE / 2);
							object.y = 1;
							object.z = (-Main.TILE_SIZE * j) + obj.pos.y + (Main.TILE_SIZE / 2);

							object.scaleX = object.scaleY = object.scaleZ = 0.6;

							object.setCollisionType("circle", 0.3);
							_world.addCone(object);

						// wall
						case 2:
							
							addWall((Main.TILE_SIZE * i) + obj.pos.x, (-Main.TILE_SIZE * j) + obj.pos.y, 3);

						// counter
						case 3:
							
							addCounterObject((Main.TILE_SIZE * i) + obj.pos.x, (-Main.TILE_SIZE * j) + obj.pos.y, "counter", 4);

						// pot
						case 4:
							
							addCounterObject((Main.TILE_SIZE * i) + obj.pos.x, (-Main.TILE_SIZE * j) + obj.pos.y, "pot", 5);
							addPrompt((Main.TILE_SIZE * i) + obj.pos.x, (-Main.TILE_SIZE * j) + obj.pos.y, "assets/prompt_empty.png", 0);
							addPrompt((Main.TILE_SIZE * i) + obj.pos.x, (-Main.TILE_SIZE * j) + obj.pos.y, "assets/prompt_drop.png", 0);

						// grill
						case 5:
							
							addCounterObject((Main.TILE_SIZE * i) + obj.pos.x, (-Main.TILE_SIZE * j) + obj.pos.y, "grill", 6);

						// box
						case 6:
							
							var object:GameObject = new GameObject("box", cast(_models[7].clone(), ObjectContainer3D));
							object.x = (Main.TILE_SIZE * i) + obj.pos.x;
							object.y = 0;
							object.z = (-Main.TILE_SIZE * j) + obj.pos.y;

							object.scaleX = object.scaleY = object.scaleZ = 4;

							object.setCollisionType("aabb", Main.TILE_SIZE, Main.TILE_SIZE * 0.75);
							_world.addObstacle(object);

							// add a label
							var material:TextureMaterial = new TextureMaterial(Cast.bitmapTexture("assets/ingredient_label_" + obj.type + ".png"), false, false, false);
							var label:Mesh = new Mesh(new PlaneGeometry(6, 6), material);
							label.rotationX = 270;
							label.y = 12;
							label.z = -4.1;
							label.castsShadows = false;

							var o:ObjectContainer3D = new ObjectContainer3D();
							o.x = (Main.TILE_SIZE * i) + obj.pos.x;
							o.y = 0;
							o.z = (-Main.TILE_SIZE * j) + obj.pos.y;
							o.addChild(label);
							_world.add(o);

							addPrompt((Main.TILE_SIZE * i) + obj.pos.x, (-Main.TILE_SIZE * j) + obj.pos.y, "assets/prompt_collect.png", 0);

						// reviews screen
						case 7:
							
							addCounterObject((Main.TILE_SIZE * i) + obj.pos.x, (-Main.TILE_SIZE * j) + obj.pos.y, "reviews", 8);
						
						// sink
						case 8:
							
							addCounterObject((Main.TILE_SIZE * i) + obj.pos.x, (-Main.TILE_SIZE * j) + obj.pos.y, "sink", 9);

						// hotspot
						case 10:
							
							addHotspot(i, j, obj);

						case 11:

							addWall((Main.TILE_SIZE * i) + obj.pos.x, (-Main.TILE_SIZE * j) + obj.pos.y, 10);

						case 12:

							addWall((Main.TILE_SIZE * i) + obj.pos.x, (-Main.TILE_SIZE * j) + obj.pos.y, 11);

						case 13:

							addWall((Main.TILE_SIZE * i) + obj.pos.x, (-Main.TILE_SIZE * j) + obj.pos.y, 12);

						// barrier when caught
						case 14:

							var object:GameObject = new GameObject("barrier", null, 99);
							object.visible = false;
							object.x = (Main.TILE_SIZE * i) + obj.pos.x;
							object.y = 0;
							object.z = (-Main.TILE_SIZE * j) + obj.pos.y;
							object.scaleX = object.scaleY = object.scaleZ = 4;
							object.setCollisionType("aabb", Main.TILE_SIZE, Main.TILE_SIZE);
							_world.addObstacle(object);
					}
				}
				
				count++;
			}
		}
	}

	private function addPrompt(px:Float, pz:Float, texture:String, id:Int) {
		
		trace(texture);
		var material:TextureMaterial = new TextureMaterial(Cast.bitmapTexture(texture), false);
		material.alphaThreshold = 1;
		material.mipmap = false;
		material.bothSides = true;

		var prompt = new Mesh(new PlaneGeometry(8, 8), material);
		prompt.castsShadows = false;
		prompt.x = px;
		prompt.y = 24;
		prompt.z = pz;
		prompt.rotationX = -45;
		prompt.visible = false;
		_world.addPrompt(prompt, id);
	}

	private function addWall(px:Float, pz:Float, modelID:Int):Void {

		var object:GameObject = new GameObject("wall", cast(_models[modelID].clone(), ObjectContainer3D));
		object.x = px;
		object.y = 0;
		object.z = pz;

		object.scaleX = object.scaleY = object.scaleZ = 4;

		object.setCollisionType("aabb", Main.TILE_SIZE, Main.TILE_SIZE);
		_world.addObstacle(object);
	}

	private function addCounterObject(px:Float, pz:Float, name:String, modelId:Int):Void {

		var object:GameObject = new GameObject(name, cast(_models[modelId].clone(), ObjectContainer3D));
		object.x = px;//(Main.TILE_SIZE * tx) + obj.pos.x;
		object.y = 0;
		object.z = pz;//(-Main.TILE_SIZE * ty) + obj.pos.y;

		object.scaleX = object.scaleY = object.scaleZ = 4;

		object.setCollisionType("aabb", Main.TILE_SIZE, Main.TILE_SIZE);
		_world.addObstacle(object);
	}

	private function addHotspot(px:Int, py:Int, obj:ObjectData):Void {

		var object:GameObject = new GameObject("hotspot", null, obj.type);
		object.visible = false;
		object.x = (Main.TILE_SIZE * px) + obj.pos.x;
		object.y = 0;
		object.z = (-Main.TILE_SIZE * py) + obj.pos.y;

		object.setCollisionType("circle", Main.TILE_SIZE / 2);
		_world.addHotspot(object);
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