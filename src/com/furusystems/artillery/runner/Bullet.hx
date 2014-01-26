package com.furusystems.artillery.runner;
import com.furusystems.barrage.instancing.IBullet;
import com.furusystems.flywheel.geom.Vector2D;

/**
 * ...
 * @author Andreas Rønning
 */
class Bullet implements IBullet
{
	public var pos:Vector2D;
	public var acceleration:Float;
	public var velocity:Vector2D;
	public var speed:Float;
	public var active:Bool;
	public var id:Int;
	public var angle:Float;
	public function new(id:Int) 
	{
		this.id = id;
		pos = new Vector2D();
		acceleration = 0;
		velocity = new Vector2D();
		speed = 0;
		angle = 0;
	}
	
}