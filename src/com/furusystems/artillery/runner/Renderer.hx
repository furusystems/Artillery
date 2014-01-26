package com.furusystems.artillery.runner;
import com.furusystems.barrage.instancing.IBullet;
import com.furusystems.flywheel.geom.Vector2D;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.PixelSnapping;
import flash.display.Shape;
import flash.display.Sprite;
import flash.geom.Point;

/**
 * ...
 * @author Andreas Rønning
 */
class Renderer extends Sprite
{
	var bmd:BitmapData;
	var bulletSprite:BitmapData;
	var origin:Shape;
	var target:Shape;
	public function new(w:Int = 500, h:Int = 500) 
	{
		super();
		bulletSprite = new BitmapData(8, 8,true,0);
		var shp:Shape = new Shape();
		shp.graphics.beginFill(0);
		shp.graphics.drawCircle(4, 3, 3);
		bulletSprite.draw(shp);
		bmd = new BitmapData(w, h);
		addChild(new Bitmap(bmd));
		origin = cast addChild(new Shape());
		target = cast addChild(new Shape());
		
		origin.graphics.lineStyle(0, 0x00FF00);
		origin.graphics.drawRect( -5, -5, 10, 10);
		
		target.graphics.lineStyle(0, 0xFF0000);
		target.graphics.drawRect( -5, -5, 10, 10);
	}
	public function draw(e:Emitter):Void {
		bmd.lock();
		bmd.fillRect(bmd.rect, 0xFF808080);
		for (b in e.activeBullets) {
			drawBullet(b);
		}
		bmd.unlock();
		origin.x = e.pos.x;
		origin.y = e.pos.y;
		target.x = e.playerPos.x;
		target.y = e.playerPos.y;
	}
	static var destPt:Point = new Point();
	inline function drawBullet(b:IBullet) 
	{
		destPt.x = b.pos.x-4;
		destPt.y = b.pos.y-4;
		bmd.copyPixels(bulletSprite, bulletSprite.rect, destPt,null,null,true);
	}
	
}