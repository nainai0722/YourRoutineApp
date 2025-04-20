//
//  RoutineTitle.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/20.
//

import Foundation
import SwiftData

@Model
final class RoutineTitle: Identifiable {
    @Attribute(.unique) var id: UUID
    var templateTitleId: UUID?
    var name: String
    @Relationship var routines: [Routine]
    @Relationship(inverse: \TodayData.routineTitles)
    var todayData: TodayData?
    var done: Bool
    
    init(id: UUID = UUID(), name: String, routines: [Routine], done: Bool) {
        self.id = id
        self.name = name
        self.routines = routines
        self.done = done
    }
    
    init(name: String) {
        self.id = UUID()
        self.name = name
        self.done = false
        self.routines = Routine.mockThreeRoutines
    }
    
    init(name: String, routines: [Routine]) {
        self.name = name
        self.id = UUID()
        self.done = false
        self.routines = routines
    }
    
    init(templateTitleId: UUID?, name: String, routines: [Routine]) {
        self.templateTitleId = templateTitleId
        self.name = name
        self.id = UUID()
        self.done = false
        self.routines = routines
    }
}


