package com.furusystems.artillery.editor;
import com.furusystems.artillery.Macros;
import com.furusystems.artillery.runner.Runner;
import com.furusystems.barrage.Barrage;
import com.furusystems.barrage.parser.ParseError;
import com.furusystems.fl.gui.Button;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.net.SharedObject;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.text.TextInteractionMode;
import flash.ui.Keyboard;
import hscript.Macro;

/**
 * ...
 * @author Andreas Rønning
 */
using StringTools;
class Editor extends Sprite
{
	var inputField:TextField;
	var loader:URLLoader;
	var runButton:Button;
	var runner:Runner;
	var error:TextFormat;
	var normal:TextFormat;

	static var storage:SharedObject = SharedObject.getLocal("artillerysave");
	var clearButton:Button;
	
	public function new(runner:Runner) 
	{
		super();
		this.runner = runner;
		storage.clear();
		error = new TextFormat("_typewriter", 12, 0xFF2222);
		normal = new TextFormat("_typewriter", 12, 0xEEEEEE);
		
		graphics.beginFill(0x333333);
		graphics.drawRect(0, 0, 500, 500);
		inputField = new TextField();
		inputField.width = inputField.height = 500;
		inputField.defaultTextFormat = new TextFormat("_typewriter", 12, 0xEEEEEE);
		inputField.wordWrap = false;
		inputField.multiline = true;
		inputField.condenseWhite = true;
		inputField.type = TextFieldType.INPUT;
		inputField.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		
		addChild(inputField);
		
		if(Reflect.hasField(storage.data,"brg")){
			inputField.text = cleanScript(storage.data.brg);
		}else {
			inputField.text = Macros.getFileContent("D:/github/Barrage/test.brg");
		}
		
		
		runButton = new Button("Run", 80, 20);
		addChild(runButton).x = 500 - 90;
		addChild(runButton).y = 500 - 40;
		runButton.onPress.add(onRunButton);
		
		clearButton = new Button("Reset", 80, 20);
		addChild(clearButton).x = 500 - 90 - runButton.width;
		addChild(clearButton).y = 500 - 40;
		clearButton.onPress.add(onClearButton);
	}
	
	private function onClearButton(b) {
		runner.reset();
	}
	
	public function cleanScript(str:String):String {
		return str.trim();
	}
	
	private function onKeyDown(e:KeyboardEvent):Void 
	{
		if (e.keyCode == Keyboard.TAB) {
			e.preventDefault();
			if (inputField.caretIndex == inputField.text.length) {
				inputField.appendText("\t");
			}else {
				inputField.replaceText(inputField.caretIndex, inputField.caretIndex, "\t");
			}
			inputField.setSelection(inputField.caretIndex + 1, inputField.caretIndex + 1);
		}
	}
	
	function onRunButton(btn) 
	{
		try {
			inputField.setTextFormat(normal);
			var brg = Barrage.fromString(inputField.text);
			runner.setBarrage(brg);
			storage.data.brg = inputField.text;
			runner.logLine("Build complete");
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
		inputField.setTextFormat(error, startIdx, startIdx + text.length);
	}
	
	private function onLoadComplete(e:Event):Void 
	{
		inputField.text = loader.data;
	}
	
}