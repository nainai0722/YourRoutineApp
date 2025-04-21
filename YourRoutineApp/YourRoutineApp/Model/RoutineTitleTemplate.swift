//
//  RoutineTitleTemplate.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/20.
//

import Foundation
import SwiftData

@Model
final class RoutineTitleTemplate: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    var name: String
    @Relationship var routines: [RoutineTemplateItem] = []
    var done: Bool
    
    init(name: String, routines: [RoutineTemplateItem], done: Bool) {
        self.name = name
        self.routines = routines
        self.done = done
    }
    
    init(name: String) {
        self.name = name
        self.done = false
        self.routines = RoutineTemplateItem.mockThreeRoutines
    }
    init(name: String, routines: [RoutineTemplateItem]) {
        self.name = name
        self.done = false
        self.routines = routines
    }
}


struct RoutineTitleTemplateCodable: Codable {
    var id: UUID
    var name: String
    var done: Bool
    init(id: UUID, name: String, done: Bool) {
        self.id = id
        self.name = name
        self.done = done
    }
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.done = try container.decode(Bool.self, forKey: .done)
    }
}
