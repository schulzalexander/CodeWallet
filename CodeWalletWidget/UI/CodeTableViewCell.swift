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

	private func updateContent() {
		nameLabel.text = code.name
		codeImageView.image = Utils.generateCode(value: code.value,
												 codeType: code.type,
												 targetSize: codeImageView.frame.size)
	}
	
}
