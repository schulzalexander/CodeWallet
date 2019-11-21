//
//  WatchCodeManager.swift
//  CodeWalletWidgetWatch Extension
//
//  Created by Alexander Schulz on 02.06.19.
//  Copyright © 2019 Alexander Schulz. All rights reserved.
//

import Foundation

class WatchCodeManager: NSObject {
	
	private var codes: [WatchCode]
	private var lastUpdateTimestamp: Double
	
	static var shared = WatchCodeManager()
	
	private override init() {
		codes = [WatchCode]()
		lastUpdateTimestamp = 0
		super.init()
	}
	
	func getCodes() -> [WatchCode] {
		return codes
	}
	
	func setCodes(codes: [WatchCode]) {
		self.codes = codes
	}
	
	func setLastUpdateTimestamp(timestamp: Double) {
		lastUpdateTimestamp = timestamp
	}
	
	func getLastUpdateTimestamp() -> Double {
		return lastUpdateTimestamp
	}
	
}
