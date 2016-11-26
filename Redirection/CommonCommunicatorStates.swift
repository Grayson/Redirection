//
//  CommonCommunicatorStates.swift
//  Redirection
//
//  Created by Grayson Hansard on 11/26/16.
//  Copyright © 2016 From Concentrate Software. All rights reserved.
//

struct CommonCommunicatorResponses {
	private init() {}

	enum AppState: String {
		case active
		case inactive
		case working
	}

	enum Status: String {
		case success
		case failure
	}

}
