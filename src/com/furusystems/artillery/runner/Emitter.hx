package com.furusystems.artillery.runner;
import com.furusystems.barrage.instancing.IBullet;
import com.furusystems.barrage.instancing.IBulletEmitter;
import com.furusystems.flywheel.geom.Rectangle;
import com.furusystems.flywheel.geom.Vector2D;
import com.furusystems.flywheel.math.MathUtils;
import flash.geom.Point;
import haxe.ds.Vector.Vector;

/**
 * ...
 * @author Andreas Rønning
 */
class Emitter implements IBulletEmitter
{
	public var activeBullets:Array<IBullet>;
	var bulletPool:Vector<Bullet>;
	var numActive:Int = 0;
	public var pos:Vector2D;
	public var playerPos:Vector2D;
	public function new(poolsize:Int = 500) 
	{
		pos = new Vector2D();
		activeBullets = [];
		bulletPool = new Vector(poolsize);
		for (i in 0...poolsize) {
			bulletPool[i] = new Bullet(i);
		}
	}
	
	var nextBullet(get, never):Bullet;
	inline function get_nextBullet():Bullet {
		numActive++;
		if (numActive > bulletPool.length) numActive = 0;
		return bulletPool[numActive];
	}
	
	public function emit(origin:Vector2D, angle:Float, speed:Float, acceleration:Float):IBullet {
		//trace("Emit from " + origin+" to "+angleRad);
		#if debug
		trace("Emit " + angle + " " + speed + " " + acceleration);
		#end
		var angleRad = MathUtils.degToRad(angle);
		var b = nextBullet;
		b.pos.copyFrom(origin);
		b.angleRad = angleRad;
		b.velocity.setTo(Math.cos(angleRad) * speed, Math.sin(angleRad) * speed);
		b.acceleration = acceleration;
		activeBullets.push(b);
		return b;
	}
	public inline function update(delta:Float, bounds:Rectangle):Void {
		var removeList:Array<IBullet> = [];
		for (b in activeBullets) {
			updateBullet(b, delta);
			if (!b.pos.withinRect(bounds)) {
				removeList.push(b);
			}
		}
		while (removeList.length > 0) {
			activeBullets.remove(removeList.pop());
		}
	}
	
	inline function updateBullet(b:IBullet, delta:Float):Void {
		b.velocity += b.acceleration * delta;
		b.pos += b.velocity * delta;
	}
	
	/* INTERFACE com.furusystems.barrage.instancing.IBulletEmitter */
	
	public function getAngleToEmitter(pos:Vector2D):Float 
	{
		return MathUtils.radToDeg(pos.angleTo(this.pos));
	}
	
	public function getAngleToPlayer(pos:Vector2D):Float 
	{
		return MathUtils.radToDeg(pos.angleTo(playerPos));
	}
	
	public function kill(bullet:IBullet):Void 
	{
		bullet.active = false;
		activeBullets.remove(bullet);
	}
	
}