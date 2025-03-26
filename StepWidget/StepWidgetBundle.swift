//
//  StepWidgetBundle.swift
//  StepWidget
//
//  Created by Rita Huang on 2025/3/14.
//

import WidgetKit
import SwiftUI

@main
struct StepWidgetBundle: WidgetBundle {
    var body: some Widget {
        StepWidget()
        StepWidgetControl()
        StepWidgetLiveActivity()
    }
}
