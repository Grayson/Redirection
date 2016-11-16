//
//  RuleViewModel.swift
//  Redirection
//
//  Created by Grayson Hansard on 11/14/16.
//  Copyright © 2016 From Concentrate Software. All rights reserved.
//

import AppKit

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

	var browserMenuItems: [NSMenuItem] {
		get {
			return browsers.map {
				let menuItem = NSMenuItem(title: $0.title, action: nil, keyEquivalent: "")
				menuItem.image = $0.image
				return menuItem
			}
		}
	}

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
