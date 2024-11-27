package com.daviddurhamgames.secretsauce;
	
import openfl.display.Sprite;
import openfl.display.Shape;
import openfl.display.Bitmap;
import openfl.Assets;

import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFieldAutoSize;

import com.daviddurhamgames.secretsauce.Ingredient;
import com.piratejuice.BitmapText;

class IngredientPanel extends Sprite {
		
	private var valuesText:BitmapText;
    	
	public function new():Void {
		
		super();
		
        createPanel(230, 125);

        valuesText = new BitmapText(480, 200, "assets/font_1.png", 64, 42, 88);
		valuesText.printText("");
        valuesText.scaleX = valuesText.scaleY = 0.5;
        valuesText.x = -95;
        valuesText.y = -40;
		addChild(valuesText);

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

    public function show(ingredient:Ingredient):Void {

        var str:String = "";

        if (ingredient.salt > 0) {

            str += "SALTY " + ingredient.salt + " ";
        }

        if (ingredient.sweet > 0) {

            str += "SWEET " + ingredient.sweet + " ";
        }

        if (ingredient.spicy > 0) {

            str += "SPICY " + ingredient.spicy + " ";
        }

        if (ingredient.sour > 0) {

            str += "SOUR " + ingredient.sour + " ";
        }

        valuesText.printText(str);
        visible = true;
    }

    public function hide():Void {

        visible = false;
    }
}