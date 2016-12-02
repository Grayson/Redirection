//
//  Delegate.swift
//  Redirection
//
//  Created by Grayson Hansard on 11/16/16.
//  Copyright © 2016 From Concentrate Software. All rights reserved.
//

import Foundation

final class CallbackWrapper<T> {
	typealias Callback = (T) -> ()
	fileprivate let callback: Callback
	private weak var delegate: Delegate<T>?

	fileprivate init(delegate: Delegate<T>, callback: @escaping Callback) {
		self.callback = callback
		self.delegate = delegate
	}

	func cancel() {
		delegate?.remove(wrapper: self)
	}
}

final class Delegate<T> {
	typealias Wrapper = CallbackWrapper<T>

	func invoke(_ value: T) {
		callbacks.forEach { $0.callback(value) }
	}

	private var callbacks = [Wrapper]()

	fileprivate func remove(wrapper: Wrapper) {
		callbacks = callbacks.filter { $0 !== wrapper }
	}

	func add(callback: @escaping Wrapper.Callback) -> Wrapper {
		let wrapper = Wrapper(delegate: self, callback: callback)
		callbacks.append(wrapper)
		return wrapper
	}
}

func +=<T> (delegate: Delegate<T>, callback: @escaping Delegate<T>.Wrapper.Callback) -> Delegate<T>.Wrapper {
	return delegate.add(callback: callback)
}
