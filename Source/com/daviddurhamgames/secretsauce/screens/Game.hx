package com.daviddurhamgames.secretsauce.screens;

import away3d.materials.methods.ShadowMapMethodBase;
import com.daviddurhamgames.secretsauce.Player;
import com.daviddurhamgames.secretsauce.HUD;
import com.daviddurhamgames.secretsauce.TouchController;
import com.daviddurhamgames.secretsauce.World;
import com.daviddurhamgames.secretsauce.Level;
import com.daviddurhamgames.secretsauce.Ingredient;

import com.piratejuice.Audio;
import com.piratejuice.Vector2D;
import com.piratejuice.InputManager;
import com.piratejuice.Collisions;

import away3d.containers.*;
import away3d.entities.*;
import away3d.materials.*;
import away3d.materials.lightpickers.StaticLightPicker;
import away3d.lights.*;
import away3d.materials.methods.HardShadowMapMethod;
import away3d.cameras.lenses.*;
import away3d.library.Asset3DLibrary;
import away3d.loaders.parsers.DAEParser;
import away3d.loaders.misc.AssetLoaderContext;
import away3d.events.Asset3DEvent;
import away3d.library.assets.IAsset;
import away3d.library.assets.Asset3DType;

import openfl.display.*;
import openfl.events.*;
import openfl.geom.Vector3D;
import openfl.Assets;
import openfl.Lib.getTimer;

import motion.Actuate;
import motion.easing.Quad;

class Game extends Sprite {
	
	// game running flag
	private var isRunning:Bool;

	// flag when quit is initiated to block further interaction
	private var isQuitting = false;
	
	// lock controls when game still running
	private var isControlLocked:Bool;
	
	// pointer flag
	private var isButtonDown:Bool = false;

	// pixelated mode
	private var isRetroMode:Bool = true;
	
	// update loop
	//private var deltaTime:Float;
    //private var oldTime:Float;
    //private var accumulator:Float;
	private var isStarted = false;
	private var accumulator:Float = 0;
    private var previousTime:Float = 0;

	private var upperTimeStep:Float = 1 / 62.0;
	private var lowerTimeStep:Float = 1 / 60.0;

	// touch controller
	private var controller:TouchController;
	
	// hold everything in this
	private var holder:Sprite;
	
	// loading message
	private var loadingMessage:Bitmap;

	// transition
	private var transition:Shape;

	// HUD includes pause button/panel and scores
	private var hud:HUD;
	
	private var objects:Array<GameObject>;
	
	// background music
	private var bgm:Audio;
	
	// sfx
	private var eventSFXAudio:Audio;

	// for 3D...
	//engine variables
	private var view:View3D;

	private var mainLight:DirectionalLight;
	private var lightPicker:StaticLightPicker;
	private var shadowMapMethod:ShadowMapMethodBase;

	// loaded model mesh
	private var assetLoaderContext:AssetLoaderContext;
	private var loadedMesh:Mesh;
	private var modelsToLoad:Array<String>;
	private var meshCounts:Array<Int>;
	private var shadows:Array<Bool>;
	private var currentModelLoading:Int = -1;

	private var loadedModels:Array<ObjectContainer3D>;

	// mesh counter
	private var meshCount:Int = 0;

	// putting all the world elements into one class
	// so I can pass them around easier
	private var world:World;

	// level skin
	private var skin:String = "default";

	// level builder
	private var level:Level;
	
	// game mode (quick race, championship etc)
	private var gameMode:String;

	// winning player
	private var winner:Int = 0;
	
	// player
	private var p1:Player;
	
	// boss
	private var enemy:Player;

	// other players
	private var players:Array<Player>;

	// current ingredient the player is next to
	private var currentHotspot = 0;

	private var timeLimit:Int = 90;
	private var currentTime:Float = 0;

	// keyboard input manager
	private var input:InputManager;

	private var bitmapData:BitmapData;
	private var bitmap:Bitmap;

	private var zoom:Int = 1;

	// DEBUG
	private var isFreeCamera:Bool = false;
	private var isPointerDown:Bool = false;
	private var pointerStart:Vector2D;
	private var pointerCurrent:Vector2D;

	private var map:Array<Array<Int>> = [	[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ],
											[1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1 ],
											[1, 1, 1, 2, 7, 7, 7, 7, 7, 7, 7, 7, 7, 2, 1, 1, 1 ],
											[1, 1, 1, 2, 7, 0,11,12, 0,13,14, 0, 7, 2, 1, 1, 1 ],
											[1, 1, 1, 2, 7, 0, 0, 0, 0, 0, 0, 0, 7, 2, 1, 1, 1 ],
											[1, 1, 1, 2, 7, 0,15,16, 0,17,18, 0, 7, 2, 1, 1, 1 ],
											[1, 1, 1, 2, 7, 0, 0, 0, 0, 0, 0, 0, 7, 2, 1, 1, 1 ],
											[1, 1, 1, 2, 7, 0, 0, 0, 0, 0, 0, 0, 7, 2, 1, 1, 1 ],
											[1, 1, 1, 2, 7, 7, 7, 7, 7, 0, 7, 7, 7, 2, 1, 1, 1 ],
											[1, 1, 1, 2, 7, 8, 8,10,10, 0, 6, 5, 7, 2, 1, 1, 1 ],
											[1, 1, 1, 2, 7, 8, 0, 0, 0, 0, 0, 0, 7, 2, 1, 1, 1 ],
											[1, 1, 1, 2, 7, 8, 0, 0, 0, 0, 0, 0, 7, 2, 2, 2, 2 ],
											[1, 1, 1, 2, 7, 8, 0, 0, 0, 0, 0, 8, 7, 3, 3, 3, 3 ],
											[1, 1, 1, 2, 7, 8, 0, 0, 0, 0, 0, 8, 7, 3, 3, 3, 3 ],
											[1, 1, 1, 2, 7, 8, 0, 0, 0, 0, 0, 8, 7, 3, 3, 3, 3 ],
											[1, 1, 1, 2, 7, 7, 7, 0, 7, 7, 7, 7, 7, 2, 2, 2, 2 ],
											[1, 1, 1, 2, 7, 8, 8, 0, 9, 8, 7, 2, 2, 2, 1, 1, 1 ],
											[1, 1, 1, 2, 7, 8, 0, 0, 0, 0, 7, 2, 1, 1, 1, 1, 1 ],
											[1, 1, 1, 2, 7, 8, 0, 0, 0, 0, 7, 2, 1, 1, 1, 1, 1 ],
											[1, 1, 1, 2, 7, 8, 0, 0, 0, 0, 7, 2, 1, 1, 1, 1, 1 ],
											[1, 1, 1, 2, 7, 7, 7, 7, 7, 7, 7, 2, 7, 1, 1, 1, 1 ],
											[1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1 ],
											[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ]	];

	private var ingredients:Array<Ingredient> = [

		new Ingredient(1, "white", 	3, 0, 1, 0, "assets/ingredient1.png"),
		new Ingredient(2, "blue",	2, 0, 0, 1, "assets/ingredient2.png"),

		new Ingredient(3, "pink", 	0, 3, 0, 1, "assets/ingredient3.png"),
		new Ingredient(4, "brown",	1, 2, 0, 0, "assets/ingredient4.png"),
		
		new Ingredient(5, "red", 	0, 1, 3, 0, "assets/ingredient5.png"),
		new Ingredient(6, "orange",	1, 0, 2, 0, "assets/ingredient6.png"),
		
		new Ingredient(7, "green", 	0, 0, 1, 3, "assets/ingredient7.png"),
		new Ingredient(8, "purple",	0, 1, 0, 2, "assets/ingredient8.png")
	];

	// tweak this for difficulty
	private var recipeLength:Int = 5;

	// TODO: generate a target secret recipe each time
	// the ingredients don't have to match - just the flavour levels
	private var targetRecipe:Array<Int> = [ 1, 3, 6 ];

	// TODO: randomize starting recipe each time
	private var currentRecipe:Array<Int> = [ 2, 1, 7 ];
	private var potContents:Array<Int> = [];

	private var currentDay:Int = 0;

	private var reviews:Array<String> = [];
	private var recipe:Array<String> = [];

	public function new(mode:String = "default", players:Int = 1, code:String = "") {
		
		super();

		// get game settings
		gameMode = mode;

		addEventListener(Event.ADDED_TO_STAGE, init);
	}

	private function init(event:Event) {
		
		removeEventListener(Event.ADDED_TO_STAGE, init);
		
		isRunning = true;
		isControlLocked = false;
		
		holder = new Sprite();
		addChild(holder);
		
		transition = new Shape();
		transition.x = Main.maxWidth / 2;
		transition.y = Main.maxHeight / 2;
		transition.graphics.beginFill(0x000000);
		transition.graphics.drawRect(-1000, -600, 2000, 1200);
		transition.graphics.endFill();
		addChild(transition);
		

		// keyboard controls
		input = new InputManager(stage);
		input.addKey("left", Main.KEY_LEFT);
		input.addKey("right", Main.KEY_RIGHT);
		input.addKey("up", Main.KEY_UP);
		input.addKey("down", Main.KEY_DOWN);

		input.addKey("a", Main.KEY_A);
		input.addKey("b", Main.KEY_B);

		input.addKey("pause", 80);
		input.addKey("restart", 82);
		
		// on key events
		input.onKey("a", "a_pressed");
		input.addEventListener("a_pressed", onAPressed, false, 0, true);

		input.onKey("b", "b_pressed");
		input.addEventListener("b_pressed", onBPressed, false, 0, true);
		
		// on key events		
		input.onKey("pause", "pause_key_pressed");
		input.addEventListener("pause_key_pressed", onPauseKeyPressed, false, 0, true);
		
		//setup the 3D view
		view = new View3D();
		view.visible = false;	// <-- doesn't work?
        view.backgroundColor = 0x000000;

		// setup the camera - we want a low-ish FOV to approximate an orthographic camera
		// NOTE: very low field of view (e.g. < 10) causes weirdness with shadows
		view.camera.lens = new PerspectiveLens(20);
		
		view.camera.lens.far = 400 * zoom;
		
		view.height = Main.maxHeight;// * Main.scale;
        view.width = Main.maxWidth;//view.height * 2.17;
		holder.addChild(view);

		// create main light
		mainLight = new DirectionalLight();
		mainLight.castsShadows = false;
		mainLight.color = 0xeedddd;
        mainLight.direction = new Vector3D(0, -1, 0);
        mainLight.ambient = 0.8;
        mainLight.ambientColor = 0xaaaaaa;
        mainLight.diffuse = 0.5;
        mainLight.specular = 0;
		view.scene.addChild(mainLight);
		
		lightPicker = new StaticLightPicker([ mainLight ]);

		// hard shadows are the most efficient
		shadowMapMethod = new HardShadowMapMethod(mainLight);
		shadowMapMethod.epsilon = 0.5;

		bitmapData = new BitmapData(Main.maxWidth, Main.maxHeight, false, 0x000000);
		bitmap = new Bitmap(bitmapData, PixelSnapping.ALWAYS, false);
		
		if (isRetroMode) {
		
			holder.addChild(bitmap);
		}

		// show a loading message while 3D models are loaded
		loadingMessage = new Bitmap(Assets.getBitmapData("assets/loading_message.png"));
		loadingMessage.x = Std.int((Main.maxWidth / 2) - (loadingMessage.width / 2));
        loadingMessage.y = Std.int((Main.maxHeight / 2) - (loadingMessage.height / 2));
        addChild(loadingMessage);

		// add touch controls
		controller = new TouchController(stage);
		holder.addChild(controller);

		// create HUD
		hud = new HUD();
		hud.addEventListener("pause", pause, false, 0, true);
		hud.addEventListener("resume", resume, false, 0, true);
		hud.addEventListener("quit", quit, false, 0, true);
		hud.addEventListener("restart", restart, false, 0, true);
		holder.addChild(hud);

		// load 3D models
		// first setup url maps for textures in the DAE files
		assetLoaderContext = new AssetLoaderContext();
		assetLoaderContext.mapUrlToData("robochef.png", Assets.getBitmapData("assets/robochef.png"));
		assetLoaderContext.mapUrlToData("tree.png", Assets.getBitmapData("assets/tree.png"));
		assetLoaderContext.mapUrlToData("shadow_circle.png", Assets.getBitmapData("assets/shadow_circle.png"));
		assetLoaderContext.mapUrlToData("cone.png", Assets.getBitmapData("assets/cone.png"));
		assetLoaderContext.mapUrlToData("box.png", Assets.getBitmapData("assets/box.png"));

		Asset3DLibrary.enableParser(DAEParser);
		Asset3DLibrary.addEventListener(Asset3DEvent.ASSET_COMPLETE, onAssetComplete);

		// need to load models sequentially
		loadedModels = [];
		modelsToLoad = ["assets/models/robochef.dae", "assets/models/tree.dae", "assets/models/cone.dae", "assets/models/wall.dae", "assets/models/counter.dae", "assets/models/pot.dae", "assets/models/grill.dae", "assets/models/box.dae"];
		meshCounts = [12, 4, 2, 1, 6, 8, 6, 9];

		// some models shouldn't receive shadows
		shadows = [true, false, false, true, true, true, true, true];
		currentModelLoading = -1;
		loadNextModel();
				
		// create audio object
		eventSFXAudio = new Audio();
		eventSFXAudio.setSound("assets/audio/button_click" + "." + Main.audioFormat);
		
		// basic mouse events
		//stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		//stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		//stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		
		// ensure we have focus
		stage.focus = stage;

		// initialize frame loop
		//oldTime = getTimer();
    	isStarted = false;
		previousTime = getTimer() / 1000;
		accumulator = 0;

		stage.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
		
		onResize();
	}

	private function render():Void {
		
		if (isRetroMode) {
		
			view.renderer.queueSnapshot(bitmapData);
		}

		view.render();
	}

	private function loadNextModel():Void {

		loadedModels.push(new ObjectContainer3D());

		meshCount = 0;
		currentModelLoading++;

		if (currentModelLoading < modelsToLoad.length) {

			Asset3DLibrary.loadData(Assets.getBytes(modelsToLoad[currentModelLoading]), assetLoaderContext);
		}
		else {

			onAllModelsLoaded();
		}
	}

	private function onAllModelsLoaded():Void {

		// remove event listener for loading models
		Asset3DLibrary.removeEventListener(Asset3DEvent.ASSET_COMPLETE, onAssetComplete);

		// create the world
		// the world contains everything in the game space
		world = new World(view.scene, lightPicker, shadowMapMethod);
		
		// level
		level = new Level(world, loadedModels, skin, map);
		level.createLevel();
		
		players = new Array<Player>();
		
		// player character
		p1 = new Player(1, cast(loadedModels[0], ObjectContainer3D), view.camera);		
		world.add(p1);
		players.push(p1);

		p1.setLightPicker(lightPicker);
		view.scene.addChild(p1);

		// enemy / boss
		enemy = new Player(2, cast(loadedModels[0], ObjectContainer3D), view.camera);
		world.add(enemy);
		players.push(enemy);

		enemy.setLightPicker(lightPicker);
		view.scene.addChild(enemy);

		//deltaTime = (getTimer() / 1000);
		//oldTime = (getTimer() / 1000);
		
		previousTime = getTimer() / 1000;
		accumulator = 0;
		isStarted = true;

		removeChild(loadingMessage);
		loadingMessage = null;

		reset();

		// transition in
		Actuate.tween(transition, 0.5, { alpha: 0 }).delay(0).onComplete(onTransitionIn).ease(Quad.easeInOut);
	}

	private function onAssetComplete (event:Asset3DEvent) {

		var asset:IAsset = event.asset;

		switch (asset.assetType) {

			case Asset3DType.MESH:

				loadedMesh = cast(asset, Mesh);
				loadedModels[currentModelLoading].addChild(loadedMesh);	
				meshCount++;
				
				if (meshCount >= meshCounts[currentModelLoading]) {

					// model complete!
					loadNextModel();
				}

			case Asset3DType.MATERIAL:
				
				var material:TextureMaterial = cast(asset, TextureMaterial);
				material.ambientColor = 0xffffff;
				material.lightPicker = lightPicker;

				if (shadows[currentModelLoading] == true) {
				
					material.shadowMethod = shadowMapMethod;
				}
		}
	}
	
	private function onTransitionIn():Void {
		
		removeChild(transition);

		// start the day
		startNextDay();
	}
	
	/* Game Functions */

	private function startNextDay():Void {

		reset();

		currentDay++;
		hud.setDay(currentDay);
		
		currentTime = timeLimit;
		hud.setTime(Math.floor(currentTime));

		// set current recipe
		recipe = [];

		for (i in 0...currentRecipe.length) {

			for (ingredient in ingredients) {
			
				if (ingredient.id == currentRecipe[i]) {

					recipe[i] = ingredient.image;		
					break;
				}
			}			
		}

		// reset reviews
		reviews = [];

		// no reviews on first day
		if (/*currentDay > 1*/currentRecipe.length != 0) {

			var targetSalt:Int = 0;
			var targetSweet:Int = 0;
			var targetSpicy:Int = 0;
			var targetSour:Int = 0;

			var currentSalt:Int = 0;
			var currentSweet:Int = 0;
			var currentSpicy:Int = 0;
			var currentSour:Int = 0;

			var diffSalt:Int = 0;
			var diffSweet:Int = 0;
			var diffSpicy:Int = 0;
			var diffSour:Int = 0;			

			// compare current recipe with target
			for (i in 0...targetRecipe.length) {

				for (ingredient in ingredients) {
			
					if (ingredient.id == targetRecipe[i]) {

						targetSalt += ingredient.salt;
						targetSweet += ingredient.sweet;
						targetSpicy += ingredient.spicy;
						targetSour += ingredient.sour;
						break;
					}
				}
			}

			for (i in 0...currentRecipe.length) {

				for (ingredient in ingredients) {
			
					if (ingredient.id == currentRecipe[i]) {

						currentSalt += ingredient.salt;
						currentSweet += ingredient.sweet;
						currentSpicy += ingredient.spicy;
						currentSour += ingredient.sour;
						break;
					}
				}
			}

			diffSalt = currentSalt - targetSalt;
			diffSweet = currentSweet - targetSweet;
			diffSpicy = currentSpicy - targetSpicy;
			diffSour = currentSour - targetSour;

			if (diffSalt != 0) {

				var reviewSalt:String = diffSalt > 0 ? "TOO SALTY" : "NOT SALTY ENOUGH";
				reviewSalt += " (" + diffSalt + ")";

				reviews.push(reviewSalt);
			}

			if (diffSweet != 0) {

				var reviewSweet:String = diffSweet > 0 ? "TOO SWEET" : "NOT SWEET ENOUGH";
				reviewSweet += " (" + diffSweet + ")";

				reviews.push(reviewSweet);
			}

			if (diffSpicy != 0) {

				var reviewSpicy:String = diffSpicy > 0 ? "TOO SPICY" : "NOT SPICY ENOUGH";
				reviewSpicy += " (" + diffSpicy + ")";

				reviews.push(reviewSpicy);
			}

			if (diffSour != 0) {

				var reviewSour:String = diffSour > 0 ? "TOO SOUR" : "NOT SOUR ENOUGH";
				reviewSour += " (" + diffSour + ")";

				reviews.push(reviewSour);
			}

			hud.showReviewsPanel(reviews);
		}

		hud.showRecipePanel(recipe);
	}

	private function endDay():Void {

		startNextDay();
	}

	private function startEnemyRoutine():Void {

		Actuate.timer(5).onComplete(function() {
		
				enemy.moveToPosition(Main.TILE_SIZE * 6, Main.TILE_SIZE * -13, function() {

					Actuate.timer(3).onComplete(function() {

						enemy.moveToPosition(Main.TILE_SIZE * 8, Main.TILE_SIZE * -13, function() {

							Actuate.timer(3).onComplete(function() {

								enemy.moveToPosition(Main.TILE_SIZE * 8, Main.TILE_SIZE * -10, function() {

									Actuate.timer(3).onComplete(function() {

										enemy.moveToPosition(Main.TILE_SIZE * 6, Main.TILE_SIZE * -10, function() {
		
											startEnemyRoutine();
										});
									});
								});
							});
						});
					});
				});
			}
		);
	}

	private function onEnemyMoveComplete():Void {

		
	}

	private function reset():Void {

		p1.x = Main.TILE_SIZE * 9;
		p1.z = Main.TILE_SIZE * -12;

		enemy.x = Main.TILE_SIZE * 6;
		enemy.z = Main.TILE_SIZE * -10;
		enemy.setMaxSpeed(0.3);
		enemy.setRotation(0, 1);

		startEnemyRoutine();

		// initial camera position
		view.camera.x = p1.x;
		view.camera.y = 400;
		view.camera.z = p1.z - 400;
		view.camera.lookAt(new Vector3D(p1.x, p1.z, 0));
	}

	private function start():Void {

		hud.enableButtons();
	}
	
	private function pause(event:Event = null):Void {
		
		isRunning = false;
	}
	
	private function resume(event:Event = null):Void {
		
		isRunning = true;
	}
	
	public function restart(event:Event = null):Void {
		
		hud.pauseMenu.visible = false;
		
		// reset race //
		
		stage.focus = stage;
		isRunning = true;
	}

	private function quit(event:Event = null):Void {
		
		if (!isQuitting) {
		
			isQuitting = true;

			addChild(transition);
			Actuate.tween(transition, 0.5, { alpha: 1 }).delay(0).onComplete(onTransitionOut).ease(Quad.easeInOut);
		}
	}
	
	private function onTransitionOut():Void {
		
		dispatchEvent(new Event("quit"));
	}
	
	private function onPauseKeyPressed(isDev:Bool = false):Void {
		
		if (isRunning) {
			
			pause();
			hud.pauseMenu.show();
		}
		else {
			
			resume();
			hud.pauseMenu.hide();
		}
	}

	private function onAPressed(event:Event):Void {
		
		if (isRunning) {
			
			// not holding anything?
			if (p1.holding == null) { 
				
				// ingredients 1 - 10
				if (currentHotspot > 0 && currentHotspot <= 10) {

					p1.collectIngredient(ingredients[currentHotspot - 1]);
				}
			}
			// try to drop the thing being held
			else {

				// ingredients 1 - 10
				if (currentHotspot > 10) {

					// can drop here?
					// 11 is the pot (make sure pot is not full)
					if (currentHotspot == 11 && potContents.length < 8) {
				
						var id:Int = p1.holding.id;
						p1.dropIngredient();

						potContents.push(id);
						trace(potContents);

						// completed new recipe
						if (potContents.length >= currentRecipe.length) {

							currentRecipe = [];

							for (i in 0...potContents.length) {

								currentRecipe.push(potContents[i]);
							}

							potContents = [];
							endDay();
						}
					}
				}
			}
		}
	}
	
	private function onBPressed(event:Event):Void {
		
		if (isRunning) {
			
			
		}
	}
	
	private function onMouseDown(event:MouseEvent):Void {
		
	}
	
	private function onMouseMove(event:MouseEvent):Void {
		
	}
	
	private function onMouseUp(event:MouseEvent):Void {
		
	}

	private function updateInput():Void {
		
		p1.isLeft = false;
		p1.isRight = false;

		if (input.keyDown("left")) {
			
			p1.isLeft = true;
		}
		else if (input.keyDown("right")) {
			
			p1.isRight = true;
		}
		
		p1.isUp = false;
		p1.isDown = false;

        if (input.keyDown("up")) {
			
			p1.isUp = true;	
		}
		else if (input.keyDown("down")) {
			
			p1.isDown = true;
		}
		
		if (input.keyDown("a")) {

			//isShooting = true;
		}
		else {

			//isShooting = false;
		}

		if (input.keyDown("b")) {

			//isThrusting = true;
		}
		else {

			//isThrusting = false;
		}
	}

	public function onResize(event:Event = null):Void {

		hud.onResize();

		if (isRetroMode) {
		
			// resize 3D view area
			view.width = Main.maxWidth;
        	view.height = Main.maxHeight;

        	view.x = ((Main.maxWidth / 2)) - (view.width / 2);
			view.y = 1000;

			bitmap.x = ((Main.maxWidth / 2)) - (bitmap.width / 2);
			bitmap.y = ((Main.maxHeight / 2)) - (bitmap.height / 2);
		}
		else {

			// resize 3D view area
			view.width = Main.maxWidth * 1.001;	// <-- this is weird and I don't understand it
        	view.height = Main.maxHeight * 1.001; // <- but i need to multiply by something for it to work properly

        	view.x = (Main.maxWidth / 2) - (view.width / 2);
			view.y = (Main.maxHeight / 2) - (view.height / 2);
		}
    }

	/**
	* Hide / show events
	*/
	public function onActivate(event:Event = null):Void {

		
    }

	public function onDeactivate(event:Event = null):Void {

		// show pause menu if no other menu is active
		if (!hud.completeMessage.visible &&	!hud.failedMessage.visible) {

			hud.pauseMenu.show();
		}

		pause();
    }
	
	public function cleanUp():Void {
		
		// clear update loop
		stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame, false);

		// clean up the input manager
		input.cleanUp();
		input.removeEventListener("pause_key_pressed", onPauseKeyPressed);
		input.removeEventListener("a_pressed", onAPressed);
		input.removeEventListener("b_pressed", onBPressed);
		input = null;
		
		// remove lighting
		lightPicker.dispose();
		lightPicker = null;
		
		shadowMapMethod.dispose();
		shadowMapMethod = null;
		
		mainLight.dispose();
		view.scene.removeChild(mainLight);
		
		// dispose the 3D view
		holder.removeChild(view);
		view.dispose();
		view = null;
		
		// dispose the bitmap view
		holder.removeChild(bitmap);
		bitmap = null;
		bitmapData.dispose();
		bitmapData = null;
		
		// create HUD
		hud.removeEventListener("pause", pause);
		hud.removeEventListener("resume", resume);
		hud.removeEventListener("quit", quit);
		hud.removeEventListener("restart", restart);
		holder.removeChild(hud);
		hud.cleanUp();
				
		// clean up any audio
		if (eventSFXAudio != null) {
			
			eventSFXAudio.cleanUp();
			eventSFXAudio = null;
		}
		
		// clean up the game
		removeChild(holder);
		holder = null;		
	}

	private function onEnterFrame(event:Event):Void {

		if (isStarted) {
			
			/*
			deltaTime = (getTimer() / 1000) - oldTime;
			oldTime = (getTimer() / 1000);
			accumulator += deltaTime;
			
			while (accumulator > 1.0 / 61.0) {
			
				// update 
				update();
				accumulator -= (1.0 / 59.0);
			}
			*/

			var currentTime:Float = getTimer() / 1000;
        	var elapsedTime:Float = currentTime - previousTime;
        	previousTime = currentTime;
        
        	accumulator += elapsedTime;
	
        	while (accumulator >= upperTimeStep) {
	        
				update(elapsedTime);
            	accumulator -= lowerTimeStep;

				if (accumulator < 0) {
					
					accumulator = 0;
				}
        	}

			// render
			render();
		}
	}

	/* Game Loop */

	private function update(dt:Float):Void {
		
		if (isRunning && !isQuitting) {

			if (currentTime > 0) {
			
				//currentTime -= dt;

				if (currentTime <= 0) {

					endDay();
				}
			}
			else {

				currentTime = 0;
			}

			hud.setTime(Math.floor(currentTime));

			updateInput();

			// update world objects
			world.update();

			for (player in players) {
				
				player.update();

				// basic collisions with obstacles
				for (object in world.obstacles) {

					if (object.collisionType == "circle") {

						if (Collisions.sphereCollision(player.x, player.y, player.z, player.radius, object.x, object.y, object.z, object.cRadius)) {
							
							var cd:Vector2D = new Vector2D(object.x - player.x, object.z - player.z);
							cd.normalize();
						}
					}

					else if (object.collisionType == "aabb") {

						if (Collisions.isAABBCollision(player.x, player.z, player.radius * 2, player.radius * 2, object.x, object.z, object.cWidth, object.cHeight)) {
							
							var cd:Vector2D = Collisions.AABBCollision(player.x, player.z, player.radius * 2, player.radius * 2, object.x, object.z, object.cWidth, object.cHeight);
							
							player.x += (cd.x * 1.1);
							player.z += (cd.y * 1.1);
						}
					}
				}

				// just for player
				if (player == p1) {

					// collisions with interactive hotspots (e.g ingredients)
					hud.hideIngredientPanel();
					hud.hideReviewsPanel();
					//hud.hideRecipePanel();

					currentHotspot = 0;

					for (hotspot in world.hotspots) {

						// for hotspots use a smaller player radius to avoid overlaps
						if (Collisions.sphereCollision(player.x, player.y, player.z, player.radius / 2, hotspot.x, hotspot.y, hotspot.z, hotspot.cRadius)) {
							
							currentHotspot = hotspot.objectID;

							if (currentHotspot <= 10) {
							
								hud.showIngredientPanel(ingredients[hotspot.objectID - 1]);
							}
							else if (currentHotspot == 12) {

								// show recipe
								hud.showReviewsPanel(reviews);
							}
							else if (currentHotspot == 13) {

								// show reviews
								//hud.showRecipePanel(recipe);
							}
						}
					}
				}

				// collisions with moveable obstacles (e.g cones)
				for (cone in world.cones) {

					if (Collisions.sphereCollision(player.x, player.y, player.z, player.radius, cone.x, cone.y, cone.z, cone.cRadius)) {
							
						var cd:Vector2D = new Vector2D(cone.x - player.x, cone.z - player.z);
						cd.normalize();
							
						cone.vel.x += (cd.x * 1);
						cone.vel.y -= (cd.y * 1);
					}
				}
				
				if (player == p1) {

					for (otherPlayer in players) {
						
						if (otherPlayer != player) {
							
							if (Collisions.isAABBCollision(player.x, player.z, player.radius * 2, player.radius * 2, otherPlayer.x, otherPlayer.z, otherPlayer.radius * 2, otherPlayer.radius * 2)) {
							
								var cd:Vector2D = Collisions.AABBCollision(player.x, player.z, player.radius * 2, player.radius * 2, otherPlayer.x, otherPlayer.z, otherPlayer.radius * 2, otherPlayer.radius * 2);
								
								player.x += (cd.x * 1.1);
								player.z += (cd.y * 1.1);
							}
						}
					}
				}
			}

			view.camera.x = p1.x;
			view.camera.y = 150 * zoom;
			view.camera.z = p1.z - (150 * zoom);
			view.camera.lookAt(new Vector3D(p1.x, p1.z, 0));
		}
	}
}