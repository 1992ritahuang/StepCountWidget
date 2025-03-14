//
//  StepCountViewModel.swift
//  stepCount
//
//  Created by Rita Huang on 2025/3/14.
//

import UIKit
import Combine

class StepCountViewModel: ObservableObject {
    @Published var stepCount = 0
    private var healthKitManager = HealthKitManager()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        healthKitManager.$stepCount
            .receive(on: DispatchQueue.main)
            .sink { newValue in             //.assign(to: \.stepCount, on: self)
                self.stepCount = newValue
            }
            .store(in: &cancellables)  //for memory leak
    }
}
