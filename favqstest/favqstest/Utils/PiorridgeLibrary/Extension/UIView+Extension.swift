//
//  UIView+Extension.swift
//  Porridge
//
//  Created by Vu Phan on 17/05/2019.
//  Copyright © 2019 Vu Phan. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
	// MARK:
	// MARK: __ Utils & Easy access
	static func pr_nib() -> UINib {
		return UINib.init(nibName: String(describing: self), bundle: nil)
	}

	static func pr_nibView(forOwner: Any, nibName: String? = nil) -> UIView? {
		var forNibName = String(describing: self)
		if let nibName = nibName {
			forNibName = nibName
		}
		/// - By default, Bundle is set on main, so make sure it is from class bundle (ex: Pods)
		let bundle = Bundle.init(for: self.classForCoder())
		let nib = UINib(nibName: forNibName, bundle: bundle)
		let nibViews = nib.instantiate(withOwner: forOwner, options: nil)
		return nibViews[0] as? UIView
	}

	var pr_top: CGFloat {
		get {
			return self.frame.origin.y;
		}
		set(newTop) {
			self.frame = CGRect.init(x: self.frame.origin.x,
									y: newTop,
									width: self.frame.size.width,
									height: self.frame.size.height)
		}
	}

	var pr_right: CGFloat {
		get {
			return self.frame.origin.x + self.frame.size.width;
		}
		set(newRight) {
			self.frame = CGRect.init(x: newRight - self.frame.size.width,
									y: self.frame.origin.y,
									width: self.frame.size.width,
									height: self.frame.size.height)
		}
	}

	var pr_bottom: CGFloat {
		get {
			return self.frame.origin.y + self.frame.size.height;
		}
		set(newBottom) {
			self.frame = CGRect.init(x: self.frame.origin.x,
									y: newBottom - self.frame.size.height,
									width: self.frame.size.width,
									height: self.frame.size.height)
		}
	}

	var pr_left: CGFloat {
		get {
			return self.frame.origin.x;
		}
		set(newLeft) {
			self.frame = CGRect.init(x: newLeft,
									y: self.frame.origin.y,
									width: self.frame.size.width,
									height: self.frame.size.height)
		}
	}

	var pr_height: CGFloat {
		get {
			return self.frame.size.height;
		}
		set (newHeight) {
			self.frame = CGRect.init(x: self.frame.origin.x,
									y: self.frame.origin.y,
									width: self.frame.size.width,
									height: newHeight)
		}
	}

	var pr_width: CGFloat {
		get {
			return self.frame.size.width;
		}
		set (newWidth) {
			self.frame = CGRect.init(x: self.frame.origin.x,
									y: self.frame.origin.y,
									width: newWidth,
									height: self.frame.size.height)
		}
	}

	func pr_frameSize() -> CGRect {
		let frameRect = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
		return frameRect
	}

	func pr_addSubviewList(_ subviewList: [UIView]) {
		subviewList.forEach { self.addSubview($0) }
	}

	func pr_getAllSubviewList(_ ofView: UIView? = nil) -> [UIView] {
		var allSubviewList = [UIView]()
		var fromView = self as UIView
		if let ofView = ofView {
			fromView = ofView
		}

		for subview in fromView.subviews {
			allSubviewList += pr_getAllSubviewList()
			allSubviewList.append(subview)
		}

		return allSubviewList
	}

	func pr_removeSubviews() {
		for subview in self.subviews {
			subview.removeFromSuperview()
		}
	}

	func pr_removeAllGestureRecognizer() {
		self.gestureRecognizers?.forEach(self.removeGestureRecognizer)
	}

	func pr_getScreenshotImage() -> UIImage? {
		UIGraphicsBeginImageContextWithOptions(self.layer.frame.size, false, 0)
		defer { UIGraphicsEndImageContext() }
		if let context = UIGraphicsGetCurrentContext() {
			self.layer.render(in: context)
			return UIGraphicsGetImageFromCurrentImageContext()
		}
		return nil
	}

	// MARK:
	// MARK: __ Keyboard handler
    func pr_setupKeyboardHideOnTap(cancelTouches: Bool? = false) -> UITapGestureRecognizer {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(pr_dimissKeyboard))
        tap.cancelsTouchesInView = cancelTouches!
        self.addGestureRecognizer(tap)
        
        return tap
    }

    @objc func pr_dimissKeyboard() {
        self.endEditing(true)
    }


	// MARK:
	// MARK: __ Constraint method
	func pr_setConstraint(forId: String, withValue: CGFloat) {
		for constraint in self.constraints {
			if constraint.identifier == forId {
				constraint.constant = withValue
			}
		}
	}

	func pr_getConstraint(forId: String) -> NSLayoutConstraint? {
		for constraint in self.constraints {
			if constraint.identifier == forId {
				return constraint
			}
		}
		return nil
	}

	func pr_setupEdgeConstraint(toView: UIView, edgeList: [NSLayoutConstraint.Attribute]) {
		self.translatesAutoresizingMaskIntoConstraints = false
		for edge in edgeList {
			let layoutConstraint = NSLayoutConstraint(item: self, attribute: edge, relatedBy: .equal,
													  toItem: toView, attribute: edge, multiplier: 1, constant: 0)
			toView.addConstraint(layoutConstraint)
		}
	}

	func pr_setConstraint(_ forConstraintList: [NSLayoutConstraint.Attribute: CGFloat]) {
		for constraint in self.constraints {
			for (key, value) in forConstraintList {
				if constraint.firstAttribute == key || constraint.secondAttribute == key {
					constraint.constant = value
				}
			}
		}
	}
    
    func pr_setHeightConstraint(_ value: CGFloat) {
        for constraint in self.constraints {
            if constraint.firstAttribute == .height {
                constraint.constant = value
            }
        }
    }

	// MARK:
	// MARK: __ Safe Area handlers
	func pr_getSafeOffset() -> (top: CGFloat, bottom: CGFloat) {
		var statusBarTop: CGFloat = 20
		var safeBottom: CGFloat = 0

		if #available(iOS 11.0, *) {
			if let top = UIApplication.shared.keyWindow?.safeAreaInsets.top {
				if top != 0 {
					statusBarTop = top
				}

			}
			if let safeAreabottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom {
				if safeAreabottom != 0 {
					safeBottom = safeAreabottom
				}
			}
		}

		return (top: statusBarTop, bottom: safeBottom)
	}



	// MARK:
	// MARK: __ Loading handlers
	func pr_loadingIndicator(_ display: Bool) {
		if display {
			pr_loading() /// - display UI in view
		} else {
			pr_active() /// - clear UI in view
		}
	}

	func pr_loading() {
		if let _ = self.viewWithTag(4200) {
			// View is already loading
		} else {
			let loadingView = UIView(frame: self.bounds)
			loadingView.backgroundColor = UIColor(white: 0.7, alpha: 0.1)
			loadingView.tag = 4200
			loadingView.alpha = 0.0

			let activity = UIActivityIndicatorView(style: .medium)
			activity.hidesWhenStopped = true
			activity.center = loadingView.center
			loadingView.addSubview(activity)
			activity.startAnimating()
			self.addSubview(loadingView)

			UIView.animate(withDuration: 0.2) {
				loadingView.alpha = 1.0
			}
		}
	}

	func pr_active() {
		if let loadingView = self.viewWithTag(4200) {
			UIView.animate(withDuration: 0.2, animations: {
				loadingView.alpha = 0.0
			}) { finished in
				loadingView.removeFromSuperview()
			}
		}
	}

	// MARK:
	// MARK: __ UI FX
	enum PrRectCorner {
		case topLeft
		case topRight
		case bottomLeft
		case bottomRight
		case all
	}

	func pr_roundBackground(color: UIColor? = nil, radius: CGFloat? = nil) {
		var layerColor = UIColor.black
		if let color = color {
			layerColor = color
		} else if let color = self.backgroundColor {
			layerColor = color
		}
		self.layer.backgroundColor = layerColor.cgColor
		if let radius = radius {
			self.layer.cornerRadius = radius
		} else {
			self.layer.cornerRadius = self.pr_height / 2
		}
	}

	func pr_round(radius: CGFloat) {
		let maskPath = UIBezierPath(roundedRect			: self.bounds,
									byRoundingCorners	: .allCorners,
									cornerRadii			: CGSize(width: radius, height: radius))
		let shape = CAShapeLayer()
		shape.path = maskPath.cgPath
		self.layer.mask = shape
		self.layer.shouldRasterize = true
		self.layer.rasterizationScale = UIScreen.main.scale
	}


	func pr_roundCorners(_ corners: [PrRectCorner: CGFloat], withBorder: (color: UIColor, width: CGFloat)? = nil) {
		var maskPath = UIBezierPath(shouldRoundRect: bounds,
									topLeft: corners[.topLeft] ?? 0,
									topRight: corners[.topRight] ?? 0,
									bottomLeft: corners[.bottomLeft] ?? 0,
									bottomRight: corners[.bottomRight] ?? 0)
		if let all = corners[.all] {
			maskPath = UIBezierPath(roundedRect			: self.bounds,
									byRoundingCorners	: .allCorners,
									cornerRadii			: CGSize(width: all, height: all))
		}
		let shape = CAShapeLayer()
		shape.path = maskPath.cgPath
		layer.mask = shape

		if let withBorder = withBorder {
			let borderLayer = CAShapeLayer()
			borderLayer.path = (layer.mask! as! CAShapeLayer).path!
			borderLayer.strokeColor = withBorder.color.cgColor
			borderLayer.fillColor = UIColor.clear.cgColor
			borderLayer.lineWidth = withBorder.width
			borderLayer.frame = bounds
			layer.addSublayer(borderLayer)
		}
		
		layer.shouldRasterize = true
		layer.rasterizationScale = UIScreen.main.scale
	}

	func pr_addShadow(color: UIColor = UIColor.init(pr_rgb: 0x333333), radius: CGFloat = 3, offset: CGSize = CGSize(width: 4.0, height: 4.0), opacity: Float = 0.5) {
		self.layer.cornerRadius = radius
		self.layer.shadowRadius = radius
		self.layer.shadowOffset = offset
		self.layer.shadowColor = color.cgColor
		self.layer.shadowOpacity = opacity
		self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: radius).cgPath
		self.layer.shouldRasterize = true
		self.layer.rasterizationScale = UIScreen.main.scale
	}

    func pr_fadeOut(_ forAlpha: CGFloat = 0, _ completion: (() -> Void)? = nil) {
		UIView.animate(withDuration: 0.3, animations: {
			self.alpha = forAlpha
		}, completion: { (success) in
			if completion != nil {
				completion!()
			}
		})
	}

	func pr_fadeIn(_ completion: (() -> Void)? = nil) {
		UIView.animate(withDuration: 0.3, animations: {
			self.alpha = 1.0
		}, completion: { (success) in
			if completion != nil {
				completion!()
			}
		})
	}

	func pr_blur(style:UIBlurEffect.Style) {
		let blurEffect = UIBlurEffect(style: style)
		let blurEffectView = UIVisualEffectView(effect: blurEffect)
		blurEffectView.frame = self.bounds
		blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		blurEffectView.alpha = 0.8
		blurEffectView.tag = 24000

		self.addSubview(blurEffectView)
	}

	func pr_removeBlur() {
		if let blurView = self.viewWithTag(24000) {
			UIView.animate(withDuration: 0.2, animations: {
				blurView.alpha = 0.0
			}) { finished in
				blurView.removeFromSuperview()
			}
		}
	}

	func pr_rotate(by rotation: CGFloat, animations: (() -> Void)?, duration: TimeInterval = 0.25, completion: ((Bool) -> Void)?) {
		UIView.animate(withDuration : duration,
					   delay        : 0.0,
					   options      : .curveLinear,
					   animations   : {
						self.self.transform = self.self.transform.rotated(by: rotation)
						if animations != nil {
							animations!()
						}
		}, completion: { (finished: Bool) in
			if completion != nil {
				completion!(finished)
			}
		})
	}

	func pr_scale(withOffset: CGPoint, animated: Bool = false, duration: TimeInterval = 0.25, completion: ((Bool) -> Void)? = nil) {
		if animated {
			UIView.animate(withDuration	: duration,
						   delay		: 0,
						   options		: .curveLinear,
						   animations	: { () -> Void in
							self.self.transform = self.self.transform.scaledBy(x: withOffset.x, y: withOffset.y)
			}, completion: completion)
		} else {
			self.transform = self.transform.scaledBy(x: withOffset.x, y: withOffset.y)
			completion?(true)
		}
	}

	func pr_cratere(forRect: CGRect, cornerRadius: CGFloat) {
		//let exRect = CGRect(x: 100, y: 100, width: 100, height: 100)
		let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height), cornerRadius: 0)
		let rectPath = UIBezierPath(roundedRect: forRect, cornerRadius: cornerRadius)
		path.append(rectPath)
		path.usesEvenOddFillRule = true

		let fillLayer = CAShapeLayer()
		fillLayer.path = path.cgPath
		fillLayer.fillRule = CAShapeLayerFillRule.evenOdd
		fillLayer.fillColor = UIColor.red.cgColor
		fillLayer.opacity = 0.5
		self.layer.addSublayer(fillLayer)
	}

	enum PrViewSide {
		case left, right, top, bottom
	}

	func pr_addBorder(toSide side: PrViewSide, withColor color: CGColor, andThickness thickness: CGFloat) {
		let frame = self.frame
		let border = CALayer()
		border.backgroundColor = color

		switch side {
			case .left: border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height); break
			case .right: border.frame = CGRect(x: frame.maxX, y: frame.minY, width: thickness, height: frame.height); break
			case .top: border.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: thickness); break
			case .bottom: border.frame = CGRect(x: frame.minX, y: frame.maxY, width: frame.width, height: thickness); break
		}

		self.layer.addSublayer(border)
	}
}
