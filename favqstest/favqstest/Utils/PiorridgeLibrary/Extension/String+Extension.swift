//
//  String+Extension.swift
//  Porridge
//
//  Created by Vu Phan on 17/05/2019.
//  Copyright © 2019 Vu Phan. All rights reserved.
//

import UIKit

public extension String {
	// MARK:
	// MARK: __ Clean Localized text
	var pr_loc: String {
		return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
	}

	// MARK:
	// MARK: __ Utils
	var pr_bool: Bool? {
		let lowercased = self.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
		switch lowercased {
			case "true", "yes", "1":
				return true
			case "false", "no", "0":
				return false
			default:
				return nil
		}
	}

	func pr_trim() -> String {
		return self.trimmingCharacters(in: .whitespacesAndNewlines)
	}

	func pr_truncate(length: Int = 42) -> String {
		if self.count > length {
			return String(self.prefix(length)) + "..."
		} else {
			return self
		}
	}

	func pr_capitalizingFirstLetter() -> String {
		return self.prefix(1).capitalized + self.dropFirst()
	}

	func pr_capitalizedForWords() -> String {
		return self.capitalized(with: Locale.current)
	}
    
    func pr_getNSRange(from: String) -> NSRange {
        return (from as NSString).range(of: self)
    }

	var pr_isEmail: Bool {
		let regex = "^(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])$"
		return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
	}


	// MARK:
	// MARK: __ URL
	var pr_isUrl: Bool {
		return URL(string: self) != nil
	}

	func pr_decodeUrl() ->  String {
		return self.removingPercentEncoding ?? self
	}

	func pr_encoreUrl() ->  String {
		return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
	}

	func pr_getUrlList() -> [String] {
		var result = [String]()
		let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
		let matches = detector.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))

		for match in matches {
			guard let range = Range(match.range, in: self) else { return [String]() }
			let url = self[range]
			result.append(String(url))
		}

		return result
	}

	func pr_shortLink(font: UIFont, forLength: Int = 40) -> NSMutableAttributedString {
		let textAttr = NSMutableAttributedString.init(string: self)
		let urlList = pr_getUrlList()

		for url in urlList {
			if let urlObj = URL.init(string: url) {
				let truncateUrlStr = url.pr_truncate(length: forLength)
				let range = textAttr.mutableString.range(of: url)

				textAttr.mutableString.replaceOccurrences(of: url, with: truncateUrlStr, options: .caseInsensitive, range: range)
				textAttr.addAttribute(NSAttributedString.Key.link, value: urlObj, range: textAttr.mutableString.range(of: truncateUrlStr))
			}
		}
		textAttr.addAttribute(NSAttributedString.Key.font, value: font, range: NSMakeRange(0, textAttr.mutableString.length))

		return textAttr
	}
}

// MARK:
// MARK: __ Emoji / Emoticons utils
/// - https://stackoverflow.com/a/39425959
public extension String {
	var pr_glyphCount: Int {
		let richText = NSAttributedString(string: self)
		let line = CTLineCreateWithAttributedString(richText)
		return CTLineGetGlyphCount(line)
	}

	var pr_isSingleEmoji: Bool {
		return pr_glyphCount == 1 && pr_containsEmoji
	}

	var pr_containsEmoji: Bool {
		return self.unicodeScalars.contains { $0.pr_isEmoji }
	}

	var pr_containsOnlyEmoji: Bool {
		return !self.isEmpty
			&& !self.unicodeScalars.contains(where: {
				!$0.pr_isEmoji
					&& !$0.pr_isZeroWidthJoiner
			})
	}

	var pr_emojiString: String {
		return pr_emojiScalars.map { String($0) }.reduce("", +)
	}

	var pr_emojis: [String] {
		var scalars: [[UnicodeScalar]] = []
		var currentScalarSet: [UnicodeScalar] = []
		var previousScalar: UnicodeScalar?

		for scalar in pr_emojiScalars {
			if let prev = previousScalar, !prev.pr_isZeroWidthJoiner && !scalar.pr_isZeroWidthJoiner {
				scalars.append(currentScalarSet)
				currentScalarSet = []
			}
			currentScalarSet.append(scalar)

			previousScalar = scalar
		}
		scalars.append(currentScalarSet)

		return scalars.map { $0.map{ String($0) } .reduce("", +) }
	}

	fileprivate var pr_emojiScalars: [UnicodeScalar] {
		var chars: [UnicodeScalar] = []
		var previous: UnicodeScalar?
		for cur in self.unicodeScalars {

			if let previous = previous, previous.pr_isZeroWidthJoiner && cur.pr_isEmoji {
				chars.append(previous)
				chars.append(cur)

			} else if cur.pr_isEmoji {
				chars.append(cur)
			}

			previous = cur
		}

		return chars
	}
}

public extension UnicodeScalar {
	var pr_isEmoji: Bool {
		switch self.value {
			case 0x1F600...0x1F64F, // Emoticons
			0x1F300...0x1F5FF, // Misc Symbols and Pictographs
			0x1F680...0x1F6FF, // Transport and Map
			0x1F1E6...0x1F1FF, // Regional country flags
			0x2600...0x26FF,   // Misc symbols
			0x2700...0x27BF,   // Dingbats
			0xE0020...0xE007F, // Tags
			0xFE00...0xFE0F,   // Variation Selectors
			0x1F900...0x1F9FF,  // Supplemental Symbols and Pictographs
			127000...127600, // Various asian characters
			65024...65039, // Variation selector
			9100...9300, // Misc items
			8400...8447: // Combining Diacritical Marks for Symbols
				return true

			default: return false
		}
	}

	var pr_isZeroWidthJoiner: Bool {
		return self.value == 8205
	}
}
