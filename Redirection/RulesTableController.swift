//
//  RulesTableController.swift
//  Redirection
//
//  Created by Grayson Hansard on 11/14/16.
//  Copyright © 2016 From Concentrate Software. All rights reserved.
//

import AppKit

class RulesTableController : NSObject, NSTableViewDelegate, NSTableViewDataSource {
	enum RowViews: String {
		case `default` = "Default"
	}

	var tableView: NSTableView? {
		didSet {
			tableView?.dataSource = self
			tableView?.delegate = self
		}
	}

	var onRuleChanged: (Change<Rule>) -> () = { _ in }
	var onRuleDeleted: (Rule) -> () = { _ in }

	private var rules: [RuleViewModel] = [] { didSet { tableView?.reloadData() } }

	func update(rules: [Rule]) {
		self.rules = rules.map {
			let vm = RuleViewModel(rule: $0)
			vm.didChange = { [weak self] in self?.onRuleChanged($0) }
			vm.onDelete = { [weak self] in self?.onRuleDeleted($0) }
			return vm
		}
	}

	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		return tableView.make(withIdentifier: RowViews.default.rawValue, owner: nil)
	}

	func numberOfRows(in tableView: NSTableView) -> Int {
		return rules.count
	}
	
	func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
		return rules[row]
	}

	func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		return 42.0
	}

	func tableView(_ tableView: NSTableView, selectionIndexesForProposedSelection proposedSelectionIndexes: IndexSet) -> IndexSet {
		return IndexSet()
	}
}
