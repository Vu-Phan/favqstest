//
//  JSONDecoder+Extension.swift
//  PiorridgeLibrary
//
//  Created by Vu Phan on 01/06/2020.
//

import UIKit

public extension JSONDecoder {
	func pr_decode<T: Decodable>(from data: Data?) -> T? {
		guard let data = data else {
			return nil
		}
		return try? self.decode(T.self, from: data)
	}

	func pr_decodeInBackground<T: Decodable>(from data: Data?, onDecode: @escaping (T?) -> Void) {
		DispatchQueue.global().async {
			let decoded: T? = self.pr_decode(from: data)

			DispatchQueue.main.async {
				onDecode(decoded)
			}
		}
	}
}
