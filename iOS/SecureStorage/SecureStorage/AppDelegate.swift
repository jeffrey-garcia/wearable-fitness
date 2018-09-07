//
//  AppDelegate.swift
//  SecureStorage
//
//  Created by jeffrey on 20/6/2018.
//  Copyright © 2018 jeffrey. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

import Reachability

import SalesforceSDKCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    let reachability = Reachability()!
    
    var window: UIWindow?

    var logger:SFLogger?
    
    func registerReachabilityObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged(_:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    func requestPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {
            (accepted, error) in
            if !accepted {
                print("Notification access denied.")
            }
        }
        UNUserNotificationCenter.current().delegate = self
    }
    
    // for displaying notification when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
    // for handling tap and user actions
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        switch response.actionIdentifier {
        case "action1":
            print("Action First Tapped")
        case "action2":
            print("Action Second Tapped")
        default:
            break
        }
        
        completionHandler()
    }
    
    // for handling reachability changed event
    func reachabilityChanged(_ note:Notification) {
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
            case .wifi:
                print("Reachable via WiFi")
            case .cellular:
                print("Reachable via Cellular")
            case .none:
                print("Network not reachable")
        }
    }
    
    func configureLogger() {
        self.logger = SFLogger.shared()
        self.logger?.logLevel = SFLogLevel.all
        self.logger?.shouldLogToFile = true
        self.logger?.info("testing abc")
    }
    
    func configureOfflineManager() {
        // to instantiate Core OfflineManager
//        let offlineMgr = OfflineManager.shared()
//        print("@@@ offline maanger: \(type(of: offlineMgr))")
//        print("@@@ logging manager: \(offlineMgr.loggingManager)")
//        print("@@@ secure storage: \(offlineMgr.secureStorage)")
        
        // to instantiate Local CmpOfflineManager
        let cmpOfflineMgr = CmpOfflineManager.shared()
        print("@@@ offline maanger: \(type(of: cmpOfflineMgr))")
        print("@@@ logging manager: \(cmpOfflineMgr.loggingManager)")
        print("@@@ secure storage: \(cmpOfflineMgr.secureStorage)")
        cmpOfflineMgr.secureStorage.putRequestToBuffer()
        (cmpOfflineMgr.secureStorage as? CmpSecureStorage)?.doSomething()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.configureLogger()
        
        self.logger?.info("\(NSStringFromClass(object_getClass(self)!)) - didFinishLaunchingWithOptions")
        
        let window: UIWindow = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
        let viewController = ViewController(nibName: "ViewController", bundle: Bundle.main)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.setNavigationBarHidden(true, animated: false)
        
        self.window!.rootViewController = navigationController
        
        self.window!.backgroundColor = UIColor(white: 0.7, alpha: 1.0)
        self.window!.makeKeyAndVisible()
        
        self.requestPermissions()
        
        self.registerReachabilityObserver()
        
        self.configureOfflineManager()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.cocoacasts.PersistentStores" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = NSPersistentStoreCoordinator.init(managedObjectModel: self.setupCoreDataModel())
        
        // setup persistent store coordinator
        let storeUrl = self.applicationDocumentsDirectory.appendingPathComponent("DTCachedFile.sqllite")
        
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeUrl, options: nil)
            let context = NSManagedObjectContext.init(concurrencyType: .privateQueueConcurrencyType)
            context.persistentStoreCoordinator = coordinator
            return context
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }()
    
    private func setupCoreDataModel() -> NSManagedObjectModel {
        var properties = [NSAttributeDescription]()
        
        let some_key = NSAttributeDescription()
        some_key.name = "some_key"
        some_key.attributeType = .stringAttributeType
        some_key.isOptional = false
        properties.append(some_key)
        
        let some_value = NSAttributeDescription()
        some_value.name = "some_value"
        some_value.attributeType = .stringAttributeType
        some_value.isOptional = false
        properties.append(some_value)
        
        let entity = NSEntityDescription()
        entity.name = "DTCachedFile"
        entity.managedObjectClassName = "DTCachedFile"
        entity.properties = properties
        
        let model = NSManagedObjectModel()
        model.entities = [entity]
        
        return model
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "SecureStorage")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        
        if self.managedObjectContext.hasChanges {
            do {
                try self.managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

