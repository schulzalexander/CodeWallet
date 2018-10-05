//
//  CodeCollectionViewCell.swift
//  TodayExtension
//
//  Created by Alexander Schulz on 04.10.18.
//  Copyright © 2018 Alexander Schulz. All rights reserved.
//

import UIKit

class CodeCollectionViewCell: UICollectionViewCell {
	
	//MARK: Properties
	var code: Code! {
		didSet {
			imageView.image = code.logo
			nameLabel.text = code.name
		}
	}
	
	//MARK: Outlets
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		imageView.backgroundColor = .white
		imageView.layer.cornerRadius = 15
//		imageView.layer.shadowColor = UIColor.lightGray.cgColor
//		imageView.layer.shadowOffset = CGSize(width: 0, height: 3)
//		imageView.layer.shadowOpacity = 1.0
		imageView.clipsToBounds = true
	}
	
}
