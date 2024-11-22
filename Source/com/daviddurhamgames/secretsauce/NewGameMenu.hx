package com.daviddurhamgames.secretsauce;
	
import openfl.display.Sprite;
import openfl.display.MovieClip;
import openfl.display.Bitmap;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.Assets;

import com.daviddurhamgames.secretsauce.BasicButton;

class NewGameMenu extends Sprite {
	
    public var buttonNormal:BasicButton;
    public var buttonHard:BasicButton;
    public var buttonBack:BasicButton;

    // selector to move through buttons
    public var selector:MovieClip;
    private var buttonList:Array<BasicButton>;
    private var currButton:Int;
	
	public function new():Void {
		
		super();

        buttonNormal = new BasicButton("assets/button_normal.png", "assets/button_normal.png", "assets/button_normal.png");
        buttonNormal.addEventListener(MouseEvent.CLICK, onNormalClicked);
		buttonNormal.x = -200;
		buttonNormal.y = 0;
        addChild(buttonNormal);

        buttonHard = new BasicButton("assets/button_hard.png", "assets/button_hard.png", "assets/button_hard.png");
        buttonHard.addEventListener(MouseEvent.CLICK, onHardClicked);
		buttonHard.x = 200;
		buttonHard.y = 0;
        addChild(buttonHard);

        buttonBack = new BasicButton("assets/back_button.png", "assets/back_button.png", "assets/back_button.png");
        buttonBack.addEventListener(MouseEvent.CLICK, onBackClicked);
        buttonBack.scaleX = buttonBack.scaleY = 0.75;
		buttonBack.x = 0;
		buttonBack.y = 250;
        addChild(buttonBack);

        //create button list
		currButton = 0;
		buttonList = [buttonNormal, buttonHard, buttonBack];

        visible = false;
	}

    public function show():Void {

        visible = true;
    }

    public function hide():Void {

        visible = false;
    }

    /* Button Handlers */

    private function onNormalClicked(event:MouseEvent = null):Void {
        
        Main.mode = "quick_race";
        dispatchEvent(new Event("start"));
    }
    private function onHardClicked(event:MouseEvent = null):Void {
        
        Main.mode = "quick_race";
        dispatchEvent(new Event("start"));
    }

    private function onBackClicked(event:MouseEvent = null):Void {
        
        dispatchEvent(new Event("back"));
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