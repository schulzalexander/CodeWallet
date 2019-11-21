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


class CodeTableInterfaceController: WKInterfaceController {

	//MARK: Properties
	var session : WCSession?
	
	//MARK: Outlets
	@IBOutlet weak var barcodeTable: WKInterfaceTable!
	@IBOutlet weak var countLabel: WKInterfaceLabel!
	
	
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
		
		WatchSessionManager.shared.delegate = self
		WatchSessionManager.shared.activateWCSession()
    }
	
	//MARK: Table
	override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
		let code = WatchCodeManager.shared.getCodes()[rowIndex]
		presentController(withName: "CodeDetailInterfaceController", context: code)
	}
	
	func populateTable() {
		let codes = WatchCodeManager.shared.getCodes()
		barcodeTable.setNumberOfRows(codes.count, withRowType: "CodeRowController")
		
		for i in 0..<codes.count {
			guard let controller = barcodeTable.rowController(at: i) as? CodeRowController else {
				fatalError("Receiver row controller has unknown type.")
			}
			controller.code = codes[i]
		}
		
		countLabel.setText(String(format: NSLocalizedString("WatchCountLabelText", comment: ""), arguments: [codes.count]))
	}
	
}

extension CodeTableInterfaceController: WatchSessionManagerDelegate {
	
	func didUpdateTimerManager() {
		populateTable()
	}
	
}
