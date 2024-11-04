package com.piratejuice;

import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.media.SoundTransform;
import openfl.events.EventDispatcher;
import openfl.events.Event;
import openfl.events.TimerEvent;
import openfl.utils.Timer;
import openfl.Assets;

class Audio extends EventDispatcher {
	
	public var loops:Int = 1;
	
	public var sound:Sound;
	private var channel:SoundChannel;
	
	private var loopCount:Int = 0;
	private var playhead:Float = 0;
	private var volume:Float = 1;
	private var pan:Float = 0;
	
	// status
	public var isPlaying:Bool = false;
	private var isMute:Bool = false;
	
	// optional audio group for selective muting
	private var group:String;
	
	// fade timer
	private var fadeTimer:Timer;
	private var fadeStep:Float;
	
	
	public function new(pSound:String = "", pLoops:Int = 1, pStartAt:Float = 0, pGroup:String = ""):Void {
		
		super();
		
		if (pSound != "") sound = Assets.getSound(pSound);
		
		playhead = pStartAt;
		loops = pLoops;
		group = pGroup;
	}
	
	public function setSound(pSound:String, pLoops:Int = 1, pStartAt:Float = 0, pGroup:String = ""):Void {
		
		// reassign the audio object without creating a new one
		sound = Assets.getSound(pSound);
		
		playhead = pStartAt;
		loops = pLoops;
		group = pGroup;
	}
	
	public function cleanUp():Void {
		
		stop();
		
		// clear object references
		sound = null;
		channel = null;
	}
	
	
	/* Volume and Pan Control */
	
	public function getVolume():Float {
		
		return volume;
	}
	
	public function setVolume(vol:Float):Void {
		
		volume = vol;
		if (isPlaying) channel.soundTransform = getTransform();
	}
	
	public function getMute():Bool {
		
		return isMute;
	}
	
	public function setMute(mute:Bool):Void {
		
		isMute = mute;
		if (isPlaying) channel.soundTransform = getTransform();
	}
	
	public function getPan():Float {
		
		return pan;
	}
	
	public function setPan(val:Float):Void {
		
		pan = Math.max( -1, Math.min(val, 1));
		if (isPlaying) channel.soundTransform = getTransform();
	}
	
	private function getTransform():SoundTransform {
		
		return new SoundTransform(isMute ? 0 : volume, pan);
	}
	
	
	/* Fading */
	
	public function fadeIn(duration:Float = 1):Void {
		
		
	}
	
	public function fadeOut(duration:Float = 1):Void {
		
		if (isPlaying) {
			
			fadeStep = channel.soundTransform.volume / (duration * 10);
			
			var timer:Timer = new Timer(100, Std.int(duration * 10));
			timer.addEventListener(TimerEvent.TIMER, onFadeTimer, false, 0, true);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onFadeTimerComplete, false, 0, true);
			timer.start();
		}
	}
	
	private function onFadeTimer(event:TimerEvent):Void {
		
		setVolume(volume - fadeStep);
	}
	
	private function onFadeTimerComplete(event:TimerEvent):Void {
		
		var timer:Timer = cast (event.target, Timer);
		
		timer.stop();
		timer.removeEventListener(TimerEvent.TIMER, onFadeTimer);
		timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onFadeTimerComplete);
		
		stop();
	}
	
	
	/* Playback Control */

	public function rewind():Void {
		
		if (isPlaying) {
			
			stop();
			playhead = 0;
			play();
		}
		else {
			
			playhead = 0;
		}
	}
	
	public function reset():Void {
		
		loopCount = 0;
		rewind();
	}
	
	public function play():Void	{
		
		if (!isPlaying) {
			
			isPlaying = true;
			
			channel = sound.play(playhead, 0, getTransform());
			
			if (channel != null) {
				
				channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete, false, 0, true);
			}
		}
	}
	
	public function stop():Void {
		
		if (isPlaying) {
			
			isPlaying = false;
			
			if (channel != null) {
				
				playhead = channel.position;
				channel.stop();
				channel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
				channel = null;
			}
		}
	}
	
	private function onSoundComplete(event:Event):Void {
		
		// clear spent channel
		channel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
		channel = null;
		
		// increment loop
		loopCount++;
		
		// if loop is infinite or count is still less than limit
		if (loops <= 0 || loopCount < loops) {
			
			// play new loop
			rewind();
			play();
		}
		else {
			
			isPlaying = false;
			reset();
		}
		
		dispatchEvent(new Event(Event.SOUND_COMPLETE));
	}
}