//
//  WidgetDataManager.swift
//  YourRoutineApp
//
//  Created by 指原奈々 on 2025/04/23.
//

import Foundation
import UIKit
import SwiftData
import WidgetKit


class WidgetDataManager {
    static let shared = WidgetDataManager()
    
    let appGroupID = "group.com.nanasashihara.yourroutineapp"
    
    func saveImageToAppGroup(image: UIImage, fileName: String) -> Bool {
        guard let data = image.pngData() else { return false }
        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupID) else { return false }
        
        let defaults = UserDefaults(suiteName: appGroupID)
        let imageData = ImageData(fileName: "bath", category: .life, isPinned: false, timestamp: Date())
        if let encoded = try? JSONEncoder().encode(imageData) {
            defaults?.set(encoded, forKey: "pinnedImageData")
            print("📦 ImageData 保存成功")
            WidgetCenter.shared.reloadAllTimelines()
        }
        
        let fileURL = containerURL.appendingPathComponent(fileName)
        
        do {
            try data.write(to: fileURL)
            return true
        } catch {
            print("画像の保存に失敗: \(error)")
            return false
        }
    }
    
    func saveTodayDataWidgetToAppGroup(todayData: TodayData, modelContext: ModelContext) {
        let defaults = UserDefaults(suiteName: appGroupID)
        
        var routineTitles: [String] = []
        
        for title in todayData.routineTitles {
            routineTitles.append(title.name)
        }
        
        let widgetTodayData = WidgetTodayData(routineTitles: routineTitles, timestamp: Date())
        if let encoded = try? JSONEncoder().encode(widgetTodayData) {
            defaults?.set(encoded, forKey: "widgetTodayData")
            print("📦 widgetTodayData 保存成功")
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}
