//
//  Match.swift
//  Redirection
//
//  Created by Grayson Hansard on 11/14/16.
//  Copyright © 2016 From Concentrate Software. All rights reserved.
//

import Foundation

enum MatchType: Int {
	case contains
	case startsWith
	case endsWith
	case hasExtension
	case regexMatch
}

private func does(string: String, matchRegex pattern: String) -> Bool {
	let regex = try! NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
	let matchRange = regex.rangeOfFirstMatch(in: string, options: [], range: NSMakeRange(0, string.characters.count))
	return matchRange.location != NSNotFound
}

struct Match {
	let type: MatchType
	let test: String

	func matches(_ string: String) -> Bool {
		switch(type) {
		case .contains:
			return string.contains(test)
		case .startsWith:
			return string.hasPrefix(test)
		case .endsWith:
			return string.hasSuffix(test)
		case .hasExtension:
			return (string as NSString).pathExtension == string
		case .regexMatch:
			return does(string: string, matchRegex: test)
		}
	}
}
