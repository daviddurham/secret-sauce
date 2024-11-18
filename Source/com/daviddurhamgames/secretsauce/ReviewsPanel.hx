package com.daviddurhamgames.secretsauce;
	
import openfl.display.Sprite;
import openfl.display.Shape;
import openfl.display.Bitmap;
import openfl.Assets;

import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFieldAutoSize;

class ReviewsPanel extends Sprite {
		
	private var reviewsText:TextField;
    	
	public function new():Void {
		
		super();
		
        createPanel(270, 140);

        var title:Bitmap = new Bitmap(Assets.getBitmapData("assets/reviews_title.png"));
		title.x = -title.width / 2;
        title.y = -70;
        addChild(title);

        reviewsText = new TextField();
		
		var format:TextFormat = new TextFormat("_sans", 12);
		reviewsText.defaultTextFormat = format;

		reviewsText.textColor = 0xffffff;
		reviewsText.selectable = false;
		reviewsText.autoSize = TextFieldAutoSize.LEFT;
        reviewsText.x = -80;
        reviewsText.y = -35;
		addChild(reviewsText);

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

    public function show(reviews:Array<String>):Void {

        var str:String = "";

        for (review in reviews) {

            str += review + "\n\n";
        }
        
        reviewsText.text = str;
        visible = true;
    }

    public function hide():Void {

        visible = false;
    }
}