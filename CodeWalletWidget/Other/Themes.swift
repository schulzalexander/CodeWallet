//
//  Themes.swift
//  CodeWalletWidget
//
//  Created by Alexander Schulz on 03.10.18.
//  Copyright © 2018 Alexander Schulz. All rights reserved.
//

import Foundation
import UIKit

enum Themes: Int {
	case light, dark
}

protocol ThemeDelegate {
	func updateAppearance()
}

class Theme {
	
	// MARK: Navigation Controller
	static var navigationBarTintColor: UIColor? {
		get {
			switch Settings.shared.selectedTheme {
			case .light:
				return nil
			case .dark:
				return UIColor.darkGray
			}
		}
	}
	
	//MARK: CodeTable
	
	static var codeCellBackgroundColor: UIColor {
		get {
			switch Settings.shared.selectedTheme {
			case .light:
				return .white
			case .dark:
				return UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)
			}
		}
	}
	
	static var mainBackgroundGradientColors: [CGColor] {
		get {
			switch Settings.shared.selectedTheme {
			case .light:
				return [UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.0).cgColor, UIColor.white.cgColor]
			case .dark:
				return [UIColor.darkGray.cgColor, UIColor.lightGray.cgColor]
			}
		}
	}
	
	//MARK: Settings
	static var settingsTableViewBackgroundColor: UIColor? {
		get {
			switch Settings.shared.selectedTheme {
			case .light:
				return UIColor(red: 0.937255, green: 0.937255, blue: 0.956863, alpha: 1)
			case .dark:
				return UIColor.lightGray
			}
		}
	}
	
	static var settingsTableViewCellBackgroundColor: UIColor? {
		get {
			switch Settings.shared.selectedTheme {
			case .light:
				return UIColor.white
			case .dark:
				return UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)//UIColor.lightGray.withAlphaComponent(0.4)
			}
		}
	}
	
	static var tableViewSeperatorColor: UIColor? {
		get {
			switch Settings.shared.selectedTheme {
			case .light:
				return nil
			case .dark:
				return UIColor.black
			}
		}
	}
	
}
