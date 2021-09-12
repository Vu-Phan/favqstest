//
//  UIScrollView+Extension.swift
//  PiorridgeLibrary
//
//  Created by Vu Phan on 31/08/2019.
//

import UIKit

public extension UIScrollView {
	func pr_snapshot() -> UIImage? {
		UIGraphicsBeginImageContextWithOptions(self.contentSize, false, 0)
		defer {
			UIGraphicsEndImageContext()
		}
		if let context = UIGraphicsGetCurrentContext() {
			let previousFrame = self.frame
			self.frame = CGRect(origin: self.frame.origin, size: self.contentSize)
			self.layer.render(in: context)
			self.frame = previousFrame
			return UIGraphicsGetImageFromCurrentImageContext()
		}
		return nil
	}
    
    // Scroll to a specific view so that it's top is at the top our scrollview
    func pr_scrollToView(view:UIView, animated: Bool) {
        if let origin = view.superview {
            // Get the Y position of your child view
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
            self.scrollRectToVisible(CGRect(x:0, y:childStartPoint.y,width: 1,height: self.frame.height), animated: animated)
        }
    }

    func pr_scrollToTop(animated: Bool) {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: animated)
    }

    func pr_scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        if bottomOffset.y > 0 {
            setContentOffset(bottomOffset, animated: true)
        }
    }
}
