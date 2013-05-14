package com.tallshort.tracker.utils
{
	public class DateUtil
	{
		
		public static const millisecondsPerMinute:int = 1000 * 60;  
		public static const millisecondsPerHour:int = millisecondsPerMinute * 60;  
		public static const millisecondsPerDay:int = millisecondsPerHour * 24;
		public static const millisecondsPerWeek:int = millisecondsPerDay * 7;
		public static const millisecondsPerBiweek:int = millisecondsPerDay * 14;
		public static const millisecondsPerMonth:int = millisecondsPerDay * 30;
		public static const millisecondsPerQuarterly:int = millisecondsPerMonth * 3;
		public static const millisecondsPerHalfyear: int = millisecondsPerMonth * 6;
		public static const millisecondsPerYear:int = millisecondsPerDay * 365;
		
		public static function daysOffset(date1:Date, date2:Date):int {
			return Math.floor(timeOffset(date1, date2) / millisecondsPerDay);
		}
		
		public static function weeksOffset(date1:Date, date2:Date):int {
			return Math.floor(timeOffset(date1, date2) / millisecondsPerWeek);
		}
		
		public static function biweeksOffset(date1:Date,date2:Date):int
		{
			return Math.floor(timeOffset(date1, date2) / millisecondsPerBiweek);
		}
		
		public static function monthsOffset(date1:Date,date2:Date):int
		{
			return Math.floor(timeOffset(date1, date2) / millisecondsPerMonth);
		}
		
		public static function quarterlyOffset(date1:Date,date2:Date):int
		{
			return Math.floor(timeOffset(date1, date2) / millisecondsPerQuarterly);
		}
		
		public static function halfyearOffset(date1:Date,date2:Date):int
		{
			return Math.floor(timeOffset(date1, date2) / millisecondsPerHalfyear);
		}
		
		public static function yearOffset(date1:Date, date2:Date):int {

			return Math.floor(timeOffset(date1, date2) / millisecondsPerYear);
		}
		
		private static function timeOffset(date1:Date, date2:Date):Number {
			return date2.getTime() - date1.getTime();
		}
		
		public static function today():Date {
			var d:Date = new Date();
			return new Date(d.fullYear, d.month, d.date, 0, 0, 0, 0);
		}
		
		public static function nextDay(day:Date):Date {
			return nNextDay(day, 1);
		}
		
		
		public static function nNextDay(day:Date, n:int):Date {
			var today:Date = today();
			today.setTime(day.getTime() + n * millisecondsPerDay);
			return today;
		}
		
		public static function prevDay(day:Date):Date {
			return nPrevDay(day, 1);
		}
		
		public static function nPrevDay(day:Date, n:int):Date {
			var today:Date = today();
			today.setTime(day.getTime() - n * millisecondsPerDay);
			return today;
		}
		
		public static function prevWeek(day:Date):Date {
			return nPrevDay(day, 7);
		}
		
		public static function prevMonth(day:Date):Date {
			if (day.month == 0) {
				return new Date(day.fullYear - 1, 11);
			} else {
				return new Date(day.fullYear, day.month - 1);
			}
		}
		
		public static function nextMonth(day:Date):Date {
			if (day.month == 11) {
				return new Date(day.fullYear + 1, 0);
			} else {
				return new Date(day.fullYear, day.month + 1);
			}
		}
		
		public static function nextWeek(day:Date):Date {
			return nNextDay(day, 7);
		}
		
		public static function monthString(time:Date):String {
			var y:String = time.fullYear.toString();
			var m:String = (time.month + 1) < 10 ? "0" + (time.month + 1).toString() : (time.month + 1).toString();
			return [y, m].join("-");
		}
		
		public static function dateString(time:Date):String {
			var y:String = time.fullYear.toString();
			var m:String = (time.month + 1) < 10 ? "0" + (time.month + 1).toString() : (time.month + 1).toString();
			var d:String = (time.date) < 10 ? "0" + time.date.toString() : time.date.toString();
			return [y, m, d].join("-");
		}
		
		/**
		 * returns day name for a particular day number in a week
		 */
		public static function getDayName(dayIndex:int):String
		{
			dayIndex++;
			switch (dayIndex) {
				case 1:
					return "Sunday";
					break;
				case 2:
					return "Monday";
					break;
				case 3:
					return "Tuesday";
					break;
				case 4:
					return "Wednesday";
					break;
				case 5:
					return "Thursday";
					break;
				case 6:
					return "Friday";
					break;
				case 7:
					return "Saturday";
					break;
				default:
					return "no day";
			}
		}
		
		public static function getDayShartName(dayIndex:int):String
		{
			dayIndex++;
			switch (dayIndex) {
				case 1:
					return "Su";
					break;
				case 2:
					return "Mo";
					break;
				case 3:
					return "Tu";
					break;
				case 4:
					return "We";
					break;
				case 5:
					return "Th";
					break;
				case 6:
					return "Fr";
					break;
				case 7:
					return "Sa";
					break;
				default:
					return "No";
			}
		}
		
		/**
		 * returns day count for a month 
		 */ 
		public static function getDaysCount(month:int, year:int):int {
			month++;
			switch (month)
			{
				case 1:
				case 3:
				case 5:
				case 7:
				case 8:
				case 10:
				case 12:
					return 31;
					break;
				case 4:
				case 6:
				case 9:
				case 11:
					return 30;
					break;
				case 2:
					if((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
						return 29;
					} else {
						return 28;
					}
					break;
				default:
					return -1;
			}
		}
		
		public static function compareTwoDates(smallDate:Date,bigDate:Date):int
		{
			var date1Timestamp : Number = smallDate.getTime ();
			var date2Timestamp : Number = bigDate.getTime ();
			var result : Number = -1;
			if (date1Timestamp == date2Timestamp)
			{
				result = 0;
			} 
			else if (date1Timestamp > date2Timestamp)
			{
				result = -1;
			}
			else 
			{
				result = 1;
			}
			return result;
		
		}
		
		public static function isSameDate(date1:Date, date2:Date):Boolean {
			return DateUtil.dateString(date1) == DateUtil.dateString(date2);
		}
		
		public static function getSaturdayInCurrentWeek(currentDate:Date):Date {
			return nNextDay(currentDate, 6 - currentDate.getDay());
		}
		
		public static function getSundayInCurrentWeek(currentDate:Date):Date {
			return nPrevDay(currentDate, currentDate.getDay());
		}
		
	}
}