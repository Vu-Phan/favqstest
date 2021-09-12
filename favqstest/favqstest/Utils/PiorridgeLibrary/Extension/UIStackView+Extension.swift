//
//  UIStackView+Extension.swift
//  PiorridgeLibrary
//
//  Created by Vu Phan on 12/02/2021.
//

import Foundation
import UIKit

public extension UIStackView {
    func pr_removeAllArrangedSubviews() {
        for arrangedSubview in self.arrangedSubviews {
            self.removeArrangedSubview(arrangedSubview)
            arrangedSubview.removeFromSuperview()
        }
    }
}
