package com.tallshort.tracker.controller
{
	import com.tallshort.tracker.events.StampEvent;
	import com.tallshort.tracker.service.StampService;
	
	import org.robotlegs.mvcs.Command;
	
	public class FetchStampsCommand extends Command
	{
		[Inject]
		public var stampEvent:StampEvent;
		
		[Inject]
		public var stampService:StampService;
		
		public function FetchStampsCommand() {
			super();
		}
		
		override public function execute():void {
			stampService.getStamps();
		}
	}
}