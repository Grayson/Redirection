//
//  RuleViewModel.swift
//  Redirection
//
//  Created by Grayson Hansard on 11/14/16.
//  Copyright © 2016 From Concentrate Software. All rights reserved.
//

import Foundation

private func convert(match: Match) -> Int {
	return match.type.rawValue
}

private func convert(int: Int) -> MatchType {
	return MatchType(rawValue: int)!
}

class RuleViewModel {

	var matchIndex: Int
	var browsers: [BrowserViewModel]
	var value: String

	init(rule: Rule) {
		matchIndex = convert(match: rule.match)
		value = rule.match.test
		browsers = fetchBrowserInfo().map {
			let vm = BrowserViewModel(info: $0)
			vm.isSelected = $0 == rule.browserInfo
			return vm
		}
	}

	func generateRule() -> Rule? {
		guard let selectedBrowser = (browsers.first { $0.isSelected }) else { return nil }
		let info = BrowserInfo(name: selectedBrowser.title, location: URL(fileURLWithPath: selectedBrowser.path), identifier: selectedBrowser.identifier)
		let match = Match(type: convert(int: matchIndex), test: value)
		return Rule(browserInfo: info, match: match)
	}
}
