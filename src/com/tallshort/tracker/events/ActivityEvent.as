package com.tallshort.tracker.events
{
	import flash.events.Event;
	
	public class ActivityEvent extends Event
	{
		public static const NEW_ACTIVITY:String = "newActivity";
		public static const CREATE_ACTIVITY:String = "createActivity";
		public static const ACTIVITY_CREATED:String = "activityCreated";
		public static const SAVE_ACTIVITY:String = "saveActivity";
		public static const ACTIVITY_SAVED:String = "activitySaved";
		public static const FETCH_ACTIVITIES:String = "fetchActivites";
		public static const ACTIVITIES_FETCHED:String = "activitesFetched";
		public static const ACTIVITIES_WITH_ACTIONS_FETCHED:String = "activitiesWithActionsFetched";
		public static const DELETE_ACTIVITY:String = "deleteActivity";
		public static const ACTIVITY_DELETED:String = "activityDeleted";
		public static const FETCH_ACTIVITIES_BY_DATE_RANGE:String = "fetchActivitiesByDateRange";
		public static const ACTIVIT_FLAGS_BY_DATE_RANGE_FETCHED:String = "activitiesByDateRangeFetched";
		
		public static const FETCH_ACTION_BY_DATE:String = "fetchActionByDate";
		public static const FETCH_ACTIONS_BY_DATE:String = "fetchActionsByDate";
		public static const ACTION_FETCHED:String = "actionFetched";
		public static const ACTIONS_FETCHED:String = "actionsFetched";
		public static const ADD_ACTION:String = "addAction";
		public static const REMOVE_ACTION:String = "removeAction";
		public static const ACTION_REMOVED:String = "actionRemoved";
		public static const ACTION_ADDED:String = "actionAdded";
		public static const SAVE_ACTION:String = "saveAction";
		public static const ACTION_SAVED:String = "actionSaved";
		public static const FETCH_SAME_DATE_ACTIONS:String = "fetchSameDateActions";
		public static const SAME_DATE_ACTIONS_FETCHED:String = "sameDateActionsFetched";
		
		public var data:Object;
		
		public function ActivityEvent(type:String, data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.data = data;
		}
		
		public override function clone():Event
		{
			return new ActivityEvent(type, this.data, bubbles, cancelable);
		}
	}
}