package com.daviddurhamgames.secretsauce;

import away3d.materials.TextureMaterial;
import away3d.containers.ObjectContainer3D;
import away3d.utils.*;

import openfl.geom.Point;

import com.daviddurhamgames.secretsauce.World;
import com.piratejuice.Vector2D;

class Level {
	
	// tile dimensions
	private var TILE_WIDTH:Int = 64;
	private var TILE_HEIGHT:Int = 64;
	
	// ref to the world
	private var _world:World;

	// ref to loaded models
	private var _models:Array<ObjectContainer3D>;

	// skin used
	private var _skin:String = "default";
	
	// track data
	public var waypoints:Array<Point>;
	public var waypointVectors:Array<Vector2D>;
	public var restartPoints:Array<Bool>;
	
	public var trackCenter:Point;

	private var tileTextures:Array<TileTexture>;

	private var circleShadowTexture:TextureMaterial;
	private var rectangleShadowTexture:TextureMaterial;
	
	private var _tileData:Array<TileData> = [	new TileData(0, "tile_grass", 0, []),	//blank
												new TileData(1, "straight_horizontal", 0, [new ObjectData(0, 0, 0), new ObjectData(0, 128, 0), new ObjectData(0, 256, 0), new ObjectData(0, -128, 0),    new ObjectData(1, 475, 432), new ObjectData(1, 402, 432), new ObjectData(1, 329, 432), new ObjectData(1, 256, 432), new ObjectData(1, 183, 432), new ObjectData(1, 110, 432), new ObjectData(1, 36, 432), new ObjectData(1, 475, 80), new ObjectData(1, 402, 80), new ObjectData(1, 329, 80), new ObjectData(1, 256, 80), new ObjectData(1, 183, 80), new ObjectData(1, 110, 80), new ObjectData(1, 36, 80), new ObjectData(2, 256, 72), new ObjectData(2, 256, 440), new ObjectData(7, 256, 168), new ObjectData(7, 256, 344)]), //straight H
												new TileData(2, "straight_horizontal", 1, [new ObjectData(0, 0, 0), new ObjectData(0, 0, 128), new ObjectData(0, 0, 256), new ObjectData(0, 0, -128),    new ObjectData(1, 80, 475), new ObjectData(1, 80, 402), new ObjectData(1, 80, 329), new ObjectData(1, 79, 256), new ObjectData(1, 79, 183), new ObjectData(1, 79, 110), new ObjectData(1, 79, 36), new ObjectData(1, 432, 475), new ObjectData(1, 432, 402), new ObjectData(1, 432, 329), new ObjectData(1, 431, 256), new ObjectData(1, 431, 183), new ObjectData(1, 431, 110), new ObjectData(1, 431, 36), new ObjectData(2, 440, 256), new ObjectData(2, 72, 256), new ObjectData(7, 168, 256), new ObjectData(7, 344, 256)]), //straight V
												
												// basic corners (br, bl, tl, tr)
												new TileData(3, "corner_tl", 0, [new ObjectData(0, 0, -256), new ObjectData(0, 16, -162), new ObjectData(0, 74, -74), new ObjectData(0, 162, -16), new ObjectData(0, 256, 0),     new ObjectData(1, 432, 479), new ObjectData(1, 183, 236), new ObjectData(1, 139, 296), new ObjectData(1, 110, 356), new ObjectData(1, 91, 418), new ObjectData(1, 81, 480), new ObjectData(1, 480, 431), new ObjectData(1, 480, 81), new ObjectData(1, 418, 90), new ObjectData(1, 354, 112), new ObjectData(1, 292, 143), new ObjectData(1, 232, 186), new ObjectData(2, 474, 474), new ObjectData(2, 190, 190), new ObjectData(7, 384, 384), new ObjectData(7, 240, 240)]),	//corner (r)
												new TileData(4, "corner_tl", 1, [new ObjectData(0, 0, -256), new ObjectData(0, -16, -162), new ObjectData(0, -74, -74), new ObjectData(0, -162, -16), new ObjectData(0, -256, 0),     new ObjectData(1, 32, 432), new ObjectData(1, 275, 183), new ObjectData(1, 215, 139), new ObjectData(1, 155, 110), new ObjectData(1, 93, 91), new ObjectData(1, 31, 81), new ObjectData(1, 80, 480), new ObjectData(1, 430, 480), new ObjectData(1, 421, 418), new ObjectData(1, 399, 354), new ObjectData(1, 368, 292), new ObjectData(1, 325, 232), new ObjectData(2, 38, 474), new ObjectData(2, 322, 190), new ObjectData(7, 128, 384), new ObjectData(7, 272, 240)]),
												new TileData(5, "corner_tl", 2, [new ObjectData(0, 0, 256), new ObjectData(0, -16, 162), new ObjectData(0, -74, 74), new ObjectData(0, -162, 16), new ObjectData(0, -256, 0),        new ObjectData(1, 79, 32), new ObjectData(1, 328, 275), new ObjectData(1, 372, 215), new ObjectData(1, 401, 155), new ObjectData(1, 420, 93), new ObjectData(1, 430, 31), new ObjectData(1, 31, 80), new ObjectData(1, 31, 430), new ObjectData(1, 93, 421), new ObjectData(1, 157, 399), new ObjectData(1, 219, 368), new ObjectData(1, 279, 325), new ObjectData(2, 37, 38), new ObjectData(2, 322, 322)]),	//(j)
												new TileData(6, "corner_tl", 3, [new ObjectData(0, 0, 256), new ObjectData(0, 16, 162), new ObjectData(0, 74, 74), new ObjectData(0, 162, 16), new ObjectData(0, 256, 0),       new ObjectData(1, 479, 79), new ObjectData(1, 236, 328), new ObjectData(1, 296, 372), new ObjectData(1, 356, 401), new ObjectData(1, 418, 420), new ObjectData(1, 480, 430), new ObjectData(1, 431, 31), new ObjectData(1, 81, 31), new ObjectData(1, 90, 93), new ObjectData(1, 112, 157), new ObjectData(1, 143, 219), new ObjectData(1, 186, 279), new ObjectData(2, 473, 37), new ObjectData(2, 190, 322)]),	//(L)
												
												// split tracks
												new TileData(7, "split_horizontal_l", 0, [new ObjectData(0, -256, 0), new ObjectData(0, -104, 0, 150), new ObjectData(0, -10, -106, 90), new ObjectData(0, -10, 106, 90), new ObjectData(0, 76, -160, 75), new ObjectData(0, 76, 160, 75), new ObjectData(0, 136, -166, 75), new ObjectData(0, 136, 166, 75), new ObjectData(0, 196, -166, 75), new ObjectData(0, 196, 166, 75), new ObjectData(0, 256, -166, 75), new ObjectData(0, 256, 166, 75),				new ObjectData(1, 36, 60), new ObjectData(1, 109, 40), new ObjectData(1, 182, 8), new ObjectData(1, 255, -33), new ObjectData(1, 328, -49), new ObjectData(1, 401, -57), new ObjectData(1, 475, -57), new ObjectData(1, 36, 452), new ObjectData(1, 109, 472), new ObjectData(1, 182, 504), new ObjectData(1, 255, 535), new ObjectData(1, 328, 551), new ObjectData(1, 401, 559), new ObjectData(1, 475, 559), new ObjectData(2, 256, 440), new ObjectData(2, 256, -128), new ObjectData(8, 404, 256)]),
												new TileData(8, "split_horizontal_l", 2, [new ObjectData(0, 256, 0), new ObjectData(0, 104, 0, 150), new ObjectData(0, 10, -106, 90), new ObjectData(0, 10, 106, 90), new ObjectData(0, -76, -160, 75), new ObjectData(0, -76, 160, 75), new ObjectData(0, -136, -166, 75), new ObjectData(0, -136, 166, 75), new ObjectData(0, -196, -166, 75), new ObjectData(0, -196, 166, 75), new ObjectData(0, -256, -166, 75), new ObjectData(0, -256, 166, 75),				new ObjectData(1, 475, 60), new ObjectData(1, 402, 40), new ObjectData(1, 329, 8), new ObjectData(1, 256, -33), new ObjectData(1, 183, -49), new ObjectData(1, 110, -57), new ObjectData(1, 36, -57), new ObjectData(1, 475, 452), new ObjectData(1, 402, 472), new ObjectData(1, 329, 504), new ObjectData(1, 256, 535), new ObjectData(1, 183, 551), new ObjectData(1, 110, 559), new ObjectData(1, 36, 559), new ObjectData(2, 256, 440), new ObjectData(2, 256, -128), new ObjectData(8, 108, 256)]),
												new TileData(9, "split_horizontal_l", 1, [new ObjectData(0, 0, -256), new ObjectData(0, 0, -104, 150), new ObjectData(0, -106, -10, 90), new ObjectData(0, 106, -10, 90), new ObjectData(0, -160, 76, 75), new ObjectData(0, 160, 76, 75), new ObjectData(0, -166, 136, 75), new ObjectData(0, 166, 136, 75), new ObjectData(0, -166, 196, 75), new ObjectData(0, 166, 196, 75), new ObjectData(0, -166, 256, 75), new ObjectData(0, 166, 256, 75),				new ObjectData(1, 80, 475), new ObjectData(1, 80, 402), new ObjectData(1, 80, 329), new ObjectData(1, 79, 256), new ObjectData(1, 79, 183), new ObjectData(1, 79, 110), new ObjectData(1, 79, 36), new ObjectData(1, 432, 475), new ObjectData(1, 432, 402), new ObjectData(1, 432, 329), new ObjectData(1, 431, 256), new ObjectData(1, 431, 183), new ObjectData(1, 431, 110), new ObjectData(1, 431, 36), new ObjectData(2, 440, 256), new ObjectData(2, 72, 256), new ObjectData(8, 256, 128)]),
												new TileData(10, "split_horizontal_l", 3, [new ObjectData(0, 0, 256), new ObjectData(0, 0, 104, 150), new ObjectData(0, -106, 10, 90), new ObjectData(0, 106, 10, 90), new ObjectData(0, -160, -76, 75), new ObjectData(0, 160, -76, 75), new ObjectData(0, -166, -136, 75), new ObjectData(0, 166, -136, 75), new ObjectData(0, -166, -196, 75), new ObjectData(0, 166, 196, 75), new ObjectData(0, -166, -256, 75), new ObjectData(0, 166, -256, 75), new ObjectData(1, 80, 475), new ObjectData(1, 80, 402), new ObjectData(1, 80, 329), new ObjectData(1, 79, 256), new ObjectData(1, 79, 183), new ObjectData(1, 79, 110), new ObjectData(1, 79, 36), new ObjectData(1, 432, 475), new ObjectData(1, 432, 402), new ObjectData(1, 432, 329), new ObjectData(1, 431, 256), new ObjectData(1, 431, 183), new ObjectData(1, 431, 110), new ObjectData(1, 431, 36), new ObjectData(2, 440, 256), new ObjectData(2, 72, 256), new ObjectData(8, 256, 384)]),
												
												// start/finish line
												new TileData(11, "tile_line", 0, [new ObjectData(0, 0, 0), new ObjectData(0, 0, 128), new ObjectData(0, 0, 256), new ObjectData(0, 0, -128),       new ObjectData(1, 80, 475), new ObjectData(1, 80, 402), new ObjectData(1, 80, 329), new ObjectData(3, 79, 256), new ObjectData(1, 79, 183), new ObjectData(1, 79, 110), new ObjectData(1, 79, 36), new ObjectData(1, 432, 475), new ObjectData(1, 432, 402), new ObjectData(1, 432, 329), new ObjectData(3, 431, 256), new ObjectData(1, 431, 183), new ObjectData(1, 431, 110), new ObjectData(1, 431, 36), new ObjectData(2, 440, 256), new ObjectData(2, 72, 256)]),// start/finish
												
												//blank variant (e.g. scrub, dressing)
												new TileData(12, "tile_grass", 0, []),
												
												//basic water
												new TileData(13, "tile_water", 0, []),
												
												// ramps
												new TileData(14, "straight_horizontal", 0, [new ObjectData(0, 0, 0), new ObjectData(0, 128, 0), new ObjectData(0, 256, 0), new ObjectData(0, -128, 0),    new ObjectData(1, 475, 432), new ObjectData(1, 402, 432), new ObjectData(1, 329, 432), new ObjectData(1, 256, 432), new ObjectData(1, 183, 432), new ObjectData(1, 110, 432), new ObjectData(1, 36, 432), new ObjectData(1, 475, 80), new ObjectData(1, 402, 80), new ObjectData(1, 329, 80), new ObjectData(1, 256, 80), new ObjectData(1, 183, 80), new ObjectData(1, 110, 80), new ObjectData(1, 36, 80), new ObjectData(2, 256, 72), new ObjectData(2, 256, 440), new ObjectData(4, 256, 256)]), //spring H
												new TileData(15, "straight_horizontal", 1, [new ObjectData(0, 0, 0), new ObjectData(0, 0, 128), new ObjectData(0, 0, 256), new ObjectData(0, 0, -128),    new ObjectData(1, 80, 475), new ObjectData(1, 80, 402), new ObjectData(1, 80, 329), new ObjectData(1, 79, 256), new ObjectData(1, 79, 183), new ObjectData(1, 79, 110), new ObjectData(1, 79, 36), new ObjectData(1, 432, 475), new ObjectData(1, 432, 402), new ObjectData(1, 432, 329), new ObjectData(1, 431, 256), new ObjectData(1, 431, 183), new ObjectData(1, 431, 110), new ObjectData(1, 431, 36), new ObjectData(2, 440, 256), new ObjectData(2, 72, 256), new ObjectData(4, 256, 256)]),//spring V
												
												// bridges
												new TileData(16, "tile_water", 0, [new ObjectData(0, 0, 0), new ObjectData(0, 128, 0), new ObjectData(0, 256, 0), new ObjectData(0, -128, 0),    new ObjectData(2, 256, 72), new ObjectData(2, 256, 440), new ObjectData(5, 0, 0)]),	//pit H
												new TileData(17, "tile_water", 0, [new ObjectData(0, 0, 0), new ObjectData(0, 0, 128), new ObjectData(0, 0, 256), new ObjectData(0, 0, -128),    new ObjectData(2, 440, 256), new ObjectData(2, 72, 256), new ObjectData(5, 0, 0)]),	//pit V
												
												// water
												new TileData(18, "tile_water", 0, [new ObjectData(2, 256, 72), new ObjectData(2, 256, 440)]),//basic water
												new TileData(19, "tile_water", 0, [new ObjectData(2, 440, 256), new ObjectData(2, 72, 256)]),//basic water
												
												// big corners (4 tiles each!) bottom-left
												new TileData(20, "big_corner_bl_tl", 0, [new ObjectData(0, 0, 256), new ObjectData(0, 12, 126), new ObjectData(0, 42, 0), new ObjectData(0, 93, -115), new ObjectData(0, 166, -223),	new ObjectData(1, 202, 477), new ObjectData(1, 164, 407), new ObjectData(1, 109, 260), new ObjectData(1, 93, 185), new ObjectData(1, 81, 110), new ObjectData(1, 76, 37), new ObjectData(1, 135, 334), new ObjectData(1, 481, 250), new ObjectData(1, 454, 179), new ObjectData(1, 437, 107), new ObjectData(1, 431, 37), new ObjectData(2, 454, 179), new ObjectData(2, 109, 260)]),
												new TileData(21, "big_corner_bl_tr", 0, []),
												new TileData(22, "big_corner_bl_bl", 0, [new ObjectData(1, 398, 201), new ObjectData(1, 342, 146), new ObjectData(1, 292, 89), new ObjectData(1, 244, 29), new ObjectData(1, 459, 249), new ObjectData(1, 683, -27), new ObjectData(1, 619, -78), new ObjectData(1, 564, -135), new ObjectData(1, 519, -199), new ObjectData(2, 590, -105), new ObjectData(2, 342, 146)]),
												new TileData(23, "big_corner_bl_br", 0, [new ObjectData(0, -223, 166), new ObjectData(0, -115, 93), new ObjectData(0, 0, 42), new ObjectData(0, 126, 12), new ObjectData(0, 256, 0),	new ObjectData(1, 83, 336), new ObjectData(1, 13, 296), new ObjectData(1, 475, 435), new ObjectData(1, 311, 414), new ObjectData(1, 231, 395), new ObjectData(1, 156, 368), new ObjectData(1, 392, 429), new ObjectData(1, 475, 81), new ObjectData(1, 394, 69), new ObjectData(1, 313, 48), new ObjectData(1, 237, 15), new ObjectData(2, 313, 48), new ObjectData(2, 231, 395)]),
												
												// top-left
												new TileData(24, "big_corner_bl_bl", 1, [new ObjectData(2, 590, 620), new ObjectData(2, 342, 368), new ObjectData(1, 398, 313), new ObjectData(1, 342, 368), new ObjectData(1, 292, 426), new ObjectData(1, 244, 486), new ObjectData(1, 459, 265), new ObjectData(1, 683, 541), new ObjectData(1, 619, 593), new ObjectData(1, 564, 649), new ObjectData(1, 519, 713)]),
												new TileData(25, "big_corner_bl_tl", 1, [new ObjectData(0, 256, 0), new ObjectData(0, 126, -12), new ObjectData(0, 0, -42), new ObjectData(0, -115, -93), new ObjectData(0, -223, -166),		new ObjectData(2, 313, 466), new ObjectData(2, 231, 120), new ObjectData(1, 83, 179), new ObjectData(1, 13, 219), new ObjectData(1, 475, 80), new ObjectData(1, 311, 101), new ObjectData(1, 231, 120), new ObjectData(1, 156, 147), new ObjectData(1, 392, 86), new ObjectData(1, 475, 434), new ObjectData(1, 394, 446), new ObjectData(1, 313, 466), new ObjectData(1, 237, 499)]),
												new TileData(26, "big_corner_bl_br", 1, [new ObjectData(0, 0, -256), new ObjectData(0, 12, -126), new ObjectData(0, 42, 0), new ObjectData(0, 93, 115), new ObjectData(0, 166, 223),	new ObjectData(2, 454, 336), new ObjectData(2, 109, 255), new ObjectData(1, 202, 37), new ObjectData(1, 164, 107), new ObjectData(1, 109, 255), new ObjectData(1, 93, 330), new ObjectData(1, 81, 405), new ObjectData(1, 76, 478), new ObjectData(1, 135, 181), new ObjectData(1, 481, 265), new ObjectData(1, 454, 336), new ObjectData(1, 437, 408), new ObjectData(1, 431, 478)]),
												new TileData(27, "big_corner_bl_tr", 1, []),
												
												// top-right
												new TileData(28, "big_corner_bl_br", 2, [new ObjectData(0, -256, 0), new ObjectData(0, -126, -12), new ObjectData(0, 0, -42), new ObjectData(0, 115, -93), new ObjectData(0, 223, -166),	new ObjectData(2, 178, 453), new ObjectData(2, 259, 108), new ObjectData(1, 477, 200), new ObjectData(1, 407, 163), new ObjectData(1, 259, 108), new ObjectData(1, 185, 91), new ObjectData(1, 109, 80), new ObjectData(1, 36, 75), new ObjectData(1, 334, 133), new ObjectData(1, 249, 480), new ObjectData(1, 178, 453), new ObjectData(1, 106, 436), new ObjectData(1, 36, 430)]),
												new TileData(29, "big_corner_bl_bl", 2, [new ObjectData(2, -106, 588), new ObjectData(2, 146, 340), new ObjectData(1, 201, 396), new ObjectData(1, 146, 340), new ObjectData(1, 88, 291), new ObjectData(1, 29, 242), new ObjectData(1, 249, 457), new ObjectData(1, -27, 681), new ObjectData(1, -79, 617), new ObjectData(1, -135, 562), new ObjectData(1, -199, 517)]),
												new TileData(30, "big_corner_bl_tr", 2, []),
												new TileData(31, "big_corner_bl_tl", 2, [new ObjectData(0, 0, -256), new ObjectData(0, -12, -126), new ObjectData(0, -42, 0), new ObjectData(0, -93, 115), new ObjectData(0, -166, 223),		new ObjectData(2, 48, 311), new ObjectData(2, 394, 229), new ObjectData(1, 336, 82), new ObjectData(1, 296, 11), new ObjectData(1, 434, 473), new ObjectData(1, 414, 309), new ObjectData(1, 394, 229), new ObjectData(1, 367, 154), new ObjectData(1, 429, 390), new ObjectData(1, 80, 473), new ObjectData(1, 69, 392), new ObjectData(1, 48, 311), new ObjectData(1, 15, 235)]),
												
												// bottom-right
												new TileData(32, "big_corner_bl_tr", 3, []),
												new TileData(33, "big_corner_bl_br", 3, [new ObjectData(0, 0, 256), new ObjectData(0, -12, 126), new ObjectData(0, -42, 0), new ObjectData(0, -93, -115), new ObjectData(0, -166, -223),	new ObjectData(2, 57, 178), new ObjectData(2, 402, 259), new ObjectData(1, 310, 477), new ObjectData(1, 347, 407), new ObjectData(1, 402, 259), new ObjectData(1, 418, 185), new ObjectData(1, 430, 109), new ObjectData(1, 435, 36), new ObjectData(1, 376, 333), new ObjectData(1, 30, 249), new ObjectData(1, 57, 178), new ObjectData(1, 74, 106), new ObjectData(1, 80, 36)]),
												new TileData(34, "big_corner_bl_tl", 3, [new ObjectData(0, -256, 0), new ObjectData(0, -126, 12), new ObjectData(0, 0, 42), new ObjectData(0, 115, 93), new ObjectData(0, 223, 166),	new ObjectData(2, 198, 48), new ObjectData(2, 281, 394), new ObjectData(1, 428, 336), new ObjectData(1, 498, 295), new ObjectData(1, 37, 434), new ObjectData(1, 201, 414), new ObjectData(1, 281, 394), new ObjectData(1, 356, 367), new ObjectData(1, 119, 429), new ObjectData(1, 37, 80), new ObjectData(1, 117, 69), new ObjectData(1, 198, 48), new ObjectData(1, 274, 15)]),
												new TileData(35, "big_corner_bl_bl", 3, [new ObjectData(2, -79, -106), new ObjectData(2, 169, 146), new ObjectData(1, 113, 201), new ObjectData(1, 169, 146), new ObjectData(1, 219, 88), new ObjectData(1, 267, 29), new ObjectData(1, 52, 249), new ObjectData(1, -172, -27), new ObjectData(1, -108, -79), new ObjectData(1, -52, -135), new ObjectData(1, -8, -199)])
											];
												
												
	// default level map data
	private var _levelMap:Array<Array<Int>> = [	[ 0, 0, 0,12, 0, 0, 0, 0],
												[ 0, 3, 1, 4, 0, 0, 0, 0],
												[ 0, 2,12, 2, 0,12, 0, 0],
												[12,11, 0, 6,14, 1, 4,12],
												[13,17,13, 0,12, 0, 2, 0],
												[ 0,15,13,12, 3, 1, 5, 0],
												[ 0, 2,13, 0, 2,12, 0, 0],
												[12, 6,16, 1, 5, 0, 0, 0],
												[ 0, 0,13,12, 0, 0, 0,12]];
												
												
	private var _levelOrder:Array<Array<Int>>;
	
	// tree positions within a tile
	private var trees:Array<Array<Array<Float>>> = [[[0.3, 0.5], [0.8, 0.7]],
												  [[0.4, 0.4], [0.6, 0.7]],
												  [[0.1, 0.3], [0.6, 0.9], [0.9, 0.5], [0.2, 0.8]],
												  [[0.2, 0.9], [0.8, 0.8]],
												  []];
 
	private var _codeString:String = "";
	
	public function new(world:World, models:Array<ObjectContainer3D>, skin:String = "default", map:Array<Array<Int>> = null) {
		
		_world = world;
		_models = models;
		_skin = skin;

		tileTextures = [

			new TileTexture("tile_grass", _skin),
			new TileTexture("straight_horizontal", _skin),
			new TileTexture("corner_tl", _skin),
			new TileTexture("split_horizontal_l", _skin),
			new TileTexture("tile_line", _skin),
			new TileTexture("tile_water", _skin),
			new TileTexture("big_corner_bl_tl", _skin),
			new TileTexture("big_corner_bl_tr", _skin),
			new TileTexture("big_corner_bl_bl", _skin),
			new TileTexture("big_corner_bl_br", _skin)
		];
		
		circleShadowTexture = new TextureMaterial(Cast.bitmapTexture("assets/shadow_circle.png"), false, false, false);
		circleShadowTexture.bothSides = false;
		circleShadowTexture.alphaBlending = true;
        
		rectangleShadowTexture = new TextureMaterial(Cast.bitmapTexture("assets/shadow_circle.png"), false, false, false);
		rectangleShadowTexture.bothSides = false;
		rectangleShadowTexture.alphaBlending = true;

		_levelMap = map;
	}
	
	
	private function getPreviousTileId(px:Int, py:Int):Int {
		
		for (i in 0..._levelOrder.length) {
			
			if (_levelOrder[i][0] == px && _levelOrder[i][1] == py) {
				
				if (i > 0) {
					
					// return tile id
					return _levelMap[_levelOrder[i - 1][1]][_levelOrder[i - 1][0]];
				}
				else {
					
					// straight up
					return 2;
				}
			}
		}
		
		return 2;
	}
	
	private function getNextTileId(px:Int, py:Int):Int {
		
		for (i in 0..._levelOrder.length) {
			
			if (_levelOrder[i][0] == px && _levelOrder[i][1] == py) {
				
				if (i < _levelOrder.length - 1) {
					
					// return tile id
					return _levelMap[_levelOrder[i + 1][1]][_levelOrder[i + 1][0]];
				}
				else {
					
					// straight up
					return 2;
				}
			}
		}
		
		return 2;
	}
	
	private function getRoadDirection(type:Int, px:Int, py:Int):Int {
		
		for (i in 0..._levelOrder.length) {
		
			switch (type) {
			
				// horizontal
				case 1, 14, 16, 18:
					
					if (_levelOrder[i][0] == px && _levelOrder[i][1] == py) {
						
						// if this the last tile in the path?
						if (i == _levelOrder.length - 1) {
							
							// CURRENTLY A HORIZONTAL TILE CAN'T BE THE LAST TILE
							// IN THE PATH, SO THIS WON'T EVER HAPPEN
						}
						else {
							
							// check the next tile in the path
							if (_levelOrder[i + 1][0] == px + 1) {
								
								// going left (dir 1)
								return 1;
							}
							else if (_levelOrder[i + 1][0] == px - 1) {
								
								// going right (dir -1)
								return -1;
							}
							else {
								
								// something went wrong!
								return 0;
							}
						}
					}
				
				// vertical
				case 2, 11, 15, 17, 19:
					
					if (_levelOrder[i][0] == px && _levelOrder[i][1] == py) {
						
						// if this the last tile in the path?
						if (i == _levelOrder.length - 1) {
							
							// last tile is always going up (at the moment)
							return -1;
						}
						else {
							
							// check the next tile in the path
							if (_levelOrder[i + 1][1] == py + 1) {
								
								// going down (dir 1)
								return 1;
							}
							else if (_levelOrder[i + 1][1] == py - 1) {
								
								// going up (dir -1)
								return -1;
							}
							else {
								
								// something went wrong!
								return 0;
							}
						}
					}
			}
		}
		
		return 0;
	}
	
	
	public function createLevel(isOverview:Bool = false):Void {
		
		addWater(_levelMap);
		buildLevel(_levelMap, isOverview);
	}
	
	private function addWater(map:Array<Array<Int>>):Void {
		
		var waterTiles:Array<Point> = new Array<Point>();
		
		for (i in 0...map[0].length) {
			
			for (j in 0...map.length) {
				
				var tileData:TileData = null;
				
				for (td in _tileData) {
					
					if (td.id == map[j][i]) {
						
						tileData = td;
						break;
					}
				}
				
				// horizontal bridges
				if (tileData.id == 16) {
					
					var dir:Int = getRoadDirection(tileData.id, i, j);
					var previousTileId:Int = getPreviousTileId(i, j);
					
					// previous tile must also be horizontal
					if (previousTileId != 1 && previousTileId != 14 && previousTileId != 16 && previousTileId != 18) {
						
						// replace with normal road
						for (td in _tileData) {
							
							if (td.id == 1) {
								
								map[j][i] = 1;
								tileData = td;
								break;
							}
						}
					}
				}
				// vertical bridges
				else if (tileData.id == 17) {
					
					var dir:Int = getRoadDirection(tileData.id, i, j);
					var previousTileId:Int = getPreviousTileId(i, j);
					
					// previous tile must be vertical
					if (previousTileId != 2 && previousTileId != 15 && previousTileId != 17 && previousTileId != 19) {
						
						// replace with normal road
						for (td in _tileData) {
							
							if (td.id == 2) {
								
								map[j][i] = 2;
								tileData = td;
								break;
							}
						}
					}
				}	
				
				if (tileData.asset == "tile_water") {
					
					waterTiles.push(new Point(i, j));
				}
			}
		}
		
		//trace("water tiles: " + waterTiles);
		
		for (i in 0...waterTiles.length) {
			
			//if (map[Std.int(waterTiles[i].y + 1)][Std.int(waterTiles[i].x)] == 0) map[Std.int(waterTiles[i].y + 1)][Std.int(waterTiles[i].x)] = 13;
			if (map[Std.int(waterTiles[i].y - 1)][Std.int(waterTiles[i].x)] == 0) map[Std.int(waterTiles[i].y - 1)][Std.int(waterTiles[i].x)] = 13;
			if (map[Std.int(waterTiles[i].y)][Std.int(waterTiles[i].x + 1)] == 0) map[Std.int(waterTiles[i].y)][Std.int(waterTiles[i].x + 1)] = 13;
			//if (map[Std.int(waterTiles[i].y)][Std.int(waterTiles[i].x - 1)] == 0) map[Std.int(waterTiles[i].y)][Std.int(waterTiles[i].x - 1)] = 13;
		}
	}
	
	public function isWaterTile(tx:Int, ty:Int):Bool {
		
		if (_levelMap[ty][tx] == 13 || _levelMap[ty][tx] == 16 || _levelMap[ty][tx] == 17 || _levelMap[ty][tx] == 18 || _levelMap[ty][tx] == 19) return true;
		return false;
	}
	
	public function buildLevel(map:Array<Array<Int>>, isOverview:Bool = false):Void {
		
		var w:Int = map[0].length;
		var h:Int = map.length;
		
		var waypointMarkers:Array<Point> = [];
		
		trackCenter = new Point();
		var pointCount:Int = 0;
		
		var tileset:String = "tiles";
		var count:Int = 0;
		
		// build track
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
				
				// find center
				if (map[j][i] > 0 && map[j][i] < 12) {
					
					trackCenter.x += (TILE_WIDTH * (i + 0.5));
					trackCenter.y += (TILE_HEIGHT * (j + 0.5));
					pointCount++;
				}
				
				// for all tiles that use this asset
				if (tileData.asset == "tile_water") {
					
					var isWaterLeft:Bool = true;
					var isWaterRight:Bool = true;
					var isWaterUp:Bool = true;
					var isWaterDown:Bool = true;
					
					// water tiles are dynamically drawn based whether
					// there are other water tiles around them
					if (j > 0) {
						
						// tile above is water?
						if (!isWaterTile(i, j - 1)) {
							
							isWaterUp = false;
						}
					}
					
					if (j < map.length - 1) {
						
						// tile below is water?
						if (!isWaterTile(i, j + 1)) {
							
							isWaterDown = false;
						}
					}
					
					if (i > 0) {
						
						// tile to left is water?
						if (!isWaterTile(i - 1, j)) {
							
							isWaterLeft = false;
						}
					}
					
					if (i < map[0].length - 1) {
						
						// tile to right is water?
						if (!isWaterTile(i + 1, j)) {
							
							isWaterRight = false;
						}
					}
					
					// single pool
					if (!isWaterDown && !isWaterUp && !isWaterLeft && !isWaterRight) {
						
						model = _models[4];
					}
					else if (!isWaterDown && !isWaterUp) {
						
						model = _models[3];

						if (isWaterLeft) {
							
							modelRotation = 1;
						}
						else if (isWaterRight) {
							
							modelRotation = 3;
						}
					}
					else if (!isWaterDown) {
						
						if (isWaterLeft) {
							
							model = _models[2];
							modelRotation = 0;
						}
						else if (isWaterRight) {
							
							model = _models[2];
							modelRotation = 0;
						}
						else {
							
							model = _models[3];
							modelRotation = 2;
						}
					}
					else if (!isWaterUp) {
						
						if (isWaterLeft) {
							
							model = _models[2];
							modelRotation = 0;
						}
						else if (isWaterRight) {
							
							model = _models[2];
							modelRotation = 0;
						}
						else {
							
							model = _models[3];
							modelRotation = 0;
						}
					}
					else {
						
						model = _models[1];
					}
				}
				else {
					
					asset = "assets/" + tileset + "/" + tileData.asset + ".png";
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
				
					var tile:LevelTile;
					
					if (tileData.asset == "tile_water") {

						tile = new LevelTile(null, model);
						tile.rotationY = (modelRotation * 90);
					}
					else {

						tile = new LevelTile(tileTexture.material);
						tile.rotationY = (tileData.assetRotation * 90);
					}
					
					tile.x = TILE_WIDTH * i;
					tile.z = -TILE_HEIGHT * j;
					_world.addTile(tile);
				}
				
				// trees and stuff on blank tiles
				if (tileData.id == 0) {
					
					var treePattern:Int = Math.floor(Math.random() * trees.length);
					var len:Int = trees[treePattern].length;

					for (t in 0...len) {
						
						var tree:GameObject = new GameObject("", cast(_models[5].clone(), ObjectContainer3D));
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

				for (obj in tileData.objects) {
					
					
					switch(obj.id) {
							
						// bollard / cone
						case 1:
							
							if (!isOverview) {

								var object:GameObject = new GameObject("", cast(_models[6].clone(), ObjectContainer3D));
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
		
		trackCenter.x = trackCenter.x / pointCount;
		trackCenter.y = trackCenter.y / pointCount;
	}
	
	public function clearLevel():Void {
		
		_world.removeAll();
		
		// reset waypoint lists
		waypoints = new Array<Point>();
		waypointVectors = new Array<Vector2D>();
	}
	
	public function getLevelMap():Array<Array<Int>> {
		
		return _levelMap;
	}
	
	public function cleanUp():Void {
		
		
	}
}