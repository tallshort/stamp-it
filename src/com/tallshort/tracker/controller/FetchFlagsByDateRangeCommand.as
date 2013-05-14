package com.tallshort.tracker.controller
{
	import com.tallshort.tracker.events.ActivityEvent;
	import com.tallshort.tracker.model.Activity;
	import com.tallshort.tracker.service.ActivityService;
	
	import org.robotlegs.mvcs.Command;
	
	public class FetchFlagsByDateRangeCommand extends Command
	{
		[Inject]
		public var activityEvent:ActivityEvent;
		
		[Inject]
		public var activityService:ActivityService;
		
		public function FetchFlagsByDateRangeCommand() {
			super();
		}
		
		override public function execute():void {
			var activity:Activity = activityEvent.data.activity as Activity;
			var fromDate:Date = activityEvent.data.fromDate as Date;
			var toDate:Date = activityEvent.data.toDate as Date;
			activityService.fetchActivityFlagsByDateRange(activity, fromDate, toDate);
		}
	}
}