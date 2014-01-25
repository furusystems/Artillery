package com.furusystems.artillery.editor;
import com.furusystems.artillery.Macros;
import com.furusystems.artillery.runner.Runner;
import com.furusystems.barrage.Barrage;
import com.furusystems.barrage.parser.ParseError;
import com.furusystems.fl.gui.Button;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.TextFormat;

/**
 * ...
 * @author Andreas Rønning
 */
class Editor extends Sprite
{
	var inputField:TextField;
	var loader:URLLoader;
	var runButton:Button;
	var runner:Runner;
	var error:TextFormat;
	var normal:TextFormat;

	public function new(runner:Runner) 
	{
		super();
		this.runner = runner;
		
		error = new TextFormat("_typewriter", 12, 0xFF2222);
		normal = new TextFormat("_typewriter", 12, 0xEEEEEE);
		
		graphics.beginFill(0x333333);
		graphics.drawRect(0, 0, 500, 500);
		inputField = new TextField();
		inputField.width = inputField.height = 500;
		inputField.defaultTextFormat = new TextFormat("_typewriter", 12, 0xEEEEEE);
		inputField.wordWrap = false;
		inputField.multiline = true;
		inputField.type = TextFieldType.INPUT;
		addChild(inputField);
		
		loader = new URLLoader(new URLRequest("D:/github/Barrage/test3.brg"));
		loader.addEventListener(Event.COMPLETE, onLoadComplete);
		
		runButton = new Button("Run", 80, 20);
		addChild(runButton).x = 500 - 90;
		addChild(runButton).y = 500 - 40;
		runButton.onPress.add(onRunButton);
	}
	
	function onRunButton(btn) 
	{
		try {
			inputField.setTextFormat(normal);
			var brg = Barrage.fromString(inputField.text);
			runner.setBarrage(brg);
		}catch (e:ParseError) {
			runner.setBarrage(null);
			runner.logLine(e + "");
			highlightLine(e.lineNo);
		}
		
	}
	
	function highlightLine(lineNo:Int) 
	{
		var text = inputField.getLineText(lineNo);
		var startIdx = inputField.text.indexOf(text);
		stage.focus = inputField;
		//inputField.setSelection(startIdx, startIdx + text.length);
		inputField.setTextFormat(error, startIdx, startIdx + text.length);
	}
	
	private function onLoadComplete(e:Event):Void 
	{
		inputField.text = loader.data;
	}
	
}