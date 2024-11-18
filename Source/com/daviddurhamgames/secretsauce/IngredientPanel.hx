﻿package com.daviddurhamgames.secretsauce;
	
import openfl.display.Sprite;
import openfl.display.Shape;
import openfl.display.Bitmap;
import openfl.Assets;

import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFieldAutoSize;

import com.daviddurhamgames.secretsauce.Ingredient;

class IngredientPanel extends Sprite {
		
	private var valuesText:TextField;
    	
	public function new():Void {
		
		super();
		
        createPanel(120, 80);

        var title:Bitmap = new Bitmap(Assets.getBitmapData("assets/paused_title.png"));
        title.x = -title.width / 2;
        title.y = -40;
        //addChild(title);

        valuesText = new TextField();
		
		var format:TextFormat = new TextFormat("_sans", 12);
		valuesText.defaultTextFormat = format;

		valuesText.textColor = 0xffffff;
		valuesText.selectable = false;
		valuesText.autoSize = TextFieldAutoSize.LEFT;
        valuesText.x = -50;
        valuesText.y = -30;
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

            str += "SALTY: " + ingredient.salt + "\n";
        }

        if (ingredient.sweet > 0) {

            str += "SWEET: " + ingredient.sweet + "\n";
        }

        if (ingredient.spicy > 0) {

            str += "SPICY: " + ingredient.spicy + "\n";
        }

        if (ingredient.sour > 0) {

            str += "SOUR: " + ingredient.sour + "\n";
        }

        valuesText.text = str;
        visible = true;
    }

    public function hide():Void {

        visible = false;
    }
}