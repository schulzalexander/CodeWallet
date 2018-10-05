//
//  Code.swift
//  CodeWalletWidget
//
//  Created by Alexander Schulz on 25.09.18.
//  Copyright © 2018 Alexander Schulz. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class Code: NSObject, NSCoding {
	
	//MARK: Properties
	var name: String
	var value: String
	var id: String
	var type: AVMetadataObject.ObjectType
	var logo: UIImage?
	
	struct PropertyKeys {
		static let name = "name"
		static let value = "value"
		static let id = "id"
		static let type = "type"
		static let logo = "logo"
	}
	
	
	init(name: String, value: String, type: AVMetadataObject.ObjectType, logo: UIImage?) {
		self.name = name
		self.value = value
		self.id = Utils.generateID()
		self.type = type
		self.logo = logo
		
		super.init()
	}
	
	//MARK: NSCoding
	func encode(with aCoder: NSCoder) {
		aCoder.encode(name, forKey: PropertyKeys.name)
		aCoder.encode(value, forKey: PropertyKeys.value)
		aCoder.encode(id, forKey: PropertyKeys.id)
		aCoder.encode(type, forKey: PropertyKeys.type)
		aCoder.encode(logo, forKey: PropertyKeys.logo)
	}
	
	required init?(coder aDecoder: NSCoder) {
		guard let name = aDecoder.decodeObject(forKey: PropertyKeys.name) as? String,
			let value = aDecoder.decodeObject(forKey: PropertyKeys.value) as? String,
			let id = aDecoder.decodeObject(forKey: PropertyKeys.id) as? String,
			let type = aDecoder.decodeObject(forKey: PropertyKeys.type) as? AVMetadataObject.ObjectType else {
				fatalError("Error while decoding Code object!")
		}
		self.name = name
		self.value = value
		self.id = id
		self.type = type
		self.logo = aDecoder.decodeObject(forKey: PropertyKeys.logo) as? UIImage
	}
	
	
}
