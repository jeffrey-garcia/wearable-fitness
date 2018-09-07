//
//  Offline.swift
//  SecureStorage
//
//  Created by jeffrey on 6/9/2018.
//  Copyright © 2018 jeffrey. All rights reserved.
//

import Foundation

class SecureStorage {
    public func putRequestToBuffer() {
        print("\(type(of: self)) - putRequestToBuffer")
    }
}

class OfflineManager {
    public static var instance:OfflineManager?
    
    public class func shared() -> OfflineManager {
        guard let _instance = instance else {
            instance = OfflineManager.init()
            return instance!
        }
        return _instance
    }
    
    public lazy var loggingManager = { () -> String in
        print("\(type(of: self)) - initializing logging manager...")
        return "LoggingManager"
    }()
    
    public lazy var secureStorage = { () -> SecureStorage in
        print("\(type(of: self)) - initializing secure storage...")
        return SecureStorage.init()
    }()
    
    public init() {
        print("\(type(of: self)) - init")
    }
}

class CmpSecureStorage:SecureStorage {
    override
    public func putRequestToBuffer() {
        print("\(type(of: self)) - putRequestToBuffer")
    }
    
    public func doSomething() {
        print("\(type(of: self)) - doSomething")
    }
}

class CmpOfflineManager:OfflineManager {
    override
    public class func shared() -> CmpOfflineManager {
        guard let _instance = instance as? CmpOfflineManager else {
            //instance = CmpOfflineManager.Builder().configureLogger().configureSecureStorage().build()
            instance = CmpOfflineManager.init().configureLogger().configureSecureStorage()
            return instance as! CmpOfflineManager
        }
        return _instance
    }
    
    class Builder {
        private lazy var loggingManager:String = {
            return "CmpLoggingManager"
        }()

        private lazy var secureStorage:CmpSecureStorage = {
            return CmpSecureStorage.init()
        }()
        
        public init() {}
        
        public func configureLogger() -> Builder {
            print("\(type(of: self.loggingManager)) - initializing logging manager...")
            return self
        }
        
        public func configureSecureStorage() -> Builder {
            print("\(type(of: self.secureStorage)) - initializing secure storage...")
            return self
        }
        
        public func build() -> CmpOfflineManager {
            let offlineManger = CmpOfflineManager.init()
            offlineManger.loggingManager = loggingManager
            offlineManger.secureStorage = self.secureStorage
            return offlineManger
        }
    }
    
    public func configureLogger() -> CmpOfflineManager {
        self.loggingManager = {
            print("\(type(of: self)) - initializing logging manager...")
            return "CmpLoggingManager"
        }()
        return self
    }

    public func configureSecureStorage() -> CmpOfflineManager {
        self.secureStorage = {
            print("\(type(of: self)) - initializing secure storage...")
            return CmpSecureStorage.init()
        }()
        return self
    }
}
