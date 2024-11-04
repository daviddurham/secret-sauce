package com.daviddurhamgames.secretsauce;
	
import openfl.display.Sprite;
import openfl.display.MovieClip;
import openfl.display.Bitmap;
import openfl.display.Shape;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.Assets;

import com.daviddurhamgames.secretsauce.BasicButton;
import com.daviddurhamgames.secretsauce.ConfirmPanel;

class OptionsMenu extends Sprite {
	
    public var buttonMusic:BasicButton;
    public var buttonSFX:BasicButton;

    public var buttonControls:BasicButton;
    public var buttonReset:BasicButton;

    public var buttonCredits:BasicButton;

    public var buttonBack:BasicButton;

    private var musicOptions:Array<Bitmap>;
    private var sfxOptions:Array<Bitmap>;
    private var controlOptions:Array<Bitmap>;

    private var confirmMessage:ConfirmPanel;

    // selector
    public var selector:MovieClip;
    
    private var buttonList:Array<BasicButton>;
    private var currButton:Int;
	
	public function new():Void {
		
		super();

        var title:Bitmap = new Bitmap(Assets.getBitmapData("assets/options_title.png"));
        title.x = -title.width / 2;
        title.y = -80 - (title.height / 2);
        addChild(title);

        buttonMusic = new BasicButton("assets/button_rounded.png", "assets/button_rounded_over.png", "assets/button_rounded_over.png");
        buttonMusic.addEventListener(MouseEvent.CLICK, onMusicClicked);
		buttonMusic.x = -90;
		buttonMusic.y = -30;
        addChild(buttonMusic);

        var label = addLabel("assets/music_button.png", buttonMusic);

        musicOptions = [
            
            addSetting("assets/option_0.png", buttonMusic, label),
            addSetting("assets/option_25.png", buttonMusic, label),
            addSetting("assets/option_50.png", buttonMusic, label),
            addSetting("assets/option_75.png", buttonMusic, label),
            addSetting("assets/option_100.png", buttonMusic, label)
        ];

        setMusicVolume();

        buttonSFX = new BasicButton("assets/button_rounded.png", "assets/button_rounded_over.png", "assets/button_rounded_over.png");
        buttonSFX.addEventListener(MouseEvent.CLICK, onSFXClicked);
		buttonSFX.x = -90;
		buttonSFX.y = 10;
        addChild(buttonSFX);

        label = addLabel("assets/sfx_button.png", buttonSFX);

        sfxOptions = [
            
            addSetting("assets/option_0.png", buttonSFX, label),
            addSetting("assets/option_25.png", buttonSFX, label),
            addSetting("assets/option_50.png", buttonSFX, label),
            addSetting("assets/option_75.png", buttonSFX, label),
            addSetting("assets/option_100.png", buttonSFX, label)
        ];

        setSFXVolume();

        buttonControls = new BasicButton("assets/button_rounded.png", "assets/button_rounded_over.png", "assets/button_rounded_over.png");
        buttonControls.addEventListener(MouseEvent.CLICK, onControlsClicked);
		buttonControls.x = -90;
		buttonControls.y = 50;
        addChild(buttonControls);

        label = addLabel("assets/controls_button.png", buttonControls);

        controlOptions = [
            
            addSetting("assets/option_hide.png", buttonControls, label),
            addSetting("assets/option_show.png", buttonControls, label)
        ];

        setControls();

        buttonReset = new BasicButton("assets/button_rounded.png", "assets/button_rounded_over.png", "assets/button_rounded_over.png");
        buttonReset.addEventListener(MouseEvent.CLICK, onResetClicked);
		buttonReset.x = 90;
		buttonReset.y = -30;
        addChild(buttonReset);

        addLabel("assets/reset_button.png", buttonReset);

        buttonCredits = new BasicButton("assets/button_rounded.png", "assets/button_rounded_over.png", "assets/button_rounded_over.png");
        buttonCredits.addEventListener(MouseEvent.CLICK, onCreditsClicked);
		buttonCredits.x = 90;
		buttonCredits.y = 10;
        addChild(buttonCredits);

        addLabel("assets/credits_button.png", buttonCredits);

        buttonBack = new BasicButton("assets/back_button.png", "assets/back_button.png", "assets/back_button.png");
        buttonBack.addEventListener(MouseEvent.CLICK, onBackClicked);
		buttonBack.x = 0;
		buttonBack.y = 90;
        addChild(buttonBack);

        // confirm reset data
        confirmMessage = new ConfirmPanel();
        confirmMessage.x = 0;
		confirmMessage.y = 0;
        confirmMessage.addEventListener("confirm", onConfirmReset);
		confirmMessage.addEventListener("cancel", onCancelReset);
		addChild(confirmMessage);

        //create button list
		currButton = 0;
		buttonList = [buttonMusic, buttonSFX, buttonReset, buttonControls, buttonCredits, buttonBack];

        visible = false;
	}

    private function addLabel(image:String, button:BasicButton):Bitmap {

        var bitmap = new Bitmap(Assets.getBitmapData(image));		
        bitmap.x = button.x - (button.width / 2);
        bitmap.y = button.y - (button.height / 2);
        addChild(bitmap);

        return bitmap;
    }

    private function addSetting(image:String, button:BasicButton, label:Bitmap):Bitmap {

        var bitmap = new Bitmap(Assets.getBitmapData(image));
        bitmap.x = label.x + 130;
        bitmap.y = label.y + (label.height / 2) - (bitmap.height / 2);
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
    
    private function onMusicClicked(event:MouseEvent = null):Void {
        
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
        
        // increment volume by 25%
        Main.sfxVolume += 0.25;

        if (Main.sfxVolume > 1) {

            Main.sfxVolume = 0;
        }

        setSFXVolume();		
		Main.savedData.save("sfx_volume", Std.string(Main.sfxVolume));
        dispatchEvent(new Event("sfx_volume"));
    }

    private function onControlsClicked(event:MouseEvent = null):Void {
        
        Main.showControls = Main.showControls == 0 ? 1 : 0;

        setControls();
		Main.savedData.save("screen_controls", Std.string(Main.showControls));
    }

    private function onResetClicked(event:MouseEvent = null):Void {
        
        for (button in buttonList) {

            button.setEnabled(false);
        }

        confirmMessage.show();
    }

    private function onConfirmReset(event:Event = null):Void {

        // clear all progress
        Main.savedData.save("progress_1", "-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1");
		Main.savedData.save("progress_2", "-1,-1,-1,-1,-1,-1,-1,-1,-1,-1");

        //Main.savedData.clear();

        for (button in buttonList) {

            button.setEnabled(true);
        }

        confirmMessage.hide();
    }

    private function onCancelReset(event:Event = null):Void {

        for (button in buttonList) {

            button.setEnabled(true);
        }

        confirmMessage.hide();
    }

    private function onCreditsClicked(event:MouseEvent = null):Void {
        
        dispatchEvent(new Event("credits"));
    }

    private function onBackClicked(event:MouseEvent = null):Void {
        
        dispatchEvent(new Event("back"));
    }

    private function setControls():Void {

        for (i in 0...controlOptions.length) {

            controlOptions[i].visible = (i == Main.showControls);
        }
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