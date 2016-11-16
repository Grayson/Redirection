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
	private struct IndexedBrowserViewModel {
		let index: Int
		let model: BrowserViewModel
	}

	var matchIndex: Int
	var value: String

	var selectedBrowserIndex: Int {
		get { return (browsers.first { $0.model.isSelected })?.index ?? -1 }
		set(value) {
			browsers.forEach { $0.model.isSelected = false }
			(browsers.first { $0.index == value })?.model.isSelected = true
		}
	}

	private var browsers: [IndexedBrowserViewModel]

	var browserMenuItems: [NSMenuItem] {
		get {
			return browsers.map {
				let menuItem = NSMenuItem(title: $0.model.title, action: nil, keyEquivalent: "")
				menuItem.tag = $0.index
				menuItem.image = $0.model.image
				return menuItem
			}
		}
	}

	init(rule: Rule) {
		matchIndex = convert(match: rule.match)
		value = rule.match.test
		browsers = fetchBrowserInfo().enumerated().map { (index, info) in
			let vm = BrowserViewModel(info: info)
			vm.isSelected = info == rule.browserInfo
			return IndexedBrowserViewModel(index: index, model: vm)
		}
	}

	func generateRule() -> Rule? {
		guard let selectedIndexedBrowser = (browsers.first { $0.model.isSelected }) else { return nil }
		let selectedBrowser = selectedIndexedBrowser.model
		let info = BrowserInfo(name: selectedBrowser.title, location: URL(fileURLWithPath: selectedBrowser.path), identifier: selectedBrowser.identifier)
		let match = Match(type: convert(int: matchIndex), test: value)
		return Rule(browserInfo: info, match: match)
	}
}
