//
//  PrDispatch.swift
//  PiorridgeLibrary
//
//  Created by Vu Phan on 21/08/2020.
//

import UIKit

public extension Pr {
	// MARK: - Dispatch
	class dispatch: NSObject {
		fileprivate var myWorker:DispatchWorkItem?
		func worker(_ bg: (() -> Void)?, main: (() -> Void)?) {
			/// cancel to avoid conflict
			myWorker?.cancel()
			myWorker = nil
			myWorker = DispatchWorkItem {
				bg?()
				DispatchQueue.main.async {
					main?()
				}
			}

			if let myWorker = myWorker {
				DispatchQueue.global(qos: .userInitiated).async(execute: myWorker)
			}
		}

		static func delay(_ value: Double, execute: @escaping (() -> Void)) {
			let time: Double = (Double(NSEC_PER_SEC) / value) / Double(NSEC_PER_SEC)
			let dispatchTime = DispatchTime.now() + time
			DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
				execute()
			})
		}
	}
}
