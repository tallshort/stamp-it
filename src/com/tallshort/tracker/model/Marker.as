package com.tallshort.tracker.model
{
	import flash.geom.Point;
	
	import org.robotlegs.mvcs.Actor;

	public class Marker extends Actor
	{
		private var _stamp:Stamp;
		private var _position:Point;
		private var _rotation:int;
		
		public function Marker()
		{
		}
		
		public function get passed():Boolean {
			return this._stamp.passed;
		}
		
		public function set stamp(stamp:Stamp):void {
			this._stamp = stamp;
		}
		
		public function get stamp():Stamp {
			return this._stamp;
		}
		
		public function set position(position:Point):void {
			this._position = position;
		}
		
		public function get position():Point {
			return this._position;
		}
		
		public function set rotation(rotation:int):void {
			this._rotation = rotation;
		}
		
		public function get rotation():int {
			return this._rotation;
		}
		
		
	}
}