//
//  StepWidget.swift
//  StepWidget
//
//  Created by Rita Huang on 2025/3/14.
//

import WidgetKit
import SwiftUI

struct StepEntry: TimelineEntry {
    let date: Date
    let stepCount: Int
}

struct Provider: TimelineProvider {
    let healthKitManager = HealthKitManager()
    
    func placeholder(in context: Context) -> StepEntry {
        StepEntry(date: Date(), stepCount: 0)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (StepEntry) -> Void) {
        let entry = StepEntry(date: Date(), stepCount: healthKitManager.stepCount)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<StepEntry>) -> Void) {
        healthKitManager.fetchStepCount()
        let entry = StepEntry(date: Date(), stepCount: healthKitManager.stepCount)
        
        let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(60 * 15))) // 每15分鐘更新一次
        completion(timeline)
    }
}

struct StepWidgetEntryView : View {
    var entry: Provider.Entry

        var body: some View {
            VStack {
                Text("今日步數")
                    .font(.headline)
                Text("\(entry.stepCount)")
                    .font(.title)
                    .bold()
            }
            .padding()
            .containerBackground(.black.gradient, for: .widget)
        }
}

struct StepWidget: Widget {
    let kind: String = "StepWidget"

        var body: some WidgetConfiguration {
            StaticConfiguration(kind: kind, provider: Provider()) { entry in
                StepWidgetEntryView(entry: entry)
            }
            .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
        }
}

struct StepWidget_Previews: PreviewProvider {
    static var previews: some View {
        StepWidgetEntryView(entry: StepEntry(date: Date(), stepCount: 3000))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
