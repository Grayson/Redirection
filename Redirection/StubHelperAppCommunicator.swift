//
//  StubHelperAppCommunicator.swift
//  Redirection
//
//  Created by Grayson Hansard on 11/18/16.
//  Copyright © 2016 From Concentrate Software. All rights reserved.
//

class StubHelperAppCommunicator : HelperAppCommunicator {

	private var currentStatus: CommonCommunicatorResponses.AppState = .inactive

	func fetchStatus(response: @escaping (CommonCommunicatorResponses.AppState) -> ()) {
		response(currentStatus)
	}
	
	func change(status: CommonCommunicatorResponses.AppState, response: @escaping (CommonCommunicatorResponses.AppState) -> ()) {
		currentStatus = status
		response(currentStatus)
	}

	func load(rules: [Rule], response: @escaping (CommonCommunicatorResponses.Status) -> ()) {
		response(.success)
	}
}
