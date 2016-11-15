//
//  RuleTableCellView.swift
//  Redirection
//
//  Created by Grayson Hansard on 11/14/16.
//  Copyright © 2016 From Concentrate Software. All rights reserved.
//

import AppKit

class RuleTableCellView : NSTableCellView {
	@IBOutlet var matchPopupButton: NSPopUpButton?
	@IBOutlet var valueTextField: NSTextField?
	@IBOutlet var browserPopupButton: NSPopUpButton?

	override var objectValue: Any? { didSet { updateValues(viewModel: objectValue as? RuleViewModel) } }

	private func updateValues(viewModel: RuleViewModel?) {
		guard
			let viewModel = viewModel,
			let matchPopupButton = matchPopupButton,
			let valueTextField = valueTextField,
			let browserPopupButton = browserPopupButton
		else { fatalError() }

		matchPopupButton.selectItem(at: viewModel.matchIndex)
		valueTextField.stringValue = viewModel.value
		browserPopupButton.items = viewModel.browsers.map {
			let menuItem = NSMenuItem(title: $0.title, action: nil, keyEquivalent: "")
			menuItem.image = $0.image
			return menuItem
		}
	}
}
