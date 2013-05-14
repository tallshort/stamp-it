package com.tallshort.tracker.controller
{
	import com.tallshort.tracker.events.ActivityEvent;
	import com.tallshort.tracker.model.Action;
	import com.tallshort.tracker.service.ActivityService;
	
	import org.robotlegs.mvcs.Command;
	
	public class FetchSameDateActionsCommand extends Command
	{
		[Inject] 
		public var event:ActivityEvent;
		
		[Inject]
		public var activityService:ActivityService;
		
		public function FetchSameDateActionsCommand() {
			super();
		}
		
		override public function execute():void {
			activityService.fetchSameDateActions(event.data as Action);
		}
	}
}