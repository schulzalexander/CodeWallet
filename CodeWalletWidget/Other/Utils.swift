//
//  Utils.swift
//  CodeWalletWidget
//
//  Created by Alexander Schulz on 02.10.18.
//  Copyright © 2018 Alexander Schulz. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class Utils {
	
	static func generateID() -> String {
		return UUID().uuidString
	}
	
	static func generateCode(value: String, codeType: AVMetadataObject.ObjectType) -> UIImage? {
		var filterName: String = ""
		switch codeType {
		case AVMetadataObject.ObjectType.code128:
			filterName = "CICode128BarcodeGenerator"
		case AVMetadataObject.ObjectType.qr:
			filterName = "CIQRCodeGenerator"
		default:
			return nil
		}
		if let filter = CIFilter(name: filterName) {
			filter.setValue(value.data(using: .ascii), forKey: "inputMessage")
			let transform = CGAffineTransform(scaleX: 3, y: 3)
			
			if let output = filter.outputImage?.transformed(by: transform) {
				return UIImage(ciImage: output)
			}
		}
		
		return nil
	}
}
