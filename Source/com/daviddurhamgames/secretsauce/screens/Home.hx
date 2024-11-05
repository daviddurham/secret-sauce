package com.daviddurhamgames.secretsauce.screens;

import com.piratejuice.Audio;
import com.piratejuice.Ticker;
import com.piratejuice.events.TickerEvent;
import com.piratejuice.vfx.ScreenShake;
import com.piratejuice.vfx.ParticleSystem;
import com.piratejuice.InputManager;

import openfl.display.*;
import openfl.events.*;
import openfl.Assets;
import openfl.geom.ColorTransform;
import openfl.Lib;

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
    private var creditsMenu:CreditsMenu;
	private var newGameMenu:NewGameMenu;
	
	// flag when quit is initiated
	private var isQuitting = false;

    // update ticker
	private var ticker:Ticker;

	// whether we should fade in or use the normal transition
	private var isFadeIn:Bool;


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

		var bg:Bitmap = new Bitmap(Assets.getBitmapData("assets/title_screen_bg.png"));
        bg.scaleX = 590;
		bg.x = 0;
        bg.y = 0;
        scene.addChild(bg);

		var title:Bitmap = new Bitmap(Assets.getBitmapData("assets/title.png"));
		title.x = Std.int((Main.maxWidth / 2) - (title.width / 2));
        title.y = Std.int((Main.maxHeight / 2) - (title.height / 2) - 80);
        scene.addChild(title);

		// background for menus
		menuBackground = new Shape();
		menuBackground.graphics.beginFill(0x990055);
		menuBackground.graphics.drawRect(-1000, 0, 2000, -Main.maxHeight);
		menuBackground.graphics.endFill();

		menuBackground.x = Main.maxWidth / 2;
		menuBackground.y = Main.maxHeight;
		menuBackground.scaleY = 0;
		scene.addChild(menuBackground);

		buttonHolder = new Sprite();
		holder.addChild(buttonHolder);

		newGameButton = createButton("assets/home_newgame_button.png", (Main.maxWidth / 2) + 90, -80, 1);
		newGameButton.addEventListener(MouseEvent.CLICK, onNewGameButtonClicked);

		continueButton = createButton("assets/home_continue_button.png", (Main.maxWidth / 2) + 90, -30, 1);
		continueButton.addEventListener(MouseEvent.CLICK, onContinueButtonClicked);

		optionsButton = createButton("assets/home_settings_button.png", (Main.maxWidth / 2) + 90, 20, 1);
		optionsButton.addEventListener(MouseEvent.CLICK, onOptionsButtonClicked);

		// menus
		optionsMenu = new OptionsMenu();
		optionsMenu.x = Main.maxWidth / 2;
		optionsMenu.y = Main.maxHeight / 2;
		optionsMenu.addEventListener("toggle_filter", onToggleFilter, false, 0, true);
		optionsMenu.addEventListener("music_volume", onMusicVolume, false, 0, true);
		optionsMenu.addEventListener("sfx_volume", onSFXVolume, false, 0, true);
		optionsMenu.addEventListener("credits", onCreditsSelected, false, 0, true);
		optionsMenu.addEventListener("back", onOptionsBack, false, 0, true);
		holder.addChild(optionsMenu);

		creditsMenu = new CreditsMenu();
		creditsMenu.x = Main.maxWidth / 2;
		creditsMenu.y = Main.maxHeight / 2;
		creditsMenu.addEventListener("back", onCreditsBack, false, 0, true);
		holder.addChild(creditsMenu);

		newGameMenu = new NewGameMenu();
		newGameMenu.x = Main.maxWidth / 2;
		newGameMenu.y = Main.maxHeight / 2;
		newGameMenu.addEventListener("back", onNewGameBack, false, 0, true);
		newGameMenu.addEventListener("start", onNewGameStart, false, 0, true);
		holder.addChild(newGameMenu);

		// create audio objects
		eventSFXAudio = new Audio();
		eventSFXAudio.setVolume(Main.sfxVolume);
		eventSFXAudio.setSound("assets/audio/button_click" + "." + Main.audioFormat);

		/*
		musicAudio = new Audio();
		musicAudio.setVolume(Main.musicVolume);
		musicAudio.setSound("assets/audio/menu_loop" + "." + Main.audioFormat);
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
		
		// update loop - 150% speed of the original game feels nice
		ticker = new Ticker((1000 / Main.fps) * 1.5);
		addChild(ticker);
		
		ticker.addEventListener(TickerEvent.TICK, update);
		ticker.start();

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

	private function createButton(labelBitmap:String, x:Float = 0, y:Float = 0, scale:Float = 1):BasicButton {

        var button:BasicButton = new BasicButton(labelBitmap, labelBitmap, labelBitmap);
		button.x = x;
		button.y = y;
        button.scaleX = button.scaleY = scale;
        buttonHolder.addChild(button);

        return button;
    }

	public function cleanUp():Void {
		
		// clear update loop
		ticker.removeEventListener(TickerEvent.TICK, update);
	}

	private function onFadeIn():Void {
			
		holder.removeChild(fadeIn);
	}
	
    private function onContinueButtonClicked(event:Event):Void {

		eventSFXAudio.play();
			
		holder.addChild(fadeIn);
		Actuate.tween(fadeIn, 0.5, { alpha: 1 }).delay(0).onComplete(onTransitionOut).ease(Quad.easeInOut);
		//musicAudio.fadeOut(0.5);
	}

	private function showHomeButtons():Void {

		buttonHolder.visible = true;
	}

	private function onOptionsButtonClicked(event:Event):Void {

		eventSFXAudio.play();

		buttonHolder.visible = false;
		Actuate.tween(menuBackground, 0.4, { scaleY: 1 }).ease(Quad.easeInOut).onComplete(showOptions);
	}

	private function showOptions():Void {

		optionsMenu.visible = true;
	}

	private function onOptionsBack(event:Event):Void {

		optionsMenu.visible = false;
		Actuate.tween(menuBackground, 0.4, { scaleY: 0 }).ease(Quad.easeInOut).onComplete(showHomeButtons);
	}

	private function onToggleFilter(event:Event):Void {

		buttonHolder.transform.colorTransform = new ColorTransform();
	}

	private function onMusicVolume(event:Event):Void {

		//musicAudio.setVolume(Main.musicVolume);
	}

	private function onSFXVolume(event:Event):Void {

		eventSFXAudio.setVolume(Main.sfxVolume);
	}

	private function onCreditsSelected(event:Event):Void {

		creditsMenu.visible = true;
		optionsMenu.visible = false;
	}
	
	private function onCreditsBack(event:Event):Void {

		creditsMenu.visible = false;
		optionsMenu.visible = true;
	}

	private function onNewGameButtonClicked(event:Event):Void {

		eventSFXAudio.play();

		buttonHolder.visible = false;
		Actuate.tween(menuBackground, 0.4, { scaleY: 1 }).ease(Quad.easeInOut).onComplete(showNewGame);
	}

	private function showNewGame():Void {

		newGameMenu.visible = true;
	}
	
	private function onNewGameBack(event:Event):Void {

		newGameMenu.visible = false;
		Actuate.tween(menuBackground, 0.4, { scaleY: 0 }).ease(Quad.easeInOut).onComplete(showHomeButtons);
	}

	private function onNewGameStart(event:Event):Void {
			
		holder.addChild(fadeIn);
		Actuate.tween(fadeIn, 0.5, { alpha: 1 }).delay(0).onComplete(onTransitionOut).ease(Quad.easeInOut);
		//musicAudio.fadeOut(0.5);
	}

	private function onTransitionOut():Void {
		
		dispatchEvent(new Event("init_game"));
    }

	public function onResize(event:Event = null):Void {

		//buttonHolder.x = (Main.maxWidth - Main.offsetX) - 80;
		buttonHolder.y = (Main.maxHeight * 0.75) - (Main.offsetY / 2);
    }
	
	private function update(event:Event):Void {
		
		if (isRunning) {
		
			//
		}
	}
}