//
//  ViewController.swift
//  CodeWalletWidget
//
//  Created by Alexander Schulz on 25.09.18.
//  Copyright © 2018 Alexander Schulz. All rights reserved.
//

import UIKit

class CodeTableViewController: UIViewController {

	//MARK: Properties
	var selectedIndex: IndexPath? // holds the index of the currently opened row
	
	//MARK: Outlets
	@IBOutlet weak var tableView: UITableView!
	
	var gradientBackgroundView: UIView?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if #available(iOS 11.0, *) {
			self.navigationController?.navigationBar.prefersLargeTitles = true
			self.navigationItem.largeTitleDisplayMode = .automatic
		}
		
		//TESTING PURPOSES
		CodeManager.shared.addCode(code: Code(name: "Test Company 1", value: "weofi39283hfoebwwf", type: .qr, logo: nil))
		CodeManager.shared.addCode(code: Code(name: "Test Company 2", value: "weofi39283hfoebwwf", type: .code128, logo: nil))
		
		tableView.delegate = self
		tableView.dataSource = self
		
		updateAppearance()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		tableView.reloadData()
	}
	
	//MARK: TableViewLayout
	
	private func setupGradientBackground() {
		let colours:[CGColor] = Theme.mainBackgroundGradientColors
		let locations:[NSNumber] = [0, 0.6]
		
		let gradientLayer = CAGradientLayer()
		gradientLayer.colors = colours
		gradientLayer.locations = locations
		gradientLayer.startPoint = CGPoint(x: 0, y: 0)
		gradientLayer.endPoint = CGPoint(x: 1, y: 1)
		gradientLayer.frame = UIScreen.main.bounds
		
		// Depending on whether the gradient layer was set before, either create a new one or edit the existing
		if gradientBackgroundView == nil {
			gradientBackgroundView = UIView(frame: UIScreen.main.bounds)
			self.view.insertSubview(gradientBackgroundView!, belowSubview: tableView)
		} else {
			gradientBackgroundView!.layer.sublayers?.removeAll()
		}
		gradientBackgroundView!.layer.addSublayer(gradientLayer)
	}
	
}

extension CodeTableViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return CodeManager.shared.count()
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cellIdentifier = "CodeTableViewCell"
		guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CodeTableViewCell else {
			fatalError("Dequeued cell is not an instance of TaskTableViewCell!")
		}
		cell.selectionStyle = .none
		cell.code = CodeManager.shared.getCodes()[indexPath.row]
		cell.backgroundColor = Theme.codeCellBackgroundColor
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		var reload = [indexPath]
		var newSelection: IndexPath? = indexPath
		if selectedIndex != nil {
			if selectedIndex!.row == indexPath.row {
				newSelection = nil
			}
			reload.append(selectedIndex!)
		}
		selectedIndex = newSelection
		tableView.reloadRows(at: reload, with: .fade)
	}
	

	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if selectedIndex != nil && selectedIndex!.row == indexPath.row {
			return 200
		} else {
			return 70
		}
	}
	
	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		return UIView()
	}
	
}

extension CodeTableViewController: ThemeDelegate {
	
	func updateAppearance() {
		setupGradientBackground()
		tableView.reloadData()
		tableView.separatorColor = Theme.tableViewSeperatorColor
	}
	
}
