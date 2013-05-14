package com.tallshort.tracker.model
{

	public class ApplicationStatus
	{
		public var currentActivity:Activity;
		public var currentStamp:Stamp;
		public var currentDate:Date;
		
		public function ApplicationStatus() {
		}
		
		public function clear():void {
			currentActivity = null;
			currentStamp = null;
			currentDate = null;
		}
	}
}