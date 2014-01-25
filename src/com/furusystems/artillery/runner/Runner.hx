package com.furusystems.artillery.runner;
import com.furusystems.artillery.editor.Editor;
import com.furusystems.barrage.Barrage;
import com.furusystems.barrage.instancing.RunningBarrage;
import com.furusystems.fl.gui.Label;
import com.furusystems.flywheel.geom.Rectangle;
import com.furusystems.flywheel.geom.Vector2D;
import com.furusystems.flywheel.metrics.Time;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.utils.Timer;

/**
 * ...
 * @author Andreas Rønning
 */
class Runner extends Sprite
{
	var emitter:Emitter;
	var renderer:Renderer;
	var t:Time;
	var bounds:Rectangle;
	var stats:Label;
	var runningBarrage:RunningBarrage;
	var playerPos:Vector2D;
	var editor:Editor;
	var loopTimer:Timer;
	public var console:TextField;
	public function new() 
	{
		super();
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}
	
	private function onAddedToStage(e:Event):Void 
	{
		removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		
		tabChildren = tabEnabled = false;
		bounds = new Rectangle(0, 0, 500, 500);
		emitter = new Emitter();
		emitter.pos.x = 250;
		emitter.pos.y = 250;
		emitter.playerPos = playerPos = new Vector2D();
		renderer = new Renderer(cast bounds.width, cast bounds.height);
		addChild(renderer);
		renderer.addEventListener(MouseEvent.MOUSE_DOWN, onRendererMouseDown);
		stats = new Label("", 100, 100, false);
		addChild(stats);
		addEventListener(Event.ENTER_FRAME, onEnterFrame);
		
		editor = new Editor(this);
		addChild(editor).x = 500;
		
		loopTimer = new Timer(5000);
		loopTimer.addEventListener(TimerEvent.TIMER, onTimerTick);
		
		console = new TextField();
		addChild(console).y = 500;
		console.background = true;
		console.backgroundColor = 0x222222;
		console.width = 1000;
		console.height = 100;
		console.defaultTextFormat = new TextFormat("_sans", 12, 0xbbbbbb);
		console.multiline = true;
		console.wordWrap = false;
		console.text = "Welcome to Artillery - Today is " + Date.now().toString();
		
		t = new Time();
	}
	
	
	public function logLine(str:String):Void {
		console.appendText("\n" + str);
		console.scrollV = console.maxScrollV;
	}
	
	private function onRendererMouseDown(e:MouseEvent):Void 
	{
		playerPos.setTo(renderer.mouseX, renderer.mouseY);
	}
	
	public function stop():Void {
		if (runningBarrage != null) runningBarrage.dispose();
		loopTimer.stop();
	}
	
	public function setBarrage(b:Barrage):Void {
		stop();
		if (b == null) return;
		runningBarrage = b.run(emitter);
		runningBarrage.start();
		loopTimer.start();
	}
	
	private function onTimerTick(e:TimerEvent):Void 
	{
		if (runningBarrage != null) {
			runningBarrage.start();
		}
	}
	
	function onEnterFrame(e:Event):Void 
	{
		t.update();
		if (runningBarrage == null) return;
		runningBarrage.update(t.deltaS);
		emitter.update(t.deltaS, bounds);
		renderer.draw(emitter);
		stats.text = emitter.activeBullets.length + " bullets"+"\nBarrage time: "+runningBarrage.time;
	}
	
}