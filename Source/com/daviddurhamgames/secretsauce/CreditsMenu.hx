package com.daviddurhamgames.secretsauce;
	
import openfl.display.Sprite;
import openfl.display.MovieClip;
import openfl.display.Bitmap;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.Assets;

import com.daviddurhamgames.secretsauce.BasicButton;

class CreditsMenu extends Sprite {
	
    public var buttonBack:BasicButton;

    // selector to move through buttons
    public var selector:MovieClip;
    private var buttonList:Array<BasicButton>;
    private var currButton:Int;
	
	public function new():Void {
		
		super();

        var title:Bitmap = new Bitmap(Assets.getBitmapData("assets/credits_title.png"));
        title.smoothing = true;
		title.scaleX = title.scaleY = 0.5;
        title.x = -title.width / 2;
        title.y = -280 - (title.height / 2);
        addChild(title);

        var credits:Bitmap = new Bitmap(Assets.getBitmapData("assets/credits.png"));
        credits.x = -credits.width / 2;
        credits.y = -credits.height / 2;
        addChild(credits);

        buttonBack = new BasicButton("assets/back_button.png", "assets/back_button.png", "assets/back_button.png");
        buttonBack.addEventListener(MouseEvent.CLICK, onBackClicked);
		buttonBack.x = 0;
		buttonBack.y = 90;
        addChild(buttonBack);

        //create button list
		currButton = 0;
		buttonList = [buttonBack];

        visible = false;
	}

    public function show():Void {

        visible = true;
    }

    public function hide():Void {

        visible = false;
    }

    /* Button Handlers */

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