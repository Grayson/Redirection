//
//  ViewController.swift
//  Redirection
//
//  Created by Grayson Hansard on 11/14/16.
//  Copyright © 2016 From Concentrate Software. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

	@IBOutlet var tableView: NSTableView? { didSet { setupRulesTableView(); } }
	@IBOutlet var statusImageView: NSImageView? { didSet { reloadView() } }
	@IBOutlet var statusLabel: NSTextField? { didSet { reloadView() } }
	@IBOutlet var statusButton: NSButton? { didSet { reloadView() } }

	var rules: [Rule] = [] { didSet { rulesTableController.update(rules: rules) } }
	let rulesTableController = RulesTableController()
	let dataStore: DataStore = { (NSApp.delegate as? AppDelegate)!.dataStore }()

	override func viewDidLoad() {
		dataStore.fetchAllRules { [weak self] in
			self?.rules = $0
		}
		rulesTableController.onRuleChanged = { [weak self] in
			self?.dataStore.replace(rule: $0.old, with: $0.new) {}
		}
		rulesTableController.onRuleDeleted = { [weak self] in
			self?.dataStore.delete(rule: $0) { self?.rules = $0 }
		}
	}

	func reloadView() {
	}

	private func setupRulesTableView() {
		guard let tableView = tableView else { return }
		rulesTableController.tableView = tableView
	}

	@IBAction func addNewRule(_ sender: AnyObject) {
		guard let info = fetchBrowserInfo().first else { fatalError() }
		let match = Match(type: .contains, test: "")
		let rule = Rule(browserInfo: info, match: match)
		rules.append(rule)
	}

}

