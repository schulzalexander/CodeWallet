//
//  Code.swift
//  CodeWalletWidget
//
//  Created by Alexander Schulz on 25.09.18.
//  Copyright © 2018 Alexander Schulz. All rights reserved.
//

import Foundation


class Code: NSObject, NSCoding {
	
	//MARK: Properties
	var name: String
	var value: String
	
	struct PropertyKeys {
		static let name = "name"
		static let value = "value"
	}
	
	
	init(name: String, value: String) {
		self.name = name
		self.value = value
		
		super.init()
	}
	
	
	//MARK: NSCoding
	func encode(with aCoder: NSCoder) {
		aCoder.encode(name, forKey: PropertyKeys.name)
		aCoder.encode(value, forKey: PropertyKeys.value)
	}
	
	required init?(coder aDecoder: NSCoder) {
		guard let name = aDecoder.decodeObject(forKey: PropertyKeys.name) as? String,
			let value = aDecoder.decodeObject(forKey: PropertyKeys.value) as? String else {
				fatalError("Error while decoding Code object!")
		}
		self.name = name
		self.value = value
	}
	
	
}
