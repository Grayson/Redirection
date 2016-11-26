//
//  ViewController.swift
//  Redirection
//
//  Created by Grayson Hansard on 11/14/16.
//  Copyright © 2016 From Concentrate Software. All rights reserved.
//

import Cocoa

private func image(for status: CommonCommunicatorResponses.AppState) -> NSImage {
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
	let dataStore: DataStore = { (NSApp.delegate as? AppDelegate)!.dataStore }()
	let communicator: HelperAppCommunicator = { (NSApp.delegate as? AppDelegate)!.helperAppCommunicator }()

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
		update(status: .inactive)
		communicator.fetchStatus { [weak self] in self?.update(status: $0) }
	}

	private func update(status: CommonCommunicatorResponses.AppState) {
		guard
			let statusImageView = statusImageView,
			let statusLabel = statusLabel,
			let statusButton = statusButton
		else { return }

		statusImageView.image = image(for: .inactive)
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

