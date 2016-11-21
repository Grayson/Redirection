//
//  HelperAppCommunicator.swift
//  Redirection
//
//  Created by Grayson Hansard on 11/18/16.
//  Copyright © 2016 From Concentrate Software. All rights reserved.
//

enum HelperAppStatus {
	case active
	case inactive
	case working
}

enum HelperAppBasicResponse {
	case success
	case failure
}

protocol HelperAppCommunicator {
	func fetchStatus(response: (HelperAppStatus) -> ())
	func change(status: HelperAppStatus, response: (HelperAppStatus) -> ())
	func load(rules: [Rule], response: (HelperAppBasicResponse) -> ())
}
