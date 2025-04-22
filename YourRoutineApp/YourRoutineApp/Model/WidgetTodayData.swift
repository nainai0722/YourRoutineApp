//
//  WidgetTodayData.swift
//  YourRoutineApp
//
//  Created by 指原奈々 on 2025/04/22.
//

import Foundation
import SwiftData

// Widgetに渡すためだけのModel
// 今日のタスクを文言で渡す
@Model
final class WidgetTodayData {
    @Attribute(.unique) var id: UUID = UUID()
    var routineTitles: [String:[String]]
    var timestamp: Date = Date()
    
    init(routineTitles: [String:[String]], timestamp: Date) {
        self.routineTitles = routineTitles
        self.timestamp = timestamp
    }
}
