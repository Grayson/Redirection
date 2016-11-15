//
//  NSPopUpButtonExtensions.swift
//  Redirection
//
//  Created by Grayson Hansard on 11/14/16.
//  Copyright © 2016 From Concentrate Software. All rights reserved.
//

import AppKit

extension NSPopUpButton {
	var items: [NSMenuItem] {
		get { return itemArray }
		set(value) {
			removeAllItems()
			for item in value {
				menu?.addItem(item)
			}
		}
	}
}
