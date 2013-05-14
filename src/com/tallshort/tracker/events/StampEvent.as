package com.tallshort.tracker.events
{
	import flash.events.Event;
	
	public class StampEvent extends Event
	{
		public static const CREATE_STAMP:String = "createStamp";
		public static const STAMP_CREATED:String = "stampCreated";
		public static const DELETE_STAMP:String = "deleteStamp";
		public static const STAMP_DELETED:String = "stampDeleted";
		public static const STAMPS_FETCHED:String = "stampsFetched";
		public static const ADD_STAMP_FROM_STORAGE:String = "addStampFromStorage";
		public static const FETCH_STAMPS:String = "fetchStamps";
		
		public static const FETCH_ACTION_STAMPS_BY_DATE_RANGE:String = "fetchActionStampByData";
		public static const ACTION_STAMPS_FETCHED:String = "actionStampFetched";
			
		public var data:Object;
		
		public function StampEvent(type:String, data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.data = data;
		}
		
		public override function clone():Event
		{
			return new StampEvent(type, this.data, bubbles, cancelable);
		}
	}
}