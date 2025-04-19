//
//  RoutineView.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/21.
//

import SwiftUI
import SwiftData

struct RoutineView: View {
    @State var routineTitle:RoutineTitleTemplate
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(routineTitle.routines) { routine in
                        NavigationLink {
                            EditRoutineView(
                                routine: routine, routineTitleId: routineTitle.id
                            )
                        } label: {
                            Text(routine.name)
                        }
                    }
                    
                    NavigationLink {
                        EditRoutineView(routineTitleId:routineTitle.id )
                    } label: {
                        Text("新しいしたくを追加する")
                    }
                }
            }
        }
        .navigationTitle(Text(routineTitle.name))
    }
}

#Preview {
    RoutineView(routineTitle: RoutineTitleTemplate(name: "プレビュー"))
        .modelContainer(for: [RoutineTitleTemplate.self, RoutineTemplateItem.self])
}
