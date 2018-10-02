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
		guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
			fatalError("Failed to retrieve task manager archive URL!")
		}
		return url.appendingPathComponent(CODEMANAGERDIR)
	}
	
	static func saveCodeManager() {
		let success = NSKeyedArchiver.archiveRootObject(CodeManager.shared, toFile: codeManagerDir().path)
		if !success {
			fatalError("Error while saving task manager!")
		}
	}
	
	static func loadCodeManager() -> CodeManager? {
		return NSKeyedUnarchiver.unarchiveObject(withFile: codeManagerDir().path) as? CodeManager
	}
}
