package com.tallshort.tracker.controller
{
	import com.tallshort.tracker.events.ActivityEvent;
	import com.tallshort.tracker.service.ActivityService;
	
	import org.robotlegs.mvcs.Command;
	
	public class RemoveActionCommand extends Command
	{
		[Inject]
		public var activityEvent:ActivityEvent;
		
		[Inject]
		public var activityService:ActivityService;
		
		public function RemoveActionCommand() {
			super();
		}
		
		override public function execute():void {
			activityService.removeAction(activityEvent.data.activity, activityEvent.data.action);
		}
	}
}