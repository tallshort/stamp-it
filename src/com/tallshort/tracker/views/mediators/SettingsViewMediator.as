package com.tallshort.tracker.views.mediators
{
	import com.tallshort.tracker.events.StampEvent;
	import com.tallshort.tracker.model.Stamp;
	import com.tallshort.tracker.model.StyleItem;
	import com.tallshort.tracker.service.StyleSheetService;
	import com.tallshort.tracker.views.ChooseStampView;
	import com.tallshort.tracker.views.SettingsView;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.MediaEvent;
	import flash.events.MouseEvent;
	import flash.media.CameraRoll;
	import flash.media.MediaPromise;
	import flash.media.Video;
	import flash.text.StyleSheet;
	import flash.ui.Mouse;
	
	import mx.resources.ResourceManager;
	
	import org.robotlegs.mvcs.Mediator;
	
	import spark.events.IndexChangeEvent;
	
	public class SettingsViewMediator extends Mediator 
	{
		[Inject]
		public var settingsView:SettingsView;
		
		[Inject]
		public var styleSheetService:StyleSheetService;
		
		private var cameraRoll:CameraRoll;
		private var stampLocation:String = "";
		
		public function SettingsViewMediator()
		{
			super();
		}
		
		override public function onRegister():void
		{
			eventMap.mapListener(settingsView.browseGallery, MouseEvent.CLICK, browseGalleryHandler, MouseEvent);
			eventMap.mapListener(settingsView.toGoodBtn, MouseEvent.CLICK, toGoodHandler, MouseEvent);
			eventMap.mapListener(settingsView.toBadBtn, MouseEvent.CLICK, toBadHandler, MouseEvent);
			eventMap.mapListener(settingsView.clearBtn, MouseEvent.CLICK, clearHandler, MouseEvent);			
			getCameraRollSupport();
		}
		
		protected function getCameraRollSupport():void
		{
			if (CameraRoll.supportsBrowseForImage)
			{
				settingsView.status.visible = false;
				cameraRoll = new CameraRoll();
				cameraRoll.addEventListener(MediaEvent.SELECT, mediaSelectHandler);
				cameraRoll.addEventListener(ErrorEvent.ERROR, errorHandler);
			}
			else
			{
				settingsView.status.visible = true;
			}
		}
		
		override public function onRemove():void {
			if (cameraRoll != null) {
				cameraRoll.removeEventListener(MediaEvent.SELECT, mediaSelectHandler);
				cameraRoll.removeEventListener(ErrorEvent.ERROR, errorHandler);
			}
		}
		
		protected function browseGalleryHandler(event:MouseEvent):void
		{
			if ( cameraRoll != null)
			{
				cameraRoll.browseForImage();
			}		
		}
		
		protected function toGoodHandler(event:MouseEvent):void
		{
			if ( "" != stampLocation)
			{
				var stamp:Stamp = new Stamp();
				stamp.location = this.stampLocation;
				stamp.passed = true;
				trace("add new good stamp: location ="+stamp.location+"; passed=true;");
				dispatch(new StampEvent(StampEvent.ADD_STAMP_FROM_STORAGE, stamp));				
			}	
		}
		
		protected function toBadHandler(event:MouseEvent):void
		{
			if ("" != stampLocation)
			{
				var stamp:Stamp = new Stamp();
				stamp.location = this.stampLocation;
				stamp.passed = false;
				trace("add new bad stamp: location ="+stamp.location+"; passed=false;");
				dispatch(new StampEvent(StampEvent.ADD_STAMP_FROM_STORAGE, stamp));
			}
		}
		
		protected function clearHandler(event:MouseEvent):void
		{
			settingsView.previewImage.source = null;
			stampLocation = "";
		}
		
		private function mediaSelectHandler(event:MediaEvent):void
		{
			var mediaPromise:MediaPromise = event.data;
			stampLocation = mediaPromise.file.url;
			settingsView.status.text = stampLocation;
			settingsView.previewImage.source = mediaPromise.file.url;			
		}
		
		private function errorHandler(event:ErrorEvent):void
		{
			trace("Select Camera Error");
		}

	}
}