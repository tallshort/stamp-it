package com.tallshort.tracker.service
{
	import com.tallshort.tracker.model.StyleItem;
	
	import mx.core.FlexGlobals;

	public class StyleSheetService
	{
		
		public function StyleSheetService()
		{
		}
		
		public function changeAppCSS(styleItem:StyleItem):void
		{
			if ( styleItem != null )
			{
				var url:String = getCssUrl(styleItem.name);
				FlexGlobals.topLevelApplication.styleManager.loadStyleDeclarations(url, true);
			}
		}
		
		private function getCssUrl(name:String):String
		{
			return "assets/css/" + name + ".swf";			
		}
	}
}