//
//  CodeManager.swift
//  CodeWalletWidget
//
//  Created by Alexander Schulz on 02.10.18.
//  Copyright © 2018 Alexander Schulz. All rights reserved.
//

import Foundation

class CodeManager: NSObject, NSCoding {
	
	//MARK: Properties
	private var codes: [Code]!
	
	static var shared: CodeManager = CodeManager()
	
	
	struct PropertyKeys {
		static let codes = "codes"
	}
	
	private override init() {
		codes = [Code]()
		super.init()
	}
	
	//MARK: Getter
	
	func count() -> Int {
		return codes.count
	}
	
	func addCode(code: Code) {
		codes.append(code)
	}
	
	func getCodes() -> [Code] {
		return codes
	}
	
	func getCode(id: String) -> Code? {
		for code in codes {
			if code.id == id {
				return code
			}
		}
		return nil
	}
	
	func deleteAllCodes() {
		CodeManager.shared = CodeManager()
		CodeManagerArchive.saveCodeManager()
	}
	
	//MARK: NSCoding
	
	func encode(with aCoder: NSCoder) {
		aCoder.encode(codes, forKey: PropertyKeys.codes)
	}
	
	required init?(coder aDecoder: NSCoder) {
		guard let codes = aDecoder.decodeObject(forKey: PropertyKeys.codes) as? [Code] else {
			fatalError("Error while decoding object of class ClassName")
		}
		self.codes = codes
	}
	
}
