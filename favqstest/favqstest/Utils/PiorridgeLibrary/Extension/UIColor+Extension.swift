//
//  UIColor+Extension.swift
//  Porridge
//
//  Created by Vu Phan on 17/05/2019.
//  Copyright © 2019 Vu Phan. All rights reserved.
//
import UIKit

public extension UIColor {
    convenience init(pr_r r: Int, g: Int, b: Int, a: CGFloat = 1.0) {
        self.init(red   	: CGFloat(r) / 255.0,
                  green 	: CGFloat(g) / 255.0,
                  blue  	: CGFloat(b) / 255.0,
                  alpha 	: a
        )
    }
    
    convenience init(pr_rgb rgb: Int, a: CGFloat = 1.0) {
        self.init(pr_r 	: (rgb >> 16) & 0xFF,
                  g 	: (rgb >> 8) & 0xFF,
                  b  	: rgb & 0xFF,
                  a     : a
        )
    }
}
