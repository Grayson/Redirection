//
//  RuleTableCellView.swift
//  Redirection
//
//  Created by Grayson Hansard on 11/14/16.
//  Copyright © 2016 From Concentrate Software. All rights reserved.
//

import AppKit

class RuleTableCellView : NSTableCellView {
	@IBOutlet var matchPopupButton: NSPopUpButton? {
		didSet {
			matchPopupButton?.target = self
			matchPopupButton?.action = #selector(matchPopupDidChange(_:))
		}
	}

	@IBOutlet var browserPopupButton: NSPopUpButton? {
		didSet {
			browserPopupButton?.target = self
			browserPopupButton?.action = #selector(browserPopupDidChange(_:))
		}
	}

	@IBOutlet override var textField: NSTextField? {
		didSet {
			textField?.target = self
			textField?.action = #selector(textFieldDidChange(_:))
		}
	}

	override var objectValue: Any? { didSet { updateValues(viewModel: objectValue as? RuleViewModel) } }

	func textFieldDidChange(_ sender: AnyObject) {
		guard
			let rvm = objectValue as? RuleViewModel,
			let textField = textField
		else { return }

		rvm.value = textField.stringValue
	}

	func browserPopupDidChange(_ sender: AnyObject) {
		guard
			let rvm = objectValue as? RuleViewModel,
			let browserPopupButton = browserPopupButton
		else { return }

		rvm.selectedBrowserIndex = browserPopupButton.selectedItem?.tag ?? -1
	}

	func matchPopupDidChange(_ sender: AnyObject) {
		guard
			let rvm = objectValue as? RuleViewModel,
			let matchPopupButton = browserPopupButton
		else { return }
		rvm.matchIndex = matchPopupButton.indexOfSelectedItem
	}

	private func updateValues(viewModel: RuleViewModel?) {
		guard
			let viewModel = viewModel,
			let matchPopupButton = matchPopupButton,
			let textField = textField,
			let browserPopupButton = browserPopupButton
		else { fatalError() }

		matchPopupButton.selectItem(at: viewModel.matchIndex)
		textField.stringValue = viewModel.value
		textField.isEditable = true
		browserPopupButton.items = viewModel.browserMenuItems
	}
}
