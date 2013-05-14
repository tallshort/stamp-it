package com.tallshort.tracker.service
{
	import com.tallshort.tracker.utils.Logger;
	
	import flash.data.SQLStatement;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.filesystem.FileMode;

	public class RepositoryCreationService extends RepositoryService
	{
		private static const INITED_FLAG:File = File.applicationStorageDirectory.resolvePath("inited");	
		
		public function RepositoryCreationService()
		{
			super();
		}
		
		public function createRepository():void {
			if (!INITED_FLAG.exists) {
				openSync(function():void {
					var statement:SQLStatement = createSyncSQLStatement(ActivityService.CREATE_ACTIVITY_DB_SQL);
					statement.execute();
					Logger.log("Activity table is created");
					statement = createSyncSQLStatement(StampService.CREATE_DB_SQL);
					statement.execute();
					Logger.log("Action table is created");
					statement = createSyncSQLStatement(ActivityService.CREATE_ACTION_DB_SQL);
					statement.execute();
					Logger.log("Stamp table is created");
					close();
					var stampService:StampService = new StampService();
					stampService.createPredefinedStamps();
					var stream:FileStream = new FileStream();
					stream.open(INITED_FLAG, FileMode.WRITE);
					stream.writeUTFBytes("inited");
					stream.close();
				});
			}
			
		}
		
	}
}