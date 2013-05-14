package com.tallshort.tracker.controller
{
	import com.tallshort.tracker.events.ActivityEvent;
	import com.tallshort.tracker.service.RepositoryCreationService;
	
	import org.robotlegs.mvcs.Command;
	
	import flash.ui.*;
	
	public class StartupCommand extends Command
	{
		
		[Inject]
		public var repositoryCreationService:RepositoryCreationService;
		
		public function StartupCommand()
		{
			super();
		}
		
		override public function execute():void {
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
			repositoryCreationService.createRepository();
		}
	}
}