package com.daviddurhamgames.secretsauce.screens;

import com.piratejuice.Audio;
import com.piratejuice.InputManager;

import openfl.display.*;
import openfl.events.*;
import openfl.Assets;
import openfl.geom.ColorTransform;
import openfl.Lib.getTimer;

import motion.Actuate;
import motion.easing.Quad;
import motion.easing.Linear;

class Home extends Sprite {
	
	// game running flag
	private var isRunning:Bool;
	
	// lock controls when game still running
	private var isControlLocked:Bool;
	
	// pointer flag
	private var isButtonDown:Bool = false;
	
	// hold everything in this
	private var holder:Sprite;

	// game level or 'scene'
	private var scene:Sprite;

	private var title:Bitmap;
	private var image:Bitmap;
	private var credit:Bitmap;
	private var menuBackground:Shape;
	
	private var buttonHolder:Sprite;

    // keyboard input manager
    private var input:InputManager;

    // buttons
    private var buttons:Array<BasicButton>;

	// audio
	private var musicAudio:Audio;
	private var eventSFXAudio:Audio;
	
	// initial menu fade in
	private var fadeIn:Shape;
	
	// main buttons
	private var continueButton:BasicButton;
	private var newGameButton:BasicButton;
	private var optionsButton:BasicButton;

	// menus
	private var optionsMenu:OptionsMenu;
	
	// flag when quit is initiated
	private var isQuitting = false;

	private var accumulator:Float = 0;
    private var previousTime:Float = 0;

	private var upperTimeStep:Float = 1 / 62.0;
	private var lowerTimeStep:Float = 1 / 60.0;

	// whether we should fade in or use the normal transition
	private var isFadeIn:Bool;

	// animated background
	private var background:TileScroller;

	/**
	* Constructor
	*/
	public function new(fade:Bool = false) {
		
		super();

		isFadeIn = fade;
		
		// wait for the game object to be added to the stage
		addEventListener(Event.ADDED_TO_STAGE, init);
	}

	private function init(event:Event) {
		
		removeEventListener(Event.ADDED_TO_STAGE, init);

		// set default game states
		isRunning = true;
		isControlLocked = false;		

		// holder sprite holds *everything*
		holder = new Sprite();
		addChild(holder);

		// scene sprite contains the main graphics
		scene = new Sprite();
		holder.addChild(scene);

		background = new TileScroller("assets/titlescreen_tile.png", 1, 1);
		background.start();
		scene.addChild(background);

		title = new Bitmap(Assets.getBitmapData("assets/title.png"), null, true);
		title.x = Std.int((Main.maxWidth / 2) - (title.width / 2));
        title.y = Std.int((Main.maxHeight / 2) - (title.height / 2) - 240);
        scene.addChild(title);

		image = new Bitmap(Assets.getBitmapData("assets/title_image.png"), null, true);
		image.x = Std.int((Main.maxWidth / 2) - (image.width / 2) - 200);
        image.y = Std.int((Main.maxHeight / 2) - (image.height / 2) + 40);
        scene.addChild(image);

		credit = new Bitmap(Assets.getBitmapData("assets/credit.png"), null, true);
		credit.x = Std.int((Main.maxWidth / 2) - (credit.width / 2));
        credit.y = Std.int((Main.maxHeight - Main.offsetY) - credit.height - 10);
		scene.addChild(credit);

		// background for menus
		menuBackground = new Shape();
		menuBackground.graphics.beginFill(0x000000, 0.5);
		menuBackground.graphics.drawRect(-1000, 0, 2000, -Main.maxHeight);
		menuBackground.graphics.endFill();

		menuBackground.x = Main.maxWidth / 2;
		menuBackground.y = Main.maxHeight;
		menuBackground.visible = false;
		scene.addChild(menuBackground);

		buttonHolder = new Sprite();
		holder.addChild(buttonHolder);

		continueButton = createButton("assets/home_continue_button.png", "assets/home_continue_button_over.png", (Main.maxWidth / 2) + 220, -220, 0.75);
		continueButton.addEventListener(MouseEvent.CLICK, onContinueButtonClicked);

		trace(Main.savedData.load("progress"));
		if (Main.savedData.load("progress") == "0") {

			continueButton.alpha = 0.5;
			continueButton.setEnabled(false);
		}

		newGameButton = createButton("assets/home_newgame_button.png", "assets/home_newgame_button_over.png", (Main.maxWidth / 2) + 220, -100, 0.75);
		newGameButton.addEventListener(MouseEvent.CLICK, onNewGameButtonClicked);

		optionsButton = createButton("assets/home_settings_button.png", "assets/home_settings_button_over.png", (Main.maxWidth / 2) + 220, 20, 0.75);
		optionsButton.addEventListener(MouseEvent.CLICK, onOptionsButtonClicked);

		// menus
		optionsMenu = new OptionsMenu();
		optionsMenu.x = Main.maxWidth / 2;
		optionsMenu.y = Main.maxHeight / 2;
		optionsMenu.addEventListener("toggle_filter", onToggleFilter, false, 0, true);
		optionsMenu.addEventListener("fullscreen", onToggleFullscreen, false, 0, true);
		optionsMenu.addEventListener("music_volume", onMusicVolume, false, 0, true);
		optionsMenu.addEventListener("sfx_volume", onSFXVolume, false, 0, true);
		optionsMenu.addEventListener("back", onOptionsBack, false, 0, true);
		holder.addChild(optionsMenu);

		// create audio objects
		eventSFXAudio = new Audio();
		eventSFXAudio.setVolume(Main.sfxVolume);
		eventSFXAudio.setSound("assets/audio/" + Main.audioFormat + "/button_2" + "." + Main.audioFormat);

		/*
		musicAudio = new Audio();
		musicAudio.setVolume(Main.musicVolume);
		musicAudio.setSound("assets/audio/" + Main.audioFormat + "/menu_loop" + "." + Main.audioFormat);
		musicAudio.play();
		*/

		// keyboard controls
		input = new InputManager(stage);
		input.addKey("left", 37);
		input.addKey("right", 39);
		input.addKey("jump", 32);
		input.addKey("grab", 40);
		input.addKey("enter", 38);
		input.addKey("pause", 80);
		input.addKey("restart", 82);
		
		// alt. keyboard controls
		input.addKey("alt_left", 65);	//a
		input.addKey("alt_right", 68);	//d
		input.addKey("alt_grab", 83);	//s
		input.addKey("alt_enter", 87);	//w
		
		// ensure we have focus
		stage.focus = stage;
		
		// initialize frame loop
		previousTime = getTimer() / 1000;
		accumulator = 0;

		stage.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);

		fadeIn = new Shape();
		fadeIn.x = Main.maxWidth / 2;
		fadeIn.y = Main.maxHeight / 2;
		fadeIn.graphics.beginFill(0x000000);
		fadeIn.graphics.drawRect(-1000, -600, 2000, 1200);
		fadeIn.graphics.endFill();
		holder.addChild(fadeIn);

		Actuate.tween(fadeIn, 0.5, { alpha: 0 }).delay(0).onComplete(onFadeIn).ease(Quad.easeInOut);
					
		onResize();
	}

	private function createButton(idle:String, over:String, x:Float = 0, y:Float = 0, scale:Float = 1):BasicButton {

        var button:BasicButton = new BasicButton(idle, over, over);
		button.x = x;
		button.y = y;
        button.scaleX = button.scaleY = scale;
        buttonHolder.addChild(button);

        return button;
    }

	public function cleanUp():Void {
		
		// clear update loop
		stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
	}

	private function onFadeIn():Void {
			
		holder.removeChild(fadeIn);
	}
	
    private function onContinueButtonClicked(event:Event):Void {

		eventSFXAudio.play();
		
		Main.mode = "continue";
		holder.addChild(fadeIn);
		Actuate.tween(fadeIn, 0.5, { alpha: 1 }).delay(0).onComplete(onTransitionOut).ease(Quad.easeInOut);
		//musicAudio.fadeOut(0.5);
	}

	private function showHomeButtons():Void {

		buttonHolder.visible = true;
	}

	private function onOptionsButtonClicked(event:Event):Void {

		eventSFXAudio.play();

		title.visible = false;
		image.visible = false;
		buttonHolder.visible = false;

		menuBackground.visible = true;
		showOptions();
	}

	private function showOptions():Void {

		optionsMenu.visible = true;
	}

	private function onOptionsBack(event:Event):Void {

		optionsMenu.visible = false;
		menuBackground.visible = false;

		title.visible = true;
		image.visible = true;
		showHomeButtons();
	}

	private function onToggleFilter(event:Event):Void {

		buttonHolder.transform.colorTransform = new ColorTransform();
	}

	private function onToggleFullscreen(event:Event):Void {

		dispatchEvent(event);
	}

	private function onMusicVolume(event:Event):Void {

		//musicAudio.setVolume(Main.musicVolume);
	}

	private function onSFXVolume(event:Event):Void {

		eventSFXAudio.setVolume(Main.sfxVolume);
	}

	private function onNewGameButtonClicked(event:Event):Void {

		eventSFXAudio.play();

		Main.mode = "new";
		holder.addChild(fadeIn);
		Actuate.tween(fadeIn, 0.5, { alpha: 1 }).delay(0).onComplete(onTransitionOut).ease(Quad.easeInOut);
	}

	private function onTransitionOut():Void {
		
		dispatchEvent(new Event("init_game"));
    }

	public function onResize(event:Event = null):Void {

		buttonHolder.y = (Main.maxHeight * 0.75) - (Main.offsetY / 2);
		credit.y = Std.int((Main.maxHeight - Main.offsetY) - credit.height - 10);
    }
	
	private function onEnterFrame(event:Event):Void {

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
	}

	private function update(dt:Float):Void {
		
		if (isRunning) {
		
			// animate background
			background.update();
		}
	}
}