//
//  UIButton+Extension.swift
//  Porridge
//
//  Created by Vu Phan on 17/05/2019.
//  Copyright © 2019 Vu Phan. All rights reserved.
//

import UIKit

public extension UIButton {
	func pr_setImage(forName: String?, color: UIColor? = nil, for state: UIControl.State) {
		if let name = forName {
			let image = UIImage(named: name)
			self.setImage(image, for: state)
			if let color = color {
				pr_setImageColor(color)
			}
		} else {
			self.setImage(nil, for: state)
		}
	}

	func pr_setImageColor(_ color: UIColor) {
		let tintedImage = self.imageView?.image?.withRenderingMode(.alwaysTemplate)
		self.setImage(tintedImage, for: .normal)
		self.tintColor = color
	}

	func pr_setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
		UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
		UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
		UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
		let colorImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		self.setBackgroundImage(colorImage, for: state)
	}
}
