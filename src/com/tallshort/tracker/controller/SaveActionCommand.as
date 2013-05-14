package com.tallshort.tracker.controller
{
	import com.tallshort.tracker.events.ActivityEvent;
	import com.tallshort.tracker.model.Action;
	import com.tallshort.tracker.service.ActivityService;
	
	import org.robotlegs.mvcs.Command;
	
	public class SaveActionCommand extends Command
	{
		[Inject]
		public var activityEvent:ActivityEvent;
		
		[Inject]
		public var activityService:ActivityService;
		
		public function SaveActionCommand() {
			super();
		}
		
		override public function execute():void {
			activityService.saveAction(activityEvent.data as Action);
		}
	}
}