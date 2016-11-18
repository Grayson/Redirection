//
//  ViewController.swift
//  Redirection
//
//  Created by Grayson Hansard on 11/14/16.
//  Copyright © 2016 From Concentrate Software. All rights reserved.
//

import Cocoa

private func image(for status: ServerStatus) -> NSImage {
	switch(status) {
	case .active:
		return NSImage(named: "NSStatusAvailable")!
	case .inactive:
		return NSImage(named: "NSStatusUnavailable")!
	case .working:
		return NSImage(named: "NSStatusPartiallyAvailable")!
	}
}

private func localizedStatusLabel(for status: ServerStatus) -> String {
	switch(status) {
	case .active:
		return NSLocalizedString("Server_is_running", comment: "Server is running")
	case .inactive:
		return NSLocalizedString("Server_is_not_running", comment: "Server is not running")
	case .working:
		return NSLocalizedString("Getting_server_info", comment: "Getting server info")
	}
}

private func localizedStatusButtonLabel(for status: ServerStatus) -> String {
	switch(status) {
	case .active:
		return NSLocalizedString("Stop_Server", comment: "Stop")
	case .inactive:
		return NSLocalizedString("Start_Server", comment: "Start")
	case .working:
		return NSLocalizedString("...", comment: "<Server button label for working state>")
	}
}


class ViewController: NSViewController {

	@IBOutlet var tableView: NSTableView? { didSet { setupRulesTableView(); } }
	@IBOutlet var statusImageView: NSImageView? { didSet { reloadView() } }
	@IBOutlet var statusLabel: NSTextField? { didSet { reloadView() } }
	@IBOutlet var statusButton: NSButton? { didSet { reloadView() } }

	var serverStatus: ServerStatus = .active
	var rules: [Rule] = [] { didSet { rulesTableController.update(rules: rules) } }
	let rulesTableController = RulesTableController()
	override func viewDidLoad() {
		rulesTableController.onRuleChanged = { [weak self] in
		}
		rulesTableController.onRuleDeleted = { [weak self] in
		}
	}

	func reloadView() {
		guard
			let _ = tableView,
			let statusImageView = statusImageView,
			let statusLabel = statusLabel,
			let statusButton = statusButton
		else { return }

		statusImageView.image = image(for: serverStatus)
		statusLabel.stringValue = localizedStatusLabel(for: serverStatus)
		statusButton.title = localizedStatusButtonLabel(for: serverStatus)
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

