package com.tallshort.tracker.controller
{
	import com.tallshort.tracker.events.StampEvent;
	import com.tallshort.tracker.model.Activity;
	import com.tallshort.tracker.service.StampService;
	
	import org.robotlegs.mvcs.Command;
	
	public class FetchStampsByDateRangeCommand extends Command
	{
		[Inject]
		public var stampEvent:StampEvent;
		
		[Inject]
		public var stampService:StampService;
		
		public function FetchStampsByDateRangeCommand() {
			super();
		}
		
		override public function execute():void {
			var activity:Activity = stampEvent.data.activity as Activity;
			var fromDate:Date = stampEvent.data.fromDate as Date;
			var toDate:Date = stampEvent.data.toDate as Date;
			stampService.fetchActionStamps(activity, fromDate, toDate);
		}
	}
}