//
//  WatchSessionManager.swift
//  CodeWalletWidgetApp
//
//  Created by Alexander Schulz on 02.06.19.
//  Copyright © 2019 Alexander Schulz. All rights reserved.
//

import Foundation
import WatchConnectivity

class WatchSessionManager: NSObject, WCSessionDelegate {
	
	var delegate: WatchSessionManagerDelegate?
	
	static var shared = WatchSessionManager()
	
	
	private override init() {
		super.init()
	}
	
	func activateWCSession() {
		if WCSession.isSupported() { //makes sure it's not an iPad or iPod
			let watchSession = WCSession.default
			watchSession.delegate = self
			watchSession.activate()
		}
	}
	
	#if os(iOS)
	func sendUpdate() {
		let session = WCSession.default
		if session.isPaired && session.isWatchAppInstalled {
			let encoder = JSONEncoder()
			let timestamp = Date().timeIntervalSince1970
			
			let codes = CodeManager.shared.getCodes().map { (code) -> WatchCode in
				return WatchCode(code: code)
			}
			
			do {
				try session.updateApplicationContext([
					"codes": try encoder.encode(codes),
					"timestamp": timestamp
					])
				CodeManager.shared.setLastUpdateTimestamp(timestamp: timestamp)
				
				print("Updated ApplicationContext.")
			} catch let error as NSError {
				print(error.description)
			}
		}
	}
	
	func sessionDidBecomeInactive(_ session: WCSession) {
		
	}
	
	func sessionDidDeactivate(_ session: WCSession) {
		
	}
	
	#else
	func receiveUpdate(applicationContext: [String: Any]) {
		let decoder = JSONDecoder()
		guard let codesData = applicationContext["codes"] as? Data,
			let timestamp = applicationContext["timestamp"] as? Double else {
				return
		}
		
		if timestamp <= WatchCodeManager.shared.getLastUpdateTimestamp() {
			return
		}
		
		do {
			let codes = try decoder.decode([WatchCode].self, from: codesData)
			WatchCodeManager.shared.setCodes(codes: codes)
			
			delegate?.didUpdateTimerManager()
			
			print("Received update.")
		} catch let error as NSError {
			print(error.description)
		}
	}
	
	func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
		receiveUpdate(applicationContext: applicationContext)
	}
	
	#endif
	
	
	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
		#if !os(iOS)
		if activationState == .activated {
			receiveUpdate(applicationContext: session.applicationContext)
		}
		#endif
	}
}

protocol WatchSessionManagerDelegate {
	
	func didUpdateTimerManager()
	
}
