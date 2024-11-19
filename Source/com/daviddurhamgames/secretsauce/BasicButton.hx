package com.daviddurhamgames.secretsauce;
	
import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.PixelSnapping;
import openfl.events.Event;
import openfl.events.MouseEvent;

import openfl.Assets;

class BasicButton extends Sprite {
	
	public var id:Int = 0;
	
	private var idleBmp:Bitmap;
	private var overBmp:Bitmap;
	private var downBmp:Bitmap;
	private var disabledBmp:Bitmap;
	
	public var isDisabled:Bool;

	private var icon:Sprite;
	private var iconPosX:Float;
	private var iconPosY:Float;
	private var iconOverX:Float;
	private var iconOverY:Float;
	
	
	/* Constructor */
	
	public function new(idle:String, ?over:String, ?down:String, ?disabled:String):Void {
		
		super();
		
		idleBmp = new Bitmap(Assets.getBitmapData(idle), PixelSnapping.AUTO, true);
		idleBmp.smoothing = true;
		idleBmp.x = -idleBmp.width / 2;
		idleBmp.y = -idleBmp.height / 2;
		
		if (over != null) {
			
			overBmp = new Bitmap(Assets.getBitmapData(over), PixelSnapping.AUTO, true);
			overBmp.smoothing = true;
			overBmp.x = -overBmp.width / 2;
			overBmp.y = -overBmp.height / 2;
		}
		
		if (down != null) {
			
			downBmp = new Bitmap(Assets.getBitmapData(down), PixelSnapping.AUTO, true);
			downBmp.smoothing = true;
			downBmp.x = -downBmp.width / 2;
			downBmp.y = -downBmp.height / 2;
		}
		
		if (disabled != null) {
			
			disabledBmp = new Bitmap(Assets.getBitmapData(disabled), PixelSnapping.AUTO, true);
			disabledBmp.smoothing = true;
			disabledBmp.x = -disabledBmp.width / 2;
			disabledBmp.y = -disabledBmp.height / 2;
		}
		
		addChild(idleBmp);
		
		buttonMode = true;
		mouseChildren = false;
		
		// add rollover/rollout listeners
		addEventListener(MouseEvent.MOUSE_OVER, onOver);
		addEventListener(MouseEvent.MOUSE_OUT, onOut);
		addEventListener(MouseEvent.MOUSE_DOWN, onDown);
		addEventListener(MouseEvent.MOUSE_UP, onUp);
	}
	
	public function addIcon(sprite:Sprite, px:Float = 0, py:Float = 0, ox:Float = null, oy:Float = null):Void {

		icon = sprite;
		icon.x = px;
		icon.y = py;
		addChild(icon);

		iconPosX = px;
		iconPosY = py;

		iconOverX = ox == null ? iconPosX : ox;
		iconOverY = oy == null ? iconPosY : oy;
	}

	public function onOver(event:MouseEvent = null):Void {
		
		if (overBmp != null) {
			
			hideAll();
			addChild(overBmp);
		}
		else {
			
			scaleX = scaleY = 1.05;
		}

		if (icon != null) {

			addChild(icon);
			icon.x = iconOverX;
			icon.y = iconOverY;
		}
	}
	
	public function onOut(event:MouseEvent = null):Void {
		
		if (overBmp != null) {
			
			hideAll();
			addChild(idleBmp);
		}
		else {
		
			scaleX = scaleY = 1.0;
		}

		if (icon != null) {

			addChild(icon);
			icon.x = iconPosX;
			icon.y = iconPosY;
		}
	}
	
	public function onDown(event:MouseEvent = null):Void {
		
		if (downBmp != null) {
			
			hideAll();
			addChild(downBmp);
		}
		else {
			
			scaleX = scaleY = 0.95;
		}

		if (icon != null) {

			addChild(icon);
			icon.x = iconOverX;
			icon.y = iconOverY;
		}
	}
	
	public function onUp(event:MouseEvent = null):Void {
		
		if (downBmp != null) {
		
			hideAll();
			addChild(idleBmp);
		}
		else {
		
			scaleX = scaleY = 1.0;
		}

		if (icon != null) {

			addChild(icon);
			icon.x = iconPosX;
			icon.y = iconPosY;
		}
	}
	
	private function hideAll():Void {
		
		removeChild(idleBmp);
		
		if (overBmp != null) removeChild(overBmp);
		if (downBmp != null) removeChild(downBmp);
		if (disabledBmp != null) removeChild(disabledBmp);
	}

	public function setEnabled(flag:Bool):Void {

		mouseEnabled = flag;
	}
}