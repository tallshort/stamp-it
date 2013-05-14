package com.tallshort.tracker.views.mediators
{
	
	import com.tallshort.tracker.events.ActionViewEvent;
	import com.tallshort.tracker.events.StampEvent;
	import com.tallshort.tracker.model.ApplicationStatus;
	import com.tallshort.tracker.model.Stamp;
	import com.tallshort.tracker.utils.DateUtil;
	import com.tallshort.tracker.views.ActionWeekView;
	import com.tallshort.tracker.views.ActionWeekViewCell;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Mediator;
	
	import spark.components.Image;
	
	public class ActionWeekViewMediator extends Mediator
	{
		[Inject]
		public var actionWeekView:ActionWeekView;
		
		[Inject]
		public var applicationStatus:ApplicationStatus;
		
		public function ActionWeekViewMediator() {
			super();
		}
		
		override public function onRegister():void {
			addViewListener(ActionViewEvent.LOAD_STAMPS, loadStampsHandler, ActionViewEvent);
			addContextListener(StampEvent.ACTION_STAMPS_FETCHED, actionStampsFetchedHandler, StampEvent);
		}
		
		private function loadStampsHandler(e:ActionViewEvent):void {
			var fromDate:Date = e.data.fromDate;
			var toDate:Date = e.data.toDate;
			dispatch(new StampEvent(StampEvent.FETCH_ACTION_STAMPS_BY_DATE_RANGE, 
				{
					activity: applicationStatus.currentActivity, 
					fromDate: fromDate, 
					toDate: toDate
				}));
		}
		
		private function actionStampsFetchedHandler(e:StampEvent):void {
			var actionStampsCollection:ArrayCollection = e.data as ArrayCollection;
			for (var i:int = 0; i < actionWeekView.numElements; i++) {
				var cell:ActionWeekViewCell = actionWeekView.getElementAt(i) as ActionWeekViewCell;
				var stamp:Stamp = getActionStamp(actionStampsCollection, cell.date);
				if (stamp != null) {
					var stampImage:Image = new Image();
					stampImage.alpha = 0.8;
					stampImage.x = 10;
					stampImage.y = 20;
					stampImage.width = Stamp.WIDTH / 2;
					stampImage.height = Stamp.HEIGHT / 2;
					stampImage.source = stamp.location;
					cell.addElement(stampImage);
				}
			}
		}
		
		private function getActionStamp(actionStampsCollection:ArrayCollection, date:Date):Stamp {
			for (var i:int = 0; i < actionStampsCollection.length; i++) { 
				if (DateUtil.dateString(actionStampsCollection.getItemAt(i).actionCreatedOn) == DateUtil.dateString(date)) {
					return actionStampsCollection.getItemAt(i).stamp;
				}
			}
			return null;
		}
	}
}