package com.tallshort.tracker.events
{
	import flash.events.Event;
	
	public class ActionViewEvent extends Event
	{
		public static const CELL_CLICK:String = "cellClick";
		public static const LOAD_STAMPS:String = "loadStamps";
		public static const LOAD_FLAGS:String = "loadFlags";
		
		public var data:Object;
		
		public function ActionViewEvent(type:String, data:Object=null, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.data = data;
		}
		
		public override function clone():Event
		{
			return new ActionViewEvent(type, this.data, bubbles, cancelable);
		}
	}
}