//
//  SystemStatusWidget.swift
//  Loop
//
//  Created by Noah Brauner on 8/15/22.
//  Copyright © 2022 LoopKit Authors. All rights reserved.
//

import LoopUI
import SwiftUI
import WidgetKit

struct SystemStatusWidgetEntryView : View {
    
    @Environment(\.widgetFamily) private var widgetFamily
    
    var entry: StatusWidgetTimelineProvider.Entry

    var body: some View {
        HStack(alignment: .center, spacing: 5) {
            VStack(alignment: .center, spacing: 5) {
                HStack(alignment: .center, spacing: 15) {
                    LoopCircleView(entry: entry)
                    
                    GlucoseView(entry: entry)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .padding(5)
                .background(
                    ContainerRelativeShape()
                        .fill(Color("WidgetSecondaryBackground"))
                )
                
                PumpView(entry: entry)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .padding(5)
                    .background(
                        ContainerRelativeShape()
                            .fill(Color("WidgetSecondaryBackground"))
                    )
            }
            
            if widgetFamily == .systemMedium {
                VStack(alignment: .center, spacing: 5) {
                    HStack(alignment: .center, spacing: 5) {
                        SystemStatusActionView(for: .carbEntry)
                        
                        SystemStatusActionView(for: .bolus)
                    }
                    
                    HStack(alignment: .center, spacing: 5) {
                        if entry.preMealPresetAllowed {
                            SystemStatusActionView(for: .preMeal, active: entry.preMealPresetActive)
                        }
                        
                        SystemStatusActionView(for: .customPreset, active: entry.customPresetActive)
                    }
                }
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
        }
        .foregroundColor(entry.contextIsStale ? Color(UIColor.systemGray3) : nil)
        .padding(5)
        .widgetBackground()
    }
}

struct SystemStatusWidget: Widget {
    let kind: String = "SystemStatusWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: StatusWidgetTimelineProvider()) { entry in
            SystemStatusWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Loop Status Widget")
        .description("See your current blood glucose and insulin delivery.")
        .supportedFamilies([.systemSmall, .systemMedium])
        .contentMarginsDisabledIfAvailable()
    }
}
