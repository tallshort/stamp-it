package com.tallshort.tracker.controller
{
	import com.tallshort.tracker.events.ActivityEvent;
	import com.tallshort.tracker.model.Activity;
	import com.tallshort.tracker.service.ActivityService;
	
	import org.robotlegs.mvcs.Command;
	
	public class DeleteActivityCommand extends Command
	{
		[Inject] 
		public var event:ActivityEvent;
		
		[Inject]
		public var activityService:ActivityService;
		
		public function DeleteActivityCommand() {
			super();
		}
		
		override public function execute():void {
			activityService.deleteActivity(event.data as Activity);
		}
	}
}