//
//  ConnectivityHandler.swift
//  CodeWalletWidgetApp
//
//  Created by Alexander Schulz on 28.04.19.
//  Copyright © 2019 Alexander Schulz. All rights reserved.
//

import Foundation
import WatchConnectivity

class ConnectivityHandler : NSObject, WCSessionDelegate {
	
	var session = WCSession.default
	
	override init() {
		super.init()
		
		session.delegate = self
		session.activate()
		
		NSLog("%@", "Paired Watch: \(session.isPaired), Watch App Installed: \(session.isWatchAppInstalled)")
	}
	
	// MARK: - WCSessionDelegate
	
	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
		NSLog("%@", "activationDidCompleteWith activationState:\(activationState) error:\(error)")
	}
	
	func sessionDidBecomeInactive(_ session: WCSession) {
		NSLog("%@", "sessionDidBecomeInactive: \(session)")
	}
	
	func sessionDidDeactivate(_ session: WCSession) {
		NSLog("%@", "sessionDidDeactivate: \(session)")
	}
	
	func sessionWatchStateDidChange(_ session: WCSession) {
		NSLog("%@", "sessionWatchStateDidChange: \(session)")
	}
	
	func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
		NSLog("didReceiveMessage: %@", message)
		print("got it")
		if message["request"] as? String == "codes" {
			let codes = CodeManager.shared.getCodes()
			var watchCodes = [WatchCode]()
			
			for code in codes {
				watchCodes.append(WatchCode(name: code.name, value: code.value,
											id: code.id, displaySize: code.displaySize, showValue: code.showValue))
			}
			replyHandler(["codes" : watchCodes])
		}
	}
	
}
