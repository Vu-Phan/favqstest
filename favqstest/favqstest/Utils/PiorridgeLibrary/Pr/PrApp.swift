//
//  AppUtils.swift
//  PiorridgeLibrary
//
//  Created by Vu Phan on 26/08/2019.
//

import UIKit

public extension Pr {
	class app: NSObject {
		static var name:String {
			if let displayName = Bundle.main.object(forInfoDictionaryKey: "CGBundleDisplayName") as? String {
				return displayName
			}
			if let name = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String {
				return name
			}
			return "App Name"
		}
		static var version:String {
			if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
				return version
			}
			return "App version"
		}
		static var buildNumber:String {
			if let version = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String {
				return version
			}
			return "App build number"
		}
		static var buildVersion:String {
//			guard let versionStr = version, let buildNumberStr = buildNumber else {
//				return nil
//			}
            if version.isEmpty || buildNumber.isEmpty {
                return ""
            }

			if version == buildNumber {
				return "v\(version)"
			} else {
				return "v\(version)(\(buildNumber))"
			}
		}

		public static func setupScreenshotNotification(completion: @escaping () -> ()) {
			let queue = OperationQueue.main
			NotificationCenter.default.addObserver(forName: UIApplication.userDidTakeScreenshotNotification,
												   object: nil,
												   queue: queue) { notification in
													completion()
			}
		}

        static func getCurrentVC() -> UIViewController? {
            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            
            if var topVC = keyWindow?.rootViewController {
                while let presentedVC = topVC.presentedViewController {
                    topVC = presentedVC
                }
                
                return topVC
            }
            
            return nil
        }
	}
}

