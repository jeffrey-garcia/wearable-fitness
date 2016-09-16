//
//  TestData.swift
//  TestSwift3
//
//  Created by Jeffrey Garcia on 9/4/16.
//  Copyright © 2016 Jeffrey Garcia. All rights reserved.
//

import Foundation

public class TestData {
    
    required public init() {
        let className = NSStringFromClass(object_getClass(self))
        print("\(className) - init")
    }
    
}
