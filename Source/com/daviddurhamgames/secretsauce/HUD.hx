package com.daviddurhamgames.secretsauce;

import motion.easing.Linear;
import motion.Actuate;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.Assets;
import openfl.Lib;

import com.daviddurhamgames.secretsauce.PausePanel;
import com.daviddurhamgames.secretsauce.CompletePanel;
import com.piratejuice.Audio;

class HUD extends Sprite {
    
    public var pauseButton:BasicButton;
        
    public var pauseMenu:PausePanel;
    public var completeMessage:CompletePanel;
    public var failedMessage:FailedPanel;
    
    private var tutorial:Sprite;
    private var tutorialStep:Int;
    
    public var maskedMessage:Sprite;
    public var maskAnim:Shape;

    // sfx
	private var eventSFXAudio:Audio;

    public function new():Void {
        
        super();

        var centerX:Float = Main.maxWidth / 2;
        var centerY:Float = Main.maxHeight / 2;

        // pause button invokes pause menu and suspends game
		pauseButton = new BasicButton("assets/pause_down.png", "assets/pause_down.png", "assets/pause_down.png");
		pauseButton.addEventListener(MouseEvent.CLICK, onPauseClicked);
		pauseButton.x = (Main.maxWidth - Main.offsetX) - 30;
		pauseButton.y = (Main.offsetY) + 30;
        addChild(pauseButton);

        pauseMenu = new PausePanel();
        pauseMenu.x = centerX;
		pauseMenu.y = centerY;
		pauseMenu.addEventListener("quit", quitConfirm, false, 0, true);
        pauseMenu.addEventListener("back", quitCancel, false, 0, true);
        pauseMenu.addEventListener("restart", restart, false, 0, true);
        addChild(pauseMenu);

        completeMessage = new CompletePanel();
        completeMessage.x = centerX;
		completeMessage.y = centerY;
		addChild(completeMessage);

        failedMessage = new FailedPanel();
        failedMessage.x = centerX;
		failedMessage.y = centerY;
		addChild(failedMessage);

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

    private function helpClicked(event:Event):Void {

        eventSFXAudio.setSound("assets/audio/button_click" + "." + Main.audioFormat);
		eventSFXAudio.play();
        
        disableButtons();
        dispatchEvent(new Event("pause"));
        //helpMenu.show();
    }
    
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
    
    
    /* Help Menu Events */
    
    private function helpCancel(event:Event):Void {
        
        enableButtons();
        
        //helpMenu.hide();
        dispatchEvent(new Event("resume"));
    }
    
    
    /* Keys */
    
    public function onUpPressed():Void {
        
        if (pauseMenu.visible) {
            
            pauseMenu.selectionUp();
        }
        else if (failedMessage.visible) {
            
            failedMessage.selectionUp();
        }
    }
    
    public function onDownPressed():Void {
        
        if (pauseMenu.visible) {
            
            pauseMenu.selectionDown();
        }
        else if (failedMessage.visible) {
            
            failedMessage.selectionDown();
        }
    }
    
    public function onSelectPressed():Void {
        
        if (pauseMenu.visible) {
            
            pauseMenu.select();
        }
        else if (failedMessage.visible) {
            
            failedMessage.select();
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
    
    
    /* Success / Failure Messages */
    
    public function showCompleteMessage():Void {
        
        disableButtons();			
        showMessage(completeMessage);
    }
    
    public function hideCompleteMessage():Void {
        
        hideMessage(completeMessage);
    }
    
    public function showFailedMessage():Void {
        
        disableButtons();			
        showMessage(failedMessage);
    }
    
    public function hideFailedMessage():Void {
        
        hideMessage(failedMessage);
    }
    
    
    /* Showing / Hiding Messages */
    
    private function showMessage(message:Sprite):Void {
        
        message.visible = true;
        
        // init. mask
        maskAnim.visible = true;
        Actuate.tween(maskAnim, 0.5, { scaleY: 1 }).onComplete(onMaskOnComplete).ease(Linear.easeNone);
        
        // mask
        message.mask = maskAnim;
        maskedMessage = cast(message, Sprite);
    }
    
    private function hideMessage(message:Sprite):Void {
        
        // init. mask
        maskAnim.visible = true;
        Actuate.tween(maskAnim, 0.5, { scaleY: 0 }).onComplete(onMaskOffComplete).ease(Linear.easeNone);
        
        // mask
        message.mask = maskAnim;
        maskedMessage = cast(message, Sprite);
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

        pauseButton.x = (Main.maxWidth - Main.offsetX) - 30;
		pauseButton.y = (Main.offsetY) + 30;
    }
}