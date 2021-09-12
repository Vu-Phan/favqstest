//
//  NSAttributedString+Extension.swift
//  PiorridgeLibrary
//
//  Created by Vu Phan on 28/08/2019.
//

import Foundation
import UIKit

public extension NSAttributedString {
	var pr_attributeList: [NSAttributedString.Key: Any] {
		guard self.length > 0 else { return [:] }
		return self.attributes(at: 0, effectiveRange: nil)
	}

	func pr_apply(attrList: [NSAttributedString.Key: Any]) -> NSAttributedString {
		let selfValue = NSMutableAttributedString(attributedString: self)
		let range = (self.string as NSString).range(of: self.string)

		selfValue.addAttributes(attrList, range: range)
		return selfValue
	}

	func pr_bold() -> NSAttributedString {
		return pr_apply(attrList: [.font: UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)])
	}
	func pr_underline() -> NSAttributedString {
		return pr_apply(attrList: [.underlineStyle: NSUnderlineStyle.single.rawValue])
	}
	func pr_italic() -> NSAttributedString {
		return pr_apply(attrList: [.font: UIFont.italicSystemFont(ofSize: UIFont.systemFontSize)])
	}
    func pr_strikeThrough(value: Int) -> NSAttributedString {
		return pr_apply(attrList: [.strikethroughStyle: value])
	}
	func pr_color(_ color: UIColor) -> NSAttributedString {
		return pr_apply(attrList: [.foregroundColor: color])  
	}
    
    static func pr_setupImageWithText(_ data: [Any?]) -> NSAttributedString {
        let attrString = NSMutableAttributedString()
        
        for item in data {
            if let image = item as? UIImage {
                let imageAttachment = NSTextAttachment()
                imageAttachment.image = image
                let imageAttrString = NSAttributedString(attachment: imageAttachment)
                attrString.append(imageAttrString)
            } else if let text = item as? String {
                let textAttrString = NSAttributedString(string: text)
                attrString.append(textAttrString)
            } else if let textAttrString = item as? NSAttributedString {
                attrString.append(textAttrString)
            }
        }
        
        return attrString
    }
}
