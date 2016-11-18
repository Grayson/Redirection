//
//  DataStore.swift
//  Redirection
//
//  Created by Grayson Hansard on 11/17/16.
//  Copyright © 2016 From Concentrate Software. All rights reserved.
//

protocol DataStore {
	func fetchAllRules( onCompletion: @escaping ([Rule]) -> () )
	func save(rules: [Rule], onCompletion: @escaping () -> ())
	func replace(rule: Rule, with: Rule, onCompletion: @escaping () -> ())
	func delete(rule: Rule, onCompletion: @escaping ([Rule]) -> ())
}
