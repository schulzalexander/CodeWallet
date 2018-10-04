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
	
	
	//MARK: Outlets
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var barcodeImageView: UIImageView!
	@IBOutlet weak var barcodeBackButton: UIButton!
	@IBOutlet weak var barcodeStackView: UIStackView!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		// Load Code Manager if saved
		if let savedCodeManager = CodeManagerArchive.loadCodeManager() {
			CodeManager.shared = savedCodeManager
		}
		
		collectionView.delegate = self
		collectionView.dataSource = self
		
		barcodeStackView.isHidden = true
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}

extension TodayViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return CodeManager.shared.count()
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
			barcodeImageView.image = image
			
			barcodeStackView.isHidden = false
		}
	}
	
}
