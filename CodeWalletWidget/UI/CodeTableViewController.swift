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
	
	var addButton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if #available(iOS 11.0, *) {
			self.navigationController?.navigationBar.prefersLargeTitles = true
			self.navigationItem.largeTitleDisplayMode = .automatic
		}
		
		//TESTING PURPOSES
		CodeManager.shared.addCode(code: Code(name: "Test Company 1", value: "weofi39283hfoebwwf", type: .qr))
			CodeManager.shared.addCode(code: Code(name: "Test Company 2", value: "weofi39283hfoebwwf", type: .code93))
		
		tableView.delegate = self
		tableView.dataSource = self
		
		layoutAddButton()
		setupGradientBackground()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		tableView.reloadData()
	}

	//MARK: AddButton

	private func layoutAddButton() {
		let height: CGFloat = 50
		let width: CGFloat = view.frame.width * 0.4
		let frame = CGRect(x: (view.frame.width - width) / 2, y: view.frame.maxY - height - 20, width: width, height: height)
		
		addButton = UIButton(frame: frame)
		addButton.layer.cornerRadius = height / 2
		addButton.layer.shadowRadius = 3
		addButton.layer.shadowColor = UIColor.lightGray.cgColor
		addButton.layer.shadowOpacity = 1.0
		addButton.layer.shadowOffset = CGSize(width: 0, height: 2)
		addButton.backgroundColor = .white
		addButton.setAttributedTitle(NSAttributedString(string: "+", attributes: [NSAttributedString.Key.font: UIFont(name: "Times", size: 45)!, NSAttributedString.Key.foregroundColor: UIColor.black]), for: .normal)
		view.insertSubview(addButton, aboveSubview: tableView)
		
		setupAddButtonActions()
	}
	
	private func setupAddButtonActions() {
		addButton.addTarget(self, action: #selector(self.addButtonTouchUpInside), for: UIControl.Event.touchUpInside)
		addButton.addTarget(self, action: #selector(self.addButtonTouchDown), for: UIControl.Event.touchDown)
		addButton.addTarget(self, action: #selector(self.addButtonTouchUpOutside), for: UIControl.Event.touchUpOutside)
	}
	
	@objc private func addButtonTouchDown(_ sender: UIButton) {
		sender.layer.shadowColor = UIColor.clear.cgColor
	}
	
	@objc private func addButtonTouchUpOutside(_ sender: UIButton) {
		sender.layer.shadowColor = UIColor.lightGray.cgColor
	}
	
	@objc private func addButtonTouchUpInside(_ sender: UIButton) {
		sender.layer.shadowColor = UIColor.lightGray.cgColor
		
		guard let navigationController = storyboard?.instantiateViewController(withIdentifier: "AddCodeNavigationController") else {
			return
		}
		present(navigationController, animated: true, completion: nil)
	}
	
	//MARK: TableViewLayout
	
	private func setupGradientBackground() {
		let colours:[CGColor] = [UIColor.lightGray.withAlphaComponent(0.1).cgColor, UIColor.white.cgColor]
		let locations:[NSNumber] = [0, 0.6]
		
		let gradientLayer = CAGradientLayer()
		gradientLayer.colors = colours
		gradientLayer.locations = locations
		gradientLayer.startPoint = CGPoint(x: 0, y: 0)
		gradientLayer.endPoint = CGPoint(x: 1, y: 1)
		gradientLayer.frame = UIScreen.main.bounds
		
		let view = UIView(frame: UIScreen.main.bounds)
		view.layer.addSublayer(gradientLayer)
		tableView.backgroundView = view
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
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//		var reload = [indexPath]
//		if selectedIndex != nil {
//			reload.append(selectedIndex!)
//		}
//		tableView.reloadRows(at: reload, with: .automatic)
	}
	
	func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
		var reload = [indexPath]
		if selectedIndex != nil {
			if selectedIndex!.row == indexPath.row {
				return indexPath
			}
			reload.append(selectedIndex!)
		}
		selectedIndex = indexPath
		tableView.reloadRows(at: reload, with: .automatic)
		return indexPath
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if selectedIndex != nil && selectedIndex!.row == indexPath.row {
			return 170
		} else {
			return 70
		}
	}
	
	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		return UIView()
	}
	
}

