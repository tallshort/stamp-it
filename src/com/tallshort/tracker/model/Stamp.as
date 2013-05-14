package com.tallshort.tracker.model
{
	public class Stamp
	{
		private var _id:int;
		private var _passed:Boolean;
		private var _location:String;
		
		public static const WIDTH:int = 256;
		public static const HEIGHT:int = WIDTH;
		public static const LOW_ALPHA:Number = 0.1;
		public static const ALPHA:Number = 0.8;
		
		public function Stamp() {
		}
		
		public function set id(id:int):void {
			this._id = id;
		}
		
		public function get id():int {
			return this._id;
		}
		
		public function set passed(passed:Boolean):void {
			this._passed = passed;
		}
		
		public function get passed():Boolean {
			return this._passed;
		}
		
		[Bindable]
		public function set location(location:String):void {
			this._location = location;
		}
		
		public function get location():String {
			return this._location;
		}
	}
}