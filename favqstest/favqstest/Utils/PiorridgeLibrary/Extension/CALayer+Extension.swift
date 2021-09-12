//
//  CALayer+Extension.swift
//  Porridge
//
//  Created by Vu Phan on 22/05/2019.
//  Copyright © 2019 Vu Phan. All rights reserved.
//

import UIKit

public extension CALayer {
	func pr_addBorder(edgeList: [UIRectEdge], color: UIColor, thickness: CGFloat) {
		let border = CALayer()

		for edge in edgeList {
			switch edge {
				case .top:
					border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: thickness)
				case .bottom:
					border.frame = CGRect(x: 0, y: self.frame.height - thickness, width: self.frame.width, height: thickness)
				case .left:
					border.frame = CGRect(x: 0, y: 0, width: thickness, height: self.frame.height)
				case .right:
					border.frame = CGRect(x: self.frame.width - thickness, y: 0, width: thickness, height: self.frame.height)
				default:
					print("")
			}
		}

		border.backgroundColor = color.cgColor
		self.addSublayer(border)
	}

	//	private func addShadowWithRoundedCorners() {
	//		if let contents = self.contents {
	//			masksToBounds = false
	//			sublayers?.filter{ $0.frame.equalTo(self.bounds) }
	//				.forEach{ $0.roundCorners(radius: self.cornerRadius) }
	//			self.contents = nil
	//			if let sublayer = sublayers?.first,
	//				sublayer.name == Constants.contentLayerName {
	//
	//				sublayer.removeFromSuperlayer()
	//			}
	//			let contentLayer = CALayer()
	//			contentLayer.name = Constants.contentLayerName
	//			contentLayer.contents = contents
	//			contentLayer.frame = bounds
	//			contentLayer.cornerRadius = cornerRadius
	//			contentLayer.masksToBounds = true
	//			insertSublayer(contentLayer, at: 0)
	//		}
	//	}

	//	func addShadow() {
	//		self.shadowOffset = .zero
	//		self.shadowOpacity = 0.2
	//		self.shadowRadius = 10
	//		self.shadowColor = UIColor.black.cgColor
	//		self.masksToBounds = false
	//		if cornerRadius != 0 {
	//			addShadowWithRoundedCorners()
	//		}
	//	}
	//
	//	func roundCorners(radius: CGFloat) {
	//		self.cornerRadius = radius
	//		if shadowOpacity != 0 {
	//			addShadowWithRoundedCorners()
	//		}
	//	}
}
