//
//  ViewController.swift
//  TestSwift3
//
//  Created by Jeffrey Garcia on 9/1/16.
//  Copyright © 2016 Jeffrey Garcia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print("\(NSStringFromClass(object_getClass(self))) - viewDidLoad")
        
        //print(testCasting1())
        //print(testCasting2())
        //print(testCasting3())
        //print(testCasting4())
        //testThreading1()
        //testThreading3()
        //testDataType1()
        //testDataType2()
        //testDataType3()
        //testDataType4()
        //testDataType5()
        //testAbstractDataType1()
        //testAbstractDataType3()
        //testAbstractDataType4()
        //testAbstractDataType5()
        //testDataTypeParsing()
        //testDataTypeParsing2()
        //testGuard(count: nil)
        //testTryCatch(count: nil)
        testCastDataType()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // ============================================================================= //
    
    public struct TestStruct {
        let string: String
        
        internal init(string: String) {
            self.string = string
        }
    }
    
    func testCastDataType() {
        let inputCount:Int? = 1500
        
        let test:TestStruct = TestStruct(string: String(describing: inputCount))
        
        // casting from String to Int like this will cause runtime error and the compiler cannot catch it
        // since the runtime will assume the value is non-optional and hit error when casting to optional value
        let count:Int = Int(test.string)! // crash in this line
        
        print("@@@ \(count)")
    }
    
    func testTryCatch(count:Int?) {
        do {
            try testGuard(count: nil)
        } catch {
            print(error.localizedDescription)
            return
        }
    }
    
    func testGuard(count:Int?) throws {
        // guard cannot protect from runtime type casting error
        guard
            count != nil // count should not be nil or otherwise goto the else block
        else {
            throw DataConversionError.NonOptionalUnwrappingError
        }
        let countDouble:Double = Double((count)!)
        print("success: \(countDouble))")
    }
    
    public enum DataConversionError: Error {
        case NonOptionalUnwrappingError
    }
    
    public enum TestDataType {
        case steps
        case sleep
        case caloriesBurned
        case weight
    }
    
    func testDataTypeParsing2() {
        var testDataTypeArray:[TestDataType] = []
        
        testDataTypeArray.append(TestDataType.steps)
        
        if !testDataTypeArray.contains(TestDataType.steps) {
            print("steps type not specify")
        } else {
            print("steps type specified")
        }
    }
    
    func testDataTypeParsing() {
        var testDataTypeDict:[String: TestDataType] = [:]
        
        testDataTypeDict["steps"] = TestDataType.steps
        
        print(testDataTypeDict["steps"])
        
        if (testDataTypeDict["weight"] == nil) {
            print("weight type not specify")
        }
        
        if (testDataTypeDict["steps"] == nil) {
            print("steps type not specify")
        }
    }
    
    func testAbstractDataType5() {
        var temp : [AnyObject]
        temp = [AnyObject]() //instantiate as an empty array
        
        if (temp is AnyObject) {
            print("running instance is AnyObject")
            temp = [NSNull]()
        }
        
        print("actual class - \(NSStringFromClass(object_getClass(temp)))")
    }
    
    func testAbstractDataType4() {
        var temp : AnyObject
        temp = NSString()
        temp = NSNull()
        
        if (temp is NSString) {
            print("running instance is NSString")
        }
        
        if (temp is NSNull) {
            print("running instance is NSNull")
        }
        
        print("actual class - \(NSStringFromClass(object_getClass(temp)))")
    }
    
    func testAbstractDataType3() {
        var temp : [String]! // temp is an array of type TestClassA and must not be nil
        //print(temp) //accessing temp here will trigger runtime exception
        
        temp = [String]() // now temp has been instantied, but is an empty array
        print(temp) //accessing temp here will be okay
        
        temp.append("test")
        print(temp)
    }
    
    func testAbstractDataType2() {
        var temp : [String]? // temp is an array of String, but its default is nil
        print(temp)
        
        /* if temp is set to optional, even if its nil,
         * accessing it will not trigger runtime error
         */
        temp?.append("test")
        print(temp?[0])
    }
    
    func testAbstractDataType1() {
        var temp : [String]! // default will be nil
        
        temp = ["A", "B", "C"]
        
        print(temp)
    }
    
    func testDataType5() {
        var temp2 : Int? // temp2 will default to nil
        
        /* To effectively prevent the runtime excepton when certain 
         * statement in the code attempt to force un-wrap temp2,
         * add the fail-safe handling to check for nil first
         */
        if (temp2 != nil) {
            print(temp2!)
        } else {
            print(NSNull())
        }
    }
    
    func testDataType4() {
        var temp1 : Int! = 0 // temp1 will default to 0 and assumed won't be nil in runtime
        
        /* suprisingly assigning nil to a non-optional value here would
         * not introduce compile-time error!!!
         */
        temp1 = nil
        
        /* To effectively prevent the runtime excepton,
         * add the fail-safe handling to check for nil 
         * first
         */
        if (temp1 == nil) {
            print(NSNull())
        } else {
            print(temp1)
        }
    }
    
    func testDataType3() {
        var temp1 : Int! = 0 // temp1 will default to 0 and assumed won't be nil in runtime
        
        /* suprisingly assigning nil to a non-optional value here would 
         * not introduce compile-time error!!!
         */
        temp1 = nil
        
        /* since the value is assumed non-optional, during runtime it will force
         * un-wrapping of temp1 but immediately throw runtime exception
         */
        print(temp1)
    }
    
    func testDataType2() {
        var temp2 : Int? // temp2 will default to nil
        
        /* suprisingly force un-wrapping of temp2 (which is nil) here
         * would not introduce compile-time error!!! 
         *
         * Instead a runtime exception will be thrown upon execution
         */
        print(temp2!)
    }
    
    func testDataType1() {
        var temp1 : Int! = 0 // temp1 will default to 0 and assumed won't be nil in runtime
        
        /* on a 32-bit platform, int is the same as int32
         * on a 64-bit platform, int is the same as int64
         */
        print(temp1)
    }
    
    func testThreading3() {
        DispatchQueue.main.async {
            print("in main thread? \(Thread.isMainThread)")
            Thread.main.setValue("MainThread", forKey: "name")
            print("current thread name: \(Thread.main.name!)")
        }
    }
    
    func testThreading2() {
        let queue = DispatchQueue(label: "com.test.myqueue")
        queue.async {
            print("in main thread? \(Thread.isMainThread)")
            print("current thread label: \(queue.label)")
            
            // if not in main thread, dispatch the work in main thread
            if !Thread.isMainThread {
                DispatchQueue.main.async {
                    print("in main thread? \(Thread.isMainThread)")
                    print("current queue label: \(queue.label)")
                }
            }
        }
    }
    
    func testThreading1() {
        for i in 1...10 {
            // just spawn a new thread
            let queue = DispatchQueue(label: "com.test.myqueue-\(i)")
            queue.async {
                print("in main thread? \(Thread.isMainThread)")
                print("current queue label: \(queue.label)")
            }
        }
    }
    
    func testCasting4() -> AnyObject {
        let temp1 = TestClassA(name: "testing")
        
        /* fail-safe handling to use as? for conditional
         * casting, this can avoid the run-time error (crash)
         * when down-casting an incompatible type
         */
        if let temp2 = temp1 as? NSString {
            return temp2
        } else {
            return NSNull()
        }
    }
    
    func testCasting3() -> String {
        let temp1 = "testing"
        let temp2 = temp1 as! AnyObject
        
        if temp2 is String {
            print("temp2 is String")
        }
        
        if temp2 is AnyObject {
            print("temp2 is AnyObject")
        }
        
        /* although the actual instance of temp2 is String, it has been
         * casted into AnyObject, therefore cannot match the return type
         * String unless casted back into String
         */
        return temp2 as! String
    }
    
    func testCasting2() -> AnyObject {
        let temp1 = "testing"
        let temp2 = temp1 as! NSObject
        
        /* since String is a primitive in Swift but not NSObject, in
         * order to match the return type AnyObject, should cast the
         * String into NSObject
         */
        return temp2
    }
    
    func testCasting1() -> [String:AnyObject] {
        let temp = TestClassA(name: "testing")
        
        if (temp is NSObject) {
            print ("temp is NSObject")
        }
        
        /* if TestClass is an abstract class, it can always match the
         * type AnyObject but NOT NSObject
         *
         * if TestClass inherits NSObject, it will also match the
         * type AnyObject
         */
        return ["1":temp, "2":temp, "3":temp]
    }

}

// abstract class does not automatically inherit NSObject, better to explicitly declare to inherit NSObject?
class TestClassA:NSObject {
    var mName: String
    init(name: String) {
        self.mName = name
    }
}
