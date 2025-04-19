//
//  ImageData.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/04/18.
//

import Foundation
import SwiftData

//public enum ImageCategory: String, CaseIterable, Codable {
//    case foodDrink = "food-drink"
//    case life = "life"
//    case school = "school"
//}
//
//@Model
//public final class ImageData: Identifiable, Codable {
//    @Attribute(.unique)
//    public var id: UUID = UUID()
//    public var fileName: String
//    public var category: ImageCategory
//    public var isPinned: Bool
//    public var timestamp: Date
//    
//    public init(fileName: String, category: ImageCategory, isPinned: Bool, timestamp: Date) {
//        self.fileName = fileName
//        self.category = category
//        self.isPinned = isPinned
//        self.timestamp = timestamp
//    }
//}
import Foundation
import SwiftData

public enum ImageCategory: String, CaseIterable, Codable {
    case foodDrink = "food-drink"
    case life = "life"
    case school = "school"
}

@Model
public final class ImageData: Identifiable, Codable {
    @Attribute(.unique)
    public var id: UUID = UUID()
    public var fileName: String
    public var category: ImageCategory
    public var isPinned: Bool
    public var timestamp: Date

    public init(fileName: String, category: ImageCategory, isPinned: Bool, timestamp: Date) {
        self.fileName = fileName
        self.category = category
        self.isPinned = isPinned
        self.timestamp = timestamp
    }

    // MARK: - Codable conformance

    enum CodingKeys: String, CodingKey {
        case id, fileName, category, isPinned, timestamp
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        fileName = try container.decode(String.self, forKey: .fileName)
        category = try container.decode(ImageCategory.self, forKey: .category)
        isPinned = try container.decode(Bool.self, forKey: .isPinned)
        timestamp = try container.decode(Date.self, forKey: .timestamp)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(fileName, forKey: .fileName)
        try container.encode(category, forKey: .category)
        try container.encode(isPinned, forKey: .isPinned)
        try container.encode(timestamp, forKey: .timestamp)
    }
}
