package com.daviddurhamgames.secretsauce;
	
import openfl.display.Sprite;
import openfl.display.Shape;
import openfl.display.Bitmap;
import openfl.Assets;

import com.piratejuice.BitmapText;

class Review extends Sprite {
		
	private var reviewText:BitmapText;
    private var panel:Bitmap;

	public function new():Void {
		
		super();

        panel = new Bitmap(Assets.getBitmapData("assets/review_panel.png"));
        panel.scaleX = panel.scaleY = 0.75;
		panel.x = -panel.width / 2;
        panel.y = -panel.height / 2;
        addChild(panel);

        reviewText = new BitmapText(290, 300, "assets/font_1.png", 64, 42, 80, true);
		reviewText.printText("");
		reviewText.x = -70;
		reviewText.y = -70;
        reviewText.scaleX = reviewText.scaleY = 0.4;
        addChild(reviewText);
	}

    public function show(review:String = ""):Void {

        reviewText.printText(review);
        visible = true;
    }

    public function hide():Void {

        visible = false;
    }
}