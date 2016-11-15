//
//  BrowserViewModel.swift
//  Redirection
//
//  Created by Grayson Hansard on 11/14/16.
//  Copyright © 2016 From Concentrate Software. All rights reserved.
//

import AppKit

class BrowserViewModel {
	let image: NSImage
	let title: String
	let path: String
	let identifier: String

	var isSelected: Bool = false

	init(info: BrowserInfo) {
		title = info.name
		path = info.location.path
		identifier = info.identifier
		image = NSWorkspace.shared().icon(forFile: path)
	}
}
