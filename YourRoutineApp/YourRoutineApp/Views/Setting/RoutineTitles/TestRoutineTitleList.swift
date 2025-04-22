//
//  TestRoutineTitleList.swift
//  YourRoutineApp
//
//  Created by 指原奈々 on 2025/04/22.
//

import SwiftUI
import SwiftData

struct TestRoutineTitleList: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var routineTitles: [RoutineTitleTemplate]
    var body: some View {
        List {
            ForEach(routineTitles) { title in
                Text(title.name)
            }
        }
        .onAppear {
            print("テンプレート数")
            print(routineTitles.count)
        }
    }
}

#Preview {
    TestRoutineTitleList()
        .modelContainer(for: [
            TodayData.self,
            RoutineTitle.self,
            RoutineTitleTemplate.self
            
        ])
}
