package com.daviddurhamgames.secretsauce;
	
import openfl.display.Sprite;
import openfl.display.MovieClip;
import openfl.display.Bitmap;
import openfl.display.Shape;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.Assets;

import com.daviddurhamgames.secretsauce.BasicButton;

import com.piratejuice.Audio;
import com.piratejuice.BitmapText;

class OptionsMenu extends Sprite {
	
    public var buttonFullscreen:BasicButton;
    public var buttonMusic:BasicButton;
    public var buttonSFX:BasicButton;
    public var buttonBack:BasicButton;

    private var fullscreenOptions:Array<Bitmap>;
    private var musicOptions:Array<Bitmap>;
    private var sfxOptions:Array<Bitmap>;

    // selector
    public var selector:MovieClip;
    
    private var buttonList:Array<BasicButton>;
    private var currButton:Int;

    private var eventSFXAudio:Audio;
    
	public function new():Void {
		
		super();

        var titleText:BitmapText = new BitmapText(512, 64, "assets/font_1.png");
		titleText.printText("SETTINGS");
		titleText.x = -150;
		titleText.y = -300;
        titleText.scaleX = titleText.scaleY = 0.75;
        addChild(titleText);

        buttonFullscreen = createButton("assets/fullscreen_button.png", "assets/fullscreen_button_over.png", -150, -160, 0.75);
        buttonFullscreen.addEventListener(MouseEvent.CLICK, onFullscreenClicked);
        
        fullscreenOptions = [
            
            addSetting("assets/option_off.png", buttonFullscreen),
            addSetting("assets/option_on.png", buttonFullscreen)
        ];

        setFullscreen();

        buttonMusic = createButton("assets/music_button.png", "assets/music_button_over.png", -150, -40, 0.75);
        buttonMusic.addEventListener(MouseEvent.CLICK, onMusicClicked);

        musicOptions = [
            
            addSetting("assets/option_0.png", buttonMusic),
            addSetting("assets/option_25.png", buttonMusic),
            addSetting("assets/option_50.png", buttonMusic),
            addSetting("assets/option_75.png", buttonMusic),
            addSetting("assets/option_100.png", buttonMusic)
        ];

        setMusicVolume();

        buttonSFX = createButton("assets/sfx_button.png", "assets/sfx_button_over.png", -150, 80, 0.75);
        buttonSFX.addEventListener(MouseEvent.CLICK, onSFXClicked);
		addChild(buttonSFX);

        sfxOptions = [
            
            addSetting("assets/option_0.png", buttonSFX),
            addSetting("assets/option_25.png", buttonSFX),
            addSetting("assets/option_50.png", buttonSFX),
            addSetting("assets/option_75.png", buttonSFX),
            addSetting("assets/option_100.png", buttonSFX)
        ];

        setSFXVolume();

        buttonBack = createButton("assets/back_button.png", "assets/back_button_over.png", 0, 240, 0.75);
        buttonBack.addEventListener(MouseEvent.CLICK, onBackClicked);
		
        //create button list
		currButton = 0;
		buttonList = [buttonFullscreen, buttonMusic, buttonSFX, buttonBack];

        // create audio object
		eventSFXAudio = new Audio("assets/audio/" + Main.audioFormat + "/button_2" + "." + Main.audioFormat);
		eventSFXAudio.setVolume(Main.sfxVolume);

        visible = false;
	}

    private function createButton(idle:String, over:String, x:Float = 0, y:Float = 0, scale:Float = 1):BasicButton {

        var button:BasicButton = new BasicButton(idle, over, over);
		button.x = x;
		button.y = y;
        button.scaleX = button.scaleY = scale;
        addChild(button);

        return button;
    }

    private function addSetting(image:String, button:BasicButton):Bitmap {

        var bitmap = new Bitmap(Assets.getBitmapData(image));
        bitmap.x = button.x + 200;
        bitmap.y = button.y - (bitmap.height / 2);
        addChild(bitmap);

        return bitmap;
    }

    public function show():Void {

        visible = true;
    }

    public function hide():Void {

        visible = false;
    }

    /* Button Handlers */
    
    private function onFullscreenClicked(event:MouseEvent = null):Void {

        eventSFXAudio.play();

        setFullscreen();		
		//Main.savedData.save("fullscreen", Std.string(Main.isFullscreen));
        dispatchEvent(new Event("fullscreen"));
    }

    private function onMusicClicked(event:MouseEvent = null):Void {
        
        eventSFXAudio.play();

        // increment volume by 25%
        Main.musicVolume += 0.25;

        if (Main.musicVolume > 1) {

            Main.musicVolume = 0;
        }

        setMusicVolume();		
		Main.savedData.save("music_volume", Std.string(Main.musicVolume));
        dispatchEvent(new Event("music_volume"));
    }
    
    private function onSFXClicked(event:MouseEvent = null):Void {
        
        eventSFXAudio.play();

        // increment volume by 25%
        Main.sfxVolume += 0.25;

        if (Main.sfxVolume > 1) {

            Main.sfxVolume = 0;
        }

        setSFXVolume();
		Main.savedData.save("sfx_volume", Std.string(Main.sfxVolume));

        eventSFXAudio.setVolume(Main.sfxVolume);
        dispatchEvent(new Event("sfx_volume"));
    }

    private function onBackClicked(event:MouseEvent = null):Void {
        
        eventSFXAudio.play();
        dispatchEvent(new Event("back"));
    }

    private function setFullscreen():Void {

        fullscreenOptions[0].visible = !Main.isFullscreen;
        fullscreenOptions[1].visible = Main.isFullscreen;
    }

    private function setMusicVolume():Void {

        for (i in 0...musicOptions.length) {

            // get values in whole numbers (0 to 4)
            musicOptions[i].visible = (i == Std.int(Main.musicVolume * 4));
        }
    }

    private function setSFXVolume():Void {

        for (i in 0...sfxOptions.length) {

            // get values in whole numbers (0 to 4)
            sfxOptions[i].visible = (i == Std.int(Main.sfxVolume * 4));
        }
    }

    
    /* Key Handlers */
    
    public function select():Void {
        
        buttonList[currButton].dispatchEvent(new MouseEvent(MouseEvent.CLICK, true, false));
    }
    
    public function selectionUp():Void {
        
        if (--currButton < 0) {
            
            currButton = buttonList.length - 1;
        }
        
        setPointerPosition(selector, buttonList[currButton].x - selector.width, buttonList[currButton].y + (buttonList[currButton].height / 2));
    }
    
    public function selectionDown():Void {
        
        if (++currButton > buttonList.length - 1) {
            
            currButton = 0;
        }
        
        setPointerPosition(selector, buttonList[currButton].x - selector.width, buttonList[currButton].y + (buttonList[currButton].height / 2));
    }
    
    private function setPointerPosition(pointer:MovieClip, px:Float, py:Float):Void {
        
        pointer.x = px;
        pointer.y = py;
    }
}