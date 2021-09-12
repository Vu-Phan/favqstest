//
//  TimeInterval+Extension.swift
//  Porridge
//
//  Created by Vu Phan on 17/05/2019.
//  Copyright © 2019 Vu Phan. All rights reserved.
//

import UIKit

public extension TimeInterval {
	init(pr_hours: Int, minutes: Int, seconds: Int) {
		let timeInterval =  seconds + (minutes * 60) + (pr_hours * 60 * 60)
		self.init(timeInterval)
	}

	/// - get total hours
	var pr_hoursInTotal: Int {
		return Int(floor(((self / 60.0) / 60.0)))
	}
	/// - get hours by clock
	var pr_hours: Int {
		return pr_hoursInTotal % 24
	}
	/// - get total minutes
	var pr_minutesInTotal: Int {
		return Int(floor(self / 60.0))
	}
	/// - get minutes by clock
	var pr_minutes: Int {
		return pr_minutesInTotal - (pr_hours * 60)
	}
	/// - get total seconds
	var pr_secondsInTotal: Int {
		return Int(floor(self))
	}
	/// - get seconds by clock
	var pr_seconds: Int {
		return pr_secondsInTotal - (pr_minutes * 60)
	}
	/// - get total days
	var pr_days: Int {
		return pr_hoursInTotal / 24
	}

	func pr_getTimeFormat(withSeconds: Bool = true) -> String {
		let hoursStr = pr_hours < 10 ? "0" + String(pr_hours) : String(pr_hours)
		let minutesStr = pr_minutes < 10 ? "0" + String(pr_minutes) : String(pr_minutes)
		var secondsStr = ""
		if withSeconds {
			secondsStr = ":" + (pr_seconds < 10 ? "0" + String(pr_seconds) : String(pr_seconds))
		}
		return "\(hoursStr):\(minutesStr)\(secondsStr)"
	}
}
