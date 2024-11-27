package com.daviddurhamgames.secretsauce;
	
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.display.Shape;
import openfl.display.Bitmap;
import openfl.Assets;

import com.piratejuice.BitmapText;

class Review extends Sprite {
		
	private var reviewText:BitmapText;
    private var panel:Bitmap;

    private var plus:BitmapData;
    private var minus:BitmapData;

    private var plusIcons:Array<Bitmap> = [];
    private var minusIcons:Array<Bitmap> = [];

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

        // plus and minus
        plus = Assets.getBitmapData("assets/plus2.png");
        minus = Assets.getBitmapData("assets/minus2.png");

        var offset = -64;

        for (i in 0...9) {

            var pIcon = new Bitmap(plus);
            pIcon.scaleX = pIcon.scaleY = 0.5;
		    pIcon.x = (i * 20) + offset;
            pIcon.y = 32;
            addChild(pIcon);
            plusIcons.push(pIcon);

            if (i > 5) {

                pIcon.x -= (6 * 20);
                pIcon.y += 20;
            }

            var mIcon = new Bitmap(minus);
            mIcon.scaleX = mIcon.scaleY = 0.5;
		    mIcon.x = (i * 20) + offset;
            mIcon.y = 32;
            addChild(mIcon);
            minusIcons.push(mIcon);

            if (i > 5) {

                mIcon.x -= (6 * 20);
                mIcon.y += 20;
            }
        }
	}

    public function show(review:String = "", stat:Int = 0):Void {

        reviewText.printText(review);

        for (i in 0...9) {

            plusIcons[i].visible = false;
            minusIcons[i].visible = false;
        }

        if (stat < 0) {

            for (i in 0...9) {

                minusIcons[i].visible = i < Math.abs(stat);
            }
        }
        else if (stat > 0) {

            for (i in 0...9) {

                plusIcons[i].visible = i < Math.abs(stat);
            }
        }

        visible = true;
    }

    public function hide():Void {

        visible = false;
    }
}