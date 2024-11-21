package com.daviddurhamgames.secretsauce;
	
import openfl.display.Sprite;
import openfl.display.Shape;
import openfl.display.Bitmap;
import openfl.Assets;

import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFieldAutoSize;

import com.piratejuice.BitmapText;

class ReviewsPanel extends Sprite {
		
	private var reviewsText:TextField;
    private var notes:Array<Review>;
    	
	public function new():Void {
		
		super();
		
        createPanel(820, 300);

        var titleText:BitmapText = new BitmapText(1024, 64, "assets/font_1.png");
		titleText.printText("YESTERDAY'S REVIEWS");
		titleText.x = -200;
		titleText.y = -125;
        titleText.scaleX = titleText.scaleY = 0.5;
        addChild(titleText);

        /*
        reviewsText = new TextField();
		
		var format:TextFormat = new TextFormat("_sans", 12);
		reviewsText.defaultTextFormat = format;

		reviewsText.textColor = 0xffffff;
		reviewsText.selectable = false;
		reviewsText.autoSize = TextFieldAutoSize.LEFT;
        reviewsText.x = -80;
        reviewsText.y = -35;
		addChild(reviewsText);
        */

        notes = [];
        var positions:Array<Int> = [-300, -100, 100, 300];
        
        for (i in 0...4) {

            var review:Review = new Review();
            review.x = positions[i];
            review.y = 25;
            addChild(review);
            notes.push(review);
        }

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

        trace(reviews);
        var str:String = "";
        var count:Int = 0;

        for (note in notes) {

            note.hide();
        }

        for (review in reviews) {

            notes[count].show(review);
            //str += review + "\n\n";
            count++;
        }
        
        //reviewsText.text = str;
        visible = true;
    }

    public function hide():Void {

        visible = false;
    }
}