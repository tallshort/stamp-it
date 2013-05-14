package com.tallshort.tracker.events
{
	import flash.events.Event;
	
	public class StampSelectionEvent extends Event
	{
		public static const STAMP_SELECTED:String = "stampSelected";
		public static const CLEAR:String = "clear";
			
		public var data:Object;
		
		public function StampSelectionEvent(type:String, data:Object=null, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.data = data;
		}
		
		public override function clone():Event
		{
			return new StampSelectionEvent(type, this.data, bubbles, cancelable);
		}
	}
}