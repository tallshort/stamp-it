package com.tallshort.tracker.config
{
	
	import flash.system.Capabilities;
	import com.tallshort.tracker.model.Stamp;
	import mx.core.FlexGlobals;
	
	public class Config
	{
		public function Config()
		{
		}
		
		public static function monthCellWidth():int {
			if (isXOOM()) {
				return 174;
			} else if (isiPad()) {
				return 101;
			} else {
				return 60;
			}
		}
		
		public static function stampChooserWidth():int {
			if (isXOOM()) {
				return 1280;
			} else if (isiPad()) {
				return 768;
			} else {
				return 480;
			}
		}
		
		private static function isXOOM():Boolean {
			return ((Capabilities.screenResolutionY >= 1280 || Capabilities.screenResolutionX >= 1280)
						&& Capabilities.os.indexOf("Linux") != -1);
		}
		
		private static function isiPad():Boolean {
			return ((Capabilities.screenResolutionY >= 1024 || Capabilities.screenResolutionX >= 1024)
				&& Capabilities.os.indexOf("iPhone") != -1);
		}
	}
}