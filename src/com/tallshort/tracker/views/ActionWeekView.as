package com.tallshort.tracker.views
{
	import com.tallshort.tracker.events.ActionViewEvent;
	import com.tallshort.tracker.utils.DateUtil;
	
	import flash.display.Sprite;
	
	import spark.components.TileGroup;
	
	public class ActionWeekView extends TileGroup
	{
		public function createDaysGrid(sundayInWeek:Date, today:Date):void {
			this.removeAllElements();
			for (var i:int = 0; i < 7; i++) {
				var actionWeekViewCell:ActionWeekViewCell = new ActionWeekViewCell();
				actionWeekViewCell.dayLabel = DateUtil.getDayName(i);
				var date:Date = DateUtil.nNextDay(sundayInWeek, i);
				if (DateUtil.isSameDate(date, today)) {
					actionWeekViewCell.currentState = "highlighted";
				}
				actionWeekViewCell.date = date;
				actionWeekViewCell.dateLabel = DateUtil.dateString(date);
				addElement(actionWeekViewCell);
			}
			dispatchEvent(new ActionViewEvent(ActionViewEvent.LOAD_STAMPS, {
				fromDate: sundayInWeek,
				toDate: DateUtil.nNextDay(sundayInWeek, 6)
			}));
		}
	}
}