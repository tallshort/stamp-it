package com.tallshort.tracker.controller
{
	import com.tallshort.tracker.events.ActivityEvent;
	import com.tallshort.tracker.service.ActivityService;
	
	import org.robotlegs.mvcs.Command;
	
	public class AddActionCommand extends Command
	{
		[Inject]
		public var activityEvent:ActivityEvent;
		
		[Inject]
		public var activityService:ActivityService;
		
		public function AddActionCommand() {
			super();
		}
		
		override public function execute():void {
			activityService.addAction(activityEvent.data.activity, activityEvent.data.action);
		}
	}
}