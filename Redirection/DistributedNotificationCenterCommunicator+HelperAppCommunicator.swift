//
//  DistributedNotificationCenterCommunicator+HelperAppCommunicator.swift
//  Redirection
//
//  Created by Grayson Hansard on 11/26/16.
//  Copyright © 2016 From Concentrate Software. All rights reserved.
//

import AppKit

private func isHelperRunning() -> Bool {
	return NSWorkspace.shared().runningApplications.any { $0.bundleIdentifier == DistributedNotificationCenterCommunicator.HelperAppBundleIdentifier }
}

extension DistributedNotificationCenterCommunicator: HelperAppCommunicator {
	func fetchStatus(response: @escaping StatusChangeCallback) {
		guard isHelperRunning() else {
			response(.working)
			return
		}

		let uuid = UUID()
		let callback = ExpectedResponse.Callback.StatusChange(response)
		register(expectedResponse: ExpectedResponse(identifier: uuid, onReceive: callback ))
		sendMessage(action: .Heartbeat, uuid: uuid)
	}

	func change(status: CommonCommunicatorResponses.AppState, response: @escaping StatusChangeCallback) {
		guard isHelperRunning() else {
			response(.inactive)
			return
		}

		let uuid = UUID()
		let callback = ExpectedResponse.Callback.StatusChange(response)
		register(expectedResponse: ExpectedResponse(identifier: uuid, onReceive: callback ))
		sendMessage(action: .ChangeStatus, uuid: uuid)
	}

	func load(rules: [Rule], response: @escaping BasicResponseCallback){
		guard isHelperRunning() else {
			response(.failure)
			return
		}

		let uuid = UUID()
		let callback = ExpectedResponse.Callback.BasicResponse(response)
		register(expectedResponse: ExpectedResponse(identifier: uuid, onReceive: callback ))
		sendMessage(action: .Heartbeat, uuid: uuid)
		
	}
}
