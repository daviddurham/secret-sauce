package com.daviddurhamgames.secretsauce;

import motion.easing.Linear;
import motion.Actuate;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFieldAutoSize;
import openfl.Assets;
import openfl.Lib;

import com.daviddurhamgames.secretsauce.PausePanel;
import com.daviddurhamgames.secretsauce.SauceMadePanel;
import com.daviddurhamgames.secretsauce.GameCompletePanel;
import com.daviddurhamgames.secretsauce.IngredientPanel;
import com.daviddurhamgames.secretsauce.Ingredient;
import com.piratejuice.BitmapText;
import com.piratejuice.Audio;

class HUD extends Sprite {
    
    public var pauseButton:BasicButton;
        
    public var pauseMenu:PausePanel;
    public var sauceMadePanel:SauceMadePanel;
    public var gameCompletePanel:GameCompletePanel;
    public var ingredientPanel:IngredientPanel;
    public var reviewsPanel:ReviewsPanel;
    public var recipePanel:RecipePanel;
    
    private var tutorial:Sprite;
    private var tutorialStep:Int;
    
    public var maskedMessage:Sprite;
    public var maskAnim:Shape;

    // sfx
	private var eventSFXAudio:Audio;

    private var dayText:BitmapText;
    private var timeText:BitmapText;

    public function new():Void {
        
        super();

        var centerX:Float = Main.maxWidth / 2;
        var centerY:Float = Main.maxHeight / 2;

        dayText = new BitmapText(256, 128, "assets/font_1.png");
		dayText.printText("");
		dayText.x = Main.offsetX + 20;
		dayText.y = Main.offsetY + 25;
        dayText.scaleX = dayText.scaleY = 0.75;
        addChild(dayText);

        timeText = new BitmapText(64, 64, "assets/font_1.png");
		timeText.printText("");
		timeText.x = centerX - 32;
		timeText.y = Main.offsetY + 10;
        //addChild(timeText);        

        sauceMadePanel = new SauceMadePanel();
        sauceMadePanel.x = centerX;
		sauceMadePanel.y = centerY;
		addChild(sauceMadePanel);

        gameCompletePanel = new GameCompletePanel();
        gameCompletePanel.x = centerX;
		gameCompletePanel.y = centerY;
        addChild(gameCompletePanel);

        ingredientPanel = new IngredientPanel();
		ingredientPanel.x = (Main.maxWidth - Main.offsetX) - 140;
		ingredientPanel.y = (Main.maxHeight - Main.offsetY) - 90;
        addChild(ingredientPanel);

        reviewsPanel = new ReviewsPanel();
        reviewsPanel.x = centerX;
        reviewsPanel.y = centerY;
		addChild(reviewsPanel);

        recipePanel = new RecipePanel();
        recipePanel.x = Main.offsetX + 190;
        recipePanel.y = (Main.maxHeight - Main.offsetY) - 90;
		addChild(recipePanel);

        maskAnim = new Shape();
        maskAnim.graphics.beginFill(0x00ff00);
        maskAnim.graphics.drawRect(-500, -250, 1000, 500);
        maskAnim.graphics.endFill();
        maskAnim.x = centerX;
        maskAnim.y = centerY;
        maskAnim.scaleY = 0;
        maskAnim.visible = false;
        addChild(maskAnim);

        // create audio object
		eventSFXAudio = new Audio();
		//eventSFXAudio.setVolume(Global.sfxVolume);

        // pause button invokes pause menu and suspends game
		pauseButton = new BasicButton("assets/pause_button_idle.png", "assets/pause_button_over.png", "assets/pause_button_over.png");
		pauseButton.addEventListener(MouseEvent.CLICK, onPauseClicked);
        pauseButton.scaleX = pauseButton.scaleY = 0.75;
		pauseButton.x = (Main.maxWidth - Main.offsetX) - 75;
		pauseButton.y = (Main.offsetY) + 65;
        addChild(pauseButton);

        pauseMenu = new PausePanel();
        pauseMenu.x = centerX;
		pauseMenu.y = centerY;
		pauseMenu.addEventListener("quit", quitConfirm, false, 0, true);
        pauseMenu.addEventListener("back", quitCancel, false, 0, true);
        pauseMenu.addEventListener("restart", restart, false, 0, true);
        addChild(pauseMenu);
    }
    
    public function setDay(day:Int):Void {

        dayText.printText("DAY " + day);
    }

    public function setTime(time:Int):Void {

        timeText.printText(Std.string(time));
    }

    public function enableButtons():Void {
        
        pauseButton.mouseEnabled = true;
    }
    
    public function disableButtons():Void {
        
        pauseButton.mouseEnabled = false;
    }

    public function cleanUp():Void {
        
        pauseMenu.removeEventListener("quit", quitConfirm);
        pauseMenu.removeEventListener("back", quitCancel);
        pauseMenu.removeEventListener("restart", restart);
        removeChild(pauseMenu);
        pauseMenu = null;
    }
    
    private function onPauseClicked(event:Event):Void {
        
        eventSFXAudio.setSound("assets/audio/button_click" + "." + Main.audioFormat);
		eventSFXAudio.play();

        disableButtons();
            
        dispatchEvent(new Event("pause"));
        pauseMenu.show();
    }

    /* Pause Menu Events */
    
    private function quitConfirm(event:Event):Void {
        
        dispatchEvent(new Event("quit"));
    }
    
    private function quitCancel(event:Event):Void {
        
        enableButtons();
        
        pauseMenu.hide();
        dispatchEvent(new Event("resume"));
    }
    
    private function restart(event:Event):Void {
        
        pauseMenu.hide();
        dispatchEvent(new Event("restart"));
    }
    
    
    /* Keys */
    
    public function onUpPressed():Void {
        
        if (pauseMenu.visible) {
            
            pauseMenu.selectionUp();
        }
        else if (gameCompletePanel.visible) {
            
            gameCompletePanel.selectionUp();
        }
    }
    
    public function onDownPressed():Void {
        
        if (pauseMenu.visible) {
            
            pauseMenu.selectionDown();
        }
        else if (gameCompletePanel.visible) {
            
            gameCompletePanel.selectionDown();
        }
    }
    
    public function onSelectPressed():Void {
        
        if (pauseMenu.visible) {
            
            pauseMenu.select();
        }
        else if (gameCompletePanel.visible) {
            
            gameCompletePanel.select();
        }
    }
    
    
    /* Tutorial */
    
    public function showTutorial(step:Int = 1):Void {
        
        // ensure old tutorial is removed
        hideTutorial();
        
        /*
        var TutorialClass:Class = getDefinitionByName("Tutorial" + step) as Class;
        tutorial = new TutorialClass();
        addChildAt(tutorial, getChildIndex(helpMenu));
        */

        tutorialStep = step;
    }
    
    public function getTutorialStep():Int {
        
        return tutorialStep;
    }
    
    public function setTutorialStep(step:Int = 0):Void {
        
        tutorialStep = step;
    }
    
    public function hideTutorial():Void {
        
        if (tutorial != null) {
            
            removeChild(tutorial);
            tutorial = null;
        }
    }
    
    public function showIngredientPanel(ingredient:Ingredient):Void {
        
        ingredientPanel.show(ingredient);
    }
    
    public function hideIngredientPanel():Void {
        
        ingredientPanel.hide();
    }
    
    public function showReviewsPanel(reviews:Array<String>):Void {
        
        reviewsPanel.show(reviews);
    }
    
    public function hideReviewsPanel():Void {
        
        reviewsPanel.hide();
    }

    public function showRecipePanel(recipe:Array<String>):Void {
        
        recipePanel.show(recipe);
    }
    
    public function hideRecipePanel():Void {
        
        recipePanel.hide();
    }
    
    public function showSauceMadePanel():Void {
        
        disableButtons();			
        showMessage(sauceMadePanel);
    }
    
    public function hideSauceMadePanel(snap:Bool = false):Void {
        
        hideMessage(sauceMadePanel, snap);
    }
    
    public function showGameCompletePanel():Void {
        
        disableButtons();			
        showMessage(gameCompletePanel);
    }
    
    public function hideGameCompletePanel(snap:Bool = false):Void {
        
        hideMessage(gameCompletePanel, snap);
    }
    
    
    /* Showing / Hiding Messages */
    
    private function showMessage(message:Sprite, snap:Bool = false):Void {
        
        message.visible = true;
        
        if (!snap) {

            // init. mask
            maskAnim.visible = true;
            Actuate.tween(maskAnim, 0.5, { scaleY: 1 }).onComplete(onMaskOnComplete).ease(Linear.easeNone);
            
            // mask
            message.mask = maskAnim;
            maskedMessage = cast(message, Sprite);
        }
    }
    
    private function hideMessage(message:Sprite, snap:Bool = false):Void {
        
        if (snap) {

            message.visible = false;
        }
        else {

            // init. mask
            maskAnim.visible = true;
            Actuate.tween(maskAnim, 0.5, { scaleY: 0 }).onComplete(onMaskOffComplete).ease(Linear.easeNone);
            
            // mask
            message.mask = maskAnim;
            maskedMessage = cast(message, Sprite);
        }
    }
    
    private function onMaskOnComplete():Void {
        
        maskAnim.visible = false;
        maskedMessage.mask = null;
    }
    
    private function onMaskOffComplete():Void {
        
        maskAnim.visible = false;
        
        maskedMessage.visible = false;
        maskedMessage.mask = null;
    }    

    public function onResize(event:Event = null):Void {

        pauseButton.x = (Main.maxWidth - Main.offsetX) - 75;
		pauseButton.y = (Main.offsetY) + 65;
    }
}