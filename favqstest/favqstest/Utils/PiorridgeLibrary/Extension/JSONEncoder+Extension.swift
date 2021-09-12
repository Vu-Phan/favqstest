//
//  JSONEncoder+Extension.swift
//  PiorridgeLibrary
//
//  Created by Vu Phan on 01/06/2020.
//

import UIKit

public extension JSONEncoder {
	func pr_encode<T: Encodable>(from value: T?) -> Data? {
		guard let value = value else {
			return nil
		}
		return try? self.encode(value)
	}

	func pr_encodeInBackground<T: Encodable>(from encodableObject: T?, onEncode: @escaping (Data?) -> Void) {
		DispatchQueue.global().async {
			let encode = self.pr_encode(from: encodableObject)

			DispatchQueue.main.async {
				onEncode(encode)
			}
		}
	}
}
