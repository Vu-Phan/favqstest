//
//  SystemUtils.swift
//  Porridge
//
//  Created by Vu Phan on 17/05/2019.
//  Copyright © 2019 Vu Phan. All rights reserved.
//

import UIKit
import AVKit

public extension Pr {
	class system: NSObject {
		static func copyToPasteboard(_ string: String) {
			UIPasteboard.general.string = string
		}

		static func hapticFeedback() {
			if #available(iOS 10.0, *) {
				let impact = UIImpactFeedbackGenerator()
				impact.impactOccurred()
			} else {
				// Fallback on earlier versions
			}
		}

		// MARK: - Document
		public class doc: NSObject {
			public static let folderName = "folderName"
			public static func getFolderPath() -> String {
				let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(folderName)
				return path
			}

			public static func deleteFolder() {
				let fileManager = FileManager.default
				if fileManager.fileExists(atPath: getFolderPath()) {
					try! fileManager.removeItem(atPath: getFolderPath())
				}
			}

			public static func deleteContent(forPath: String) {
				let fileManager = FileManager.default
				if fileManager.fileExists(atPath: forPath) {
					try! fileManager.removeItem(atPath: forPath)
				}
			}

			public static func getContentOfFolder() -> [URL] {
				var urlList = [URL]()
				let fileManager = FileManager.default
				let url = URL.init(string: getFolderPath())!
				do {
					urlList = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
				} catch {
					print("Error while enumerating files \(url): \(error.localizedDescription)")
				}

				return urlList
			}

			public static func saveContentInFolder(data: Data, name: String, ext: String) -> String {
				let fileManager = FileManager.default
				let path = getFolderPath()
				/// - create directory if not exists
				if !fileManager.fileExists(atPath: path) {
					try! fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
				}
				///
				let url = NSURL(string: path)
				var mediaName = name.replacingOccurrences(of: "/", with: "-")
				mediaName = mediaName.replacingOccurrences(of: ".", with: "-")
				let mediaUrl = url!.appendingPathComponent("\(mediaName).\(ext)")
				let mediaPath = mediaUrl!.absoluteString
				/// - delete first if file exists
				if fileManager.fileExists(atPath: mediaPath) {
					try! fileManager.removeItem(atPath: mediaPath)
				}
				fileManager.createFile(atPath: mediaPath, contents: data, attributes: nil)

				return mediaPath
			}

			public static func isUrlInFolder(_ url: String) -> Bool {
				if url.contains(folderName) {
					return true
				}
				return false
			}
		}

		// MARK: - Activity Controller / Share
		public class activity: NSObject {
			public static func openShare(inVC: UIViewController, withData: [Any]) {
				let activityVC = UIActivityViewController(activityItems			: withData,
														  applicationActivities	: nil)
				/// - For ipad presentation
				activityVC.popoverPresentationController?.sourceView = inVC.view
				/// - can exclude some activity types
				/// activityVC.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
				inVC.present(activityVC, animated: true, completion: nil)
			}
		}
	}
}
