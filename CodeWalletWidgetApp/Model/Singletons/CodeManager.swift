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
	private var lastUpdateTimestamp: Double
	
	static var shared: CodeManager = CodeManager()
	
	
	struct PropertyKeys {
		static let codes = "codes"
		static let lastUpdateTimestamp = "lastUpdateTimestamp"
	}
	
	private override init() {
		codes = [Code]()
		lastUpdateTimestamp = Date().timeIntervalSince1970.binade
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
	
	func deleteCode(id: String) {
		for i in 0..<codes.count {
			if id == codes[i].id {
				codes[i].notification?.isEnabled = false
				codes.remove(at: i)
				return
			}
		}
	}
	
	func deleteCode(index: Int) {
		guard index < codes.count else {
			return
		}
		codes[index].notification?.isEnabled = false
		codes.remove(at: index)
	}
	
	func deleteAllCodes() {
		CodeManager.shared = CodeManager()
		CodeManagerArchive.saveCodeManager()
	}
	
	func setLastUpdateTimestamp(timestamp: Double) {
		lastUpdateTimestamp = timestamp
	}
	
	func getLastUpdateTimestamp() -> Double {
		return lastUpdateTimestamp
	}
	
	//MARK: NSCoding
	
	func encode(with aCoder: NSCoder) {
		NSKeyedArchiver.setClassName("Code", for: Code.self)
		aCoder.encode(codes, forKey: PropertyKeys.codes)
		aCoder.encode(lastUpdateTimestamp, forKey: PropertyKeys.lastUpdateTimestamp)
	}
	
	required init?(coder aDecoder: NSCoder) {
		NSKeyedUnarchiver.setClass(Code.self, forClassName: "Code")
		guard let codes = aDecoder.decodeObject(forKey: PropertyKeys.codes) as? [Code] else {
			fatalError("Error while decoding object of class ClassName")
		}
		self.codes = codes
		self.lastUpdateTimestamp = aDecoder.decodeDouble(forKey: PropertyKeys.lastUpdateTimestamp)
	}
	
}
