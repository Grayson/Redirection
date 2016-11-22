//
//  DistributedNotificationCenterHelperAppCommunicator.swift
//  Redirection
//
//  Created by Grayson Hansard on 11/21/16.
//  Copyright © 2016 From Concentrate Software. All rights reserved.
//

import AppKit

private func isHelperRunning() -> Bool {
	return NSWorkspace.shared().runningApplications.any { $0.bundleIdentifier == DistributedNotificationCenterHelperAppCommunicator.HelperAppBundleIdentifier }
}

private struct NotificationConstants {
	private init() {}
	static let NotificationName = Notification.Name("com.fromconcentratesoftware.redirection.notification")
	static let ActionKey = "action"
	static let IdentifierKey = "identifier"
	static let PayloadKey = "payload"
	static let StatusKey = "status"
	static let ResponseKey = "response"
}

private enum Action : String {
	case Heartbeat
	case ChangeStatus
	case LoadRules
	case Shutdown
}

class DistributedNotificationCenterHelperAppCommunicator: HelperAppCommunicator {
	fileprivate static let HelperAppBundleIdentifier = "com.fromconcentratesoftware.redirectionhelperapp"

	typealias StatusChangeCallback = (HelperAppStatus) -> ()
	typealias BasicResponseCallback = (HelperAppBasicResponse) -> ()

	private struct ExpectedResponse {
		enum Callback {
			case StatusChange(StatusChangeCallback)
			case BasicResponse(BasicResponseCallback)
		}
		public let identifier: UUID
		public let onReceive: Callback
	}

	private var expectedResponses = [ExpectedResponse]()

	init() {
		DistributedNotificationCenter.default().addObserver(self, selector: #selector(receivedNotification(_:)), name: NotificationConstants.NotificationName, object: nil)
	}

	func fetchStatus(response: @escaping StatusChangeCallback) {
		guard isHelperRunning() else {
			response(.working)
			return
		}

		let uuid = UUID()
		let callback = ExpectedResponse.Callback.StatusChange(response)
		expectedResponses.append(ExpectedResponse(identifier: uuid, onReceive: callback ))
		sendMessage(action: .Heartbeat, uuid: uuid)
	}

	func change(status: HelperAppStatus, response: @escaping StatusChangeCallback) {
		guard isHelperRunning() else {
			response(.inactive)
			return
		}

		let uuid = UUID()
		let callback = ExpectedResponse.Callback.StatusChange(response)
		expectedResponses.append(ExpectedResponse(identifier: uuid, onReceive: callback ))
		sendMessage(action: .ChangeStatus, uuid: uuid)
	}

	func load(rules: [Rule], response: @escaping BasicResponseCallback){
		guard isHelperRunning() else {
			response(.failure)
			return
		}

		let uuid = UUID()
		let callback = ExpectedResponse.Callback.BasicResponse(response)
		expectedResponses.append(ExpectedResponse(identifier: uuid, onReceive: callback ))
		sendMessage(action: .Heartbeat, uuid: uuid)

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

	private func sendMessage(action: Action, uuid: UUID = UUID(), payload: [AnyHashable: Any] = [:]) {
		let message: [String : Any] = [
			NotificationConstants.IdentifierKey: uuid,
			NotificationConstants.PayloadKey: payload,
		]
		DistributedNotificationCenter.default().post(name: NotificationConstants.NotificationName, object: nil, userInfo: message)
	}
}
