//
//  UIBezierPath+Extension.swift
//  PiorridgeLibrary
//
//  Created by Vu Phan on 01/06/2020.
//

import Foundation
import UIKit

extension UIBezierPath {
	convenience init(shouldRoundRect rect: CGRect, topLeft: CGFloat, topRight: CGFloat, bottomLeft: CGFloat, bottomRight: CGFloat) {
		self.init()

		let mPath = CGMutablePath()

		let topLeftRadius = CGSize(width: topLeft, height: topLeft)
		let topRightRadius = CGSize(width: topRight, height: topRight)
		let bottomLeftRadius = CGSize(width: bottomLeft, height: bottomLeft)
		let bottomRightRadius = CGSize(width: bottomRight, height: bottomRight)

		let topLeft = rect.origin
		let topRight = CGPoint(x: rect.maxX, y: rect.minY)
		let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
		let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY)

		if topLeftRadius != .zero {
			mPath.move(to: CGPoint(x: topLeft.x + topLeftRadius.width,
								   y: topLeft.y))
		} else {
			mPath.move(to: topLeft)
		}

		if topRightRadius != .zero {
			mPath.addLine(to: CGPoint(x: topRight.x - topRightRadius.width,
									  y: topRight.y))
			mPath.addCurve(to:  CGPoint(x: topRight.x,
										y: topRight.y + topRightRadius.height),
						   control1: topRight,
						   control2:CGPoint(x: topRight.x,
											y: topRight.y + topRightRadius.height))
		} else {
			mPath.addLine(to: topRight)
		}

		if bottomRightRadius != .zero {
			mPath.addLine(to: CGPoint(x: bottomRight.x,
									  y: bottomRight.y - bottomRightRadius.height))
			mPath.addCurve(to: CGPoint(x: bottomRight.x - bottomRightRadius.width,
									   y: bottomRight.y),
						   control1: bottomRight,
						   control2: CGPoint(x: bottomRight.x - bottomRightRadius.width,
											 y: bottomRight.y))
		} else {
			mPath.addLine(to: bottomRight)
		}

		if bottomLeftRadius != .zero {
			mPath.addLine(to: CGPoint(x: bottomLeft.x + bottomLeftRadius.width,
									  y: bottomLeft.y))
			mPath.addCurve(to: CGPoint(x: bottomLeft.x,
									   y: bottomLeft.y - bottomLeftRadius.height),
						   control1: bottomLeft,
						   control2: CGPoint(x: bottomLeft.x,
											 y: bottomLeft.y - bottomLeftRadius.height))
		} else {
			mPath.addLine(to: bottomLeft)
		}

		if topLeftRadius != .zero {
			mPath.addLine(to: CGPoint(x: topLeft.x,
									  y: topLeft.y + topLeftRadius.height))
			mPath.addCurve(to: CGPoint(x: topLeft.x + topLeftRadius.width,
									   y: topLeft.y),
						   control1: topLeft,
						   control2: CGPoint(x: topLeft.x + topLeftRadius.width, y: topLeft.y))
		} else {
			mPath.addLine(to: topLeft)
		}

		mPath.closeSubpath()
		cgPath = mPath
	}
}
