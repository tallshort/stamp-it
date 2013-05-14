package com.tallshort.tracker
{
	import com.tallshort.tracker.controller.*;
	import com.tallshort.tracker.events.ActivityEvent;
	import com.tallshort.tracker.events.StampEvent;
	import com.tallshort.tracker.model.ApplicationStatus;
	import com.tallshort.tracker.service.*;
	import com.tallshort.tracker.views.*;
	import com.tallshort.tracker.views.mediators.*;
	
	import flash.display.DisplayObjectContainer;
	
	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.mvcs.Context;
	
	public class ActivityTrackerContext extends Context
	{
		public function ActivityTrackerContext(contextView:DisplayObjectContainer=null, autoStartup:Boolean=true)
		{
			super(contextView, autoStartup);
		}
		
		override public function startup():void {
			
			injector.mapClass(ActivityService, ActivityService);
			injector.mapClass(StampService, StampService);
			injector.mapClass(RepositoryCreationService, RepositoryCreationService);
			injector.mapClass(StyleSheetService,StyleSheetService);
			
			injector.mapSingletonOf(ApplicationStatus, ApplicationStatus);
			
			mediatorMap.mapView(ActivityView, ActivityMediator);
			mediatorMap.mapView(NewOrEditActivityView, NewOrEditActivityMediator);
			mediatorMap.mapView(ChooseStampView, ChooseStampMediator);
			mediatorMap.mapView(ActionView, ActionMediator);

			mediatorMap.mapView(SettingsView, SettingsViewMediator);
			mediatorMap.mapView(AnalysisView, AnalysisViewMediator);
			
			mediatorMap.mapView(ActionWeekView, ActionWeekViewMediator);
			mediatorMap.mapView(ActionMonthView, ActionMonthViewMediator);
			
			commandMap.mapEvent(ActivityEvent.CREATE_ACTIVITY, CreateActivityCommand, ActivityEvent);
			commandMap.mapEvent(ActivityEvent.SAVE_ACTIVITY, SaveActivityCommand, ActivityEvent);
			commandMap.mapEvent(ActivityEvent.DELETE_ACTIVITY, DeleteActivityCommand, ActivityEvent);
			commandMap.mapEvent(ActivityEvent.FETCH_ACTIVITIES, FetchActivitiesCommand, ActivityEvent);
			commandMap.mapEvent(ActivityEvent.FETCH_ACTION_BY_DATE, FetchActionByDateCommand, ActivityEvent);
			commandMap.mapEvent(ActivityEvent.ADD_ACTION, AddActionCommand, ActivityEvent);
			commandMap.mapEvent(ActivityEvent.REMOVE_ACTION, RemoveActionCommand, ActivityEvent);
			commandMap.mapEvent(ActivityEvent.SAVE_ACTION, SaveActionCommand, ActivityEvent);
			commandMap.mapEvent(ActivityEvent.FETCH_SAME_DATE_ACTIONS, FetchSameDateActionsCommand, ActivityEvent);
			commandMap.mapEvent(ActivityEvent.FETCH_ACTIVITIES_BY_DATE_RANGE, FetchFlagsByDateRangeCommand, ActivityEvent);
			
			commandMap.mapEvent(StampEvent.FETCH_STAMPS, FetchStampsCommand, StampEvent);
			commandMap.mapEvent(StampEvent.ADD_STAMP_FROM_STORAGE, AddStampCommand, StampEvent);
			commandMap.mapEvent(StampEvent.FETCH_ACTION_STAMPS_BY_DATE_RANGE, FetchStampsByDateRangeCommand, StampEvent);
			
			commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, StartupCommand, ContextEvent, true);
			super.startup();
		}
	}
}