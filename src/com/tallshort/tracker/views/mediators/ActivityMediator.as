package com.tallshort.tracker.views.mediators
{
	import com.tallshort.tracker.events.ActivityEvent;
	import com.tallshort.tracker.model.Activity;
	import com.tallshort.tracker.model.ApplicationStatus;
	import com.tallshort.tracker.views.ActionView;
	import com.tallshort.tracker.views.ActivityView;
	import com.tallshort.tracker.views.NewOrEditActivityView;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	
	import org.robotlegs.mvcs.Mediator;
	
	import spark.components.Image;
	import spark.events.IndexChangeEvent;
	import spark.events.ViewNavigatorEvent;
	
	public class ActivityMediator extends Mediator
	{
		[Inject]
		public var activityView:ActivityView;
		
		[Inject]
		public var applicationStatus:ApplicationStatus;
		
		public function ActivityMediator() {
			super();
		}
		
		override public function onRegister():void {
			loadActivitiesIntoView();
			eventMap.mapListener(activityView.newActivityBtn, MouseEvent.CLICK, newActivityHandler, MouseEvent);
			eventMap.mapListener(activityView.activityList, IndexChangeEvent.CHANGE, selectActivityHandler, IndexChangeEvent);
			eventMap.mapListener(activityView.stampItBtn, MouseEvent.CLICK, stampItHandler, MouseEvent);
			eventMap.mapListener(activityView.editViewMenuItem, MouseEvent.CLICK, editViewMenuItemHandler, MouseEvent);
			eventMap.mapListener(activityView.deleteViewMenuItem, MouseEvent.CLICK, deleteViewMenuItemHandler, MouseEvent);
			addViewListener(TransformGestureEvent.GESTURE_SWIPE, shoeMenuHandler, TransformGestureEvent);
			addContextListener(ActivityEvent.ACTIVITIES_FETCHED, activitiesFetchedHandler, ActivityEvent);
			addContextListener(ActivityEvent.ACTIVITY_DELETED, activityDeletedHandler, ActivityEvent);
		}
		
		private function activityDeletedHandler(e:ActivityEvent):void {
			loadActivitiesIntoView();
		}
		
		private function loadActivitiesIntoView():void {
			dispatch(new ActivityEvent(ActivityEvent.FETCH_ACTIVITIES));
		}
		
		private function activitiesFetchedHandler(e:ActivityEvent):void {
			var activityCollection:ArrayCollection = e.data as ArrayCollection;
			if (activityCollection.length != 0) {
				activityView.activityList.dataProvider = activityCollection;
				activityView.currentState = "normal";
			} else {
				activityView.currentState = "faked";
			}
			activityView.stampItBtn.enabled = false;
		}
		
		private function newActivityHandler(e:Event):void {
			activityView.navigator.pushView(NewOrEditActivityView, new Activity());
		}
		
		private function selectActivityHandler(e:IndexChangeEvent):void {
			var selectedActivity:Activity = getSelectedActivity();
			activityView.stampItBtn.enabled = (selectedActivity != null);
		}
		
		private function getSelectedActivity():Activity {
			return activityView.activityList.selectedItem as Activity;
		}
		
		private function stampItHandler(e:MouseEvent):void {
			var selectedActivity:Activity = getSelectedActivity();
			if (selectedActivity != null) {
				applicationStatus.clear(); // reset
				applicationStatus.currentActivity = selectedActivity;
				activityView.navigator.pushView(ActionView);
			}
		}
		
		private function editViewMenuItemHandler(e:MouseEvent):void {
			var selectedActivity:Activity = getSelectedActivity();
			if (selectedActivity != null) {
				activityView.navigator.pushView(NewOrEditActivityView, selectedActivity);
			}
		}
		
		private function deleteViewMenuItemHandler(e:MouseEvent):void {
			var selectedActivity:Activity = getSelectedActivity();
			if (selectedActivity != null) {
				dispatch(new ActivityEvent(ActivityEvent.DELETE_ACTIVITY, selectedActivity));
			}
		}
		
		private function shoeMenuHandler(event:TransformGestureEvent):void {
			var direction:String = ""; 
			if(event.offsetX == 1) direction = "right"; 
			if(event.offsetX == -1) direction = "left"; 
			if(event.offsetY == 1) direction = "down"; 
			if(event.offsetY == -1) direction = "up";
			if (direction == "down") {
				FlexGlobals.topLevelApplication.viewMenuOpen = false;
			}
			if (direction == "up") {
				FlexGlobals.topLevelApplication.viewMenuOpen = true;
			}
		}
	}
}