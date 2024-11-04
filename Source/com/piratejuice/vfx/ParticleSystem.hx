package com.piratejuice.vfx;

import com.piratejuice.Vector3D;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.geom.Point;
import openfl.geom.ColorTransform;
import flash.Lib;

import com.piratejuice.vfx.Particle;

class ParticleSystem extends Sprite {
	
	// 180 diveded by Pi - for 'orient to path' calculation
	private var D180_OVER_PI:Float = 57.2957795;
	
	// state flags
	private var isRunning:Bool;
	private var isPaused:Bool;
	
	// array stores references to particles
	private var particles:Array<Particle>;
	
	// total number of particles
	private var count:Int;
	
	// how many frames until particle is removed
	private var lifespan:Float;
	
	// random element added to lifespan
	private var lifeRandom:Float;
	
	// basic x, y and z speeds
	private var _vel:Vector3D;
	
	// random element added to speed
	private var _velRandom:Vector3D;
	
	// rotation increment
	private var rotate:Float;
	
	// random element added to rotation
	private var rotateRandom:Float;
	
	// scaling factor
	private var scalingX:Float;
	private var scalingY:Float;

	// initial scale
	private var startScaleX:Float;
	private var startScaleY:Float;
	
	// simple gravity factor
	private var _forces:Vector3D;
	
	// turn alpha fading on/off
	private var isAlpha:Bool;
	private var alphaEasing:Float;
	
	// rotates in the direction of movement
	private var isOrientToPath:Bool;
	
	// rotation is set to that of the emitter
	private var isOrientToSource:Bool;
	
	// number of frames between particle spawns
	private var spawnInterval:Float;
	private var spawnNext:Float;
	
	// random deviation of the spawn point from the centre
	private var _spawnArea:Vector3D;
	
	// frame offset allows us to start a particle system a number
	// of frames in (so we don't have to wait for a stream to get going)
	private var frameOffset:Int;
	
	// attach the particles to this clip
	private var holder:Sprite;
	
	// for set duration bursts
	private var duration:Int;
	
	// coloring
	private var startColour:Array<Float>;
	private var endColour:Array<Float>;
	
	// flags to detect completion
	private var willComplete:Bool;
	private var isComplete:Bool;
	
	private var _floor:Int;
	private var _bounce:Float;
	
	
	/* Constructor */
	
	public function new():Void {
		
		super();
		
		// system is stopped, pause is off
		isRunning = false;
		isPaused = false;
		
		// create empty array
		particles = new Array<Particle>();
		
		// default particle system attributes
		count = 20;
		lifespan = 10;
		
		rotation = 0.0;
		scalingX = 1.0;
		scalingY = 1.0;

		startScaleX = 1.0;
		startScaleY = 1.0;
		
		_vel = new Vector3D();
		_velRandom = new Vector3D();
		
		lifeRandom = 0;
		rotateRandom = 0;
		
		// extra effects
		_forces = new Vector3D();
		isOrientToPath = false;
		isOrientToSource = false;
		
		// basic alpha on
		isAlpha = true;
		alphaEasing = 0;
		
		// set interval to zero (spawn every frame)
		spawnInterval = 0;
		spawnNext = 0;
		
		// by default spawn only at the centre point
		_spawnArea = new Vector3D();
		
		// frame offset default is zero (no offset)
		frameOffset = 0;
		
		// how long to continue stream (0 is infinate)
		duration = 0;
		
		// dispatches events when 'complete'
		willComplete = false;
		isComplete = false;
		
		// floor and bounce
		_floor = -1;
		_bounce = 1.0;
	}
	
	
	/* Interface Functions */
	
	public function start(d:Int = 0):Void {
		
		// start a continuos particle stream
		duration = d;
		isRunning = true;
		
		if (duration != 0) willComplete = true;
		else willComplete = false;
		
		isComplete = false;
		
		// do any frame offsetting (run updates)
		for (i in 0...frameOffset) {
			
			update();
		}
	}
	
	// stop spawning particles - exisiting particles continue
	public function stop():Void {
		
		isRunning = false;
	}
	
	// stops all particles where they are and stops spawning
	public function pause():Void {
		
		isPaused = true;
	}
	
	// sets particles moving again and recommences spawning
	public function resume():Void {
		
		isPaused = true;
	}
	
	// spawn all particles at once
	public function burst():Void {
		
		if (!isPaused) {
			
			for (i in 0...count) {
				
				addParticle(randSpeed(_vel.x, _velRandom.x), randSpeed(_vel.y, _velRandom.y), randSpeed(_vel.z, _velRandom.z), randLife(lifespan));
			}
		}
		
		willComplete = true;
		isComplete = false;
	}
	
	// spawn all particles at once in a uniform horizontal ring
	public function ringBurst(rand:Int = 0):Void {
		
		if (!isPaused) {
			
			for (i in 0...count) {
				
				// calcuate velocity
				var pos:Point = Point.polar(1, (i / count) * Math.PI * 2);
				
				//pos.x += (Math.random() * rand) - (rand * 0.5);
				//pos.y += (Math.random() * rand) - (rand * 0.5);
				
				addParticle(pos.x * _velRandom.x, 0, pos.y * _velRandom.z, randLife(lifespan));
			}
		}
		
		willComplete = true;
		isComplete = false;
	}
	
	
	/* Initialisation Functions */

	public function init(clip:String, num:Int, life:Float, dx:Float, dy:Float, dz:Float, holderRef:Sprite = null, frames:Int = 1, width:Int = 0, height:Int = 0, animDelay:Int = 1):Void {
		
		if (holderRef == null) holder = this;
		else holder = holderRef;
		
		// set number of particles
		count = num;
		lifespan = life;
		
		// set speed
		_vel.x = dx;
		_vel.y = dy;
		_vel.z = dz;
		
		// finally create all the particles
		for (i in 0...count) {
			
			// create particle and put in list
			var p:Particle = new Particle(clip, frames, width, height, animDelay);
			particles.push(p);
			
			// initial settings
			p.pos.x = 0;
			p.pos.y = 0;
			p.pos.z = 0;
			p.visible = false;
			p.life = 1;
			
			// add to holder
			holder.addChild(p);
		}
	}
	
	/** Sets the initial scale of the particles
	@param scale - the scaling factor applied */
	public function setStartScale(xscale:Float, yscale:Float = 0):Void {
		
		startScaleX = xscale;
		startScaleY = yscale;
	}

	/** Sets the the size of particles change. A factor greater than 1 increases the size
	and a factor of less than 1 reduces the size.
	@param scale - the scaling factor applied to each particle every frame*/
	public function setScaling(xscale:Float, yscale:Float = 0):Void {
		
		scalingX = xscale;
		
		if (yscale == 0) {
			
			scalingY = xscale;
		}
		else {
			
			scalingY = yscale;
		}
	}
	
	/** Sets the basic rotation applied to particles in the system.
	@param r - the number of degrees each particle is rotated every frame */
	public function setRotation(r:Float):Void {
		
		rotate = r;
	}
	
	/** Sets the maximum random deviation of the particle lifespan
	@param rand - number refers to the maximum number of frames deviation */
	public function setLifeRandomness(rand:Float):Void {
		
		lifeRandom = rand;
	}
	
	/** Sets the maximum random deviation of the particle speed on both axes
	@param x - the maximum deviation from the horizontal base speed
	@param y - the maximum deviation from the vertical base speed */
	public function setSpeedRandomness(rx:Float, ry:Float, rz:Float):Void {
		
		_velRandom.x = rx;
		_velRandom.y = ry;
		_velRandom.z = rz;
	}
	
	/** Sets the maximum random deviation of the particle rotation
	@param rand - the maximum deviation from the base rotation value */
	public function setRotationRandomness(rand:Float):Void {
		
		rotateRandom = rand;
	}
	
	/** Sets a downward force, primarily used to simulate gravitational effect.
	@param gravity - a number (has no real world significance) */
	public function setForces(fx:Float = 0, fy:Float = 0, fz:Float = 0):Void {
		
		_forces.x = fx;
		_forces.y = fy;
		_forces.z = fz;
	}
	
	/** Turns alpha fading effects on or off (on by default). Turning alpha off may be useful to boost performance.
	@param alpha - set to true to turn alpha on, false to turn alpha off */
	public function setAlpha(alpha:Bool):Void {
		
		isAlpha = alpha;
	}
	
	/** Sets how the alpha fading is distributed over the particle lifetime.
	@param ease - number between 0 and 1, higher numbers start fading later */
	public function setAlphaEasing(ease:Float):Void {
		
		// cap values
		if (ease > 1) ease = 1;
		else if (ease < 0) ease = 0;
		
		alphaEasing = ease;
	}
	
	/** Rotates the particle so that the upward edge is always pointing in the direction of movement.
	If set to true it over-rides any other rotation.
	@param orient - true or false */
	public function setOrientToPath(orient:Bool):Void {
		
		isOrientToPath = orient;
	}
	
	public function setOrientToSource(orient:Bool):Void {
		
		isOrientToSource = orient;
	}
	
	/** Sets the max distance from the centre that a particle can randomly spawn (on both axes).
	@param x - total width of the spawn area (half this value either side of the centre point)
	@param y - total height of the spawn area (half this value either side of the centre point)*/
	public function setSpawnArea(sx:Float, sy:Float, sz:Float):Void {
		
		_spawnArea.x = sx;
		_spawnArea.y = sy;
		_spawnArea.z = sz;
	}

	/** Set a frame delay between each particle spawned.
	@param interval - number of frames between each particle spawned */
	public function setSpawnInterval(interval:Float):Void {
		
		spawnInterval = interval;
	}
	
	/** Loops through and updates particles for a defined number of frames when the particle system
	starts (or bursts). Mainly used to allow a particle stream to start in full flow.
	@param offset - number of frames to offset */
	public function setFrameOffset(offset:Int):Void {
		
		frameOffset = offset;
	}
	
	public function setColouring(r1:Float, g1:Float, b1:Float, r2:Float, g2:Float, b2:Float):Void {
		
		startColour = [r1, g1, b1];
		endColour = [r2, g2, b2];
	}
	
	/** With a floor level set, particles will bounce */
	public function setFloor(floor:Int, k:Float = 1.0):Void {
		
		_floor = floor;
		_bounce = k;
	}
	
	/* Implementation Functions */
	
	// creates a new particle with a defined velocity
	private function addParticle(dx:Float, dy:Float, dz:Float, life:Float):Void {
		
		var p:Particle;
		
		// find next free particle
		for (i in 0...count) {
			
			p = particles[i];
			
			// unused particles are hidden
			if (!p.visible) {
		
				var hx:Float = 0;
				var hy:Float = 0;
				
				if (holder != this) {
					
					hx = x;
					hy = y;
				}
				
				// set start position
				if (_spawnArea.x != 0) {
					
					p.pos.x = hx + (Math.random() * _spawnArea.x) - (_spawnArea.x * 0.5);
				}
				else {
					
					p.pos.x = hx;
				}
				
				if (_spawnArea.y != 0) {
					
					p.pos.y = hy + (((Math.random() * _spawnArea.y) - (_spawnArea.y * 0.5)) * 0.5);
				}
				else {
					
					p.pos.y = hy;
				}
				
				if (_spawnArea.z != 0) {
					
					p.pos.z = hy + (((Math.random() * _spawnArea.z) - (_spawnArea.z * 0.5)) * 0.5);
				}
				else {
					
					p.pos.y = hy;
				}
				/*
				// start colour set?
				if (startColour != null) {
					
					var trans:ColorTransform = new ColorTransform(startColour[0], startColour[1], startColour[2]);
					p.transform.colorTransform = trans;
				}
				*/
				// reset all attributes
				p.rotation = 0;
				p.scaleX = startScaleX;
				p.scaleY = startScaleY;
				p.alpha = 1;
				
				if (p.isAnimated) p.anim.gotoFrame(0);
				
				p.maxLife = life;
				p.life = life;
				p.fade = 1 / life;
				
				p.vel.x = dx;
				p.vel.y = dy;
				p.vel.z = dz;
				
				p.rot = randRotation(rotate);
				p.scalingX = scalingX;
				p.scalingY = scalingY;
				
				if (isOrientToSource) {
					
					p.rotation = rotation - 90;
				}
				
				// show particle
				p.visible = true;
				p.reset();
				
				// break loop when free particle is found
				break;
			}
		}
	}
	
	// give each particle a slightly different speed by
	// deviating from the base speed by a random amount
	private function randSpeed(speed:Float, rand:Float):Float {
		
		// deviation may be positive or negative
		var r:Float = (((speed + 1) * rand) * Math.random()) - (((speed + 1) * rand) * 0.5);
		speed += r;
		
		return speed;
	}
	
	// give each particle a different lifespan
	private function randLife(life:Float):Float {
		
		// deviation may ONLY be negative (so we always know the maximum value)
		var r:Float = ((life + 1) * lifeRandom) * Math.random();
		life -= r;
		
		return life;
	}
	
	// give each particle deviation from rotation speed
	private function randRotation(rot:Float):Float {
		
		// deviation may be positive or negative
		var r:Float = (((rot + 1) * rotateRandom) * Math.random()) - (((rot + 1) * rotateRandom) * 0.5);
		rot += r;
		
		return rot;
	}
	
	// update all particles
	public function update():Void {
		
		if (duration > 0) {
			
			duration--;
			if (duration == 0) stop();
		}
		
		if (isRunning && !isPaused) {
			
			if (spawnNext >= spawnInterval) {
				
				// add a particle every frame while the system is running
				addParticle(randSpeed(_vel.x, _velRandom.x), randSpeed(_vel.y, _velRandom.y), randSpeed(_vel.z, _velRandom.z), randLife(lifespan));
				spawnNext = 0;
			}
			
			spawnNext++;
		}
		
		for (i in 0...count) {
			
			var p:Particle = particles[i];
			
			if (p.visible) {
				
				// reduce life
				p.life--;
				
				if (p.life <= 0) {
					
					// remove the particle when dead
					p.visible = false;
				}
				else {
					
					#if html5
					// can't support colour transform
					
					#else
					// colouring
					if (startColour != null) {
						
						var progress:Float = 1 - (p.life / p.maxLife);
						
						var r:Float = startColour[0] + (endColour[0] - startColour[0]) * progress;
						var g:Float = startColour[1] + (endColour[1] - startColour[1]) * progress;
						var b:Float = startColour[2] + (endColour[2] - startColour[2]) * progress;
						
						var a:Float = p.alpha;
						if (!isAlpha) a = 1;
						
						var trans:ColorTransform = new ColorTransform(r, g, b, a);
						p.transform.colorTransform = trans;
					}
					#end
					
					// alpha fade particles if required
					if (isAlpha) {
						
						// how much have we faded
						if ((p.life / p.maxLife) < (1 - alphaEasing)) {
							
							p.alpha -= (p.fade / (1 - alphaEasing));
						}
					}
					
					if (isOrientToPath) {
						
						// rotate particle to face direction of movement
						p.rotation = (Math.atan2(p.vel.y, p.vel.x) * D180_OVER_PI) - 270;
					}
					else if (isOrientToSource) {
						
						p.rotation = rotation - 90;
					}
					else {
						
						// do normal rotation
						p.rotation += p.rot;
					}
					
					// is there any gravity
					p.vel.x += _forces.x;
					p.vel.y += _forces.y;
					p.vel.z += _forces.z;
					
					// update position
					p.pos.x += p.vel.x;
					p.pos.y += p.vel.y;
					p.pos.z += p.vel.z;
					
					if (_floor >= 0) {
						
						if (p.pos.y >= 0) {
						
							p.vel.y *= -_bounce;
							p.pos.y = 0;
						}
					}
					
					// update size
					p.scaleX *= p.scalingX;
					p.scaleY *= p.scalingY;
					
					// update anim
					p.update();
					
					p.x = p.pos.x;
					//p.y = (p.pos.z * 0.5) + (p.pos.y * 0.5);
					p.y = (p.pos.z) + (p.pos.y);
				}
			}
		}
		
		// check for completion
		if (willComplete && !isComplete) {
			
			var complete:Bool = true;
			
			for (j in particles) {
				
				if (j.visible) {
					
					complete = false;
					break;
				}
			}
			
			if (complete) {
				
				dispatchEvent(new Event(Event.COMPLETE));
				isComplete = true;
			}
		}
	}
	
	public function cleanUp():Void {
		
		for (p in particles) {
			
			holder.removeChild(p);
			p = null;
		}
		
		particles.splice(0, particles.length);
		particles = null;
		count = 0;
	}
	
	private function reset():Void {
		
		for (i in 0...count) {
			
			particles[i].visible = false;
		}
	}
}