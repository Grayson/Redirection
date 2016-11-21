//
//  AppDelegate.swift
//  Redirection
//
//  Created by Grayson Hansard on 11/14/16.
//  Copyright © 2016 From Concentrate Software. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	let dataStore: DataStore = {
		let fm = FileManager.default
		guard let url = fm.urls(for: .applicationSupportDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first
		else { fatalError() }

		let appSupportUrl = url.appendingPathComponent(ProcessInfo.processInfo.processName)
		try! fm.createDirectory(at: appSupportUrl, withIntermediateDirectories: true, attributes: nil)

		let propertyListUrl = appSupportUrl.appendingPathComponent("data.plist")
		return PropertyListDataStore(fileUrl: propertyListUrl)
	}()

	let helperAppCommunicator: HelperAppCommunicator = StubHelperAppCommunicator()

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Insert code here to initialize your application
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}


}

