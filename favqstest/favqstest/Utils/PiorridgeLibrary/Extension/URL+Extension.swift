//
//  URL+Extension.swift
//  PiorridgeLibrary
//
//  Created by Vu Phan on 31/08/2019.
//

import UIKit

public extension URL {
	func pr_getParameter() -> [String: String]? {
		if let components = URLComponents(url: self, resolvingAgainstBaseURL: false), let queryItems = components.queryItems {
			var items: [String: String] = [:]

			for queryItem in queryItems {
				items[queryItem.name] = queryItem.value
			}

			return items
		}
		return nil
	}
}
