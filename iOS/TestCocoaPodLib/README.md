# TestLib - a sample cocoapod-based project with local pod library mixing Swift and Objective-C
This is an cocoapod-based project which references a local development pod that supports both Objective-c and Swift3.3.

The sample project has been verified on Xcode 9.3

### Development Tooling
- CocoaPods : 1.2.1
- Ruby : ruby 2.3.4p301 (2017-03-30 revision 58214) [x86_64-darwin16]
- RubyGems : 2.5.2
- Host : Mac OS X 10.13.3 (17D102)
- Xcode : 9.3 (9E145)
- Git : git version 2.15.1 (Apple Git-101)
- Bundler : 1.15.1

### Steps to create a cocoa-based project mixing both Swift and Objective-C code
1. pod lib create XXX 
2. choose iOS as the platform
3, choose ObjC as the language
4. choose Yes to include a demo application
5. choose None for test framework
6. choose No for a view based testing
7. Type My for the class prefix
8. Replace all Objective-C classes with Swift classes in the Example project
9. Add new swift class (AppDelegate.swift and ViewController.swift) and Xcode will automatically prompt for the creation of the Bridging Header file
10. Create the Objective-C .h and .m class in the local development pod
11. Create the Swift class in the local development pod
12. run pod install command to re-generate the project
13. to use the local pod from the Swift classes in the sample project, make sure to import XXX where XXX is the Pod library name
14. to use the Swift class in the local development pod from another Objective-C class, make sure to #import <XXX/XXX-Swift.h>
15. to use the Objective-C class in the local development pod from another Swift class, simply use Swift syntax to reference the class or construct the object of the Objective-C class 
