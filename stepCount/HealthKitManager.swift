//
//  HealthKitManager.swift
//  stepCount
//
//  Created by Rita Huang on 2025/3/14.
//

import UIKit
import HealthKit

public class HealthKitManager: ObservableObject {
    private let healthStore = HKHealthStore()
    @Published var stepCount = 0
    
    public init() {
        requestAuthorization()
    }

    private func requestAuthorization() {
        guard HKHealthStore.isHealthDataAvailable(),
              let stepType = HKObjectType.quantityType(forIdentifier: .stepCount) else { return }
        
        healthStore.requestAuthorization(toShare: [], read: [stepType]) { success, error in
            if success {
                self.fetchStepCount()
            } else {
                print("HealthKit error：\(error?.localizedDescription ?? "unknown")")
            }
        }
    }
    
    public func fetchStepCount() {
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
        let startOfDay = Calendar.current.startOfDay(for: Date())
        
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            DispatchQueue.main.async {
                if let sum = result?.sumQuantity() {
                    self.stepCount = Int(sum.doubleValue(for: HKUnit.count()))
                }
            }
        }
        
        healthStore.execute(query)
    }
}
