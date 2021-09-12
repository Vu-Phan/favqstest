//
//  Date+Extension.swift
//  Porridge
//
//  Created by Vu Phan on 17/05/2019.
//  Copyright © 2019 Vu Phan. All rights reserved.
//

import UIKit

// MARK: __ Format reminders
/// Reminders for date format
/// "EEEE, MMM d, yyyy" 			// Thursday, Sep 23, 2019
/// "MM/dd/yyyy" 					// 05/23/2019
/// "MM-dd-yyyy HH:mm"				// 05-23-2019 00:24
/// "MMM d, hh:mm a" 				// Sep 23, 06:24 AM
/// "MMMM yyyy" 					// September 2019
/// "MMM d, yyyy" 					// Sep 23, 2019
/// "E, d MMM yyyy HH:mm:ss Z"		// Thu, 23 Sep 2019 00:24:38 +0000
/// "yyyy-MM-dd'T'HH:mm:ssZ"		// 2019-05-23T00:24:38+0000
/// "HH:mm:ss.SSS"				// 00:24:38.884
/// "yyyy/MM-MMM/dd-E HH:mm:ss Z"	// 2019/09_Sep/23_Fri 00:24:23 +0000

public extension Date {
	// MARK:
	// MARK: __ Format
	func pr_toEasyPrint() -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy/MM_MMM/dd_E HH:mm:ss Z"
		return formatter.string(from: self)
	}

	func pr_getServerFormat() -> String {
		let formatter = DateFormatter()
		/// Apple Date class will automatically format from device's Locale
		/// specify the locale to ensure a specific format to send
		formatter.locale = Locale(identifier: "en_US_POSIX")
		formatter.timeZone = TimeZone(secondsFromGMT: 0)
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
		return formatter.string(from: self)
	}

	// MARK:
	// MARK: __ Time utils
	func pr_is24hFormat() -> Bool {
		var isMiliratyTime = true
		let formatter = DateFormatter()
		formatter.dateStyle = DateFormatter.Style.none
		formatter.timeStyle = DateFormatter.Style.short

		let dateString = formatter.string(from: self)
		let amRange = dateString.range(of: formatter.amSymbol)
		let pmRange = dateString.range(of: formatter.pmSymbol)
		isMiliratyTime = (amRange == nil && pmRange == nil)

		formatter.dateStyle = .medium
		formatter.timeStyle = .short

		return isMiliratyTime
	}

	func pr_getTimeFormat(withSeconds: Bool = false, in24h: Bool? = nil) -> String {
		let formatter = DateFormatter.init()

		var secondsFormat = ""
		if withSeconds {
			secondsFormat = ":ss"
		}
		let formatIn24h = "HH:mm\(secondsFormat)"
		let formatAmPm = "hh:mm\(secondsFormat) a"

		if let in24h = in24h {
			formatter.locale = Locale(identifier: "en_US_POSIX")
			if in24h {
				formatter.dateFormat = formatIn24h
			} else {
				formatter.dateFormat = formatAmPm
			}
		} else {
			formatter.dateFormat = formatIn24h
			if pr_is24hFormat() {
				formatter.dateFormat = formatAmPm
			}
		}

		return "\(formatter.string(from: self))"
	}

	func pr_resetHour() -> Foundation.Date? {
		return pr_setTime(hour: 0, min: 0, sec: 0)
	}

	func pr_setTime(hour: Int, min: Int, sec: Int, timeZoneAbbrev: String? = nil) -> Date? {
		let componentList: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
		let cal = Calendar.current
		var dateComponent = cal.dateComponents(componentList, from: self)

		dateComponent.hour = hour
		dateComponent.minute = min
		dateComponent.second = sec
		if let timeZoneAbbrev = timeZoneAbbrev {
			dateComponent.timeZone = TimeZone(abbreviation: timeZoneAbbrev)
		}

		return cal.date(from: dateComponent)
	}

	func pr_setTime(from: Date) -> Date? {
		let fromComponents: Set<Calendar.Component> = [.hour, .minute, .second]
		let cal = Calendar.current
		let fromDateComponent = cal.dateComponents(fromComponents, from: from)
		var dateComponent = cal.dateComponents(fromComponents, from: self)

		dateComponent.hour = fromDateComponent.hour
		dateComponent.minute = fromDateComponent.minute
		dateComponent.second = fromDateComponent.second

		return cal.date(from: dateComponent)
	}

	func pr_timeRoundedBy5() -> Date {
		let componentList: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
		let cal = Calendar.current
		var dateComponent = cal.dateComponents(componentList, from: self)

		var minutes = dateComponent.minute!
		let minuteUnit = ceil(CGFloat(minutes) / 5.0)
		minutes = Int(minuteUnit) * 5

		dateComponent.hour = dateComponent.hour
		dateComponent.minute = minutes
		dateComponent.second = 0

		return cal.date(from: dateComponent)!
	}

	func pr_getTimeZoneSeconds() -> TimeInterval {
		return TimeInterval(TimeZone.current.secondsFromGMT(for: self))
	}

	/// - HandleTimeZone
	/// transform a UTC date in the current TimeZone
	/// if UTC date is : Thu, 23 Sep 2019 00:00:00 +0000
	/// Paris TimeZone : Thu, 23 Sep 2019 02:00:00 +0200 - handleTimeZone : Thu, 23 Sep 2019 00:00:00 +0200
	/// San Francisco : Wed, 22 Sep 2019 17:00:00 -0700 - handleTimeZone : Thu, 23 Sep 2019 00:00:00 -0700
	func pr_handleTimeZone(_ forUTCDate: Date) -> Date {
		let dateTimeZone = TimeInterval(TimeZone.current.secondsFromGMT(for: forUTCDate))
		return forUTCDate.addingTimeInterval(-dateTimeZone)
	}


	// MARK:
	// MARK: __ Compare utils
	func pr_getSecondDiff(toDate: Foundation.Date) -> Int? {
		let diff = Calendar.current.dateComponents([.second], from: self, to: toDate).second
		if let diff = diff {
			return diff
		}
		return nil
	}

	func pr_getMinuteDiff(toDate: Foundation.Date) -> Int? {
		let diff = Calendar.current.dateComponents([.minute], from: self, to: toDate).minute
		if let diff = diff {
			return diff
		}
		return nil
	}

	func pr_getHourDiff(toDate: Foundation.Date) -> Int? {
		let diff = Calendar.current.dateComponents([.hour], from: self, to: toDate).hour
		if let diff = diff {
			return diff
		}
		return nil
	}

	func pr_getDayDiff(toDate: Foundation.Date) -> Int? {
		let diff = Calendar.current.dateComponents([.day], from: self, to: toDate).day
		if let diff = diff {
			return diff
		}
		return nil
	}

	func pr_getYearDiff(toDate: Foundation.Date) -> Int? {
		let diff = Calendar.current.dateComponents([.year], from: self, to: toDate).year
		if let diff = diff {
			return diff
		}
		return nil
	}

	func pr_isToday() -> Bool {
		return pr_isSameDay(Date())
	}

	func pr_isSameDay(_ withDate: Date) -> Bool {
		let calendar = Calendar.current
		let components1: DateComponents = calendar.dateComponents([.year, .month, .day], from: self)
		var components2: DateComponents? = nil
		components2 = calendar.dateComponents([.year, .month, .day], from: withDate)

		return components1.year == components2?.year && components1.month == components2?.month && components1.day == components2?.day
	}

	func pr_isSameMonth(_ anotherDate: Date) -> Bool {
		let calendar = Calendar.current
		let components1: DateComponents? = calendar.dateComponents([.year, .month], from: self)
		let components2: DateComponents? = calendar.dateComponents([.year, .month], from: anotherDate)
		return components1?.year == components2?.year && components1?.month == components2?.month
	}

	func pr_isSameYear(_ anotherDate: Date) -> Bool {
		let calendar = Calendar.current
		let components1: DateComponents? = calendar.dateComponents([.year], from: self)
		let components2: DateComponents? = calendar.dateComponents([.year], from: anotherDate)
		return components1?.year == components2?.year
	}

	func pr_isBetween(_ date: Foundation.Date, toDate: Foundation.Date) -> Bool {
		let ownDate = self.timeIntervalSinceReferenceDate
		let of = date.timeIntervalSinceReferenceDate
		let from = toDate.timeIntervalSinceReferenceDate
		if ownDate >= of && ownDate <= from {
			return true
		}
		return false
	}


	// MARK:
	// MARK: __ Calendar utils
	enum Weekday {
		case monday
		case sunday
	}

	func pr_getComponent(for component: Calendar.Component) -> Int{
		let calendar = Calendar.current
		return calendar.component(component, from: self)
	}

	func pr_add(component: Calendar.Component, value: Int) -> Date {
		return Calendar.current.date(byAdding: component, value: value, to: self)!
	}

	func pr_getWeekdayStart() -> Weekday {
		let currentCal = Calendar.current
		let firstDayOfCurrentWeek = currentCal.date(from: currentCal.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
		if let firstDayOfCurrentWeek = firstDayOfCurrentWeek {
			let firstDay = currentCal.dateComponents([.weekday], from: firstDayOfCurrentWeek)
			if firstDay.weekday == 2 {
				return .monday
			}
		}
		/// sunday = 1, monday = 2, ...
		return .sunday
	}

	func pr_getFirstWeekday() -> Foundation.Date {
		let weekdayComponent = Calendar.current.dateComponents([.weekday, .day], from: self)
		var componentToSubstract = DateComponents.init()

		var dayToSubstract = weekdayComponent.weekday! - 1
		if self.pr_getWeekdayStart() == .monday {
			dayToSubstract = weekdayComponent.weekday! - 2
			if dayToSubstract < 0 {
				dayToSubstract = 6
			}
		}
		componentToSubstract.day = -dayToSubstract
		return Calendar.current.date(byAdding: componentToSubstract, to: self)!
	}

	func pr_getWeekOfYear() -> Int {
		let calendar = Calendar.current
		let weekOfYear = calendar.component(.weekOfYear, from: self)
		return weekOfYear
	}

	func pr_getFirstOfMonth() -> Foundation.Date {
		let components = Calendar.current.dateComponents([.year, .month], from: self)
		return Calendar.current.date(from: components)!
	}

	func pr_getLastOfMonth() -> Foundation.Date {
		let components = Calendar.current.dateComponents([.year, .month], from: self)
		var newDate = Calendar.current.date(from: components)!
		newDate = newDate.pr_add(component: .month, value: 1)
		newDate = newDate.pr_add(component: .day, value: -1)
		return newDate
	}
}
