//
//  BrowserUtility.swift
//  Redirection
//
//  Created by Grayson Hansard on 11/14/16.
//  Copyright © 2016 From Concentrate Software. All rights reserved.
//

import Foundation

struct BrowserInfo {
	let name: String
	let location: URL
	let identifier: String
}

extension BrowserInfo : Equatable {}
func ==(lhs: BrowserInfo, rhs: BrowserInfo) -> Bool {
	return lhs.name == rhs.name
		&& lhs.location == rhs.location
		&& lhs.identifier == rhs.identifier
}

private func fetchName(from dictionary: [String: Any?]?) -> String? {
	guard let dictionary = dictionary else { return nil }
	let value: Any? = dictionary["CFBundleDisplayName"]
		?? dictionary["CFBundleName"]
		?? nil
	return value as? String
}

private func convertBundleToBrowserInfo(url: URL) -> BrowserInfo?
{
	guard
		let bundle = Bundle(url: url),
		let identifier = bundle.bundleIdentifier,
		let name = fetchName(from: bundle.localizedInfoDictionary) ?? fetchName(from: bundle.infoDictionary)
	else { return nil }
	return BrowserInfo(name: name, location: bundle.bundleURL, identifier: identifier)
}

func fetchBrowserInfo() -> [BrowserInfo] {
	if let url = NSURL(string: "http://"),
		let browsersTmp = LSCopyApplicationURLsForURL(url, LSRolesMask.all),
		let browsers = browsersTmp.takeUnretainedValue() as? [URL] {
		return browsers.flatMap(convertBundleToBrowserInfo)
	}
	return []
}

