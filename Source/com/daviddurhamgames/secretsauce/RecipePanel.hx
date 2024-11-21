﻿package com.daviddurhamgames.secretsauce;
	
import openfl.display.Sprite;
import openfl.display.Shape;
import openfl.display.Bitmap;
import openfl.Assets;

import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFieldAutoSize;

import com.piratejuice.BitmapText;

class RecipePanel extends Sprite {
	
	private var recipeText:BitmapText;
    
    private var image1:Bitmap;
    private var image2:Bitmap;
    private var image3:Bitmap;

	public function new():Void {
		
		super();
		
        createPanel(320, 120);

        var titleText:BitmapText = new BitmapText(512, 64, "assets/font_1.png");
		titleText.printText("LAST RECIPE");
		titleText.x = -145;
		titleText.y = -40;
        titleText.scaleX = titleText.scaleY = 0.5;
        addChild(titleText);
		
        recipeText = new BitmapText(640, 64, "assets/font_1.png");
		recipeText.printText("A  X1 B  X1 C  X1");
        recipeText.scaleX = recipeText.scaleY = 0.4;
        recipeText.x = -112;
        recipeText.y = 14;
		addChild(recipeText);

        image1 = new Bitmap(Assets.getBitmapData("assets/ingredient1.png"));
        image1.x = -147;
        image1.y = 10;
        addChild(image1);

        image2 = new Bitmap(Assets.getBitmapData("assets/ingredient2.png"));
        image2.x = -47;
        image2.y = 10;
        addChild(image2);

        image3 = new Bitmap(Assets.getBitmapData("assets/ingredient3.png"));
        image3.x = 53;
        image3.y = 10;
        addChild(image3);

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

    public function show(recipe:Array<String>):Void {

        var str:String = "";

        var arr:Array<String> = [];
        var counts:Array<Int> = [];
        var images:Array<Bitmap> = [image1, image2, image3];

        for (i in 0...recipe.length) {

            var isMultiple:Bool = false;

            for (j in 0...arr.length) {

                if (arr[j] == recipe[i]) {

                    counts[j]++;
                    isMultiple = true;
                    break;
                }
            }

            if (!isMultiple) {

                arr.push(recipe[i]);
                counts.push(1);
            }
        }

        image1.visible = false;
        image2.visible = false;
        image3.visible = false;

        for (i in 0...counts.length) {

            str += "X" + counts[i] + "    ";

            images[i].bitmapData = Assets.getBitmapData(arr[i]);
            images[i].visible = true;
        }

        recipeText.printText(str);
        visible = true;
    }

    public function hide():Void {

        visible = false;
    }
}