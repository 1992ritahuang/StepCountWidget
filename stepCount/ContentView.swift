//
//  ContentView.swift
//  stepCount
//
//  Created by Rita Huang on 2025/3/14.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = StepCountViewModel()
    
    var body: some View {
        VStack {
            Text("\(viewModel.getDate())")
                .font(.title)
            Text("\(viewModel.stepCount) 步")
                .font(.largeTitle)
                .bold()
            Button("update") {
                viewModel.healthKitManager.fetchStepCount()
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
