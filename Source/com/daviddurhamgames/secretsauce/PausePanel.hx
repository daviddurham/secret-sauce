package com.daviddurhamgames.secretsauce;
	
import openfl.display.Sprite;
import openfl.display.Shape;
import openfl.display.MovieClip;
import openfl.display.Bitmap;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.Assets;

import com.daviddurhamgames.secretsauce.BasicButton;

class PausePanel extends Sprite {
	
    public var buttonQuit:BasicButton;
    public var buttonRestart:BasicButton;
    public var buttonBack:BasicButton;
    
    // selector
    public var selector:MovieClip;
    
    private var buttonList:Array<BasicButton>;
    private var currButton:Int;
    
		
	/* Constructor */
	
	public function new():Void {
		
		super();
		
        createPanel(230, 200);

        var title:Bitmap = new Bitmap(Assets.getBitmapData("assets/paused_title.png"));
		title.scaleX = 0.25;
        title.scaleY = 0.25;
        title.x = -title.width / 2;
        title.y = -100;
        addChild(title);

        buttonBack = createButton("assets/resume_button.png", 0, -35);
        buttonBack.addEventListener(MouseEvent.CLICK, onBackClicked);

        buttonRestart = createButton("assets/restart_button.png", 0, 10);
        buttonRestart.addEventListener(MouseEvent.CLICK, onRestartClicked);

        buttonQuit = createButton("assets/quit_button.png", 0, 55);
        buttonQuit.addEventListener(MouseEvent.CLICK, onQuitClicked);
		
        //create button list
		currButton = 0;
		buttonList = [buttonQuit, buttonRestart, buttonBack];

        visible = false;
	}

    private function createPanel(w:Float, h:Float):Sprite {

        var panel:Sprite = new Sprite();
        addChild(panel);

        var background:Shape = new Shape();
        background.graphics.beginFill(0x111111, 0.5);
        background.graphics.drawRect(-w / 2, -h / 2, w, h);
        background.graphics.endFill();
        panel.addChild(background);

        return panel;
    }

    private function createButton(labelBitmap:String, x:Float = 0, y:Float = 0, scale:Float = 1):BasicButton {

        var button:BasicButton = new BasicButton("assets/button_rect.png", "assets/button_rect.png", "assets/button_rect.png");
		button.x = x;
		button.y = y;
        button.scaleX = button.scaleY = scale;
        addChild(button);

		var icon:Sprite = new Sprite();
		var label:Bitmap = new Bitmap(Assets.getBitmapData(labelBitmap));
		label.x = 10 - (label.width / 2);
		label.y = 5 - (label.height / 2);
        label.scaleX = label.scaleY = 0.75;
        icon.addChild(label);
		button.addIcon(icon, 0, 0);

        return button;
    }

    public function show():Void {

        visible = true;
    }

    public function hide():Void {

        visible = false;
    }

    /* Button Handlers */
		
    private function onQuitClicked(event:MouseEvent = null):Void {
        
        dispatchEvent(new Event("quit"));
    }
    
    private function onRestartClicked(event:MouseEvent = null):Void {
        
        dispatchEvent(new Event("restart"));
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