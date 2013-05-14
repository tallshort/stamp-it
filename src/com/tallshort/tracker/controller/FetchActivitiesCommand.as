package com.tallshort.tracker.controller
{
	import com.tallshort.tracker.events.ActivityEvent;
	import com.tallshort.tracker.model.Activity;
	import com.tallshort.tracker.service.ActivityService;
	
	import org.robotlegs.mvcs.Command;
	
	public class FetchActivitiesCommand extends Command
	{
		
		[Inject]
		public var activityService:ActivityService;
		
		public function FetchActivitiesCommand() {
			super();
		}
		
		override public function execute():void {
			activityService.fetchActivities();
		}
	}
}