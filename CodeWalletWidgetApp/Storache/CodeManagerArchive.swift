//
//  CodeManagerArchive.swift
//  CodeWalletWidget
//
//  Created by Alexander Schulz on 02.10.18.
//  Copyright © 2018 Alexander Schulz. All rights reserved.
//

import Foundation

class CodeManagerArchive {
	
	static let CODEMANAGERDIR = "CodeManager"
	
	//MARK: TaskManager
	static func codeManagerDir() -> URL {
		guard let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.alexanderschulz.CodeWalletWidget") else {//urls(for: .documentDirectory, in: .userDomainMask).first else {
			fatalError("Failed to retrieve task manager archive URL!")
		}
		return url.appendingPathComponent(CODEMANAGERDIR)
	}
	
	static func saveCodeManager() {
		NSKeyedArchiver.setClassName("CodeManager", for: CodeManager.self)
		let success = NSKeyedArchiver.archiveRootObject(CodeManager.shared, toFile: codeManagerDir().path)
		if !success {
			fatalError("Error while saving task manager!")
		}
	}
	
	static func loadCodeManager() -> CodeManager? {
		NSKeyedUnarchiver.setClass(CodeManager.self, forClassName: "CodeManager")
		return NSKeyedUnarchiver.unarchiveObject(withFile: codeManagerDir().path) as? CodeManager
	}
}
