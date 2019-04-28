//
//  WatchCode.swift
//  CodeWalletWidgetWatch Extension
//
//  Created by Alexander Schulz on 28.04.19.
//  Copyright © 2019 Alexander Schulz. All rights reserved.
//

import Foundation

class WatchCode {
	
	//MARK: Properties
	var name: String
	var value: String
	var id: String
	var displaySize: Float
	var showValue: Bool
	
	init(name: String, value: String, id: String, displaySize: Float, showValue: Bool) {
		self.name = name
		self.value = value
		self.id = id
		self.displaySize = displaySize
		self.showValue = showValue
	}
	
}
