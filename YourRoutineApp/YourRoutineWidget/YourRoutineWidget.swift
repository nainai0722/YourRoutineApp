//
//  YourRoutineWidget.swift
//  YourRoutineWidget
//
//  Created by 指原奈々 on 2025/04/19.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        let imageData = fetchPinnedImageData()
        let widgetTodayData = fetchWidgetTodayData()
        return SimpleEntry(date: Date(), imageData: imageData, widgetTodayData: widgetTodayData,configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        let imageData = fetchPinnedImageData()
        let widgetTodayData = fetchWidgetTodayData()
        return SimpleEntry(date: Date(), imageData: imageData, widgetTodayData: widgetTodayData, configuration: configuration)
    }

    
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let imageData = fetchPinnedImageData()
            let widgetTodayData = fetchWidgetTodayData()
            let entry = SimpleEntry(date: entryDate, imageData: imageData, widgetTodayData: widgetTodayData, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
    let appGroupID = "group.com.nanasashihara.yourroutineapp"
    func fetchPinnedImageData() -> ImageData? {
        let defaults = UserDefaults(suiteName: appGroupID)
        guard let data = defaults?.data(forKey: "pinnedImageData"),
              let decoded = try? JSONDecoder().decode(ImageData.self, from: data) else {
            print("何も取れなかった・・・・")
            return nil
        }
        print("decodeできた！")
        return decoded
    }
    func fetchWidgetTodayData() -> WidgetTodayData? {
        let defaults = UserDefaults(suiteName: appGroupID)
        guard let data = defaults?.data(forKey: "widgetTodayData"),
              let decoded = try? JSONDecoder().decode(WidgetTodayData.self, from: data) else {
            print("何も取れなかった・・・・")
            return nil
        }
        print("decodeできた！")
        return decoded
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let imageData: ImageData?
    let widgetTodayData: WidgetTodayData?
    let configuration: ConfigurationAppIntent
}

struct YourRoutineWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Time:")
            Text(entry.date, style: .time)

            Text("Favorite Emoji:")
            Text(entry.configuration.favoriteEmoji)
        
            if let fileName = entry.imageData?.fileName,
               let image = loadImageFromAppGroup(fileName: fileName) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                Text("したくアイコンなし")
            }
            if let todayTitles: [String] = entry.widgetTodayData?.routineTitles {
                let _ = print("\(todayTitles.count) 件)")
                Text("\(todayTitles.count) 件)")
                ForEach(todayTitles, id:\.self) { title in
                    Text(title)
                }
            }
        }
    }
    
    let appGroupID = "group.com.nanasashihara.yourroutineapp"
//    func loadImageFromAppGroup(fileName: String) -> UIImage? {
//        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupID) else { return nil }
//
//        let fileURL = containerURL.appendingPathComponent(fileName)
//
//        return UIImage(contentsOfFile: fileURL.path)
//    }
    func loadImageFromAppGroup(fileName: String) -> UIImage? {
        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupID) else {
            print("❌ AppGroup URL が見つからない")
            return nil
        }
        
        let fileURL = containerURL.appendingPathComponent(fileName)
        print("🔍 読み込もうとしているファイル: \(fileURL.path)")

        if FileManager.default.fileExists(atPath: fileURL.path) {
            print("✅ ファイル見つかった")
        } else {
            print("❌ ファイルが存在しない")
        }

        return UIImage(contentsOfFile: fileURL.path)
    }

}

struct YourRoutineWidget: Widget {
    let kind: String = "YourRoutineWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            YourRoutineWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemSmall) {
    YourRoutineWidget()
} timeline: {
    SimpleEntry(date: .now, imageData: nil, widgetTodayData: nil, configuration: .smiley)
    SimpleEntry(date: .now, imageData: nil, widgetTodayData: nil, configuration: .starEyes)
}
