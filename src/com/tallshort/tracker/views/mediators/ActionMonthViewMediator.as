package com.tallshort.tracker.views.mediators
{
	
	import com.tallshort.tracker.events.ActionViewEvent;
	import com.tallshort.tracker.events.ActivityEvent;
	import com.tallshort.tracker.model.Activity;
	import com.tallshort.tracker.model.ApplicationStatus;
	import com.tallshort.tracker.model.Stamp;
	import com.tallshort.tracker.utils.DateUtil;
	import com.tallshort.tracker.views.ActionMonthView;
	import com.tallshort.tracker.views.ActionMonthViewCell;
	import com.tallshort.tracker.views.ActionWeekView;
	import com.tallshort.tracker.views.ActionWeekViewCell;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Mediator;
	
	import spark.components.Image;
	
	public class ActionMonthViewMediator extends Mediator
	{
		[Inject]
		public var actionMonthView:ActionMonthView;

		[Inject]
		public var applicationStatus:ApplicationStatus;
		
		public function ActionMonthViewMediator() {
			super();
		}
		
		override public function onRegister():void {
			addViewListener(ActionViewEvent.LOAD_FLAGS, fetchActivityFlagsHandler, ActionViewEvent);
			addContextListener(ActivityEvent.ACTIVIT_FLAGS_BY_DATE_RANGE_FETCHED, activityFlagsFetchedHandler, ActivityEvent);
		}
		
		private function fetchActivityFlagsHandler(e:ActionViewEvent):void {
			var fromDate:Date = e.data.fromDate;
			var toDate:Date = e.data.toDate;
			dispatch(new ActivityEvent(ActivityEvent.FETCH_ACTIVITIES_BY_DATE_RANGE, {
				activity: applicationStatus.currentActivity, 
				fromDate: fromDate,
				toDate: toDate
			}));
		}
		
		private function activityFlagsFetchedHandler(e:ActivityEvent):void {
			var activitiesCollection:ArrayCollection = e.data as ArrayCollection;
			for (var i:int = 7; i < actionMonthView.numElements; i++) { // Skip the week title
				var cell:ActionMonthViewCell = actionMonthView.getElementAt(i) as ActionMonthViewCell;
				var activityFlag:String = getFlag(activitiesCollection, cell.date);
				if (activityFlag != null) {
					var flagImage:Image = new Image();
					flagImage.alpha = 0.8;
					flagImage.x = 6;
					flagImage.y = 16;
					flagImage.source = "assets/flags/" + activityFlag + ".png";
					cell.addElement(flagImage);
				}
			}
		}
		
		private function getFlag(activitiesCollection:ArrayCollection, date:Date):String {
			if (date != null) {
				for (var i:int = 0; i < activitiesCollection.length; i++) { 
					if (DateUtil.dateString(activitiesCollection.getItemAt(i).actionCreatedOn) == DateUtil.dateString(date)) {
						return activitiesCollection.getItemAt(i).activityFlag;
					}
				}
			}
			return null;
		}

	}
}