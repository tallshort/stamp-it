package com.tallshort.tracker.model
{
	public class EvaluationResult
	{
		
		private var _actualCount:int;
		private var _expectedCount:int;
		
		public function EvaluationResult()
		{
		}
		
		public function set actualCount(actualCount:int):void {
			this._actualCount = actualCount;
		}
		
		public function get actualCount():int {
			return this._actualCount;
		}
		
		public function set expectedCount(expectedCount:int):void {
			this._expectedCount = expectedCount;
		}
		
		public function get expectedCount():int {
			return this._expectedCount;
		}
		
		public function getFiveStarRating():Number
		{
			var rating:Number = 0;			
			var actualCount:int = actualCount ;
			var expectedCount:int = expectedCount ;
			if ( expectedCount == 0)
				return 0;
			rating=(actualCount/expectedCount)*100/20;
			return rating;
		}
		
		public function getThreeStarRating():int
		{
			var value:int = 0;
			var rating:int = 0;
			var actualCount:int = actualCount ;
			var expectedCount:int = expectedCount;
			if (expectedCount == 0)
			{
				return 0;
			}
			value = (actualCount/expectedCount)*100;
			if (value >= 0 && value <= 50)
			{
				rating = EvaluationType.LEVEL_ONE;
			}
			else if (value > 50 && value <= 70)
			{
				rating = EvaluationType.LEVEL_TWO;
			}
			else if (value > 70 && value <= 100)
			{
				rating = EvaluationType.LEVEL_THREE;
			}
			return rating;		
		}
		
		public  function getThumbRating():int
		{
			var value:int = 0;
			var rating:int = 0;
			var actualCount:int = actualCount ;
			var expectedCount:int = expectedCount;
			if (expectedCount == 0)
			{
				return 0;
			}
			value = (actualCount/expectedCount)*100;
			if (value >= 0 && value <= 60)
			{
				rating = EvaluationType.LEVEL_ONE;
			}
			else
			{
				rating = EvaluationType.LEVEL_TWO ;
			}
			return rating;		
		}
		
		public function getPercentageRating():int
		{
			var value:int = 0;
			
			var actualCount:int = actualCount ;
			var expectedCount:int = expectedCount;
			if (expectedCount == 0)
			{
				return 0;
			}
			value = (actualCount / expectedCount) * 100;
			return value;
		}
		
		public function getCountRating():int
		{
			return actualCount;		
		}
		
	
		
	}
}