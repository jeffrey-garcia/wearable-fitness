//
//  ViewController.swift
//  TestHealthKit
//
//  Created by Jeffrey Garcia on 9/9/16.
//  Copyright © 2016 Jeffrey Garcia. All rights reserved.
//

import UIKit

import HealthKit

public enum HealthKitServiceError: Error {
    case healthDataUnavailable
    case permissionDenied
    case unexpectedError
    case errorCaluclatingQuery
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("\(NSStringFromClass(object_getClass(self))) - viewDidLoad")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("\(NSStringFromClass(object_getClass(self))) - viewDidAppear")
        
        self.requestHealthKitPermission {
            success, error in
            print("HealthKit request permission result: \(success)");
            
            if !(error != nil) {
                print("Error: \(error)")
            }
            
            self.writeData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func requestHealthKitPermission(completion: @escaping (Bool, Error?) -> Void)  {
        let healthKitStore:HKHealthStore = HKHealthStore()
        
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, HealthKitServiceError.permissionDenied)
            return
        }
        
        let typesToRead: [HKObjectType] = [
            HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!,
            HKObjectType.characteristicType(forIdentifier: .bloodType)!,
            HKObjectType.quantityType(forIdentifier: .bodyMass)!,
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!,
            HKQuantityType.workoutType(),
            HKObjectType.activitySummaryType(),
            ]
        
        let typesToWrite: [HKSampleType] = [
            HKObjectType.quantityType(forIdentifier: .bodyMass)!,
            HKObjectType.quantityType(forIdentifier: .bodyMassIndex)!,
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!,
            HKQuantityType.workoutType(),
            ]
        
        healthKitStore.requestAuthorization(toShare: Set(typesToWrite), read: Set(typesToRead)) {
            success, error in
            completion(success, error)
        }
    }
    
    func writeData() {
        let finish = Date() // Now
        let start = finish.addingTimeInterval(-3600) // 1 hour ago
        
        // 1,000 kilojoules
        let totalEnergyBurned = HKQuantity(unit: HKUnit.jouleUnit(with: .kilo), doubleValue: 1000)
        
        // 3 KM distance
        let totalDistance = HKQuantity(unit: HKUnit.meter(), doubleValue: 3000)
        
        let workout = HKWorkout(
            activityType: .running,
            start: start,
            end: finish,
            workoutEvents: nil,
            totalEnergyBurned: totalEnergyBurned,
            totalDistance: totalDistance,
            device: nil,
            metadata: nil
        )
        
        let healthKitStore:HKHealthStore = HKHealthStore()
        healthKitStore.save(workout) {
            success, error in
            print("HealthKit save data result: \(success)");
            if !(error != nil) {
                print("Error: \(error)")
            }
        }
    }
}

