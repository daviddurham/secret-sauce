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

class SauceMadePanel extends Sprite {
	
    public var buttonQuit:BasicButton;
    public var buttonRestart:BasicButton;
    public var buttonBack:BasicButton;
    
    // selector
    public var selector:MovieClip;
    
    private var buttonList:Array<BasicButton>;
    private var currButton:Int;
	
	public function new():Void {
		
		super();
		
        createPanel(540, 150);

        var titleText:BitmapText = new BitmapText(800, 64, "assets/font_1.png");
		titleText.printText("SAUCE MADE");
		titleText.x = -220;
		titleText.y = -50;
        titleText.scaleX = titleText.scaleY = 0.75;
        addChild(titleText);

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

    public function show():Void {

        visible = true;
    }

    public function hide():Void {

        visible = false;
    }
}