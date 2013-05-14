package com.tallshort.tracker.model
{
	import flashx.textLayout.formats.Float;

	public class AnalysisItem
	{
		private var _name:String;
		private var _evaluation:String;
		private var _start_date:Date;
		private var _evaluationResult:EvaluationResult;
		private var _rating:Number;
		
		
		public function AnalysisItem()
		{
		}
		
		public function set name(name:String):void {
			this._name = name;
		}
		
		public function get name():String {
			return this._name;
		}
		
		public function set evaluation(evaluation:String):void {
			this._evaluation = evaluation;
		}
		
		public function get evaluation():String {
			return this._evaluation;
		}
		
		public function set evaluationResult(evaluationResult:EvaluationResult):void {
			this._evaluationResult = evaluationResult;
		}
		
		public function get evaluationResult():EvaluationResult {
			return this._evaluationResult ;
		}
		
		public function set rating(ratingFloat:Number):void {
			this._rating = ratingFloat;
		}
		
		public function get rating():Number {
			return this._rating;
		}
		
		public function set start_date(start_date:Date):void {
			this._start_date = start_date;
		}
		
		public function get start_date():Date {
			return this._start_date;
		}
		
	}
}