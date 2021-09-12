//
//  UIImageView+Extension.swift
//  Porridge
//
//  Created by Vu Phan on 17/05/2019.
//  Copyright © 2019 Vu Phan. All rights reserved.
//

import UIKit

public extension UIImageView {
	func pr_colorImage(_ color: UIColor) {
		if let image = self.image {
			self.image = image.withRenderingMode(.alwaysTemplate)
			self.tintColor = color
		}
	}

	func pr_blurImage(style: UIBlurEffect.Style = .light) -> UIImageView {
		let imgView = self
		let view = imgView as UIView
		view.pr_blur(style: style)
		return view as! UIImageView
	}
}
