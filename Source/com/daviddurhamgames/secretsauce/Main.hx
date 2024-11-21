package com.daviddurhamgames.secretsauce;

import openfl.display.Sprite;
import openfl.display.StageAlign;
import openfl.display.StageScaleMode;
import openfl.display.StageQuality;
import openfl.display.StageDisplayState;
import openfl.display.Bitmap;
import openfl.events.Event;
import openfl.ui.Keyboard;
import openfl.events.KeyboardEvent;
import openfl.Lib;
import openfl.display.FPS;
import openfl.Assets;

import com.piratejuice.debug.Debug;

import com.daviddurhamgames.secretsauce.screens.Home;
import com.daviddurhamgames.secretsauce.screens.Game;
import com.daviddurhamgames.secretsauce.screens.Splash;

/**
 * Application Entry Point
 * @author David Durham
 */

class Main extends Sprite {
	
	// build version
	public static var version:String = "0.0.1";
	
	// show debug info
	public static var isDebug:Bool = true;
	
	// fullscreen mode
	public static var isFullscreen:Bool = false;
	
	// window properties
	public static var scale:Float = 1;
	
	public static var winWidth:Float;
	public static var winHeight:Float;
	
	public static var maxWidth:Int = 1760;//885;//590;
	public static var maxHeight:Int = 810;//405;//270;
	public static var minWidth:Int = 1080;//540;//360;
	public static var minHeight:Int = 720;//360;//240;
	
	public static var offsetX:Float;
	public static var offsetY:Float;
	
	public static var fps:Int = 0;
	
	// global settings
	public static var sfxVolume:Float = 1;
	public static var musicVolume:Float = 1;
	public static var showControls:Int = 0;
	
	public static var audioFormat:String = "wav";
	
	// save data
	public static var savedData:SavedData;
	
	// container sprite for easy re-sizing/re-framing
	private var _container:Sprite;
	
	// splash screen
	private var _splash:Splash;
	
	// and the actual 'gameplay' part
	private var _game:Game;
	
	// menu system
	private var _menu:Home;
	
	// fps counter
	private var _fps:FPS;

	// some globals (move these)
	// height and width of each tile
	public static var TILE_SIZE:Int = 16;

	public static var mode:String = "";
	public static var numberOfPlayers = 1;
	public static var level:String = "";

	// control keys
	public static var KEY_UP:Int = 38;
	public static var KEY_DOWN:Int = 40;
	public static var KEY_LEFT:Int = 37;
	public static var KEY_RIGHT:Int = 39;

	public static var KEY_A:Int = 88;	// x
	public static var KEY_B:Int = 90;	// z

	public static var KEY_START:Int = 13;	// enter
	public static var KEY_SELECT:Int = 8;	// backspace
	
	public function new() {
		
		// latest version of openfl won't let me get fps from the project.xml
		fps = 60;//Lib.application.config.fps;
		Main.isDebug = false;
		
		super();
		addEventListener(Event.ADDED_TO_STAGE, init);
	}

	private function init(event:Event) {
		
		removeEventListener(Event.ADDED_TO_STAGE, init);
		
		#if windows
		if (Main.isDebug) {
			
			fullscreenMode(false/*true*/);
			onResize();
		}
		else {
			
			fullscreenMode(false/*true*/);
		}
		#else
		fullscreenMode(false);
		#end

		//fullscreenMode(true);

		// init save data
		savedData = new SavedData();
		//savedData.clear();

		showControls =  Std.parseInt(savedData.load("screen_controls"));

		sfxVolume = Std.parseFloat(savedData.load("sfx_volume"));
		musicVolume = Std.parseFloat(savedData.load("music_volume"));

		var bg:Bitmap = new Bitmap(Assets.getBitmapData("assets/bg.png"));
		bg.scaleX = Main.maxWidth;
		//addChild(bg);

		//initSplash();
		initMenu();
		//initGame();

		//if (Main.isDebug) {
			
			//_fps = new FPS(4, 4, 0xffffff);
			//addChild(_fps);
		//}
				
		var guide:Bitmap = new Bitmap(Assets.getBitmapData("assets/guide.png"));
		//addChild(guide);
		
		
		// hide/show event handlers (to suspend game on close)
		Lib.current.stage.addEventListener(Event.ACTIVATE, onActivate);
		Lib.current.stage.addEventListener(Event.DEACTIVATE, onDeactivate);
	}
	
	private function initGame(event:Event = null) {

		if (_menu != null) {
		
			removeChild(_menu);
			
			_menu.removeEventListener("init_game", initGame);
			_menu = null;
		}
		
		_game = new Game(mode, numberOfPlayers);
		_game.addEventListener("quit", initMenu);
		addChild(_game);

		if (_fps != null) {
			
			Lib.current.addChild(_fps);
		}
	}
	
	private function initMenu(event:Event = null) {
		
		var animate:Bool = false;
		
		if (_splash != null) {
			
			// coming from the splash screen
			// so animate in
			animate = true;
			
			removeChild(_splash);
			_splash.removeEventListener("init_menu", initMenu);
			_splash = null;
		}

		if (_game != null) {
		
			_game.cleanUp();
			removeChild(_game);

			_game.removeEventListener("init_menu", initMenu);
			_game.removeEventListener("quit", initMenu);
			
			_game = null;
		}
		
		_menu = new Home(animate);
		_menu.addEventListener("init_game", initGame);
		addChild(_menu);

		if (_fps != null) {
			
			Lib.current.addChild(_fps);
		}
	}
	
	private function initSplash(event:Event = null) {
		
		_splash = new Splash();
		_splash.addEventListener("init_menu", initMenu);
		addChild(_splash);
	}
	
	static public function main() {
		
		Lib.current.stage.align = StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		Lib.current.stage.quality = StageQuality.BEST;
		
		Lib.current.stage.stageFocusRect = false;
		Lib.current.addChild(new Main());
	}
	

	/* Fullscreen */
	
	private function fullscreenMode(flag:Bool):Void {
		
		Lib.current.stage.addEventListener(Event.RESIZE, onResize);
		
		if (flag) {
			
			Lib.current.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPressed);
			
			Main.isFullscreen = true;
		}
		else {
			
			if (Main.isFullscreen) {
				
				Lib.current.stage.displayState = StageDisplayState.NORMAL;
				//stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyPressed);
				
				Main.isFullscreen = false;
			}
		}
	}

	private function onActivate(event:Event = null):Void {

		if (_game != null) {

			_game.onDeactivate(event);
		}
	}

	private function onDeactivate(event:Event = null):Void {

		if (_game != null) {

			_game.onActivate(event);
		}
	}
	
	private function onResize(event:Event = null):Void {
		
		winWidth = Lib.current.stage.stageWidth;
		winHeight = Lib.current.stage.stageHeight;
		
		// Find closest safe zone proportion to aspect ratio...
		scale = Math.min(winWidth / minWidth, winHeight / minHeight);
		
		// ...re-scale to fit screen.
		scaleX = scaleY = scale;
		x = (( -maxWidth / 2) * scale) + (winWidth / 2);
		y = (( -maxHeight / 2) * scale) + (winHeight / 2);
		
		// positioning offsets
		offsetX = 0;
		offsetY = 0;
		
		if ((maxWidth * scale) > winWidth) {
			
			offsetX = (((maxWidth * scale) - winWidth) * 0.5) / scale;
		}
		
		if ((maxHeight * scale) > winHeight) {
			
			offsetY = (((maxHeight * scale) - winHeight) * 0.5) / scale;
		}

		if (_game != null) {

			_game.onResize(event);
		}

		if (_menu != null) {

			_menu.onResize(event);
		}
	}
	
	/**
 	 * Switch between fullscreen/windowed mode when pressing ESC
 	 */	
	public function onKeyPressed(event:KeyboardEvent):Void {
		
		if (event.keyCode == Keyboard.ESCAPE) {
			
			fullscreenMode(!Main.isFullscreen);
		}
	}
}