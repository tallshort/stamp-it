package com.tallshort.tracker.views.mediators
{
	import com.tallshort.tracker.events.ActivityEvent;
	import com.tallshort.tracker.model.Activity;
	import com.tallshort.tracker.model.AnalysisItem;
	import com.tallshort.tracker.model.EvaluationResult;
	import com.tallshort.tracker.model.EvaluationType;
	import com.tallshort.tracker.service.ActivityService;
	import com.tallshort.tracker.views.AnalysisView;
	
	import flashx.textLayout.formats.Float;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Mediator;
	
	import spark.events.IndexChangeEvent;

	public class AnalysisViewMediator extends Mediator
	{
		[Inject]
		public var analysisView:AnalysisView;
		[Inject]
		public var activityService:ActivityService;
		
		public function AnalysisViewMediator()
		{
		}
		
		override public function onRegister():void
		{
			eventMap.mapListener(analysisView.analysisList, IndexChangeEvent.CHANGE, indexChangeHandler, IndexChangeEvent);
			addContextListener(ActivityEvent.ACTIVITIES_WITH_ACTIONS_FETCHED, updateDataCollectionHandler, ActivityEvent);
			loadDataToView();
		}
		
		protected function loadDataToView():void
		{
			activityService.fetchActivityWithAction();
		}
		
		protected function indexChangeHandler(e:IndexChangeEvent):void
		{
			var analysisItem:AnalysisItem = this.analysisView.analysisList.selectedItem as AnalysisItem;
			if (analysisItem!=null)
			{
				var evaluationResult:EvaluationResult = analysisItem.evaluationResult;
				if ( evaluationResult != null)
				{
					this.analysisView.acctualResult.text = "Actual Count: " + evaluationResult.actualCount;
					this.analysisView.expectedResult.text = "Expected Count: " + evaluationResult.expectedCount;
				}
			}	
			
		}
		
		protected function updateDataCollectionHandler(event:ActivityEvent):void
		{
			var arrayCollection:ArrayCollection = event.data as ArrayCollection;
			var dataCollection:ArrayCollection = getAnalysisItemArrayCollection(arrayCollection);
			this.analysisView.analysisList.dataProvider = dataCollection;
		}
		
		private function getAnalysisItemArrayCollection(sourceCollection:ArrayCollection):ArrayCollection
		{	
			var resultCollection:ArrayCollection = new ArrayCollection();
			if (sourceCollection != null)
			{
				for (var i:int=0;i<sourceCollection.length;i++)
				{
					var activity:Activity = sourceCollection.getItemAt(i) as Activity;
					var analysisItem:AnalysisItem = new AnalysisItem();
					analysisItem.name = activity.title;
					analysisItem.start_date = activity.startDate;
					analysisItem.evaluation= activity.evaluation;
					analysisItem.evaluationResult = activity.evaluate();
					analysisItem.rating = getRatingFloat(analysisItem.evaluation,analysisItem.evaluationResult);
					resultCollection.addItem(analysisItem);
				}
			}
			return resultCollection;
		
		}
		
		private function getRatingFloat(evaluation:String,evaluationResult:EvaluationResult):Number
		{
			if (evaluationResult == null || "" == evaluation )
			{
				return 0;
			}
			
			if ( evaluation == EvaluationType.FIVE_STARS)
			{
				return evaluationResult.getFiveStarRating();
			}
			else if ( evaluation == EvaluationType.THREE_STARS)
			{
				return evaluationResult.getThreeStarRating();
			}
			else if ( evaluation == EvaluationType.THUMBS)
			{
				return evaluationResult.getThumbRating();
			}
			else if ( evaluation == EvaluationType.PERCENTAGE)
			{
				return evaluationResult.getPercentageRating();
			}
			else if ( evaluation == EvaluationType.COUNT)
			{
				return evaluationResult.getCountRating();
			}
			return 0;
		}
		
	}
}