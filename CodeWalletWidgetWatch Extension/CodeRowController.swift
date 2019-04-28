//
//  CodeRowController.swift
//  CodeWalletWidgetWatch Extension
//
//  Created by Alexander Schulz on 28.04.19.
//  Copyright © 2019 Alexander Schulz. All rights reserved.
//

import WatchKit

class CodeRowController: NSObject {
	
	//MARK: Properties
	var code: WatchCode! {
		didSet {
			nameLabel.setText(code.name)
		}
	}
	
	//MARK: Outlets
	@IBOutlet weak var nameLabel: WKInterfaceLabel!
	
	

}
