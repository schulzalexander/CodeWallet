//
//  InterfaceController.swift
//  CodeWalletWidgetWatch Extension
//
//  Created by Alexander Schulz on 27.04.19.
//  Copyright © 2019 Alexander Schulz. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class CodeTableInterfaceController: WKInterfaceController, WCSessionDelegate {

	//MARK: Properties
	var codes: [WatchCode]! {
		didSet {
			// Configure interface objects here.
			barcodeTable.setNumberOfRows(codes.count, withRowType: "CodeRow")
			
			for index in 0..<barcodeTable.numberOfRows {
				guard let controller = barcodeTable.rowController(at: index) as? CodeRowController else {
					continue
				}
				controller.code = codes[index]
			}
		}
	}
	var session : WCSession?
	
	//MARK: Outlets
	@IBOutlet weak var barcodeTable: WKInterfaceTable!
	
	
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
		
		session = WCSession.default
		session?.delegate = self
		session?.activate()
		
		requestInfo()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
	
	//MARK: Table
	override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
		let code = codes[rowIndex]
		presentController(withName: "CodeDetailInterfaceController", context: code)
	}
	
	
	// MARK: - WCSessionDelegate
	
	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
		NSLog("%@", "activationDidCompleteWith activationState:\(activationState) error:\(error)")
	}
	
	func requestInfo() {
		session?.sendMessage(["request" : "date"], replyHandler: { (response) in
			guard let codes = response as? [WatchCode] else {
				return
			}
			self.codes = codes
		}, errorHandler: { (error) in
			print("Error sending message: %@", error)
		})
	}
	

}
