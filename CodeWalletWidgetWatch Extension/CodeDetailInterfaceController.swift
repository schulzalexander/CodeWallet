//
//  CodeDetailInterfaceController.swift
//  CodeWalletWidgetWatch Extension
//
//  Created by Alexander Schulz on 28.04.19.
//  Copyright © 2019 Alexander Schulz. All rights reserved.
//

import WatchKit
import Foundation


class CodeDetailInterfaceController: WKInterfaceController {

	//MARK: Properties
	var code: WatchCode! {
		didSet {
			imageView.setImage(code.codeImage)
		}
	}
	
	//MARK: Outlets
	@IBOutlet weak var imageView: WKInterfaceImage!
	
	
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
		if let code = context as? WatchCode {
			self.code = code
		}
    }
	
	override func willActivate() {
		super.willActivate()
		
		WKExtension.shared().isAutorotating = true
	}
	
	override func willDisappear() {
		super.willDisappear()
		
		WKExtension.shared().isAutorotating = false
	}

}
