package com.tallshort.tracker.views.mediators
{
	import com.tallshort.tracker.events.StampEvent;
	import com.tallshort.tracker.events.StampSelectionEvent;
	import com.tallshort.tracker.model.ApplicationStatus;
	import com.tallshort.tracker.model.Stamp;
	import com.tallshort.tracker.views.ActionView;
	import com.tallshort.tracker.views.ChooseStampView;
	import com.tallshort.tracker.views.NewStampView;
	import com.tallshort.tracker.views.items.StampItemRenderer;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	import mx.events.FlexEvent;
	
	import org.robotlegs.mvcs.Mediator;
	
	import spark.events.IndexChangeEvent;
	
	public class ChooseStampMediator extends Mediator
	{
		[Inject]
		public var chooseStampView:ChooseStampView;
		
		[Inject]
		public var applicationStatus:ApplicationStatus;
		
		private var previousSelectedStampRenderer:StampItemRenderer;
		
		private var timeoutId:uint;
		
		public function ChooseStampMediator() {
			super();
		}
		
		override public function onRegister():void {
			addViewListener(StampSelectionEvent.STAMP_SELECTED, stampSelectionHandler, StampSelectionEvent);
			addContextListener(StampEvent.STAMPS_FETCHED, stampsFetchedHandler, StampEvent);
			addContextListener(StampSelectionEvent.CLEAR, clearHandler, StampSelectionEvent);
			// UX enhancement
			timeoutId = setTimeout(loadStampsIntoView, 1000);
		}
		
		protected function loadStampsIntoView():void {
			clearTimeout(timeoutId);
			dispatch(new StampEvent(StampEvent.FETCH_STAMPS));			
		}
		
		protected function stampsFetchedHandler(event:StampEvent):void {
			var stampCollection:ArrayCollection = event.data as ArrayCollection;
			var resultArray:Array = getGoodAndBadStampCollections(stampCollection);
			chooseStampView.goodStampChooser.stampCollection = resultArray[0] as ArrayCollection;
			chooseStampView.badStampChooser.stampCollection = resultArray[1] as ArrayCollection;
			chooseStampView.currentState = "loaded";
		}
		
		private function getGoodAndBadStampCollections(stampCollection:ArrayCollection):Array {
			var goodStampCollection:ArrayCollection = new ArrayCollection();
			var badStampCollection:ArrayCollection = new ArrayCollection();
			for (var i:int = 0; i < stampCollection.length; i++) {
				var stamp:Stamp = stampCollection.getItemAt(i) as Stamp;
				if (stamp.passed) {
					goodStampCollection.addItem(stamp);
				} else {
					badStampCollection.addItem(stamp);
				}
			}
			return [goodStampCollection, badStampCollection];
		}

		protected function stampSelectionHandler(event:StampSelectionEvent):void {
			var currentSelectedStampRenderer:StampItemRenderer = event.target as StampItemRenderer;
			if (previousSelectedStampRenderer != currentSelectedStampRenderer) {
				clear();
				previousSelectedStampRenderer = currentSelectedStampRenderer;
				currentSelectedStampRenderer.selected = true;
				applicationStatus.currentStamp = currentSelectedStampRenderer.data as Stamp;
			} else {
				if (previousSelectedStampRenderer.selected == true) {
					clear();
				} else {
					previousSelectedStampRenderer.selected = true;
					applicationStatus.currentStamp = previousSelectedStampRenderer.data as Stamp;
				}
			}
		}
		
		protected function clearHandler(event:StampSelectionEvent):void {
			clear();
		}
		
		private function clear():void {
			if (previousSelectedStampRenderer != null) {
				previousSelectedStampRenderer.selected = false;
				applicationStatus.currentStamp = null;
			}
		}
		
	}
}