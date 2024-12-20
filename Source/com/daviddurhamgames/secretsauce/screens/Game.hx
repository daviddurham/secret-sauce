package com.daviddurhamgames.secretsauce.screens;

import motion.easing.Linear;
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
import com.piratejuice.BitmapText;
import com.piratejuice.vfx.Confetti;

import away3d.containers.*;
import away3d.entities.*;
import away3d.materials.*;
import away3d.materials.methods.ShadowMapMethodBase;
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
	private var isRetroMode:Bool = false;//true;

	private var isIntro:Bool = true;
	private var isTutorial:Bool = false;
	private var isComplete:Bool = false;
	
	// update loop
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
	private var loadingMessage:BitmapText;

	// transition
	private var transition:Shape;

	// HUD includes pause button/panel and scores
	private var hud:HUD;
	
	private var objects:Array<GameObject>;
	
	// background music
	private var bgm1:Audio;
	private var bgm2:Audio;
	
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
	
	// ingredient objects in the scene
	private var ingredientObjects:Array<GameObject> = [];
	
	// player
	private var p1:Player;
	
	// boss chef
	private var enemy:Player;

	// all characters
	private var players:Array<Player>;

	// for debug only
	private var detectionCircle:Mesh;

	// current ingredient the player is next to
	private var currentHotspot = 0;
	private var hotspotObject:GameObject = null;

	// game timer (may not use time limit after all)
	private var timeLimit:Int = 90;
	private var currentTime:Float = 0;

	// keyboard input manager
	private var input:InputManager;

	// for 'retro' mode
	private var bitmapData:BitmapData;
	private var bitmap:Bitmap;

	// camera zoom  multiplier
	private var zoom:Int = 1;
	private var cameraPosition:Vector2D;
	private var cameraMovement:Vector2D;

	// level map
	private var map:Array<Array<Int>> = [	[2, 2, 1, 2, 2, 1, 2, 2, 1, 1, 2, 1, 2, 2, 2, 1, 2 ],
											[2, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 2, 2 ],
											[2, 1, 2, 2, 7, 7, 7, 7, 7, 7, 7, 7, 7, 2, 2, 1, 2 ],
											[2, 1, 1, 2, 7, 0,11,12, 0,13,14, 0, 7, 2, 2, 1, 2 ],
											[2, 2, 1, 2, 7, 0, 0, 0, 0, 0, 0, 0, 7, 2, 1, 2, 2 ],
											[2, 1, 2, 2, 7, 0,15,16, 0,17,18, 0, 7, 2, 2, 2, 2 ],
											[2, 2, 1, 2, 7, 0, 0, 0, 0, 0, 0, 0, 7, 2, 1, 2, 2 ],
											[2, 1, 2, 2, 7, 0, 0, 0, 0, 0, 0, 0, 7, 2, 2, 1, 2 ],
											[2, 1, 1, 2, 7, 7,22, 7,24, 0, 7, 7, 7, 2, 2, 1, 2 ],
											[2, 1, 1, 2, 7,26, 8,10,10, 0, 6, 5, 7, 2, 1, 1, 2 ],
											[2, 1, 2, 2, 7, 8, 0, 0, 0, 0, 0, 0, 7, 2, 1, 2, 2 ],
											[2, 1, 2, 2, 7,27, 0, 0, 0, 0, 0, 0, 7, 2, 2, 2, 2 ],
											[2, 1, 1, 2, 7, 8, 0, 0, 0, 0, 0, 8, 7, 3, 3, 3, 3 ],
											[2, 1, 1, 2, 7, 8, 0, 0, 0, 0, 0, 8, 7, 3, 3, 3, 3 ],
											[2, 2, 1, 2, 7, 8, 0, 0, 0, 0, 0, 8, 7, 3, 3, 3, 3 ],
											[2, 1, 2, 2, 7, 7, 7,25,23, 7, 7, 7, 7, 2, 2, 2, 2 ],
											[2, 1, 1, 2, 7, 8, 8, 0,21, 9, 7, 2, 2, 2, 1, 1, 2 ],
											[2, 1, 2, 2, 7, 8, 0, 0, 0, 0, 7, 2, 1, 1, 2, 2, 2 ],
											[2, 1, 1, 2, 7, 8, 0, 0, 0, 0, 7, 2, 2, 1, 1, 2, 2 ],
											[2, 2, 1, 2, 7, 8, 0, 0, 0, 0, 7, 2, 1, 2, 2, 1, 2 ],
											[2, 1, 1, 2, 7, 7, 7, 7, 7, 7, 7, 2, 2, 2, 1, 1, 2 ],
											[2, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 2 ],
											[2, 1, 1, 1, 2, 2, 1, 1, 2, 1, 2, 1, 1, 1, 1, 1, 2 ]	];

	private var ingredients:Array<Ingredient> = [

		new Ingredient(1, "white", 	3, 0, 1, 0, "assets/ingredient_1.png"),
		new Ingredient(2, "blue",	2, 0, 0, 1, "assets/ingredient_2.png"),

		new Ingredient(3, "pink", 	0, 3, 0, 1, "assets/ingredient_3.png"),
		new Ingredient(4, "brown",	1, 2, 0, 0, "assets/ingredient_4.png"),
		
		new Ingredient(5, "red", 	0, 1, 3, 0, "assets/ingredient_5.png"),
		new Ingredient(6, "orange",	1, 0, 2, 0, "assets/ingredient_6.png"),
		
		new Ingredient(7, "green", 	0, 0, 1, 3, "assets/ingredient_7.png"),
		new Ingredient(8, "purple",	0, 1, 0, 2, "assets/ingredient_8.png")
	];

	// tweak this for difficulty?
	private var recipeLength:Int = 3;

	// TODO: generate a target secret recipe each time
	// the ingredients don't have to match - just the flavour levels
	private var targetRecipe:Array<Int> = [ 1, 3, 6 ];

	// TODO: randomize starting recipe each time
	private var currentRecipe:Array<Int> = [ 2, 1, 7 ];
	private var potContents:Array<Int> = [];

	// how many turns the player has taken
	private var currentDay:Int = 0;

	// flag when a sauce (any sauce) has been made and day ends
	private var isSauceMade:Bool = false;

	// pot must be emptied first
	private var isPotReady:Bool = false;

	// current review and recipe strings (sent to HUD)
	private var reviews:Array<String> = [];
	private var reviewStats:Array<Int> = [];
	private var recipe:Array<String> = [];

	private var confetti:Confetti;

	public function new(mode:String = "new") {
		
		super();

		isTutorial = Main.isTutorial;
		Main.isTutorial = false;

		if (mode == "continue") {

			var progress:String = Main.savedData.load("progress");
			var progressArray:Array<String> = progress.split(",");
			
			currentDay = Std.parseInt(progressArray[0]);

			for (i in 0...3) {

				targetRecipe[i] = Std.parseInt(progressArray[1 + i]);
				currentRecipe[i] = Std.parseInt(progressArray[4 + i]);
			}
		}
		else {

			// set the target and starting recipes
			for (i in 0...3) {

				// making it totally random for now
				// ...but maybe that's not good enough?
				targetRecipe[i] = Math.floor(Math.random() * 8) + 1;
				currentRecipe[i] = Math.floor(Math.random() * 8) + 1;
			}
		}
		
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
		input.addKey("pause", 80);
		
		// on key events
		input.onKey("a", "a_pressed");
		input.addEventListener("a_pressed", onAPressed, false, 0, true);
		
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
		view.height = Main.maxHeight;
        view.width = Main.maxWidth;
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
		loadingMessage = new BitmapText(440, 64, "assets/font_1.png");
		loadingMessage.printText("LOADING");
		loadingMessage.x = (Main.maxWidth / 2) - 100;
        loadingMessage.y = (Main.maxHeight / 2) - 16;
        loadingMessage.scaleX = loadingMessage.scaleY = 0.5;
        addChild(loadingMessage);

		// add touch controls
		controller = new TouchController(stage);
		holder.addChild(controller);

		// create HUD
		hud = new HUD();
		hud.addEventListener("pause", pause, false, 0, true);
		hud.addEventListener("resume", resume, false, 0, true);
		hud.addEventListener("quit", quit, false, 0, true);
		holder.addChild(hud);

		// load 3D models
		// first setup url maps for textures in the DAE files
		assetLoaderContext = new AssetLoaderContext();
		assetLoaderContext.mapUrlToData("robochef.png", Assets.getBitmapData("assets/robochef.png"));
		assetLoaderContext.mapUrlToData("tree.png", Assets.getBitmapData("assets/tree.png"));
		assetLoaderContext.mapUrlToData("shadow_circle.png", Assets.getBitmapData("assets/shadow_circle.png"));
		assetLoaderContext.mapUrlToData("cone.png", Assets.getBitmapData("assets/cone.png"));
		assetLoaderContext.mapUrlToData("box.png", Assets.getBitmapData("assets/box.png"));
		assetLoaderContext.mapUrlToData("sign_1.png", Assets.getBitmapData("assets/sign_1.png"));
		assetLoaderContext.mapUrlToData("sign_2.png", Assets.getBitmapData("assets/sign_2.png"));
		assetLoaderContext.mapUrlToData("fruits.png", Assets.getBitmapData("assets/fruits.png"));
		assetLoaderContext.mapUrlToData("burger.png", Assets.getBitmapData("assets/burger.png"));
		assetLoaderContext.mapUrlToData("review_screen.png", Assets.getBitmapData("assets/review_screen.png"));

		Asset3DLibrary.enableParser(DAEParser);
		Asset3DLibrary.addEventListener(Asset3DEvent.ASSET_COMPLETE, onAssetComplete);

		// need to load models sequentially
		loadedModels = [];
		modelsToLoad = [	"assets/models/robochef.dae",
							"assets/models/tree.dae",
							"assets/models/cone.dae",
							"assets/models/wall.dae",
							"assets/models/counter.dae",
							"assets/models/pot.dae",
							"assets/models/grill.dae",
							"assets/models/box.dae",
							"assets/models/terminal.dae",
							"assets/models/sink.dae",
							"assets/models/wall_alt1.dae",
							"assets/models/wall_alt2.dae",
							"assets/models/wall_alt3.dae",
						
							"assets/models/ingredients/white.dae",
							"assets/models/ingredients/blue.dae",
							"assets/models/ingredients/pink.dae",
							"assets/models/ingredients/brown.dae",
							"assets/models/ingredients/red.dae",
							"assets/models/ingredients/orange.dae",
							"assets/models/ingredients/green.dae",
							"assets/models/ingredients/purple.dae",

							"assets/models/sauce.dae",
							"assets/models/pattys.dae",
							"assets/models/buns.dae",
						];

		meshCounts = [	12, 4, 2, 1, 6, 8, 6, 9, 8, 9, 3, 3, 3,
						1, 1, 1, 1, 1, 1, 1, 1,
						1, 10, 9
					 ];

		// some models shouldn't receive shadows
		shadows = [ true, false, false, true, true, true, true, true, true, true, true, true, true,
					true, true, true, true, true, true, true, true,
					true, true, true];

		currentModelLoading = -1;
		loadNextModel();
				
		// create audio object
		eventSFXAudio = new Audio("assets/audio/" + Main.audioFormat + "/button_2" + "." + Main.audioFormat);
		eventSFXAudio.setVolume(Main.sfxVolume);

		bgm1 = new Audio("assets/audio/" + Main.audioFormat + "/not_holding" + "." + Main.audioFormat, -1);
		bgm1.setVolume(Main.musicVolume);

		bgm2 = new Audio("assets/audio/" + Main.audioFormat + "/holding" + "." + Main.audioFormat, -1);
		bgm2.setVolume(Main.musicVolume);
		
		// create confetti
		confetti = new Confetti(50, Main.maxWidth, Main.maxHeight, 1);
		holder.addChild(confetti);

		cameraPosition = new Vector2D();
		cameraMovement = new Vector2D();

		// ensure we have focus
		stage.focus = stage;

		// initialize frame loop
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

		// animate blocked entry indicator
		Actuate.tween(world.wall.material, 1, { alpha: 0.25 }).repeat().reflect().ease(Linear.easeNone);
		
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

		// ingredients
		for (i in 0...8) {

			var ingredient:GameObject = new GameObject(name, cast(loadedModels[13 + i].clone(), ObjectContainer3D));
			//ingredient.x = Main.TILE_SIZE * 9;
			ingredient.y = 10;
			//ingredient.z = Main.TILE_SIZE * -12;		
			ingredient.rotationY = 90;
			ingredient.scaleX = ingredient.scaleY = ingredient.scaleZ = 4;
			ingredient.visible = false;
			world.add(ingredient);
			
			ingredientObjects.push(ingredient);
		}

		/*
		var mat = new ColorMaterial(0xff00ff);
		mat.bothSides = true;
		detectionCircle = new Mesh(new CylinderGeometry(enemy.detectionRadius, enemy.detectionRadius, 2, 16, 1, false, false), mat);
		world.level.addChild(detectionCircle);
		*/
		enemy.setLightPicker(lightPicker);
		view.scene.addChild(enemy);
		
		previousTime = getTimer() / 1000;
		accumulator = 0;
		isStarted = true;

		removeChild(loadingMessage);
		loadingMessage = null;

		reset();

		bgm1.play();

		bgm2.setVolume(0);
		bgm2.play();

		startNextDay();

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
		//startNextDay();
	}
	
	private function checkRecipesMatch():Bool {

		var targetSalt:Int = 0;
		var targetSweet:Int = 0;
		var targetSpicy:Int = 0;
		var targetSour:Int = 0;

		var currentSalt:Int = 0;
		var currentSweet:Int = 0;
		var currentSpicy:Int = 0;
		var currentSour:Int = 0;	

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

		if (currentSalt - targetSalt == 0 && 
			currentSweet - targetSweet == 0 &&
			currentSpicy - targetSpicy == 0 &&
			currentSour - targetSour == 0) {

			return true;
		}

		return false;
	}

	private function startNextDay():Void {

		var progress:String = currentDay + "," + targetRecipe[0] + "," + targetRecipe[1] + "," + targetRecipe[2] + "," + currentRecipe[0] + "," + currentRecipe[1] + "," + currentRecipe[2];
		Main.savedData.save("progress", progress);

		reset();

		bgm1.setVolume(Main.musicVolume);
		bgm2.setVolume(0);

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
		reviewStats = [];

		// no reviews on first day
		if (currentRecipe.length != 0) {

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
				//reviewSalt += " " + diffSalt;

				reviews.push(reviewSalt);
				reviewStats.push(diffSalt);
			}

			if (diffSweet != 0) {

				var reviewSweet:String = diffSweet > 0 ? "TOO SWEET" : "NOT SWEET ENOUGH";
				//reviewSweet += " " + diffSweet;

				reviews.push(reviewSweet);
				reviewStats.push(diffSweet);
			}

			if (diffSpicy != 0) {

				var reviewSpicy:String = diffSpicy > 0 ? "TOO SPICY" : "NOT SPICY ENOUGH";
				//reviewSpicy += " " + diffSpicy;

				reviews.push(reviewSpicy);
				reviewStats.push(diffSpicy);
			}

			if (diffSour != 0) {

				var reviewSour:String = diffSour > 0 ? "TOO SOUR" : "NOT SOUR ENOUGH";
				//reviewSour += " " + diffSour;

				reviews.push(reviewSour);
				reviewStats.push(diffSour);
			}

			hud.showReviewsPanel(reviews, reviewStats);
		}

		hud.showRecipePanel(recipe);
	}

	private function endDay():Void {

		startNextDay();
	}

	private function startEnemyEntrance():Void {

		enemy.moveToPosition(Main.TILE_SIZE * 7, Main.TILE_SIZE * -10, function() {

			Actuate.timer(3).onComplete(function() {

				enemy.moveToPosition(Main.TILE_SIZE * 6, Main.TILE_SIZE * -10, function() {

					Actuate.timer(3).onComplete(function() {

						startEnemyRoutine();
					});
				});
			});
		});
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

	private function reset():Void {

		isPotReady = false;
		isIntro = true;

		world.wall.visible = false;
		world.sauce.visible = true;

		p1.x = Main.TILE_SIZE * 9;
		p1.z = Main.TILE_SIZE * -12;

		enemy.x = Main.TILE_SIZE * 7;
		enemy.z = Main.TILE_SIZE * -14.5;
		enemy.setMaxSpeed(0.3);
		enemy.setRotation(0, 1);

		// initial enemy movement
		startEnemyEntrance();

		// initial camera position		
		view.camera.x = p1.x;
		view.camera.y = 150 * zoom;
		view.camera.z = enemy.z - (150 * zoom);
		view.camera.lookAt(new Vector3D(p1.x, p1.z, 0));

		hud.hideSauceMadePanel(true);
		hud.hideGameCompletePanel(true);
		hud.enableButtons();
	}

	private function start():Void {

		hud.enableButtons();
	}
	
	private function pause(event:Event = null):Void {
		
		isRunning = false;

		bgm1.stop();
		bgm2.stop();
	}
	
	private function resume(event:Event = null):Void {
		
		isRunning = true;

		bgm1.play();
		bgm2.play();
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
		
		if (isRunning && !isIntro && !isComplete) {
			
			// not holding anything?
			if (p1.holding == null) { 
				
				// ingredients 1 - 10
				if (currentHotspot > 0 && currentHotspot <= 10) {

					var obj:GameObject = ingredientObjects[currentHotspot - 1];
					var ing:Ingredient = ingredients[currentHotspot - 1];

					obj.x = hotspotObject.x;
					obj.y = 10;
					obj.z = hotspotObject.z;

					obj.scaleX = 1;
					obj.scaleY = 1;
					obj.scaleZ = 1;

					obj.rotationY = -90;
					obj.visible = true;

					p1.holding = ing;

					eventSFXAudio.setSound("assets/audio/" + Main.audioFormat + "/pop1" + "." + Main.audioFormat);
					eventSFXAudio.play();

					// y is tweened to 10 x 1.1 because 1.1 is the scale of the player model
					Actuate.tween(obj, 0.25, {x: p1.x, y: 10 * 1.1, z: p1.z, scaleX: 4, scaleY: 4, scaleZ: 4}).onComplete(function() {
					
						p1.collectIngredient(ing, obj);
						bgm1.setVolume(0);
						bgm2.setVolume(Main.musicVolume);

						if (isTutorial) {
						
							if (hud.getTutorialStep() == 3) {

								hud.showTutorial(4);
							}
							else if (hud.getTutorialStep() == 5) {

								hud.hideTutorial();
								hud.setTutorialStep(6);
							}
						}	
					});
				}
				// empty pot
				else if (currentHotspot == 11 && !isPotReady) {
					
					if (isTutorial) {
					
						if (hud.getTutorialStep() == 1) {

							hud.showTutorial(2);
						}
					}

					world.sauce.visible = false;

					eventSFXAudio.setSound("assets/audio/" + Main.audioFormat + "/empty1" + "." + Main.audioFormat);
					eventSFXAudio.play();
					isPotReady = true;
				}
			}
			// try to drop the thing being held
			else {

				// put it back (ingredients 1 - 10)
				if (currentHotspot > 0 && currentHotspot <= 10) {

					if (currentHotspot == p1.holding.id) {

						world.level.addChild(p1.holdingObject);
						p1.holdingObject.scaleX = 4;
						p1.holdingObject.scaleY = 4;
						p1.holdingObject.scaleZ = 4;
						p1.holdingObject.x = p1.x;
						p1.holdingObject.y = 10;
						p1.holdingObject.z = p1.z;

						var id:Int = p1.holding.id;
						var obj:GameObject = p1.holdingObject;
						p1.dropIngredient();

						eventSFXAudio.setSound("assets/audio/" + Main.audioFormat + "/stash" + "." + Main.audioFormat);
						eventSFXAudio.play();

						Actuate.tween(obj, 0.25, {x: hotspotObject.x, y: 10, z: hotspotObject.z, scaleX: 1, scaleY: 1, scaleZ: 1}).onComplete(function() {

							p1.holdingObject.visible = false;
						});
					}
				}

				// pot
				else if (currentHotspot > 10) {

					// can drop here?
					// 11 is the pot (make sure pot is not full)
					if (currentHotspot == 11 && potContents.length < 8 && isPotReady) {

						world.level.addChild(p1.holdingObject);
						p1.holdingObject.scaleX = 4;
						p1.holdingObject.scaleY = 4;
						p1.holdingObject.scaleZ = 4;
						p1.holdingObject.x = p1.x;
						p1.holdingObject.y = 10;
						p1.holdingObject.z = p1.z;

						var id:Int = p1.holding.id;
						var obj:GameObject = p1.holdingObject;
						p1.dropIngredient();

						eventSFXAudio.setSound("assets/audio/" + Main.audioFormat + "/drop3" + "." + Main.audioFormat);
						eventSFXAudio.play();

						Actuate.tween(obj, 0.25, {x: hotspotObject.x, y: 10, z: hotspotObject.z, scaleX: 1, scaleY: 1, scaleZ: 1}).onComplete(function() {

							world.sauce.visible = true;

							bgm1.setVolume(Main.musicVolume);
							bgm2.setVolume(0);						

							potContents.push(id);

							if (isTutorial) {
							
								if (hud.getTutorialStep() == 4) {

									hud.showTutorial(5);
								}
							}

							// completed new recipe
							if (potContents.length >= currentRecipe.length) {

								currentRecipe = [];

								for (i in 0...potContents.length) {

									currentRecipe.push(potContents[i]);
								}

								isSauceMade = true;
								hud.hideRecipePanel();

								// game complete
								if (checkRecipesMatch() == true) {

									// reset progress
									Main.savedData.save("progress", "0");

									hud.showGameCompletePanel();
									confetti.start();
									isComplete = true;
								}
								// next day
								else {

									hud.showSauceMadePanel();

									Actuate.timer(3).onComplete(function() {

										potContents = [];
										endDay();
									});
								}
							}	
						});
					}
				}
			}
		}
	}

	private function updateInput():Void {
		
		if (!isIntro && !isComplete) {

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

			}
			else {

			}
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
		if (!hud.sauceMadePanel.visible && !hud.gameCompletePanel.visible) {

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
		input = null;
		
		// remove lighting
		lightPicker.dispose();
		lightPicker = null;
		
		shadowMapMethod.dispose();
		shadowMapMethod = null;
		
		view.scene.removeChild(mainLight);
		mainLight.dispose();
		
		// dispose the 3D view
		holder.removeChild(view);
		//view.dispose();	// <-- this is throwing an error?
		view = null;
		
		// dispose the bitmap view
		if (isRetroMode) {
			
			holder.removeChild(bitmap);
		}
		
		bitmap = null;
		bitmapData.dispose();
		bitmapData = null;
		
		// create HUD
		hud.removeEventListener("pause", pause);
		hud.removeEventListener("resume", resume);
		hud.removeEventListener("quit", quit);
		holder.removeChild(hud);
		hud.cleanUp();
				
		// clean up any audio
		if (eventSFXAudio != null) {
			
			eventSFXAudio.cleanUp();
			eventSFXAudio = null;
		}

		if (bgm1 != null) {
			
			bgm1.cleanUp();
			bgm1 = null;
		}

		if (bgm2 != null) {
			
			bgm2.cleanUp();
			bgm2 = null;
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

			confetti.update();

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

			var angleInRadians = (enemy.holder.rotationY + 90) * (Math.PI / 180);
    		var x = enemy.x - enemy.detectionOffset * Math.cos(angleInRadians);
    		var z = enemy.z + enemy.detectionOffset * Math.sin(angleInRadians);

			/*
			detectionCircle.x = x;
			detectionCircle.y = 1;
			detectionCircle.z = z;
			*/

			if (Collisions.circleCollision(p1.x, p1.z, 4, x, z, enemy.detectionRadius) < 0 && p1.holding != null) {

				if (enemy.alertCooldown <= 0) {
				
					eventSFXAudio.setSound("assets/audio/" + Main.audioFormat + "/alert" + "." + Main.audioFormat);
					eventSFXAudio.play();

					// turn on barriers
					for (object in world.obstacles) {

						if (object.objectID == 99) {

							object.objectID = 98;
							world.wall.visible = true;
						}
					}
				}

				enemy.alertCooldown = 5;
				enemy.alert.visible = true;

				enemy.dir.x = enemy.x - p1.x;
				enemy.dir.y = p1.z - enemy.z;
				enemy.dir.normalize();
			}
			else {

				if (enemy.alertCooldown > 0) {
				
					enemy.alertCooldown -= dt;

					if (enemy.alertCooldown <= 0) {
					
						enemy.alert.visible = false;

						// turn off barriers
						for (object in world.obstacles) {

							if (object.objectID == 98) {

								object.objectID = 99;
								world.wall.visible = false;
							}
						}
					}
				}
			}

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

						// not a disabled barrier
						if (object.objectID != 99) {

							if (Collisions.isAABBCollision(player.x, player.z, player.radius * 2, player.radius * 2, object.x, object.z, object.cWidth, object.cHeight)) {
								
								var cd:Vector2D = Collisions.AABBCollision(player.x, player.z, player.radius * 2, player.radius * 2, object.x, object.z, object.cWidth, object.cHeight);
								
								player.x += (cd.x * 1.1);
								player.z += (cd.y * 1.1);
							}
						}
					}
				}

				// just for player
				if (player == p1) {

					// collisions with interactive hotspots (e.g ingredients)
					hud.hideIngredientPanel();
					hud.hideReviewsPanel();

					currentHotspot = 0;

					var prompt:Mesh = null;
					world.hideAllPrompts();

					for (hotspot in world.hotspots) {

						// for hotspots use a smaller player radius to avoid overlaps
						if (Collisions.sphereCollision(player.x, player.y, player.z, player.radius / 2, hotspot.x, hotspot.y, hotspot.z, hotspot.cRadius)) {
							
							currentHotspot = hotspot.objectID;
							hotspotObject = hotspot;

							if (currentHotspot <= 10) {
							
								hud.showIngredientPanel(ingredients[hotspot.objectID - 1]);

								if (p1.holding == null) {

									// prompts are in a weird order and don't have a linking ID
									if (hotspot.objectID == 1) prompt = world.getPrompt(0);
									else if (hotspot.objectID == 2) prompt = world.getPrompt(2);
									else if (hotspot.objectID == 3) prompt = world.getPrompt(4);
									else if (hotspot.objectID == 4) prompt = world.getPrompt(8);
									else if (hotspot.objectID == 5) prompt = world.getPrompt(1);
									else if (hotspot.objectID == 6) prompt = world.getPrompt(3);
									else if (hotspot.objectID == 7) prompt = world.getPrompt(5);
									else if (hotspot.objectID == 8) prompt = world.getPrompt(9);

									if (prompt != null) {

										prompt.visible = true;
									}
								}
							}
							else if (currentHotspot == 11) {

								if (!isPotReady && player.holding == null) {
								
									prompt = world.getPrompt(6);
									prompt.visible = true;
								}
								else if (isPotReady && player.holding != null) {

									prompt = world.getPrompt(7);
									prompt.visible = true;
								}
							}
							else if (currentHotspot == 12) {

								// show reviews
								hud.showReviewsPanel(reviews, reviewStats);

								if (isTutorial) {
								
									if (hud.getTutorialStep() == 2) {

										hud.showTutorial(3);
									}
								}
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

			/*
			if (enemy.alertCooldown > 0) {

				cameraPosition.x = (p1.x + enemy.x) / 2;
				cameraPosition.y = (p1.z + enemy.z) / 2;
			}
			else {
			
				cameraPosition.x = p1.x;
				cameraPosition.y = p1.z;
			}

			cameraMovement.x = (view.camera.x - cameraPosition.x) / 10;
			cameraMovement.y = (view.camera.z - (cameraPosition.y - (150 * zoom))) / 10;

			view.camera.x -= cameraMovement.x;
			view.camera.y = 150 * zoom;
			view.camera.z -= cameraMovement.y;
			view.camera.lookAt(new Vector3D(view.camera.x, (view.camera.z + (150 * zoom)), 0));
			*/
			
			// follow chef in intro
			if (isIntro) {

				cameraPosition.x = p1.x;
				cameraPosition.y = enemy.z;
				
				if (cameraPosition.y >= p1.z) {

					isIntro = false;

					// start tutorial
					if (currentDay == 1 && isTutorial) {

						hud.showTutorial(1);
					}
					else {
					
						isTutorial = false;
					}
				}
			}
			else {

				cameraPosition.x = p1.x;
				cameraPosition.y = p1.z;
			}
			
			view.camera.x = cameraPosition.x;
			view.camera.y = 150 * zoom;
			view.camera.z = cameraPosition.y - (150 * zoom);
		}
	}
}