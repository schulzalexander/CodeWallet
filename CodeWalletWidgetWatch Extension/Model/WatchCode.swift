//
//  WatchCode.swift
//  CodeWalletWidgetWatch Extension
//
//  Created by Alexander Schulz on 28.04.19.
//  Copyright © 2019 Alexander Schulz. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class WatchCode: Codable {
	
	//MARK: Properties
	var name: String
	var value: String
	var id: String
	var displaySize: Float
	var showValue: Bool
	var codeImage: UIImage
	
	init(name: String, value: String, id: String, displaySize: Float, showValue: Bool, codeImage: UIImage) {
		self.name = name
		self.value = value
		self.id = id
		self.displaySize = displaySize
		self.showValue = showValue
		self.codeImage = codeImage
	}
	
	#if os(iOS)
	init(code: Code) {
		self.name = code.name
		self.value = code.value
		self.id = code.id
		self.displaySize = code.displaySize
		self.showValue = code.showValue
		self.codeImage = Utils.generateCode(value: code.value, codeType: code.type, targetSize: CGSize(width: 100, height: 100))!
	}
	#endif
	
	//MARK: Keys Codable
	enum CodingKeys: String, CodingKey {
		case name
		case value
		case id
		case type
		case displaySize
		case showValue
		case codeImage
	}
	
	//MARK: Codable
	func encode(to encoder: Encoder) throws
	{
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(name, forKey: .name)
		try container.encode(value, forKey: .value)
		try container.encode(id, forKey: .id)
		try container.encode(displaySize, forKey: .displaySize)
		try container.encode(showValue, forKey: .showValue)
		try container.encode(codeImage.pngData(), forKey: .codeImage)
	}
	
	required init(from decoder: Decoder) throws
	{
		let values = try decoder.container(keyedBy: CodingKeys.self)
		name = try values.decode(String.self, forKey: .name)
		value = try values.decode(String.self, forKey: .value)
		id = try values.decode(String.self, forKey: .id)
		displaySize = try values.decode(Float.self, forKey: .displaySize)
		showValue = try values.decode(Bool.self, forKey: .showValue)
		let codeImageData = try values.decode(Data.self, forKey: .codeImage)
		guard let image = UIImage(data: codeImageData) else {
			fatalError("Failed to decode code image!")
		}
		codeImage = image
	}
}
