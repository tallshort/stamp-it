package com.tallshort.tracker.views.mediators
{
	import com.tallshort.tracker.events.StampEvent;
	import com.tallshort.tracker.model.Stamp;
	import com.tallshort.tracker.views.ChooseStampView;
	import com.tallshort.tracker.views.NewStampView;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.MediaEvent;
	import flash.events.MouseEvent;
	import flash.media.CameraRoll;
	import flash.media.MediaPromise;
	import flash.ui.Mouse;
	
	import org.osmf.media.MediaElement;
	import org.robotlegs.mvcs.Mediator;
	
	public class NewStampViewMediator extends Mediator
	{
		[Inject]
		public var newStampView:NewStampView;
		
		private var cameraRoll:CameraRoll;
		private var stampLocation:String = "";
		
		
		public function NewStampViewMediator()
		{
			super();
		}
		
		override public function onRegister():void
		{	
			eventMap.mapListener(newStampView.browseGallery, MouseEvent.CLICK, browseGalleryHandler, MouseEvent);
			eventMap.mapListener(newStampView.toGoodBtn, MouseEvent.CLICK, toGoodHandler, MouseEvent);
			eventMap.mapListener(newStampView.toBadBtn, MouseEvent.CLICK, toBadHandler, MouseEvent);
			eventMap.mapListener(newStampView.clearBtn, MouseEvent.CLICK, clearHandler, MouseEvent);
			eventMap.mapListener(newStampView.backBtn, MouseEvent.CLICK, backViewHandler, MouseEvent);
			addContextListener(StampEvent.ADD_STAMP_FROM_STORAGE, backViewHandler, StampEvent);
			getCameraRollSupport();
		}
		
		protected function getCameraRollSupport():void
		{
			if (CameraRoll.supportsBrowseForImage)
			{
				cameraRoll = new CameraRoll();
				cameraRoll.addEventListener(MediaEvent.SELECT, mediaSelectHandler);
				cameraRoll.addEventListener(ErrorEvent.ERROR, errorHandler);
			}
			else
			{
				newStampView.status.text = "CameraRoll is unsupported on your device";
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
			newStampView.previewImage.source = null;
			stampLocation = "";
		}
		
		protected function backViewHandler(event:Event):void
		{
			newStampView.navigator.popView();		
		}
	
		private function mediaSelectHandler(event:MediaEvent):void
		{
			var mediaPromise:MediaPromise = event.data;
			stampLocation = mediaPromise.file.url;
			newStampView.status.text = stampLocation;
			newStampView.previewImage.source = mediaPromise.file.url;			
		}
		
		private function errorHandler(event:ErrorEvent):void
		{
			trace("Select Camera Error");
		}
	}
}