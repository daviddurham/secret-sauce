package com.daviddurhamgames.secretsauce;
	
import openfl.display.Sprite;
import openfl.display.Shape;
import openfl.display.MovieClip;
import openfl.display.Bitmap;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.Assets;

import com.daviddurhamgames.secretsauce.BasicButton;

class CompletePanel extends Sprite {
	
    public var buttonQuit:BasicButton;
    public var buttonRestart:BasicButton;
    public var buttonBack:BasicButton;
    
    // selector
    public var selector:MovieClip;
    
    private var buttonList:Array<BasicButton>;
    private var currButton:Int;
	
	public function new():Void {
		
		super();
		
        createPanel(450, 180);

        var title:Bitmap = new Bitmap(Assets.getBitmapData("assets/level_complete_title.png"));
        title.smoothing = true;
		title.scaleX = title.scaleY = 0.5;
        title.x = -title.width / 2;
        title.y = -title.height / 2;
        addChild(title);

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

    public function show():Void {

        visible = true;
    }

    public function hide():Void {

        visible = false;
    }
}