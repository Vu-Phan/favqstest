//
//  NSObject+Extension.swift
//  Porridge
//
//  Created by Vu Phan on 18/05/2019.
//  Copyright © 2019 Vu Phan. All rights reserved.
//

import UIKit

public extension NSObject {
	static var pr_typeName: String {
		return String(describing: self)
	}
}
