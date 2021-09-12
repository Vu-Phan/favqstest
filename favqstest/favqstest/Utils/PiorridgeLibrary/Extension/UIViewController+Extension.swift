//
//  UIViewController+Extension.swift
//  Porridge
//
//  Created by Vu Phan on 22/08/2019.
//  Copyright © 2019 Vu Phan. All rights reserved.
//

import UIKit

public extension UIViewController {
	// MARK:
	// MARK: __ Keyboard handler
    @objc func pr_keyboardHandler(willDisplay: Bool, withRect: CGRect, animationDuration: TimeInterval) {
        // override to handle keyboard in view controller
    }

    func pr_keyboardSetupHandler() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.pr_keyboardNotificationHandler),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.pr_keyboardNotificationHandler),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func pr_keyboardNotificationHandler(_ notification: Notification) {
        var animationDuration = 0.30
        if let animationDurationVal = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval {
            animationDuration = animationDurationVal
        }

        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            pr_keyboardHandler(willDisplay: true, withRect: keyboardFrame.cgRectValue, animationDuration: animationDuration)
        }
        if notification.name == UIResponder.keyboardWillHideNotification {
            pr_keyboardHandler(willDisplay: false, withRect: CGRect.zero, animationDuration: animationDuration)
        }
    }

	// MARK:
	// MARK: __ Navigation
	var pr_isVisible: Bool {
		return self.isViewLoaded && self.view.window != nil
	}

    func pr_closeVC(_ animated: Bool = true, completion: (() -> Void)? = nil) {
		if self.navigationController?.popViewController(animated: animated) == nil {
			self.dismiss(animated: animated, completion: completion)
        } else {
            completion?()
        }
	}

	private func pr_getTopVC() -> UIViewController? {
		if self.presentedViewController == nil {
			return self
		}
		if let navigation = self.presentedViewController as? UINavigationController {
			return navigation.visibleViewController?.pr_getTopVC()
		}
		if let tab = self.presentedViewController as? UITabBarController {
			if let selectedTab = tab.selectedViewController {
				return selectedTab.pr_getTopVC()
			}
			let tabVC = tab as UIViewController
			return tabVC.pr_getTopVC()
		}
		return self.presentedViewController!.pr_getTopVC()
	}

	static func pr_getCurrentVC() -> UIViewController? {
		return UIApplication.shared.keyWindow?.rootViewController?.pr_getTopVC()
	}

	func pr_add(childVC: UIViewController, inView: UIView) {
		self.addChild(childVC)
		inView.addSubview(childVC.view)
		childVC.didMove(toParent: self)
	}

	func pr_removeFromParentVC() {
		if let _ = self.parent {
			self.willMove(toParent: nil)
			self.removeFromParent()
			self.view.removeFromSuperview()
		}
	}

	func pr_presentPopover(_ inVC: UIViewController, position: CGPoint, size: CGSize? = nil, delegate: UIPopoverPresentationControllerDelegate? = nil, animated: Bool = true, completion: (() -> Void)? = nil) {
		inVC.modalPresentationStyle = .popover
		if let size = size {
			inVC.preferredContentSize = size
		}
		if let inVC = inVC.popoverPresentationController {
			inVC.sourceView = self.view
			inVC.sourceRect = CGRect(origin: position, size: .zero)
			inVC.delegate = delegate
		}

		self.present(inVC, animated: animated, completion: completion)
	}

	// MARK:
	// MARK: __ Notification
	func pr_addNotification(name: Notification.Name, selector: Selector) {
		NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
	}

	func pr_removeNotification(name: Notification.Name) {
		NotificationCenter.default.removeObserver(self, name: name, object: nil)
	}

	func pr_removeFromNotificationCenter() {
		NotificationCenter.default.removeObserver(self)
	}



	// MARK:
	// MARK: __ Status bar
	func pr_applyBlurStatusBar() {
		let statWindow = UIApplication.shared.value(forKey:"statusBarWindow") as! UIView
		let statusBar = statWindow.subviews[0] as UIView

		if let _ = self.view.viewWithTag(242424) {
			return
		}

		if #available(iOS 10.0, *) {
			let blur = UIBlurEffect(style: .light)
			let visualEffect = UIVisualEffectView(effect: blur)
			visualEffect.frame = statusBar.frame
			visualEffect.backgroundColor = UIColor.init(white: 0.6, alpha: 0.1)
			visualEffect.alpha = 0
			visualEffect.tag = 242424
			self.view.addSubview(visualEffect)
			UIView.animate(withDuration: 0.25, animations: {
				visualEffect.alpha = 1
			}) { finished in

			}
		}
	}

	func pr_removeBlurStatusBar() {
		if let blurStatusBar = self.view.viewWithTag(242424) {
			UIView.animate(withDuration: 0.25, animations: {
				blurStatusBar.alpha = 0
			}) { finished in
				blurStatusBar.removeFromSuperview()
			}

		}
	}
}
