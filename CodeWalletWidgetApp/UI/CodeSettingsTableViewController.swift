//
//  CodeSettingsTableViewController.swift
//  CodeWalletWidgetApp
//
//  Created by Alexander Schulz on 30.10.18.
//  Copyright © 2018 Alexander Schulz. All rights reserved.
//

import UIKit

class CodeSettingsTableViewController: UITableViewController {

	//MARK: Properties
	var code: Code!
	var changed: Bool!
	
	//MARK: Outlets
	@IBOutlet weak var deleteButton: UIButton!
	@IBOutlet weak var locationSwitch: UISwitch!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var sizeLabel: UILabel!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		changed = false
		
		nameLabel.text = code.name
		locationSwitch.isOn = code.notification?.isEnabled ?? false
		
		deleteButton.layer.cornerRadius = deleteButton.frame.height / 2
		deleteButton.clipsToBounds = true
    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		tableView.sizeToFit()
		preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: tableView.contentSize.height)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		CodeManagerArchive.saveCodeManager()
	}
	
	@IBAction func didChangeLocationEnabled(_ sender: UISwitch) {
		guard code.notification != nil else {
			return
		}
		code.notification!.isEnabled = sender.isOn
		changed = true
	}
	
	@IBAction func deleteCode(_ sender: UIButton) {
		guard let codeTable = self.popoverPresentationController?.delegate as? CodeTableViewController else {
			return
		}
		let alertController = UIAlertController(title: nil, message: NSLocalizedString("CodeDeletionMessage", comment: ""), preferredStyle: .alert)
		let delete = UIAlertAction(title: NSLocalizedString("Delete", comment: ""), style: .destructive, handler: { (action) in
			guard let index = CodeManager.shared.getCodes().firstIndex(of: self.code) else {
				return
			}
			codeTable.deleteCode(indexPath: IndexPath(row: index, section: 0))
			self.dismiss(animated: true, completion: nil)
		})
		let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
		alertController.addAction(delete)
		alertController.addAction(cancel)
		present(alertController, animated: true, completion: nil)
	}
	
	override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		return UIView()
	}
	
	@IBAction func incBarcodeSize(_ sender: UIButton) {
		code.displaySize = min(1.0, code.displaySize + 0.1)
		sizeLabel.text = "\(Int(round(code.displaySize * 100))) %"
		changed = true
	}
	
	@IBAction func decBarcodeSize(_ sender: UIButton) {
		code.displaySize = max(0.1, code.displaySize - 0.1)
		sizeLabel.text = "\(Int(round(code.displaySize * 100))) %"
		changed = true
	}
}
