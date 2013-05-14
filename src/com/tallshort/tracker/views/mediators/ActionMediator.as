package com.tallshort.tracker.views.mediators
{
	import com.tallshort.tracker.events.ActionViewEvent;
	import com.tallshort.tracker.events.ActivityEvent;
	import com.tallshort.tracker.events.StampSelectionEvent;
	import com.tallshort.tracker.model.*;
	import com.tallshort.tracker.utils.DateUtil;
	import com.tallshort.tracker.views.ActionView;
	import com.tallshort.tracker.views.ChooseStampView;
	
	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Mediator;
	
	import spark.components.Image;
	import spark.events.IndexChangeEvent;
	import spark.events.ViewNavigatorEvent;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	
	public class ActionMediator extends Mediator
	{
		[Inject]
		public var actionView:ActionView;
		
		[Inject]
		public var applicationStatus:ApplicationStatus;
		
		private var currentStampImage:Image;
		
		private var currentActivity:Activity;
		private var currentAction:Action;
		
		private var timeoutId:uint;
		
		public function ActionMediator() {
			super();
		}
		
		override public function onRegister():void {
			eventMap.mapListener(actionView.backBtn, MouseEvent.CLICK, backHandler, MouseEvent);
			eventMap.mapListener(actionView.stampContainer, MouseEvent.MOUSE_UP, createStampHandler, MouseEvent);
			eventMap.mapListener(actionView.addNoteBtn, MouseEvent.CLICK, addNoteHandler, MouseEvent);
			eventMap.mapListener(actionView.changeViewBtnBar, IndexChangeEvent.CHANGE, changeViewHandler, IndexChangeEvent);
			eventMap.mapListener(actionView.removeActionBtn.clickArea, MouseEvent.CLICK, removeActionHandler, MouseEvent);
			
			eventMap.mapListener(actionView.prevUnitBtn, MouseEvent.CLICK, previousUnitHandler, MouseEvent);
			eventMap.mapListener(actionView.nextUnitBtn, MouseEvent.CLICK, nextUnitHandler, MouseEvent);
			
			addViewListener(ActionViewEvent.CELL_CLICK, cellClickHandler, ActionViewEvent);
			
			addContextListener(ActivityEvent.ACTION_FETCHED, actionFetchedHandler, ActivityEvent);
			addContextListener(ActivityEvent.ACTION_ADDED, actionAddedHandler, ActivityEvent);
			addContextListener(ActivityEvent.ACTION_REMOVED, actionRemovedHandler, ActivityEvent);
			addContextListener(ActivityEvent.SAME_DATE_ACTIONS_FETCHED, sameDateActionsFetchedHandler, ActivityEvent);
			
			currentActivity = applicationStatus.currentActivity;
			
			applicationStatus.currentDate = applicationStatus.currentDate || DateUtil.today();
			
			// UX enhancement
			timeoutId = setTimeout(fillActivityIntoView, 100);
		}
		
		private function fillActivityIntoView():void {
			clearTimeout(timeoutId);
			actionView.title = currentActivity.title;
			getActionByCurrentDate();
		}
		
		private function getActionByCurrentDate():void {
			dispatch(new ActivityEvent(ActivityEvent.FETCH_ACTION_BY_DATE, 
				{activity: currentActivity, date: applicationStatus.currentDate}
			));
		}
		
		private function actionFetchedHandler(e:ActivityEvent):void {
			currentAction = e.data as Action;
			fillActionIntoView();
			updateCurrentStamp();
			removeStampImages();
			if (currentAction.isNew()) {
				actionView.disableOperationArea();
			} else {
				actionView.enableOperationArea();
				addStampToView(currentAction.marker.position.x, currentAction.marker.position.y);
			}
			dispatch(new ActivityEvent(ActivityEvent.FETCH_SAME_DATE_ACTIONS, currentAction));
		}
		
		private function sameDateActionsFetchedHandler(e:ActivityEvent):void {
			trace(e.data.length);
			var sameDateActions:ArrayCollection = e.data as ArrayCollection;
			for (var i:int = 0; i < sameDateActions.length; i++) {
				var action:Action = sameDateActions.getItemAt(i) as Action;
				var stampImage:Image = actionView.newStampImage(action, Stamp.LOW_ALPHA);
				actionView.rotateStampImage(stampImage, action.marker.rotation);
				
				// Rotation first and and set x,y
				actionView.setPosition(stampImage, action.marker.position.x, action.marker.position.y);
				
				actionView.stampArea.addElementAt(stampImage, 0);
			}
			
			// Change state at last to enhance UX
			actionView.currentState = "dayView";
			updateUnitLabel();
		}
		
		
		private function actionRemovedHandler(e:ActivityEvent):void {
			getActionByCurrentDate();
		}
		
		private function fillActionIntoView():void {
			actionView.noteLabel.text = currentAction.note;
		}
		
		private function updateCurrentStamp():void {
			applicationStatus.currentStamp = applicationStatus.currentStamp || currentAction.marker.stamp;
		}
		
		private function getCurrentStamp():Stamp {
			return applicationStatus.currentStamp || currentAction.marker.stamp;
		}
		
		private function addStampToView(x:int, y:int, randomRotation:Boolean=false):void {
			currentStampImage = actionView.newStampImage(currentAction);
			if (randomRotation) {
				var rotation:int = getRandomRotation();
				rotateCurrentStampImage(rotation);
				currentAction.marker.rotation = rotation;
			} else {
				rotateCurrentStampImage(currentAction.marker.rotation);
			}
			
			// Rotation first and and set x,y
			actionView.setPosition(currentStampImage, x, y);

			actionView.stampArea.addElement(currentStampImage);
		}
		
		private function getRandomRotation():int {
			return int(Math.random() * 60 - 30);
		}
		
		private function rotateCurrentStampImage(rotation:Number):void {
			actionView.rotateStampImage(currentStampImage, rotation);
		}
		
		private function backHandler(e:MouseEvent):void {
			actionView.navigator.popView();
		}
		
		private function createStampHandler(e:MouseEvent):void {
			if (getCurrentStamp() != null) {
				currentAction.marker.stamp = getCurrentStamp();
				removeCurrentStampImage();
				addStampToView(e.localX, e.localY, true);
				actionView.enableOperationArea();
				saveAction();
			}
		}
		
		private function removeStampImages():void {
			actionView.stampArea.removeAllElements();
			currentStampImage = null; // important
		}
		
		private function removeCurrentStampImage():void {
			if (currentStampImage != null) {
				actionView.stampArea.removeElement(currentStampImage);
				currentStampImage = null; // important
			}
		}
		
		private function addNoteHandler(e:MouseEvent):void {
			actionView.noteLabel.text += (actionView.noteTextArea.text + "\n");
			currentAction.note = actionView.noteLabel.text;
			actionView.noteTextArea.text = "";
			if (currentStampImage != null) { // No stamp no action
				saveAction();
			}
		}
		
		private function saveAction():void {
			if (currentStampImage != null) {
				currentAction.marker.position = new Point(currentStampImage.x + currentStampImage.width / 2, currentStampImage.y + currentStampImage.width / 2);
				if (currentAction.isNew()) {
					dispatch(new ActivityEvent(ActivityEvent.ADD_ACTION, {activity: currentActivity, action: currentAction}));
				} else {
					dispatch(new ActivityEvent(ActivityEvent.SAVE_ACTION, currentAction));
				}
			}
		}
		
		private function actionAddedHandler(e:ActivityEvent):void {
			currentAction.id = e.data as int;
		}
		
		protected function changeViewHandler(event:IndexChangeEvent):void
		{
			var selectedItem:Object = actionView.changeViewBtnBar.selectedItem;
			if (selectedItem == "DAY_VIEW") {
				getActionByCurrentDate();
			} else if (selectedItem == "WEEK_VIEW") {
				actionView.currentState = "weekView";
				updateUnitLabel();
				actionView.actionWeekView.createDaysGrid(DateUtil.getSundayInCurrentWeek(applicationStatus.currentDate), DateUtil.today());			
			} else if (selectedItem == "MONTH_VIEW") {
				actionView.currentState = "monthView";
				updateUnitLabel();
				actionView.actionMonthView.createDaysGrid(applicationStatus.currentDate, DateUtil.today());
			}
		}
		
		private function cellClickHandler(e:ActionViewEvent):void {
			actionView.changeViewBtnBar.selectedItem = "DAY_VIEW";
			applicationStatus.currentDate = e.data as Date;
			dispatch(new StampSelectionEvent(StampSelectionEvent.CLEAR));
			getActionByCurrentDate();
		}
		
		private function removeActionHandler(e:MouseEvent):void {
			if (!currentAction.isNew()) {
				dispatch(new ActivityEvent(ActivityEvent.REMOVE_ACTION, {
					activity: currentActivity, action: currentAction
				}));
			}
		}
		
		private function previousUnitHandler(e:MouseEvent):void {
			if (actionView.currentState == "dayView") {
				applicationStatus.currentDate = DateUtil.prevDay(applicationStatus.currentDate);
				getActionByCurrentDate();
			} else if (actionView.currentState == "weekView") {
				applicationStatus.currentDate = DateUtil.prevWeek(applicationStatus.currentDate);
				updateUnitLabel();
				actionView.actionWeekView.createDaysGrid(DateUtil.getSundayInCurrentWeek(applicationStatus.currentDate), DateUtil.today());		
			} else if (actionView.currentState == "monthView") {
				applicationStatus.currentDate = DateUtil.prevMonth(applicationStatus.currentDate);
				updateUnitLabel();
				actionView.actionMonthView.createDaysGrid(applicationStatus.currentDate, DateUtil.today());	
			}
		}
		
		private function updateUnitLabel():void {
			actionView.updateUnitLabel(applicationStatus.currentDate);
		}
		
		private function nextUnitHandler(e:MouseEvent):void {
			if (actionView.currentState == "dayView") {
				applicationStatus.currentDate = DateUtil.nextDay(applicationStatus.currentDate);
				getActionByCurrentDate();
			} else if (actionView.currentState == "weekView") {
				applicationStatus.currentDate = DateUtil.nextWeek(applicationStatus.currentDate);
				updateUnitLabel();
				actionView.actionWeekView.createDaysGrid(DateUtil.getSundayInCurrentWeek(applicationStatus.currentDate), DateUtil.today());		
			} else if (actionView.currentState == "monthView") {
				applicationStatus.currentDate = DateUtil.nextMonth(applicationStatus.currentDate);
				updateUnitLabel();
				actionView.actionMonthView.createDaysGrid(applicationStatus.currentDate, DateUtil.today());	
			}
		}
		
	}
}