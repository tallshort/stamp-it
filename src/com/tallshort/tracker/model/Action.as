package com.tallshort.tracker.model
{
	import org.robotlegs.mvcs.Actor;
	
	import com.tallshort.tracker.utils.DateUtil;
	
	public class Action extends Actor
	{
		private var _id:int = INIT_ID;
		private var _time:Date = DateUtil.today();
		private var _note:String;
		private var _marker:Marker = new Marker();
		
		private static const INIT_ID:int = -1;
		
		public function Action() {
		}
		
		public function isNew():Boolean {
			return id == INIT_ID;
		}
		
		public function set id(id:int):void {
			this._id = id;
		}
		
		public function get id():int {
			return this._id;
		}
		
		public function set time(t:Date):void {
			this._time = t;
		}
		
		public function get time():Date {
			return this._time;
		}
		
		public function set note(note:String):void {
			this._note = note;
		}
		
		public function get note():String {
			return this._note || "";
		}
		
		public function set marker(m:Marker):void {
			this._marker = m;
		}
		
		public function get marker():Marker {
			return this._marker;
		}
		
		public function get done():Boolean {
			return this._marker.passed;
		}
	}
}