//
//  SecureStorage+SFLogger.swift
//  SecureStorage
//
//  Created by jeffrey on 30/8/2018.
//  Copyright © 2018 jeffrey. All rights reserved.
//

import Foundation

import SalesforceSDKCore

extension SFLogger {
    
    func info(_ message:String) {
        self.log(SFLogLevel.info, msg: message)
    }
    
}
