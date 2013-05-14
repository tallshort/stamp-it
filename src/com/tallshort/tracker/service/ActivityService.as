package com.tallshort.tracker.service
{
	import com.tallshort.tracker.events.ActivityEvent;
	import com.tallshort.tracker.model.Action;
	import com.tallshort.tracker.model.Activity;
	import com.tallshort.tracker.model.Marker;
	import com.tallshort.tracker.model.Requirement;
	import com.tallshort.tracker.model.Stamp;
	import com.tallshort.tracker.utils.DateUtil;
	
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.events.Event;
	import flash.events.SQLEvent;
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;

	public class ActivityService extends RepositoryService
	{	
		
		public static const CREATE_ACTIVITY_DB_SQL:String = "CREATE TABLE IF NOT EXISTS activities ("
																+ "id INTEGER PRIMARY KEY AUTOINCREMENT, "
																+ "title STRING, "
																+ "start_date DATE, "
																+ "description STRING, "
																+ "requirement_type STRING, "
																+ "requirement_frequency INTEGER, "
																+ "evaluation STRING, "
																+ "flag STRING)";
		private static const GET_ACTIVITIES_SQL:String = "SELECT * FROM activities ORDER BY title";
		private static const CREATE_ACTIVITY_SQL:String = "INSERT INTO activities (title, description, start_date, requirement_type, requirement_frequency, evaluation, flag) VALUES (:title, :description, :start_date, :requirement_type, :requirement_frequency, :evaluation, :flag)";
		private static const DELETE_ACTIVITY_SQL:String = "DELETE FROM activities WHERE id = :id";
		private static const SAVE_ACTIVITY_SQL:String = "UPDATE activities SET title = :title, description = :description, start_date = :start_date, requirement_type = :requirement_type, requirement_frequency = :requirement_frequency, evaluation = :evaluation, flag = :flag WHERE id = :id";
		
		public static const CREATE_ACTION_DB_SQL:String = "CREATE TABLE IF NOT EXISTS actions ("
																+ "id INTEGER PRIMARY KEY AUTOINCREMENT, "
																+ "created_on DATE, "
																+ "note STRING, "
																+ "stamp_position_x INTEGER, "
																+ "stamp_position_y INTEGER, "
																+ "stamp_rotation INTEGER, "
																+ "stamp_id INTEGER, "
																+ "activity_id INTERGER NOT NULL)";
		
		private static const CREATE_ACTION_SQL:String = "INSERT INTO actions (created_on, note, stamp_id, stamp_position_x, stamp_position_y, stamp_rotation, activity_id) VALUES (:created_on, :note, :stamp_id, :stamp_position_x, :stamp_position_y, :stamp_rotation, :activity_id)";
		private static const GET_ACTION_BY_DATE_SQL:String = "SELECT actions.*, stamps.location, stamps.passed FROM actions, stamps WHERE activity_id = :activity_id AND created_on = :created_on and stamps.id = actions.stamp_id";
		private static const GET_ACTIONS_BY_DATE_SQL:String = "SELECT actions.*, stamps.location, stamps.passed FROM actions, stamps WHERE created_on = :created_on AND stamps.id = actions.stamp_id";
		private static const GET_ACTIONS_BY_ACTIVITY_SQL:String = "SELECT actions.*, stamps.location, stamps.passed FROM actions, stamps WHERE activity_id = :activity_id AND stamps.id = actions.stamp_id";
		private static const REMOVE_ACTION_SQL:String = "DELETE FROM actions WHERE id = :action_id AND activity_id = :activity_id";
		private static const REMOVE_ACTIONS_SQL:String = "DELETE FROM actions WHERE activity_id = :activity_id";
		private static const SAVE_ACTION_SQL:String = "UPDATE actions SET note = :note, stamp_id = :stamp_id, stamp_position_x = :stamp_position_x, stamp_position_y = :stamp_position_y, stamp_rotation = :stamp_rotation WHERE id = :id";
		private static const GET_SAME_DATE_ACTIONS_SQL:String = "SELECT actions.*, stamps.location, stamps.passed FROM actions, stamps WHERE stamps.id = actions.stamp_id AND actions.id != :current_action_id AND actions.created_on = :current_action_created_on";
		private static const GET_ACTIVITY_FLAGS_BY_DATE_RANGE_SQL:String = "SELECT actions.created_on as action_created_on, flag as activity_flag FROM activities, actions, stamps WHERE activities.id = :activity_id AND date(created_on) BETWEEN :from_date AND :to_date AND actions.activity_id = activities.id AND stamps.id = actions.stamp_id AND stamps.passed = true ORDER BY created_on";
		
		private var getActivitiesStatement:SQLStatement;
		private var createActivityStatement:SQLStatement;
		private var saveActivityStatement:SQLStatement;
		private var deleteActivityStatement:SQLStatement;
		
		private var getActionByDateStatement:SQLStatement;
		private var getActionsByDateStatement:SQLStatement;
		private var getActionByActivityStatement:SQLStatement;
		private var addActionStatement:SQLStatement;
		private var removeActionStatement:SQLStatement;
		private var removeActionsStatement:SQLStatement;
		private var saveActionStatement:SQLStatement;
		private var getSameDataActionsStatement:SQLStatement;
		private var getActivityFlagsByDateRangeStatement:SQLStatement;
		
		public function ActivityService() {
		}
		
		public function fetchActivities():void {
			openAsync(function(e:Event):void {
				getActivitiesStatement = createAsyncSQLStatement(ActivityService.GET_ACTIVITIES_SQL, getActivitiesHandler);
				getActivitiesStatement.execute();
			});
		}
		
		private function getActivitiesHandler(e:SQLEvent):void {
			var result:SQLResult = getActivitiesStatement.getResult();
			var activityCollection:ArrayCollection = new ArrayCollection();
			if (result.data != null) {
				var numResults:int = result.data.length; 
				for (var i:int = 0; i < numResults; i++) {
					var row:Object = result.data[i]; 
					var activity:Activity = new Activity();
					fillActivityFromDataRow(activity, row);
					activityCollection.addItem(activity);
				}
			}
			close();
			dispatch(new ActivityEvent(ActivityEvent.ACTIVITIES_FETCHED, activityCollection));
		}
		
		public function fetchActivityFlagsByDateRange(activity:Activity, fromDate:Date, toDate:Date):void
		{
			openAsync(function(e:Event):void {
				getActivityFlagsByDateRangeStatement = createAsyncSQLStatement(ActivityService.GET_ACTIVITY_FLAGS_BY_DATE_RANGE_SQL, getActivitiesByDateRangeHandler);
				if (fromDate != null && toDate != null)
				{
					getActivityFlagsByDateRangeStatement.parameters[":activity_id"] = activity.id;
					getActivityFlagsByDateRangeStatement.parameters[":from_date"] = DateUtil.dateString(fromDate);
					getActivityFlagsByDateRangeStatement.parameters[":to_date"] = DateUtil.dateString(toDate);
				}
				getActivityFlagsByDateRangeStatement.execute();
			});
			
		}
		
		private function getActivitiesByDateRangeHandler(e:SQLEvent):void {
			var result:SQLResult = getActivityFlagsByDateRangeStatement.getResult();
			var activityFlagCollection:ArrayCollection = new ArrayCollection();
			if (result.data != null) {
				var numResults:int = result.data.length; 
				for (var i:int = 0; i < numResults; i++) {
					var row:Object = result.data[i]; 
					activityFlagCollection.addItem({
						activityFlag: row.activity_flag, 
						actionCreatedOn: row.action_created_on});
				}
			}
			close();
			dispatch(new ActivityEvent(ActivityEvent.ACTIVIT_FLAGS_BY_DATE_RANGE_FETCHED, activityFlagCollection));
		}
		
		private function fillActivityFromDataRow(activity:Activity, row:Object):void {
			activity.id = row.id;
			activity.title = row.title;
			activity.description = row.description;
			activity.startDate = row.start_date;
			var requirement:Requirement = new Requirement();
			requirement.type = row.requirement_type;
			requirement.frequency = row.requirement_frequency;
			activity.requirement = requirement;
			activity.evaluation = row.evaluation;
			activity.flag = row.flag;
		}
		
		public function createActivity(newActivity:Activity):void {
			openAsync(function(e:Event):void {
				createActivityStatement = createAsyncSQLStatement(ActivityService.CREATE_ACTIVITY_SQL, createActivityHandler);
				assignCreateOrSaveActivityParameters(createActivityStatement, newActivity);
				createActivityStatement.execute();
			});
		}
		
		private function createActivityHandler(e:SQLEvent):void {
			close();
			dispatch(new ActivityEvent(ActivityEvent.ACTIVITY_CREATED));
		}
		
		private function assignCreateOrSaveActivityParameters(statement:SQLStatement, activity:Activity):void {
			statement.parameters[":title"] = activity.title;
			statement.parameters[":description"] = activity.description;
			statement.parameters[":start_date"] = activity.startDate;
			statement.parameters[":requirement_type"] = activity.requirement.type;
			statement.parameters[":requirement_frequency"] = activity.requirement.frequency;
			statement.parameters[":evaluation"] = activity.evaluation;
			statement.parameters[":flag"] = activity.flag;
			if (!activity.isNew()) {
				statement.parameters[":id"] = activity.id;
			}
		}
		
		public function saveActivity(activity:Activity):void {
			openAsync(function(e:Event):void {
				saveActivityStatement = createAsyncSQLStatement(ActivityService.SAVE_ACTIVITY_SQL, saveActivityHandler);
				assignCreateOrSaveActivityParameters(saveActivityStatement, activity);
				saveActivityStatement.execute();
			});
		}
		
		private function saveActivityHandler(e:SQLEvent):void {
			close();
			dispatch(new ActivityEvent(ActivityEvent.ACTIVITY_SAVED));
		}
		
		public function deleteActivity(activity:Activity):void {
			openAsync(function(e:Event):void {
				deleteActivityStatement = createAsyncSQLStatement(ActivityService.DELETE_ACTIVITY_SQL, deleteActivityHandler);
				deleteActivityStatement.parameters[":id"] = activity.id;
				deleteActivityStatement.execute();
			});
		}
		
		private function deleteActivityHandler(e:SQLEvent):void {
			// Remove actions that belong to the given activity
			removeActionsStatement = createAsyncSQLStatement(ActivityService.REMOVE_ACTIONS_SQL, removeActionsHandler);
			removeActionsStatement.parameters[":activity_id"] = deleteActivityStatement.parameters[":id"];
			removeActionsStatement.execute();
		}
		
		private function removeActionsHandler(e:SQLEvent):void {
			close();
			// Now the activity related data is fully deleted.
			dispatch(new ActivityEvent(ActivityEvent.ACTIVITY_DELETED));
		}
		
		public function addAction(activity:Activity, newAction:Action):void {
			openAsync(function(e:Event):void {
				addActionStatement = createAsyncSQLStatement(ActivityService.CREATE_ACTION_SQL, addActionHandler);
				addActionStatement.parameters[":created_on"] = newAction.time;
				addActionStatement.parameters[":note"] = newAction.note;
				addActionStatement.parameters[":stamp_id"] = newAction.marker.stamp.id;
				addActionStatement.parameters[":stamp_position_x"] = newAction.marker.position.x;
				addActionStatement.parameters[":stamp_position_y"] = newAction.marker.position.y;
				addActionStatement.parameters[":stamp_rotation"] = newAction.marker.rotation;
				addActionStatement.parameters[":activity_id"] = activity.id;
				addActionStatement.execute();
			});
		}
		
		private function addActionHandler(e:SQLEvent):void {
			close();
			var addedActionId:int = addActionStatement.getResult().lastInsertRowID;
			dispatch(new ActivityEvent(ActivityEvent.ACTION_ADDED, addedActionId));
		}
		
		public function removeAction(activity:Activity, action:Action):void {
			openAsync(function(e:Event):void {
				removeActionStatement = createAsyncSQLStatement(ActivityService.REMOVE_ACTION_SQL, removeActionHandler);
				removeActionStatement.parameters[":action_id"] = action.id;
				removeActionStatement.parameters[":activity_id"] = activity.id;
				removeActionStatement.execute();
			});
		}
		
		private function removeActionHandler(e:SQLEvent):void {
			close();
			dispatch(new ActivityEvent(ActivityEvent.ACTION_REMOVED));
		}
		
		public function fetchAction(activity:Activity, date:Date):void {
			openAsync(function(e:Event):void {
				getActionByDateStatement = createAsyncSQLStatement(ActivityService.GET_ACTION_BY_DATE_SQL, getActionByDateHandler);
				getActionByDateStatement.parameters[":activity_id"] = activity.id;
				getActionByDateStatement.parameters[":created_on"] = date;
				getActionByDateStatement.execute();
			});
		}		
		
		private function getActionByDateHandler(e:SQLEvent):void {
			var result:SQLResult = getActionByDateStatement.getResult();
			var action:Action = new Action();
			if (result.data != null) {
				fillActionFromDataRow(action, result.data[0]);
			} else {
				action.time = getActionByDateStatement.parameters[":created_on"];
			}
			close();
			dispatch(new ActivityEvent(ActivityEvent.ACTION_FETCHED, action));
		}
		
		public function fetchActivityWithAction():void
		{
			openSync(function():void {
				getActivitiesStatement = createSyncSQLStatement(ActivityService.GET_ACTIVITIES_SQL);
				getActivitiesStatement.execute();
				getActivitiesWithActionHandler();
			});
		}
		
		private function getActivitiesWithActionHandler():void {
			var result:SQLResult = getActivitiesStatement.getResult();
			var activityCollection:ArrayCollection = new ArrayCollection();
			if ( result!= null && result.data != null) {
				var numResults:int = result.data.length; 
				for (var i:int = 0; i < numResults; i++) {
					var row:Object = result.data[i]; 
					var activity:Activity = new Activity();
					activity.id = row.id;
					activity.title = row.title;
					activity.description = row.description;
					activity.startDate = row.start_date;
					var requirement:Requirement = new Requirement();
					requirement.type = row.requirement_type;
					requirement.frequency = row.requirement_frequency;
					activity.requirement = requirement;
					activity.evaluation = row.evaluation;
					activity.flag = row.flag;	
					var actionsVector:Vector.<Action> = fetchActionByActivity(activity) as Vector.<Action>;
					activity.actions = actionsVector;
					activityCollection.addItem(activity);
				}
			}
			close();
			dispatch(new ActivityEvent(ActivityEvent.ACTIVITIES_WITH_ACTIONS_FETCHED, activityCollection));
		}
		
		private function fetchActionByActivity(activity:Activity):Vector.<Action>
		{			
			getActionByActivityStatement = createSyncSQLStatement(ActivityService.GET_ACTIONS_BY_ACTIVITY_SQL);
			getActionByActivityStatement.parameters[":activity_id"] = activity.id;
			getActionByActivityStatement.execute();
			return getActionByActivity();
		}
		
		private function getActionByActivity():Vector.<Action>
		{
			var result:SQLResult = this.getActionByActivityStatement.getResult();
			if ( result != null && result.data != null)
			{
				var actionsVector:Vector.<Action> = new Vector.<Action>();
				var numResults:int = result.data.length; 
				for (var i:int = 0; i < numResults; i++) 
				{
					var action:Action = new Action();
					fillActionFromDataRow(action, result.data[i]);
					actionsVector[i] = action ;
				}
				return actionsVector;
				
			}
			return null;
		}
		
		private function fillActionFromDataRow(action:Action, row:Object):void {
			// Stamp
			var stamp:Stamp = new Stamp();
			stamp.id = row.stamp_id;
			stamp.location = row.location;
			stamp.passed = row.passed;
			// Marker
			var marker:Marker = new Marker();
			marker.stamp = stamp;
			marker.position = new Point(row.stamp_position_x, row.stamp_position_y);
			marker.rotation = row.stamp_rotation;
			// Action
			action.id = row.id;
			action.time = row.created_on;
			action.note = row.note;
			action.marker = marker;
		}
		
		public function fetchActions(date:Date):void {
			openAsync(function(e:Event):void {
				getActionsByDateStatement = createAsyncSQLStatement(ActivityService.GET_ACTIONS_BY_DATE_SQL, getActionsByDateHandler);
				getActionsByDateStatement.parameters[":created_on"] = date;
				getActionsByDateStatement.execute();
			});
		}
		
		private function getActionsByDateHandler(e:SQLEvent):void {
			var result:SQLResult = getActionByDateStatement.getResult();
			var actionCollection:ArrayCollection = new ArrayCollection();
			if (result.data != null) {
				var numResults:int = result.data.length; 
				for (var i:int = 0; i < numResults; i++) {
					var action:Action = new Action();
					fillActionFromDataRow(action, result.data[i]);
					actionCollection.addItem(action);
				}
			}
			close();
			dispatch(new ActivityEvent(ActivityEvent.ACTIONS_FETCHED, actionCollection));
		}
		
		public function fetchSameDateActions(action:Action):void {
			openAsync(function(e:Event):void {
				getSameDataActionsStatement = createAsyncSQLStatement(ActivityService.GET_SAME_DATE_ACTIONS_SQL, getSameDateActionsHandler);
				getSameDataActionsStatement.parameters[":current_action_id"] = action.id;
				getSameDataActionsStatement.parameters[":current_action_created_on"] = action.time;
				getSameDataActionsStatement.execute();
			});
		}
		
		private function getSameDateActionsHandler(e:SQLEvent):void {
			var result:SQLResult = getSameDataActionsStatement.getResult();
			var actionCollection:ArrayCollection = new ArrayCollection();
			if (result.data != null) {
				var numResults:int = result.data.length; 
				for (var i:int = 0; i < numResults; i++) {
					var action:Action = new Action();
					fillActionFromDataRow(action, result.data[i]);
					actionCollection.addItem(action);
				}
			}
			close();
			dispatch(new ActivityEvent(ActivityEvent.SAME_DATE_ACTIONS_FETCHED, actionCollection));
		}
		
		
		public function saveAction(action:Action):void {
			openAsync(function(e:Event):void {
				saveActionStatement = createAsyncSQLStatement(ActivityService.SAVE_ACTION_SQL, saveActionHandler);
				saveActionStatement.parameters[":id"] = action.id;
				saveActionStatement.parameters[":note"] = action.note;
				saveActionStatement.parameters[":stamp_id"] = action.marker.stamp.id;
				saveActionStatement.parameters[":stamp_position_x"] = int(action.marker.position.x);
				saveActionStatement.parameters[":stamp_position_y"] = int(action.marker.position.y);
				saveActionStatement.parameters[":stamp_rotation"] = action.marker.rotation;
				saveActionStatement.execute();
			});
		}
		
		private function saveActionHandler(e:SQLEvent):void {
			close();
			dispatch(new ActivityEvent(ActivityEvent.ACTION_SAVED));
		}
	}
}