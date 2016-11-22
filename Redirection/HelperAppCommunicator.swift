//
//  HelperAppCommunicator.swift
//  Redirection
//
//  Created by Grayson Hansard on 11/18/16.
//  Copyright © 2016 From Concentrate Software. All rights reserved.
//

enum HelperAppStatus: String {
	case active
	case inactive
	case working
}

enum HelperAppBasicResponse: String {
	case success
	case failure
}

protocol HelperAppCommunicator {
	func fetchStatus(response: @escaping (HelperAppStatus) -> ())
	func change(status: HelperAppStatus, response: @escaping (HelperAppStatus) -> ())
	func load(rules: [Rule], response: @escaping (HelperAppBasicResponse) -> ())
}
