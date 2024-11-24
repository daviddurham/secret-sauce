package com.daviddurhamgames.secretsauce;
	
import openfl.display.Sprite;
import openfl.display.Shape;
import openfl.display.MovieClip;
import openfl.display.Bitmap;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.Assets;

import com.daviddurhamgames.secretsauce.BasicButton;
import com.piratejuice.BitmapText;

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
		
        //createPanel(230, 200);
        var panel:Bitmap = new Bitmap(Assets.getBitmapData("assets/paused_panel.png"));
		panel.scaleX = panel.scaleY = 0.8;
        panel.x = -panel.width / 2;
        panel.y = -20 - (panel.height / 2);
        addChild(panel);

        var titleText:BitmapText = new BitmapText(512, 64, "assets/font_1.png");
		titleText.printText("PAUSED");
		titleText.x = -100;
		titleText.y = -170;
        titleText.scaleX = titleText.scaleY = 0.75;
        addChild(titleText);

        buttonBack = createButton("assets/home_continue_button.png", "assets/home_continue_button_over.png", 0, -40, 0.75);
        buttonBack.addEventListener(MouseEvent.CLICK, onBackClicked);

        buttonQuit = createButton("assets/quit_button.png", "assets/quit_button_over.png", 0, 80, 0.75);
        buttonQuit.addEventListener(MouseEvent.CLICK, onQuitClicked);
		
        //create button list
		currButton = 0;
		buttonList = [buttonQuit, buttonBack];

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

    private function createButton(idle:String, over:String, x:Float = 0, y:Float = 0, scale:Float = 1):BasicButton {

        var button:BasicButton = new BasicButton(idle, over, over);
		button.x = x;
		button.y = y;
        button.scaleX = button.scaleY = scale;
        addChild(button);

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