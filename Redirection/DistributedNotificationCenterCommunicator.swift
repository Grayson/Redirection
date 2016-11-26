//
//  DistributedNotificationCenterHelperAppCommunicator.swift
//  Redirection
//
//  Created by Grayson Hansard on 11/21/16.
//  Copyright © 2016 From Concentrate Software. All rights reserved.
//

import AppKit

class DistributedNotificationCenterCommunicator {
	enum Action : String {
		case Heartbeat
		case ChangeStatus
		case LoadRules
		case Shutdown
	}

	struct NotificationConstants {
		private init() {}
		static let NotificationName = Notification.Name("com.fromconcentratesoftware.redirection.notification")
		static let ActionKey = "action"
		static let IdentifierKey = "identifier"
		static let PayloadKey = "payload"
		static let StatusKey = "status"
		static let ResponseKey = "response"
	}

	struct ExpectedResponse {
		enum Callback {
			case StatusChange(StatusChangeCallback)
			case BasicResponse(BasicResponseCallback)
		}
		public let identifier: UUID
		public let onReceive: Callback
	}

	static let HelperAppBundleIdentifier = "com.fromconcentratesoftware.RedirectionHelper"

	typealias StatusChangeCallback = (HelperAppStatus) -> ()
	typealias BasicResponseCallback = (HelperAppBasicResponse) -> ()

	private var expectedResponses = [ExpectedResponse]()

	init() {
		DistributedNotificationCenter.default().addObserver(self, selector: #selector(receivedNotification(_:)), name: NotificationConstants.NotificationName, object: nil)
	}

	func sendMessage(action: Action, uuid: UUID = UUID(), payload: [AnyHashable: Any] = [:]) {
		let message: [String : Any] = [
			NotificationConstants.IdentifierKey: uuid,
			NotificationConstants.PayloadKey: payload,
		]
		DistributedNotificationCenter.default().post(name: NotificationConstants.NotificationName, object: nil, userInfo: message)
	}

	func register(expectedResponse: ExpectedResponse) {
		expectedResponses.append(expectedResponse)
	}

	@objc private func receivedNotification(_ notification: Notification) {
		assert(notification.name == NotificationConstants.NotificationName)
		guard let message = notification.userInfo else { return }

		if message[NotificationConstants.IdentifierKey] != nil {
			handle(response: message)
		}
		else {
			handle(message: message)
		}
	}

	private func handle(response: [AnyHashable: Any]) {
		guard
			let identifier = UUID(uuidString: response[NotificationConstants.IdentifierKey] as? String ?? ""),
			let expected = (expectedResponses.first { $0.identifier == identifier })
			else { return }
		switch(expected.onReceive) {
		case .StatusChange(let callback):
			guard let status = HelperAppStatus(rawValue: response[NotificationConstants.StatusKey] as? String ?? "")
				else {
					print("Unhandled status")
					break
			}
			callback(status)
		case .BasicResponse(let callback):
			guard let response = HelperAppBasicResponse(rawValue: response[NotificationConstants.ResponseKey] as? String ?? "")
				else {
					print("Unhandled response")
					break
			}
			callback(response)
		}
	}

	private func handle(message: [AnyHashable: Any]) {
		guard let action = Action(rawValue: message[NotificationConstants.ActionKey] as? String ?? "") else { return }
		switch(action) {
		case .Heartbeat:
			print("Received heartbeat")
		case .ChangeStatus:
			break
		case .LoadRules:
			break
		case .Shutdown:
			print("Received shutdown request")
		}

	}
}
