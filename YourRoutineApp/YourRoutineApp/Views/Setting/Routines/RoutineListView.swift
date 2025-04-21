//
//  RoutineListView.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/21.
//

import SwiftUI
import SwiftData

@MainActor
struct RoutineListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var routineTitles: [RoutineTitleTemplate]
    let title: String
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(routineTitles, id: \.id) { routineTitle in
                        NavigationLink {
                            RoutineView(routineTitle: routineTitle)
                        } label: {
                            Text(routineTitle.name)
                        }
                    }
                }
            }
        }
        .navigationTitle(title)
        .onAppear() {
            AppStatusManager.isHintShown = false
        }
    }
}

#Preview {
    RoutineListView(title: "")
        .modelContainer(for: RoutineTitleTemplate.self)
}
