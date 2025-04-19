//
//  YourRoutineWidgetLiveActivity.swift
//  YourRoutineWidget
//
//  Created by 指原奈々 on 2025/04/19.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct YourRoutineWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct YourRoutineWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: YourRoutineWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension YourRoutineWidgetAttributes {
    fileprivate static var preview: YourRoutineWidgetAttributes {
        YourRoutineWidgetAttributes(name: "World")
    }
}

extension YourRoutineWidgetAttributes.ContentState {
    fileprivate static var smiley: YourRoutineWidgetAttributes.ContentState {
        YourRoutineWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: YourRoutineWidgetAttributes.ContentState {
         YourRoutineWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: YourRoutineWidgetAttributes.preview) {
   YourRoutineWidgetLiveActivity()
} contentStates: {
    YourRoutineWidgetAttributes.ContentState.smiley
    YourRoutineWidgetAttributes.ContentState.starEyes
}
