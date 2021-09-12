//
//  UITextView+Extension.swift
//  PiorridgeLibrary
//
//  Created by Vu Phan on 27/08/2019.
//

import UIKit

public extension UITextView {
	func pr_removePadding() {
		self.textContainerInset = .zero
		self.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
	}

	func pr_centerVertically() {
		/// - to be called in viewDidLayoutSuviews()
		let fittingSize = CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude)
		let size = self.sizeThatFits(fittingSize)
		let topOffset = (self.bounds.size.height - size.height * self.zoomScale) / 2
		let positiveTopOffset = max(1, topOffset)
		self.contentOffset.y = -positiveTopOffset
	}
}
