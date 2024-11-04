package com.daviddurhamgames.secretsauce;
	
import openfl.display.Sprite;
import openfl.display.MovieClip;
import openfl.display.Bitmap;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.Assets;

import com.daviddurhamgames.secretsauce.BasicButton;

class NewGameMenu extends Sprite {
	
    public var button1Player:BasicButton;
    public var button2Player:BasicButton;
    public var buttonBack:BasicButton;

    // selector to move through buttons
    public var selector:MovieClip;
    private var buttonList:Array<BasicButton>;
    private var currButton:Int;
	
	public function new():Void {
		
		super();

        var title:Bitmap = new Bitmap(Assets.getBitmapData("assets/newgame_title.png"));
        title.x = -title.width / 2;
        title.y = -80 - (title.height / 2);
        addChild(title);

        button1Player = new BasicButton("assets/button_1player.png", "assets/button_1player.png", "assets/button_1player.png");
        button1Player.addEventListener(MouseEvent.CLICK, on1PlayerClicked);
		button1Player.x = -80;
		button1Player.y = 0;
        addChild(button1Player);

        button2Player = new BasicButton("assets/button_2player.png", "assets/button_2player.png", "assets/button_2player.png");
        button2Player.addEventListener(MouseEvent.CLICK, on2PlayerClicked);
		button2Player.x = 80;
		button2Player.y = 0;
        addChild(button2Player);

        buttonBack = new BasicButton("assets/back_button.png", "assets/back_button.png", "assets/back_button.png");
        buttonBack.addEventListener(MouseEvent.CLICK, onBackClicked);
		buttonBack.x = 0;
		buttonBack.y = 90;
        addChild(buttonBack);

        //create button list
		currButton = 0;
		buttonList = [button1Player, button2Player, buttonBack];

        visible = false;
	}

    public function show():Void {

        visible = true;
    }

    public function hide():Void {

        visible = false;
    }

    /* Button Handlers */

    private function on1PlayerClicked(event:MouseEvent = null):Void {
        
        Main.mode = "quick_race";
        Main.numberOfPlayers = 1;

        dispatchEvent(new Event("start"));
    }
    private function on2PlayerClicked(event:MouseEvent = null):Void {
        
        Main.mode = "quick_race";
        Main.numberOfPlayers = 2;

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