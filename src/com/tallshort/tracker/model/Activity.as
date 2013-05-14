package com.tallshort.tracker.model
{
	import com.tallshort.tracker.utils.DateUtil;
	
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;

	public class Activity extends EventDispatcher
	{
		private var _id:int = INIT_ID;
		private var _title:String = "";
		private var _description:String = "";
		private var _startDate:Date;
		private var _flag:String = "";
		private var _requirement:Requirement = new Requirement();
		private var _evaluation:String;
		private var _actions:Vector.<Action> = new Vector.<Action>();
		
		private static const INIT_ID:int = -1;
		
		public function Activity() {
		}
		
		public function isNew():Boolean {
			return id == INIT_ID;
		}
		
		public function set id(id:int):void {
			this._id = id;
		}
		
		public function get id():int {
			return this._id;
		}
		
		[Bindable]
		public function set title(title:String):void {
			this._title = title;
		}
		
		public function get title():String {
			return this._title;
		}
		
		[Bindable]
		public function set description(description:String):void {
			this._description = description;
		}
		
		public function get description():String {
			return this._description;
		}
		
		[Bindable]
		public function set startDate(date:Date):void {
			this._startDate = date;
		}
		
		public function get startDate():Date {
			return this._startDate;
		}
		
		[Bindable]
		public function set flag(flag:String):void {
			this._flag = flag;
		}
		
		public function get flag():String {
			return this._flag;
		}
		
		public function set evaluation(evaluationWay:String):void {
			this._evaluation = evaluationWay;
		}
		
		public function get evaluation():String {
			return this._evaluation;
		}
		
		public function set requirement(requirement:Requirement):void {
			this._requirement = requirement;
		}
		
		public function get requirement():Requirement {
			return this._requirement;
		}
		
		public function addAction(action:Action):void {
			this._actions.push(action);
		}
		
		public function set actions(actions:Vector.<Action>):void
		{
			this._actions = actions;
		}
		
		public function get actions():Vector.<Action> {
			return this._actions;
		}
		
		public function evaluate():EvaluationResult 
		{
			var result:EvaluationResult = new EvaluationResult();
			var currentTime:Date = DateUtil.today();
			var activityUnitsOffset:int = getUnitsOffset (this._requirement.type, this._startDate,currentTime);				
			if (activityUnitsOffset == -1)
			{
				var countEveryOccr:int = 0;
				for each( var action1:Action in this._actions)
				{
					if (action1.done 
						&& DateUtil.compareTwoDates(this._startDate,action1.time) != -1 
						&& DateUtil.compareTwoDates(action1.time,DateUtil.today()) != -1)
					{
						countEveryOccr++;
					}
				}
				result.actualCount = countEveryOccr;
				result.expectedCount = countEveryOccr; 
				return result;
			}			
			var resultUnitVector:Vector.<int> = new Vector.<int>(activityUnitsOffset + 1);
			var expectedFrequency:int = this._requirement.frequency;
			for each(var action:Action in this._actions) 
			{
				var actionUnitsOffset:int = getUnitsOffset(this._requirement.type,this._startDate,action.time) ;				
				if (action.done && actionUnitsOffset != -1 ) 
				{ 
					if (resultUnitVector[actionUnitsOffset] < expectedFrequency) 
					{
						resultUnitVector[actionUnitsOffset]++;
					}
				}
			}
			result.actualCount = sumVector(resultUnitVector);
			result.expectedCount = resultUnitVector.length * expectedFrequency;
			return result;
		}
		
		//
		
		private function getUnitsOffset(type:String,startTime:Date, currentTime:Date):int
		{
			if (startTime==null || currentTime==null)
			{
				return 0;
			}
			var unitsOffset:int = 0;
			
			if ( DateUtil.compareTwoDates(startTime,currentTime) == -1 )
			{
				return -1;				
			}
			
			if ( DateUtil.compareTwoDates(currentTime,DateUtil.today()) == -1)
			{
				return -1;
			}
			
			if ( type == Requirement.DAILY)
			{
				unitsOffset = DateUtil.daysOffset(startTime, currentTime);
			} 
			else if ( type == Requirement.WEEKLY) 
			{
				unitsOffset = DateUtil.weeksOffset(startTime, currentTime);
			} 
			else if ( type == Requirement.BIWEEKLY)
			{
				unitsOffset = DateUtil.biweeksOffset(startTime,currentTime);				
			}			
			else if ( type == Requirement.MONTHLY)
			{
				unitsOffset = DateUtil.monthsOffset(startTime,currentTime);				
			}			
			else if ( type == Requirement.QUARTERLY)
			{
				unitsOffset = DateUtil.monthsOffset(startTime,currentTime);				
			}
			else if ( type == Requirement.HALFYEARLY)
			{
				unitsOffset = DateUtil.halfyearOffset(startTime,currentTime);				
			}
			else if ( type == Requirement.YEARLY)
			{
				unitsOffset = DateUtil.yearOffset(startTime,currentTime);				
			}
			else if ( type == Requirement.EVERY_OCCURRENCE)
			{
				unitsOffset = -1;
			}
			return unitsOffset ;			
		}
		
		private function sumVector(v:Vector.<int>):int {
			var sum:int = 0;
			var len:int = v.length;
			for(var i:int = 0; i < len; i++) {
				sum += v[i];
			}
			return sum;
		}
		
		override public function toString():String {
			return this._title;
		}
		
	}
}