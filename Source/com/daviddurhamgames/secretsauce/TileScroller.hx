package com.daviddurhamgames.secretsauce;

import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.Assets;

import com.piratejuice.Vector2D;

class TileScroller extends Sprite {
	
	private var tiles:Array<Bitmap>;
	
	private var isStarted:Bool = true;

	// scrolling speeds
	private var dx:Float;
	private var dy:Float;

	// number of tiles	
	private var tileCount:Int;
	
	// tile dimensions
	private var tWidth:Float;
	private var tHeight:Float;

	// how far the tiles have moved
	private var xMoved:Float;
	private var yMoved:Float;
	
	public function new(asset:String = "", vx:Float = 0, vy:Float = 0):Void {
		
		super();
		
		dx = vx;
		dy = vy;
		
		xMoved = 0;
		yMoved = 0;
		
		tiles = new Array<Bitmap>();
		
		// flag once all tiles are drawn
		var isDrawn:Bool = false;
		
		// count tiles
		var c:Int = 0;
		
		var px:Float = 0;
		var py:Float = 0;
		
		while(!isDrawn) {
			
			var tile:Bitmap = new Bitmap(Assets.getBitmapData(asset));
			addChild(tile);
			tiles.push(tile);
			
			// if this is the first tile, get the dimensions 
			// and set the first position accordingly
			if (c == 0)	{
				
				tWidth = tile.width;
				tHeight = tile.height;
				
				px = -tWidth;
				py = -tHeight;
			}
			
			tile.x = px;
			tile.y = py;
			
			if (px < Main.maxWidth) {
				
				px += tWidth;
			}
			else {
				
				if (py < Main.maxHeight) {
					
					// reset row
					px = -tWidth;
					py += tHeight;
				}
				else {
					
					isDrawn = true;
				}
			}
			
			// increment count
			c++;
		}
		
		tileCount = tiles.length;
	}
	
	public function start():Void {
		
		isStarted = true;
	}
	
	public function stop():Void {
		
		isStarted = false;
	}
	
	public function show():Void {
		
		// show all tiles
	}
	
	public function hide():Void {
		
		// hide all tiles
	}
	
	public function update():Void {
		
		if (isStarted) {
			
			// keep track of movement
			xMoved += dx;
			yMoved += dy;
			
			// move all tiles
			for (tile in tiles) {
				
				tile.x += dx;
				tile.y += dy;
			}
			
			if (xMoved >= tWidth) {
				
				for (tile in tiles) {
					
					tile.x -= xMoved;
				}
				
				// reset amount moved (horizontal)
				xMoved -= tWidth;
			}
			
			if (yMoved >= tHeight) {
				
				for (tile in tiles) {
					
					tile.y -= yMoved;
				}
				
				// reset amount moved (vertical)
				yMoved -= tHeight;
			}
		}
	}
}