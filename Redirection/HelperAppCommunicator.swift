//
//  HelperAppCommunicator.swift
//  Redirection
//
//  Created by Grayson Hansard on 11/18/16.
//  Copyright © 2016 From Concentrate Software. All rights reserved.
//

protocol HelperAppCommunicator {
	func fetchStatus(response: @escaping (CommonCommunicatorResponses.AppState) -> ())
	func change(status: CommonCommunicatorResponses.AppState, response: @escaping (CommonCommunicatorResponses.AppState) -> ())
	func load(rules: [Rule], response: @escaping (CommonCommunicatorResponses.Status) -> ())
}
