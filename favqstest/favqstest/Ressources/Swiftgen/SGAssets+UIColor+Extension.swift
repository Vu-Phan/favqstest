// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen


// MARK: - Color extension from .xcassets
import UIKit

internal extension UIColor {
	static private func setupColor(_ named: String) -> UIColor {
		return UIColor(named: named) ?? UIColor.blue
	}
    struct app {
        static let border = setupColor("border")
        static let content = setupColor("content")
        static let main = setupColor("main")
        static let main02 = setupColor("main02")
        static let mainAccent = setupColor("mainAccent")
        static let separator = setupColor("separator")
        static let text = setupColor("text")
        static let text02 = setupColor("text02")
        static let text03 = setupColor("text03")
        static let textButton = setupColor("textButton")
        static let textButton02 = setupColor("textButton02")
    }
}
