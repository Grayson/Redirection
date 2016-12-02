//
//  URLRedirector.swift
//  Redirection
//
//  Created by Grayson Hansard on 12/1/16.
//  Copyright © 2016 From Concentrate Software. All rights reserved.
//

import AppKit

private func open(urls: [URL], with browser: BrowserInfo) {
	let browserLocation = browser.location as CFURL

	let browserLocationPtr = Unmanaged.passRetained(browserLocation)
	let urlsPtr = Unmanaged.passRetained(urls as CFArray)

	var launchUrlSpec = LSLaunchURLSpec(appURL: browserLocationPtr, itemURLs: urlsPtr, passThruParams: nil, launchFlags: LSLaunchFlags.defaults, asyncRefCon: nil)
	let launchUrlSpecPtr = withUnsafePointer(to: &launchUrlSpec) { $0 }

	LSOpenFromURLSpec(launchUrlSpecPtr, nil) // TODO: Handle non-zero results
}

class URLHandler {
	init() {
		NSAppleEventManager.shared().setEventHandler(self, andSelector: #selector(URLHandler.handleGetURLEvent(_:withReplyEvent:)), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
	}

	var dataStore: DataStore?
	var defaultBrowser: BrowserInfo = {
		return fetchBrowserInfo().first { $0.identifier == "com.apple.Safari" } ?? fetchBrowserInfo()[0]
	}()

	@objc func handleGetURLEvent(_ event: NSAppleEventDescriptor, withReplyEvent replyEvent: NSAppleEventDescriptor) {
		guard let dataStore = dataStore else { return }
		dataStore.fetchAllRules { rules in
			for itemIndex in 0..<event.numberOfItems {
				guard
					let descriptor = event.atIndex(itemIndex+1),
					let url = URL(string: descriptor.stringValue ?? "")
				else { continue }

				let browser = (rules.first { $0.match.matches(url.absoluteString) })?.browserInfo ?? self.defaultBrowser
				open(urls: [url], with: browser)
			}
		}
	}
}
