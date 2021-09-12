//
//  UIWindow+Extension.swift
//  PiorridgeLibrary
//
//  Created by Vu Phan on 31/08/2019.
//

import UIKit

public extension UIWindow {
	func pr_changeRootVC(toVC: UIViewController, animated: Bool, duration: TimeInterval = 0.5, options: UIView.AnimationOptions = .transitionFlipFromRight, completion: (() -> Void)? = nil) {
		if animated {
			UIView.transition(with: self, duration: duration, options: options, animations: {
				let oldState = UIView.areAnimationsEnabled
				UIView.setAnimationsEnabled(false)
				self.rootViewController = toVC
				UIView.setAnimationsEnabled(oldState)
			}, completion: { _ in
				completion?()
			})
		} else {
			rootViewController = toVC
			completion?()
		}
	}
}
