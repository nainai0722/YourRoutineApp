//
//  CommonMethod.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/04/19.
//

import Foundation
import SwiftData

func convertTemplateToRoutine(_ template: RoutineTitleTemplate) -> RoutineTitle {
    let convertedRoutines = template.routines.map { item in
        Routine(id: item.id, name: item.name, done: false, imageName: item.imageName)
        
    }
    return RoutineTitle(name: template.name, routines: convertedRoutines)
}

// DateComponents → Date へ変換する関数
func dateComponentsToDate(_ dateComponents: DateComponents) -> Date? {
    let calendar = Calendar.current
    return calendar.date(from: dateComponents)
}
