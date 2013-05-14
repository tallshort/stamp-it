package com.tallshort.tracker.model
{
	public class LocaleItem
	{
		private var _name:String;
		private var _label:String;
		
		public function LocaleItem()
		{
		}
		
		[Bindable]
		public function set name(name:String):void {
			this._name = name;
		}
		
		public function get name():String {
			return this._name;
		}

		[Bindable]
		public function set label(label:String):void {
			this._label = label;
		}
		
		public function get label():String {
			return this._label;
		}
	}
}