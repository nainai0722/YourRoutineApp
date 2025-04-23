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
final class WidgetTodayData: Codable {
    @Attribute(.unique) var id: UUID = UUID()
    var routineTitles: [String]
    var timestamp: Date = Date()
    
    init(routineTitles: [String], timestamp: Date) {
        self.routineTitles = routineTitles
        self.timestamp = timestamp
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case routineTitles
        case timestamp
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        routineTitles = try container.decode([String].self, forKey: .routineTitles)
        timestamp = try container.decode(Date.self, forKey: .timestamp)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(routineTitles, forKey: .routineTitles)
        try container.encode(timestamp, forKey: .timestamp)
    }
}
