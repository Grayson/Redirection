//
//  SequenceExtensions.swift
//  Redirection
//
//  Created by Grayson Hansard on 11/21/16.
//  Copyright © 2016 From Concentrate Software. All rights reserved.
//

import Foundation

extension Sequence {
	func any(condition: (Self.Iterator.Element) -> Bool) -> Bool {
		for value in self {
			if condition(value) {
				return true
			}
		}
		return false
	}

	func all(condition: (Self.Iterator.Element) -> Bool) -> Bool {
		for value in self {
			if !condition(value) {
				return false
			}
		}
		return true
	}
}
