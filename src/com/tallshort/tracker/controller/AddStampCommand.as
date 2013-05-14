package com.tallshort.tracker.controller
{
	import com.tallshort.tracker.events.StampEvent;
	import com.tallshort.tracker.model.Stamp;
	import com.tallshort.tracker.service.StampService;
	
	import org.robotlegs.mvcs.Command;
	
	public class AddStampCommand extends Command
	{
		[Inject]
		public var stampEvent:StampEvent;
		
		[Inject]
		public var stampService:StampService;
		
		public function AddStampCommand() {
			super();
		}
		
		override public function execute():void {
			stampService.createStamp(stampEvent.data as Stamp);
		}
	}
}