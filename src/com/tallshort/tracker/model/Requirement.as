package com.tallshort.tracker.model
{
	import mx.collections.ArrayCollection;

	public class Requirement
	{
		
		public static const DAILY:String = "DAILY";
		public static const WEEKLY:String = "WEEKLY";
		public static const BIWEEKLY:String = "BIWEEKLY";
		public static const MONTHLY:String = "MONTHLY";
		public static const QUARTERLY:String = "QUARTERLY";
		public static const HALFYEARLY:String = "HALFYEARLY";
		public static const YEARLY:String = "YEARLY";
		public static const EVERY_OCCURRENCE:String = "EVERY_OCCURRENCE";
		
		private var _type:String = DAILY;
		private var _frequency:int = 1;
		
		public static const TYPE_LIST:ArrayCollection = new ArrayCollection([
			DAILY,
			WEEKLY,
			BIWEEKLY,
			MONTHLY,
			QUARTERLY,
			HALFYEARLY,
			YEARLY,
			EVERY_OCCURRENCE
		]);
		
		public static const TIMES_LIST:ArrayCollection = new ArrayCollection([
			1, 2, 3, 4, 5, 6, 7, 8, 9
		]);
		
		public function Requirement() {
			
		}
		
		public function set type(type:String):void {
			this._type = type;
		}
		
		public function get type():String {
			return this._type;
		}
		
		public function set frequency(frequency:int):void {
			this._frequency = frequency;
		}
		
		public function get frequency():int {
			return this._frequency;
		}
	}
}