package com.tallshort.tracker.events
{
	import flash.events.Event;
	
	public class SettingEvent extends Event
	{
		public static const LOAD_SETTING:String = "loadSetting";
		public static const SETTING_LOADED:String = "settingLoaded";
		public static const SAVE_SETTING:String = "saveSetting";
		public static const SETTING_SAVED:String = "settingSaved";
		
		public var data:Object;
		
		public function SettingEvent(type:String, data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.data = data;
		}
		
		public override function clone():Event
		{
			return new SettingEvent(type, this.data, bubbles, cancelable);
		}
	}
}