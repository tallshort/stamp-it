package com.tallshort.tracker.service
{
	import com.tallshort.tracker.utils.Logger;
	
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.events.*;
	import flash.filesystem.File;
	
	import org.robotlegs.mvcs.Actor;

	public class RepositoryService extends Actor
	{
		
		private var db:File = File.applicationStorageDirectory.resolvePath("activity_tracker.db");
		private var conn:SQLConnection;
		
		public function RepositoryService() {
		}
		
		protected function openSync(openHandler:Function):void {
			Logger.log("Open Sync DB");
			try {
				conn = new SQLConnection(); 
				conn.open(db);
				openHandler();
			} catch(e:Error) {
				Logger.error(e.errorID.toString() + ": " + e.message);
			}
		}
		
		protected function openAsync(openHandler:Function):void {
			Logger.log("Open Async DB");
			conn = new SQLConnection(); 
			conn.addEventListener(SQLEvent.OPEN, openHandler); 
			conn.addEventListener(SQLErrorEvent.ERROR, errorHandler); 
			conn.openAsync(db);
		}
		
		protected function createAsyncSQLStatement(sql:String, resultHandler:Function):SQLStatement {
			var statement:SQLStatement = new SQLStatement();
			statement.sqlConnection = conn;
			statement.text = sql;
			statement.addEventListener(SQLEvent.RESULT, resultHandler);
			statement.addEventListener(SQLErrorEvent.ERROR, errorHandler);
			return statement;
		}
		
		protected function createSyncSQLStatement(sql:String):SQLStatement {
			var statement:SQLStatement = new SQLStatement();
			statement.sqlConnection = conn;
			statement.text = sql;
			return statement;
		}
		
		protected function close():void {
			Logger.log("Close DB");
			if (conn != null) {
				conn.close();
			}
		}
		
		protected function errorHandler(event:SQLErrorEvent):void {
			Logger.error("Error message: " + event.error.message); 
			Logger.error("Error Details: " + event.error.details);
		}
	}
}