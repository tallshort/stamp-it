package com.tallshort.tracker.controller
{
	import com.tallshort.tracker.events.ActivityEvent;
	import com.tallshort.tracker.model.Activity;
	import com.tallshort.tracker.service.ActivityService;
	
	import org.robotlegs.mvcs.Command;
	
	public class SaveActivityCommand extends Command
	{
		[Inject] 
		public var event:ActivityEvent;
		
		[Inject]
		public var activityService:ActivityService;
		
		public function SaveActivityCommand()
		{
			super();
		}
		
		override public function execute():void {
			activityService.saveActivity(event.data as Activity);
		}
	}
}