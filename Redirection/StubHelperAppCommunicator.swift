//
//  StubHelperAppCommunicator.swift
//  Redirection
//
//  Created by Grayson Hansard on 11/18/16.
//  Copyright © 2016 From Concentrate Software. All rights reserved.
//

class StubHelperAppCommunicator : HelperAppCommunicator {

	private var currentStatus: HelperAppStatus = .inactive

	func fetchStatus(response: @escaping (HelperAppStatus) -> ()) {
		response(currentStatus)
	}
	
	func change(status: HelperAppStatus, response: @escaping (HelperAppStatus) -> ()) {
		currentStatus = status
		response(currentStatus)
	}

	func load(rules: [Rule], response: @escaping (HelperAppBasicResponse) -> ()) {
		response(.success)
	}
}
