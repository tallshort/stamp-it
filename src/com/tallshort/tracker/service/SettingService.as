package com.tallshort.tracker.service
{
	import com.tallshort.tracker.events.SettingEvent;
	
	import flash.events.Event;
	import flash.filesystem.*;
	import flash.net.*;
	
	import org.robotlegs.mvcs.Actor;
	
	public class SettingService extends Actor
	{
		private var settingFile:File = File.applicationStorageDirectory.resolvePath("activity_tracker.xml");
		
		private static const DEFAULT_SETTING:XML = 
			<setting>
			  <locale>en_US</locale>			
			</setting>;
		
		public function SettingService() {
			super();
		}
		
		public function loadSetting():XML {
			if (settingFile.exists) {
				var stream:FileStream = new FileStream();
				stream.open(settingFile, FileMode.READ); 
				var settingXML:XML = new XML(stream.readUTFBytes(stream.bytesAvailable)); 
				stream.close();
				return settingXML;
			} else {
				return DEFAULT_SETTING;
			}
		}
		
		public function saveSetting(settingXML:XML):void {
			var stream:FileStream = new FileStream();
			stream.open(settingFile, FileMode.WRITE); 
			stream.writeUTFBytes(settingXML.toXMLString());
		}
	}
}