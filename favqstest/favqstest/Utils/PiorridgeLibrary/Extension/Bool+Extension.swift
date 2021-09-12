//
//  Bool+Extension.swift
//  PiorridgeLibrary
//
//  Created by Vu Phan on 28/08/2019.
//

import UIKit

public extension Bool {
	func pr_toInt() -> Int {
		return self ? 1 : 0
	}

	func pr_toString() -> String {
		return self ? "true" : "false"
	}

	func pr_toNSNumber() -> NSNumber {
		return self ? 1 : 0
	}
}
