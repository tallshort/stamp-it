package com.tallshort.tracker.model
{
	public class StyleItem
	{
		private var _name:String;
		private var _iconLocation:String;
		private var _swfName:String;
		
		public static const WIDTH:int = 256;
		public static const HEIGHT:int = WIDTH;
		
		public function StyleItem()
		{
		}
		
		public function set name(name:String):void {
			_name = name;
		}
		
		public function get name():String {
			return _name;
		}
		
		public function set iconLocation(iconLocation:String):void {
			_iconLocation = iconLocation;
		}
		
		public function get iconLocation():String {
			return _iconLocation;
		}
		
		public function set swfName(swfName:String):void {
			_swfName = swfName;
		}
		
		public function get swfName():String {
			return _swfName;
		}
		
		
	}
}