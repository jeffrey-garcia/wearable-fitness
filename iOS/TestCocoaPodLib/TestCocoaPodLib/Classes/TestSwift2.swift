//
//  TestSwift2.swift
//  TestCocoaPodLib
//
//  Created by jeffrey on 15/5/2018.
//

import Foundation

public class TestSwift2 : TestObjc {
    
    override
    public func test() {
        print("\(NSStringFromClass(object_getClass(self))) - test()")
    }
    
}
