//
//  CoreExtensions.swift
//  CodeWalletWidget
//
//  Created by Alexander Schulz on 05.10.18.
//  Copyright © 2018 Alexander Schulz. All rights reserved.
//

import Foundation
import UIKit

// https://www.hackingwithswift.com/example-code/media/how-to-read-the-average-color-of-a-uiimage-using-ciareaaverage
extension UIImage {
	
	var averageColor: UIColor? {
		guard let inputImage = CIImage(image: self) else { return nil }
		let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)
		
		guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
		guard let outputImage = filter.outputImage else { return nil }
		
		var bitmap = [UInt8](repeating: 0, count: 4)
		let context = CIContext(options: [CIContextOption.workingColorSpace: kCFNull])
		context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: CIFormat.RGBA8, colorSpace: nil)
		
		return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
	}
	
}

extension UICollectionView {
	
	func setEmptyMessage(_ text: String) {
		let label = UILabel(frame: self.frame)
		label.text = text
		label.textColor = .darkGray
		label.textAlignment = .center
		label.numberOfLines = 0
		label.font = label.font.withSize(16)
		label.sizeToFit()
		self.backgroundView = label
	}
	
	func removeEmptyMessage() {
		backgroundView = nil
	}
	
}

extension UITableView {
	
	func setEmptyMessage(_ text: String) {
		let label = UILabel(frame: self.frame)
		label.text = text
		label.textColor = .darkGray
		label.textAlignment = .center
		label.numberOfLines = 0
		label.font = label.font.withSize(16)
		label.sizeToFit()
		self.backgroundView = label
	}
	
	func removeEmptyMessage() {
		backgroundView = nil
	}
	
}

extension UIImage {
	func imageWithInsets(insets: UIEdgeInsets) -> UIImage? {
		UIGraphicsBeginImageContextWithOptions(
			CGSize(width: self.size.width + insets.left + insets.right,
				   height: self.size.height + insets.top + insets.bottom), false, self.scale)
		let _ = UIGraphicsGetCurrentContext()
		let origin = CGPoint(x: insets.left, y: insets.top)
		self.draw(at: origin)
		let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return imageWithInsets
	}
}
