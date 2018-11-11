//
//  Settings.swift
//  CodeWalletWidget
//
//  Created by Alexander Schulz on 03.10.18.
//  Copyright © 2018 Alexander Schulz. All rights reserved.
//

import Foundation


class Settings: NSObject, NSCoding {
	
	//MARK: Properties
	var selectedTheme: Themes
	var firstAppStart: Bool
	var hasSetLocation: Bool
	
	static var shared = Settings()
	
	struct PropertyKeys {
		static let selectedThemes = "selectedThemes"
		static let firstAppStart = "firstAppStart"
		static let hasSetLocation = "hasSetLocation"
	}
	
	private override init() {
		selectedTheme = .light
		firstAppStart = true
		hasSetLocation = true
		super.init()
	}
	
	func encode(with aCoder: NSCoder) {
		aCoder.encode(selectedTheme.rawValue, forKey: PropertyKeys.selectedThemes)
		aCoder.encode(firstAppStart, forKey: PropertyKeys.firstAppStart)
		aCoder.encode(hasSetLocation, forKey: PropertyKeys.hasSetLocation)
	}
	
	required init?(coder aDecoder: NSCoder) {
		guard let selectedTheme = Themes(rawValue: aDecoder.decodeInteger(forKey: PropertyKeys.selectedThemes)) else {
				fatalError("Error while decoding Settings!")
		}
		self.selectedTheme = selectedTheme
		self.firstAppStart = aDecoder.decodeBool(forKey: PropertyKeys.firstAppStart)
		self.hasSetLocation = aDecoder.decodeBool(forKey: PropertyKeys.hasSetLocation)
	}
	
}
