package com.tallshort.tracker.views
{
	import com.tallshort.tracker.utils.DateUtil;
	import com.tallshort.tracker.events.ActionViewEvent;
	
	import flash.display.Sprite;
	
	import spark.components.TileGroup;
	
	public class ActionMonthView extends TileGroup
	{
		
		public function createDaysGrid(currentDate:Date, today:Date):void
		{
			var currentYear:int = currentDate.getFullYear();
			var currentMonth:int = currentDate.getMonth();
			this.removeAllElements();
			
			// always assume that first day of a month will have date as 1
			var firstDay:Date = new Date(currentYear, currentMonth, 1);
			
			// get total days count for currentMonth in currentYear
			var totalDaysInMonth:int = DateUtil.getDaysCount(currentMonth, currentYear);
			var i:int;
			
			// add empty items in case first day is not Sunday
			// i.e. MonthView always shows 7 coloumns starting from Sunday and ending to Saturday
			// so if it suppose Wednesday is the date 1 of this month that means we need to
			// add 3 empty cells at start
			var arrDays:Array = new Array();
			for(i = 0; i < firstDay.getDay(); i++) {
				arrDays.push(-1);
			}
			
			// now loop through total number of days in this month and save values in array
			for(i = 0; i < totalDaysInMonth; i++) {
				var nextDay:Date = new Date(currentYear, currentMonth, (i+1));
				var state:String = null;
				if (DateUtil.isSameDate(nextDay, today)) {	
					state = "highlighted";
				} else if (nextDay.getDay() == 0 || nextDay.getDay() == 6) {
					state = "weekend";
				} else {
					state = "normal";
				}
				arrDays.push({date:nextDay, label:(i+1).toString(), state: state});
			}
			
			// cols x 6 or 7 rows
			if (arrDays.length > 28) {
				if (arrDays.length <= 35) {
					for(i = arrDays.length; i < 35; i++) {
						arrDays.push(-1);
					}
				} else {
					for(i = arrDays.length; i < 42; i++) {
						arrDays.push(-1);
					}
				}
			}				
			
			// title row
			for(i = 0; i < 7; i++) {
				var cell:ActionMonthViewCell = new ActionMonthViewCell();
				cell.label = DateUtil.getDayShartName(i);
				cell.currentState = "title";
				addElement(cell);
			}
			// once array is created now loop through the array and generate the Grid
			for(i = 0; i < arrDays.length; i++) {
				var actionMonthViewCell:ActionMonthViewCell = new ActionMonthViewCell();
				if (arrDays[i] != -1) {
					actionMonthViewCell.date = arrDays[i].date;
					actionMonthViewCell.label = arrDays[i].label;
					actionMonthViewCell.currentState = arrDays[i].state;
				}
				addElement(actionMonthViewCell);
			}
			dispatchEvent(new ActionViewEvent(ActionViewEvent.LOAD_FLAGS, {
				fromDate: new Date(currentYear, currentMonth, 1),
				toDate: new Date(currentYear, currentMonth, totalDaysInMonth)
			}));
		}
	}
}