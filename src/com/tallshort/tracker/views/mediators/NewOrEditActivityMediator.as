package com.tallshort.tracker.views.mediators
{
	import com.tallshort.tracker.events.ActivityEvent;
	import com.tallshort.tracker.model.Activity;
	import com.tallshort.tracker.views.NewOrEditActivityView;
	
	import com.tallshort.tracker.utils.DateUtil;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class NewOrEditActivityMediator extends Mediator
	{
		
		[Inject]
		public var newOrEditActivityView:NewOrEditActivityView;
		
		public function NewOrEditActivityMediator() {
			super();
		}
		
		override public function onRegister():void {
			eventMap.mapListener(newOrEditActivityView.createOrSaveActivityBtn, MouseEvent.CLICK, createOrSaveActivityHandler, MouseEvent);
			eventMap.mapListener(newOrEditActivityView.backBtn, MouseEvent.CLICK, backToActivityView, MouseEvent);
			addContextListener(ActivityEvent.ACTIVITY_CREATED, backToActivityView, ActivityEvent);
			addContextListener(ActivityEvent.ACTIVITY_SAVED, backToActivityView, ActivityEvent);
			updateViewData();
		}
		
		private function updateViewData():void {
			var activity:Activity = newOrEditActivityView.data as Activity;
			newOrEditActivityView.activityTitleInput.text = activity.title;
			newOrEditActivityView.activityDescInput.text = activity.description;
			newOrEditActivityView.requirementTypeList.selectedItem = activity.requirement.type;
			newOrEditActivityView.requirementFrequencyList.selectedItem = activity.requirement.frequency;
			newOrEditActivityView.evaluationBtnBar.selectedIndex = getEvaluationListSelectedIndex(activity.evaluation);
			newOrEditActivityView.flagBtnBar.selectedIndex = getFlagListSelectedIndex(activity.flag);
			if (activity.isNew()) {
				newOrEditActivityView.currentState = "new";
			} else {
				newOrEditActivityView.currentState = "edit";
			}
		}
		
		private function getEvaluationListSelectedIndex(evaluation:String):int {
			for (var i:int = 0; i < newOrEditActivityView.evaluationCollection.length; i++) {
				if (newOrEditActivityView.evaluationCollection.getItemAt(i).name == evaluation) {
					return i;
				}
			}
			return 0;
		}
		
		private function getFlagListSelectedIndex(flag:String):int {
			for (var i:int = 0; i < newOrEditActivityView.flagCollection.length; i++) {
				if (newOrEditActivityView.flagCollection.getItemAt(i).name == flag) {
					return i;
				}
			}
			return 0;
		}
		
		private function createOrSaveActivityHandler(e:MouseEvent):void {
			var activity:Activity = newOrEditActivityView.data as Activity;
			activity.title = newOrEditActivityView.activityTitleInput.text;
			activity.description = newOrEditActivityView.activityDescInput.text;
			if (activity.isNew()) { // startDate can not be updated if activity has been created
				activity.startDate = DateUtil.today();
			}
			activity.requirement.type = newOrEditActivityView.requirementTypeList.selectedItem;
			activity.requirement.frequency = newOrEditActivityView.requirementFrequencyList.selectedItem;
			activity.evaluation = newOrEditActivityView.evaluationBtnBar.selectedItem.name;
			activity.flag = newOrEditActivityView.flagBtnBar.selectedItem.name;
			if (activity.isNew()) {
				dispatch(new ActivityEvent(ActivityEvent.CREATE_ACTIVITY, activity));
			} else {
				dispatch(new ActivityEvent(ActivityEvent.SAVE_ACTIVITY, activity));
			}
		}
		
		private function backToActivityView(e:Event):void {
			newOrEditActivityView.navigator.popView();
		}
	}
}