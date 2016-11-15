//
//  ServerCommunicator.swift
//  Redirection
//
//  Created by Grayson Hansard on 11/14/16.
//  Copyright © 2016 From Concentrate Software. All rights reserved.
//

import Foundation

enum ServerStatus {
	case active
	case inactive
	case working
}

class ServerCommunicator {
	var status: ServerStatus { get { return ServerStatus.active } }
}
