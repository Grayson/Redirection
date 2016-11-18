//
//  PropertyListDataStore.swift
//  Redirection
//
//  Created by Grayson Hansard on 11/17/16.
//  Copyright © 2016 From Concentrate Software. All rights reserved.
//

import Foundation

private func convert(_ dict: [String: Any]) -> Match? {
	guard
		let type = dict[PropertyListDataStore.MatchTypeKey] as? Int,
		let matchType = MatchType(rawValue: type),
		let value = dict[PropertyListDataStore.MatchValueKey] as? String
	else { return nil }
	return Match(type: matchType, test: value)
}

private func convert(_ dict: [String: Any]) -> BrowserInfo? {
	guard
		let name = dict[PropertyListDataStore.BrowserInfoNameKey] as? String,
		let path = dict[PropertyListDataStore.BrowserInfoLocationKey] as? String,
		let identifier = dict[PropertyListDataStore.BrowserInfoIdentifierKey] as? String
	else { return nil }
	return BrowserInfo(name: name, location: URL(fileURLWithPath: path), identifier: identifier)
}

private func convert(_ dict: [String: Any]) -> Rule? {
	guard
		let infoDict = dict[PropertyListDataStore.BrowserInfoKey] as? [String: Any],
		let info = convert(infoDict) as BrowserInfo?,
		let matchDict = dict[PropertyListDataStore.MatchKey] as? [String: Any],
		let match = convert(matchDict) as Match?
	else { return nil }

	return Rule(browserInfo: info, match: match)
}

private func convert(match: Match) -> [String: Any] {
	return [
		PropertyListDataStore.MatchTypeKey: match.type.rawValue,
		PropertyListDataStore.MatchValueKey: match.test,
	]
}

private func convert(browserInfo: BrowserInfo) -> [String: Any] {
	return [
		PropertyListDataStore.BrowserInfoNameKey: browserInfo.name,
		PropertyListDataStore.BrowserInfoLocationKey: browserInfo.location.path,
		PropertyListDataStore.BrowserInfoIdentifierKey: browserInfo.identifier,
	]
}

private func convert(rule: Rule) -> [String: Any] {
	return [
		PropertyListDataStore.BrowserInfoKey: convert(browserInfo: rule.browserInfo),
		PropertyListDataStore.MatchKey: convert(match: rule.match),
	]
}

class PropertyListDataStore: DataStore {
	fileprivate static let RulesKey = "rules"
	fileprivate static let BrowserInfoKey = "browserInfo"
	fileprivate static let BrowserInfoNameKey = "name"
	fileprivate static let BrowserInfoLocationKey = "location"
	fileprivate static let BrowserInfoIdentifierKey = "identifier"
	fileprivate static let MatchKey = "match"
	fileprivate static let MatchTypeKey = "type"
	fileprivate static let MatchValueKey = "test"

	let url: URL

	init(fileUrl: URL) {
		url = fileUrl
	}

	func fetchAllRules( onCompletion: @escaping ([Rule]) -> () ) {
		guard
			let dict = NSDictionary(contentsOf: url) as? [String: Any],
			let rulesDictArray = dict[PropertyListDataStore.RulesKey] as? [[String: Any]]
		else {
			onCompletion([])
			return
		}

		let rules = rulesDictArray.flatMap { convert($0) as Rule? }
		onCompletion(rules)
	}

	func save(rules: [Rule], onCompletion: @escaping () -> ()) {
		let dict = NSMutableDictionary(contentsOf: url) ?? NSMutableDictionary()
		dict[PropertyListDataStore.RulesKey] = rules.map { convert(rule:$0) }
		dict.write(to: url, atomically: true)
		onCompletion()
	}

	func replace(rule: Rule, with newRule: Rule, onCompletion: @escaping () -> ()) {
		fetchAllRules {
			var rules = $0.filter { $0 != rule }
			rules.append(newRule)
			self.save(rules: rules) { onCompletion() }
		}
	}

	func delete(rule: Rule, onCompletion: @escaping ([Rule]) -> ()){
		fetchAllRules {
			let newRules = $0.filter { $0 != rule }
			self.save(rules: newRules) { onCompletion(newRules) }
		}
	}
}
