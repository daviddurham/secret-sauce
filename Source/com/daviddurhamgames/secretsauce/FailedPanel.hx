﻿package com.daviddurhamgames.secretsauce;
	
import openfl.display.Sprite;
import openfl.display.Shape;
import openfl.display.MovieClip;
import openfl.display.Bitmap;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.Assets;

import com.daviddurhamgames.secretsauce.BasicButton;

class FailedPanel extends Sprite {
	
    public var buttonQuit:BasicButton;
    public var buttonRestart:BasicButton;
    
    // selector
    public var selector:MovieClip;
    
    private var buttonList:Array<BasicButton>;
    private var currButton:Int;

	
	public function new():Void {
		
		super();
		
        createPanel(450, 350);

        var title:Bitmap = new Bitmap(Assets.getBitmapData("assets/level_failed_title.png"));
        title.smoothing = true;
		title.scaleX = title.scaleY = 0.5;
        title.x = -title.width / 2;
        title.y = -175;
        addChild(title);

        buttonRestart = createButton("assets/restart_button.png", 0, 0);
        buttonRestart.addEventListener(MouseEvent.CLICK, onRestartClicked);

        buttonQuit = createButton("assets/quit_button.png", 0, 45);
        buttonQuit.addEventListener(MouseEvent.CLICK, onQuitClicked);

        //create button list
		currButton = 0;
		buttonList = [buttonQuit, buttonRestart];

        visible = false;
	}

    private function createPanel(w:Float, h:Float):Sprite {

        var panel:Sprite = new Sprite();
        addChild(panel);

        var shadow:Shape = new Shape();
        shadow.graphics.beginFill(0x000000, 0.25);
        shadow.graphics.drawRect(-w / 2, -h / 2, w, h);
        shadow.graphics.endFill();
        shadow.x = 4;
        shadow.y = 4;
        panel.addChild(shadow);

        var background:Shape = new Shape();
        background.graphics.beginFill(0x111111);
        background.graphics.drawRect(-w / 2, -h / 2, w, h);
        background.graphics.endFill();
        panel.addChild(background);

        return panel;
    }

    private function createButton(labelBitmap:String, x:Float = 0, y:Float = 0, scale:Float = 1):BasicButton {

        var button:BasicButton = new BasicButton("assets/button_rounded.png", "assets/button_rounded.png", "assets/button_rounded.png");
		button.x = x;
		button.y = y;
        button.scaleX = button.scaleY = scale;
        addChild(button);

		var icon:Sprite = new Sprite();
		var label:Bitmap = new Bitmap(Assets.getBitmapData(labelBitmap));
		label.x = -210;//label.width / 2;
		label.y = (-label.height / 2) + 10;
        label.scaleX = label.scaleY = 0.75;
		label.smoothing = true;
        icon.addChild(label);
		button.addIcon(icon, 0, 0);

        return button;
    }
	
    private function onQuitClicked(event:MouseEvent = null):Void {
        
        dispatchEvent(new Event("quit"));
    }
    
    private function onRestartClicked(event:MouseEvent = null):Void {
        
        dispatchEvent(new Event("retry"));
    }

    public function show():Void {

        visible = true;
    }

    public function hide():Void {

        visible = false;
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