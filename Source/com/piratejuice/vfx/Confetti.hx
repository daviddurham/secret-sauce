package com.piratejuice.vfx;

import flash.display.Sprite;
import com.piratejuice.vfx.ConfettiParticle;

class Confetti extends Sprite {

    public var pieces:Array<ConfettiParticle>;
    public var countdown:Float = 0;
    public var num:Int = 0;
    public var drift:Float = 0;
    public var baseFallSpeed:Float = 3;

    public var isStarted:Bool = false;
    public var isRunning:Bool = true;

    public var screenWidth:Int = 0;
    public var screenHeight:Int = 0;

	public function new(particles:Int, maxWidth:Int, maxHeight:Int, df:Float):Void {

        super();

		num = particles;

        screenWidth = maxWidth;
        screenHeight = maxHeight;

		drift = df;

		pieces = [];
		countdown = Math.floor(Math.random() * 10) + 1;
		
		// create confetti
		for (i in 0...num) {
			
			var r:Float = Math.random();
			var type:String = "confetti/confetti_0";
			var highlight:String = "confetti/highlight_a";
			var shadow:String = "confetti/shadow_a";
			
			if (r < 0.25) {
				
				type = "confetti/confetti_1";
				highlight = "confetti/highlight_a";
				shadow = "confetti/shadow_a";
			}
			else if (r < 0.5) {
				
				type = "confetti/confetti_2";
				highlight = "confetti/highlight_b";
				shadow = "confetti/shadow_b";
			}
			else if (r < 0.75) {
				
				type = "confetti/confetti_3";
				highlight = "confetti/highlight_b";
				shadow = "confetti/shadow_b";
			}
			
			// visual attributes
			var piece:ConfettiParticle = new ConfettiParticle("assets/" + type + ".png", "assets/" + highlight + ".png", "assets/" + shadow + ".png", this);
			
			piece.rotation = Math.random() * 360;
			piece.scaleX = piece.scaleY = 0.4 + (Math.random() * 0.4);
			piece.visible = false;
			
			// movement attributes
			piece.rot = Math.random() * 2;
			piece.flip = Math.random() * 0.15;
			
			piece.dir = Math.floor(Math.random() * 2);
			
            if (piece.dir == 0) {
                
                piece.dir = -1;
            }
			
			piece.vx = piece.dir;
			piece.acc = Math.random() * 0.1;
			
			pieces.push(piece);
		}
	}
	
	public function cleanup():Void {
		
        /*
		if (pieces) {
			
			while (pieces.length > 0) {
				
				pieces[0] = null;
				pieces.splice(0, 1);
			}
		}
        */
	}
	
	public function start(precook:Float = 0):Void {
		
		this.isStarted = true;
		
		if (precook > 0) {
			
			var t:Float = 0;
			var step:Float = 1 / 60;
			
			while (t < precook) {
				
				update();
				t += step;
			}
		}
	}
	
	public function stop():Void {
		
		isStarted = false;
	}
	
	public function pause():Void {
		
		isRunning = false;
	}
	
	public function resume():Void {
		
		isRunning = true;
	}
	
	public function update():Void {
		
		if (isStarted) {
			
			// spawn pieces
			if (countdown > 0) {
				
				countdown--;
			}
			else {
				
				for (i in 0...pieces.length) {
					
					if (!pieces[i].visible) {
						
						pieces[i].x = (Math.random() * screenWidth) - (drift * 200);
						pieces[i].y = Math.random() * -300;
						pieces[i].visible = true;

						pieces[i].body.scaleY = 1;
						pieces[i].shadow.scaleY = 1;
						pieces[i].highlight.scaleY = 1;
						break;
					}
				}
				
				// countdown to next spawn
				countdown = Math.floor(Math.random() * 20);
			}
		}
		
		for (i in 0...pieces.length) {
			
			if (pieces[i].visible) {
				
				pieces[i].x += ((Math.cos(pieces[i].vx * 0.5) * (pieces[i].scaleX * 3)) + drift);
				pieces[i].vx += pieces[i].acc;
				
				pieces[i].y += (baseFallSpeed * pieces[i].scaleX);
				pieces[i].rotation += pieces[i].rot;
				
				// roation clamping
				if (pieces[i].rotation > 360) {
					
					pieces[i].rotation -= 360;
				}
				else if (pieces[i].rotation < 0) {
					
					pieces[i].rotation += 360;
				}
				
				if (pieces[i].y > screenHeight + 200) {
					
					pieces[i].visible = false;
				}			
				
				// rotation factor on highlight/shadow
				var sS = (Math.cos(pieces[i].rotation * (Math.PI / 180)) + 1) / 2;
				var hS = 1 - ((Math.cos(pieces[i].rotation * (Math.PI / 180)) + 1) / 2);
				
				pieces[i].body.scaleY += pieces[i].flip;
				pieces[i].shadow.scaleY += pieces[i].flip;
				pieces[i].highlight.scaleY += pieces[i].flip;
				
				if (pieces[i].body.scaleY >= 1 || pieces[i].body.scaleY <= -1) {
					
					pieces[i].flip *= -1;

					if (pieces[i].body.scaleY > 1) {
						
						pieces[i].body.scaleY = 1;
						pieces[i].shadow.scaleY  = 1;
						pieces[i].highlight.scaleY  = 1;
					}
					else if (pieces[i].body.scaleY < -1) {
						
						pieces[i].body.scaleY  = -1;
						pieces[i].shadow.scaleY  = -1;
						pieces[i].highlight.scaleY  = -1;
					}
				}

				pieces[i].shadow.alpha = (1 - Math.abs(pieces[i].shadow.scaleY)) * sS;
				pieces[i].highlight.alpha = (1 - Math.abs(pieces[i].highlight.scaleY)) * hS;
			}
		}
	}
}