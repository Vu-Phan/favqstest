//
//  PrLocalNotification.swift
//  PiorridgeLibrary
//
//  Created by Vu Phan on 19/06/2020.
//

import Foundation
import UIKit

public extension Pr {
	class AppNotification: NSObject {
		public static let singleton = AppNotification()
		public let userNotificationCenter = UNUserNotificationCenter.current()

		public enum CategoryIdentifier: String {
			case unknown = "unknown"
			case cat1 = "cat1"
			case cat2 = "cat2"
		}

		public enum ActionIdentifier: String {
			case unknow = "unknown"
			case snooze = "snooze"
			case delete = "delete"
		}

		public func requestAuthorization() {
			let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)

			self.userNotificationCenter.requestAuthorization(options: authOptions) { (success, error) in
				if let error = error {
					print("Error: ", error)
				}
			}
		}

		public func addCategory(_ forCategory: CategoryIdentifier) {
			let categoryIdentifier = forCategory.rawValue
			let snoozeAction = UNNotificationAction(identifier: ActionIdentifier.snooze.rawValue, title: "Snooze", options: [])
			let deleteAction = UNNotificationAction(identifier: ActionIdentifier.delete.rawValue, title: "Delete", options: [.destructive])
			let category = UNNotificationCategory(identifier: categoryIdentifier,
												  actions: [snoozeAction, deleteAction],
												  intentIdentifiers: [],
												  options: [])

			userNotificationCenter.setNotificationCategories([category])
		}

		private func getNotificationContent(forCategory: CategoryIdentifier, title: String, body: String, userInfo: [String: String]) -> UNMutableNotificationContent {
			let notificationContent = UNMutableNotificationContent()
			notificationContent.title = title
			notificationContent.body = body
			notificationContent.sound = UNNotificationSound.default
			notificationContent.badge = 1
			notificationContent.userInfo = userInfo
			notificationContent.categoryIdentifier = forCategory.rawValue

			return notificationContent
		}

		public func schedule(forCategory: CategoryIdentifier, identifier: String, content: (title: String, body: String), forDate: Date) {
			let notificationContent = getNotificationContent(forCategory: forCategory,
															 title: content.title,
															 body: content.body,
															 userInfo: [:])

			let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: forDate)
			let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
			let request = UNNotificationRequest(identifier: identifier, content: notificationContent, trigger: trigger)

			userNotificationCenter.add(request) { (error) in
				if let error = error {
					print("Error \(error.localizedDescription)")
				}
			}
		}

		public func show(forCategory: CategoryIdentifier, identifier: String, content: (title: String, body: String), delay: TimeInterval) {
			let notificationContent = getNotificationContent(forCategory: forCategory,
															 title: content.title,
															 body: content.body,
															 userInfo: [:])

			let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
			let request = UNNotificationRequest(identifier: identifier, content: notificationContent, trigger: trigger)
			userNotificationCenter.add(request) { (error) in
				if let error = error {
					print("Error \(error.localizedDescription)")
				}
			}
		}

		public func removeAllPendingNotifications() {
			userNotificationCenter.removeAllPendingNotificationRequests()
		}

		public func removePendingNotifications(forIdentifiers: [String]) {
			userNotificationCenter.removePendingNotificationRequests(withIdentifiers: forIdentifiers)
		}

		public func getPendingNotificationRequest(forIdentifier: String, completion: ((_ request: UNNotificationRequest) -> Void)?) {
			userNotificationCenter.getPendingNotificationRequests(completionHandler: { notificationRequests in
				for notificationRequest in notificationRequests {
					if notificationRequest.identifier == forIdentifier {
						completion?(notificationRequest)
						break
					}
				}
			})
		}
	}
}
