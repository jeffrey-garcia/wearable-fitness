//
//  ViewController.swift
//  TestCocoaPodLib_Example
//
//  Created by jeffrey on 8/5/2018.
//  Copyright © 2018 jeffrey.garcia@gmail.com. All rights reserved.
//
import UIKit

import TestCocoaPodLib

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("\(NSStringFromClass(object_getClass(self))) - viewDidLoad")
        
        let testObjc = TestObjc()
        testObjc.test()

        let testSwift = TestSwift()
        testSwift.test()
        
        let testSwift2 = TestSwift2()
        testSwift2.test()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
