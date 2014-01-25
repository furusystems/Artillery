package com.furusystems.artillery;

import com.furusystems.artillery.runner.Runner;
import com.furusystems.barrage.Barrage;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.Lib;

/**
 * ...
 * @author Andreas Rønning
 */

class Main 
{
	static private var runner:com.furusystems.artillery.runner.Runner;
	static function main() 
	{
		var stage = Lib.current.stage;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		// entry point
		runner = new Runner();
		stage.addChild(runner);
	}
	
}