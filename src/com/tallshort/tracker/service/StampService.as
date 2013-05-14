package com.tallshort.tracker.service
{
	import com.tallshort.tracker.events.StampEvent;
	import com.tallshort.tracker.model.Activity;
	import com.tallshort.tracker.model.Stamp;
	import com.tallshort.tracker.utils.Logger;
	import com.tallshort.tracker.utils.DateUtil;
	
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.errors.SQLError;
	import flash.events.Event;
	import flash.events.SQLEvent;
	import flash.filesystem.*;
	
	import mx.collections.ArrayCollection;
	import mx.utils.ObjectUtil;
	
	import org.robotlegs.mvcs.Actor;

	public class StampService extends RepositoryService
	{
		public static const CREATE_DB_SQL:String = "CREATE TABLE IF NOT EXISTS stamps (" + "id INTEGER PRIMARY KEY AUTOINCREMENT, location STRING, passed BOOLEAN)";
		
		private static const CREATE_STAMP_SQL:String = "INSERT INTO stamps (location, passed) VALUES (:location, :passed)";
		private static const DELETE_STAMP_SQL:String = "DELETE FROM stamps WHERE id = :id";
		private static const GET_STAMPS_SQL:String = "SELECT * FROM stamps";
		
		private static const STAMPS_COUNT_SQL:String = "SELECT COUNT(*) as stamps_count FROM stamps";
		
		private static const GET_ACTION_STAMPS_BY_DATE_RANGE_SQL:String = "SELECT actions.created_on as action_created_on, stamps.* FROM actions, stamps WHERE activity_id = :activity_id AND date(created_on) BETWEEN :from_date AND :to_date AND stamps.id = actions.stamp_id ORDER BY created_on";
		
		private var createStampStatement:SQLStatement;
		private var deleteStampStatement:SQLStatement;
		private var fetchStampsStatement:SQLStatement;
		private var fetchActionStampsStatement:SQLStatement;
		
		public function StampService() {
		}
		
		public function createPredefinedStamps():void {
			openSync(function():void {
				createPredefinedStamp("assets/stamps/cross.png", false);
				createPredefinedStamp("assets/stamps/failed.png", false);
				createPredefinedStamp("assets/stamps/lvdouwa_sad.png", false);
				createPredefinedStamp("assets/stamps/huitailang.png", false);
				createPredefinedStamp("assets/stamps/Transformers_bad.png", false);
				createPredefinedStamp("assets/stamps/xiaowanzi_sad.png", false);
				createPredefinedStamp("assets/stamps/rain.png", false);
				createPredefinedStamp("assets/stamps/tick.png", true);
				createPredefinedStamp("assets/stamps/passed.png", true);
				createPredefinedStamp("assets/stamps/lvdouwa_happy.png", true);
				createPredefinedStamp("assets/stamps/xiyangyang.png", true);
				createPredefinedStamp("assets/stamps/Transformers_good.png", true);
				createPredefinedStamp("assets/stamps/xiaowanzi.png", true);
				createPredefinedStamp("assets/stamps/sun.png", true);
				createPredefinedStamp("assets/stamps/done.png", true);
				createPredefinedStamp("assets/stamps/goodwork_lion.png", true);
				createPredefinedStamp("assets/stamps/girl.png", true);
				createPredefinedStamp("assets/stamps/foot.png", true);
				createPredefinedStamp("assets/stamps/mushroom.png", true);
				createPredefinedStamp("assets/stamps/radish.png", true);
				createPredefinedStamp("assets/stamps/sunflower.png", true);
				createPredefinedStamp("assets/stamps/fish.png", true);
				createPredefinedStamp("assets/stamps/kenan.png", true);
				createPredefinedStamp("assets/stamps/watermelon.png", true);
				createPredefinedStamp("assets/stamps/jiqimiao.png", true);
				createPredefinedStamp("assets/stamps/xiongzhang.png", true);
			});
			Logger.log("Predefined stamps are created");
		}
		
		private function createPredefinedStamp(location:String, passed:Boolean):void {
			var statement:SQLStatement = createSyncSQLStatement(StampService.CREATE_STAMP_SQL);
			statement.parameters[":location"] = location;
			statement.parameters[":passed"] = passed;
			statement.execute();
		}
		
		public function createStamp(stamp:Stamp):void {
			openAsync(function(e:Event):void {
				createStampStatement = createAsyncSQLStatement(StampService.CREATE_STAMP_SQL, createStampHandler);
				createStampStatement.parameters[":location"] = stamp.location;
				createStampStatement.parameters[":passed"] = stamp.passed;
				createStampStatement.execute();
			});
		}
		
		private function createStampHandler(e:SQLEvent):void {
			close();
			dispatch(new StampEvent(StampEvent.STAMP_CREATED));
		}
		
		public function deleteStamp(stamp:Stamp):void {
			openAsync(function(e:Event):void {
				deleteStampStatement = createAsyncSQLStatement(StampService.DELETE_STAMP_SQL, deleteStampHandler);
				deleteStampStatement.parameters[":id"] = stamp.id;
				deleteStampStatement.execute();
			});
		}
		
		private function deleteStampHandler(e:SQLEvent):void {
			close();
			dispatch(new StampEvent(StampEvent.STAMP_CREATED));
		}
		
		public function getStamps():void {
			openAsync(function(e:Event):void {
				fetchStampsStatement = createAsyncSQLStatement(StampService.GET_STAMPS_SQL, getStampsHandler);
				fetchStampsStatement.execute();
			});
		}
		
		private function getStampsHandler(e:SQLEvent):void {
			var result:SQLResult = fetchStampsStatement.getResult();
			var arrCollection:ArrayCollection = getArrayCollectionFromResults(result);
			close();
			dispatch(new StampEvent(StampEvent.STAMPS_FETCHED, arrCollection));
		}
		
		private function getArrayCollectionFromResults(result:SQLResult):ArrayCollection
		{
			var arrCollection:ArrayCollection = new ArrayCollection();
			if ( result != null)
			{
				if ( result.data != null)
				{
					for ( var i:int = 0; i < result.data.length ; i++)
					{
						var stamp:Stamp = new Stamp();
						var row:Object = result.data[i];
						stamp.id = row.id;
						stamp.location = row.location;
						stamp.passed = row.passed;
						arrCollection.addItem(stamp);
					}	
				}				
			}
			return arrCollection;
		}
		
		public function fetchActionStamps(activity:Activity, fromDate:Date, toDate:Date):void {
			openAsync(function(e:Event):void {
				fetchActionStampsStatement = createAsyncSQLStatement(StampService.GET_ACTION_STAMPS_BY_DATE_RANGE_SQL, getActionStampsByDateRangeHandler);
				fetchActionStampsStatement.parameters[":activity_id"] = activity.id;
				fetchActionStampsStatement.parameters[":from_date"] = DateUtil.dateString(fromDate);
				fetchActionStampsStatement.parameters[":to_date"] = DateUtil.dateString(toDate);
				fetchActionStampsStatement.execute();
			});
		}
		
		private function getActionStampsByDateRangeHandler(e:SQLEvent):void {
			var result:SQLResult = fetchActionStampsStatement.getResult();
			var arrCollection:ArrayCollection = new ArrayCollection();
			if ( result != null)
			{
				if ( result.data != null)
				{
					for ( var i:int = 0; i < result.data.length ; i++)
					{
						var stamp:Stamp = new Stamp();
						var row:Object = result.data[i];
						stamp.id = row.id;
						stamp.location = row.location;
						stamp.passed = row.passed;
						var actionCreatedOn:Date = row.action_created_on;
						arrCollection.addItem({stamp: stamp, actionCreatedOn: actionCreatedOn});
					}	
				}				
			}
			close();
			dispatch(new StampEvent(StampEvent.ACTION_STAMPS_FETCHED, arrCollection));
		}
	}
}