//
//  TodayViewController.swift
//  TodayExtension
//
//  Created by Alexander Schulz on 04.10.18.
//  Copyright © 2018 Alexander Schulz. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
	
	//MARK: Properties
	var barcodeInstrumentsHidden: Bool!
	
	//MARK: Outlets
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var barcodeImageView: UIImageView!
	@IBOutlet weak var barcodeBackButton: UIButton!
	@IBOutlet weak var barcodeTitleLabel: UILabel!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		// Load Code Manager if saved
		if let savedCodeManager = CodeManagerArchive.loadCodeManager() {
			CodeManager.shared = savedCodeManager
		}
		
		collectionView.delegate = self
		collectionView.dataSource = self
		
		// Hide instruments at first, so that user only sees barcode
		barcodeBackButton.layer.opacity = 0
		barcodeTitleLabel.layer.opacity = 0
		barcodeImageView.layer.opacity = 0
		barcodeInstrumentsHidden = true
		
		barcodeTitleLabel.layer.shadowColor = UIColor.black.cgColor
		barcodeTitleLabel.layer.shadowOpacity = 1.0
		barcodeTitleLabel.layer.shadowRadius = 4.0
		barcodeBackButton.layer.shadowColor = UIColor.gray.cgColor
		barcodeBackButton.layer.shadowOpacity = 1.0
		barcodeBackButton.layer.shadowRadius = 4.0
		
		// Back button press leads back to collectionView
		barcodeBackButton.addTarget(self, action: #selector(didPressBarcodeBackButton(_:)), for: .touchUpInside)
		
		// A tap on the barcode should toggle the instruments visibility
		let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didPressBarcodeImage(_:)))
		barcodeImageView.isUserInteractionEnabled = true
		barcodeImageView.addGestureRecognizer(tapRecognizer)
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
	
	@objc private func didPressBarcodeBackButton(_ sender: UIButton) {
		UIView.animate(withDuration: 0.25) {
			self.barcodeBackButton.layer.opacity = 0
			self.barcodeTitleLabel.layer.opacity = 0
			self.barcodeImageView.layer.opacity = 0
		}
		barcodeInstrumentsHidden = true
	}
	
	@objc private func didPressBarcodeImage(_ sender: UITapGestureRecognizer) {
		barcodeInstrumentsHidden = !barcodeInstrumentsHidden
		let target: Float = barcodeInstrumentsHidden ? 0.0 : 0.9
		UIView.animate(withDuration: 0.25) {
			self.barcodeBackButton.layer.opacity = target
			self.barcodeTitleLabel.layer.opacity = target
		}
	}
	
	
    
}

extension TodayViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		let count = CodeManager.shared.count()
		
		if count == 0 {
			collectionView.setEmptyMessage(NSLocalizedString("CollectionViewEmptyMessage", comment: ""))
		} else {
			collectionView.removeEmptyMessage()
		}
		
		return count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CodeCollectionViewCell", for: indexPath) as? CodeCollectionViewCell else {
			fatalError("Failed to dequeue collectionView cell!")
		}
		cell.code = CodeManager.shared.getCodes()[indexPath.row]
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let code = CodeManager.shared.getCodes()[indexPath.row]
		if let image = Utils.generateCode(value: code.value, codeType: code.type, targetSize: barcodeImageView.frame.size) {
			barcodeImageView.image = image.imageWithInsets(insets: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5))
			barcodeImageView.layer.opacity = 1.0
			barcodeTitleLabel.text = code.name
			
			// Adapt the background color of the tools to match the selected code's logo
			let averageColor = code.logo?.averageColor ?? .white
			barcodeBackButton.backgroundColor = averageColor
			barcodeTitleLabel.backgroundColor = averageColor
		}
	}
	
}


