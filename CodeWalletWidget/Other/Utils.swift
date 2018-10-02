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
import RSBarcodes_Swift

class Utils {
	
	static func generateID() -> String {
		return UUID().uuidString
	}
	
	static func generateCode(value: String, codeType: AVMetadataObject.ObjectType, targetSize: CGSize) -> UIImage? {
		guard let image = RSUnifiedCodeGenerator.shared.generateCode(value, machineReadableCodeObjectType: codeType.rawValue) else {
			return nil
		}
		return RSAbstractCodeGenerator.resizeImage(image, targetSize: targetSize, contentMode: UIView.ContentMode.scaleAspectFit)
	}
}
