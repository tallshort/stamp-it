package com.tallshort.tracker.utils
{
	public class Logger
	{
		public function Logger() {
		}
		
		public static function log(message:String):void {
			trace(message);
		}
		
		public static function warn(message:String):void {
			trace(message);
		}
		
		public static function error(message:String):void {
			trace(message);
		}
	}
}