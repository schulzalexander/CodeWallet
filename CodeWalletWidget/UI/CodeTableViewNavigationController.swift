//
//  CodeTableViewNavigationController.swift
//  CodeWalletWidget
//
//  Created by Alexander Schulz on 25.09.18.
//  Copyright © 2018 Alexander Schulz. All rights reserved.
//

import UIKit

class CodeTableViewNavigationController: UINavigationController {

	//MARK: Properties
	var sideMenu: SideMenu!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSideMenu()
    }

	private func setupSideMenu() {
		sideMenu = SideMenu(superview: view)
		let frameTemp = CGRect(x: view.frame.maxX + 5, // +5 for shadow
			y: view.frame.height - (UIScreen.main.nativeBounds.height == 2436 ? 220 : 190),
			width: 150,
			height: 60)
		
		let addFrame = CGRect(x: frameTemp.minX, y: frameTemp.minY, width: frameTemp.width, height: frameTemp.height)
		let addButton = SideMenuButton(frame: addFrame, title: NSAttributedString(string: "  +", attributes: [NSAttributedString.Key.font: UIFont(name: "Times", size: 45)!]), image: nil, color: UIColor.white) { (sender) in
			guard let navigationController = self.storyboard?.instantiateViewController(withIdentifier: "AddCodeNavigationController") else {
				return
			}
			self.present(navigationController, animated: true, completion: nil)
		}
		sideMenu.addButton(button: addButton, alwaysOn: true)
	}
	
}
