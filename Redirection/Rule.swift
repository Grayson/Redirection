//
//  Rule.swift
//  Redirection
//
//  Created by Grayson Hansard on 11/14/16.
//  Copyright © 2016 From Concentrate Software. All rights reserved.
//

struct Rule {
	let browserInfo: BrowserInfo
	let match: Match
}

extension Rule: Equatable {}
func ==(left: Rule, right: Rule) -> Bool {
	return left.browserInfo == right.browserInfo
		&& left.match == right.match
}
