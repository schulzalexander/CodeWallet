//
//  CodeAction.swift
//  CodeWalletWidgetApp
//
//  Created by Alexander Schulz on 29.11.19.
//  Copyright © 2019 Alexander Schulz. All rights reserved.
//

import Foundation

class CodeAction {
    
    var title: String
    var action: () -> ()
    
    init(title: String, action: @escaping () -> ()) {
        self.title = title
        self.action = action
    }
    
}
