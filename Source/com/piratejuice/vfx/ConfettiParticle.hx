package com.piratejuice.vfx;

import openfl.Assets;
import flash.display.Sprite;
import flash.display.Bitmap;

class ConfettiParticle extends Sprite {

    public var container:Sprite;

    public var body:Sprite;
    public var shadow:Sprite;
    public var highlight:Sprite;

    public var rot:Float = 0;
    public var dir:Int = 0;
    public var flip:Float = 0;

    public var vx:Float = 0;
    public var acc:Float = 0;

	public function new(type:String, highlightType:String, shadowType:String, parent:Sprite):Void {

		super();

		container = parent;
		
        body = new Sprite();
        addChild(body);

		var bodyBitmap:Bitmap = new Bitmap(Assets.getBitmapData(type));
		bodyBitmap.x = -bodyBitmap.width / 2;
        bodyBitmap.y = -bodyBitmap.height / 2;
		body.addChild(bodyBitmap);

        highlight = new Sprite();
        addChild(highlight);

		var highlightBitmap:Bitmap = new Bitmap(Assets.getBitmapData(highlightType));
		highlightBitmap.x = -highlightBitmap.width / 2;
        highlightBitmap.y = -highlightBitmap.height / 2;
		highlight.addChild(highlightBitmap);

        shadow = new Sprite();
        addChild(shadow);

		var shadowBitmap:Bitmap = new Bitmap(Assets.getBitmapData(shadowType));
		shadowBitmap.x = -shadowBitmap.width / 2;
        shadowBitmap.y = -shadowBitmap.height / 2;
		shadow.addChild(shadowBitmap);

        container.addChild(this);
	}
}