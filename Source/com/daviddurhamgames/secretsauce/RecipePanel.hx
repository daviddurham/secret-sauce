package com.daviddurhamgames.secretsauce;
	
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
		
        createPanel(365, 125);

        var titleText:BitmapText = new BitmapText(512, 64, "assets/font_1.png");
		titleText.printText("LAST RECIPE");
		titleText.x = -170;
		titleText.y = -48;
        titleText.scaleX = titleText.scaleY = 0.5;
        addChild(titleText);
		
        recipeText = new BitmapText(800, 64, "assets/font_1.png");
		recipeText.printText("A  X1 B  X1 C  X1");
        recipeText.scaleX = recipeText.scaleY = 0.4;
        recipeText.x = -105;
        recipeText.y = 12;
		addChild(recipeText);

        image1 = new Bitmap(Assets.getBitmapData("assets/ingredient_1.png"), null, true);
        image1.x = -175;
        image1.y = -14;
        addChild(image1);

        image2 = new Bitmap(Assets.getBitmapData("assets/ingredient_2.png"), null, true);
        image2.x = -57;
        image2.y = -14;
        addChild(image2);

        image3 = new Bitmap(Assets.getBitmapData("assets/ingredient_3.png"), null, true);
        image3.x = 61;
        image3.y = -14;
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

            str += "X" + counts[i] + "     ";

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