//
//  UITextField+Extension.swift
//  PiorridgeLibrary
//
//  Created by Vu Phan on 18/08/2021.
//

import UIKit

public extension UITextField {
    func setupPlaceholder(_ text: String, font: UIFont? = nil, color: UIColor = UIColor.systemGray) {
        self.placeholder = text
        let attrStr = NSMutableAttributedString(string: text)
        attrStr.addAttributes([.foregroundColor: color],
                              range: (text as NSString).range(of: text))
        if let font = font {
            attrStr.addAttributes([.font: font], range: text.pr_getNSRange(from: text))
        }
        self.attributedPlaceholder = attrStr
    }
}
