//
//  CodeTableViewCell.swift
//  CodeWalletWidget
//
//  Created by Alexander Schulz on 25.09.18.
//  Copyright © 2018 Alexander Schulz. All rights reserved.
//

import UIKit

class CodeTableViewCell: UITableViewCell {

	//MARK: Properties
	var code: Code! {
		didSet {
			updateContent()
		}
	}
	
	//MARK: Outlets
	@IBOutlet weak var logoImageView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var codeImageView: UIImageView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		logoImageView.layer.cornerRadius = 10
//		logoImageView.layer.shadowOffset = CGSize(width: 2, height: 2)
//		logoImageView.layer.shadowColor = UIColor.lightGray.cgColor
//		logoImageView.layer.shadowOpacity = 1.0
		logoImageView.clipsToBounds = true
	}

	private func updateContent() {
		nameLabel.text = code.name
		codeImageView.image = Utils.generateCode(
			value: code.value,
			codeType: code.type,
			targetSize: codeImageView.frame.size) ?? UIImage(named: "LaunchScreenAppIcon")
		if code.logo != nil {
			logoImageView.image = code.logo!
		} else {
			if let image = Utils.generateCode(value: code.value, codeType: code.type, targetSize: logoImageView.frame.size) {
				logoImageView.image = image.imageWithInsets(insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)) ?? UIImage(named: "LaunchScreenAppIcon")
			}
		}
	}
	
}
