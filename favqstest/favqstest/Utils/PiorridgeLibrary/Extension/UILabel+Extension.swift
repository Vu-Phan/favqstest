//
//  UILabel+Extension.swift
//  Porridge
//
//  Created by Vu Phan on 18/08/2021.
//

import UIKit

public extension UILabel {
    func pr_setup(font: UIFont, color: UIColor, lines: Int? = nil, align: NSTextAlignment? = nil, bg: UIColor = UIColor.clear) {
        self.font = font
        self.textColor = color
        self.backgroundColor = bg
        if let lines = lines {
            self.numberOfLines = lines
        }
        if let align = align {
            self.textAlignment = align
        }
    }
}
