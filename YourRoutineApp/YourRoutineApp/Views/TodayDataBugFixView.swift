//
//  TodayDataBugFixView.swift
//  YourRoutineApp
//
//  Created by 指原奈々 on 2025/05/01.
//

import SwiftUI
import SwiftData

struct TodayDataBugFixView: View {
    @Query private var todayDatas: [TodayData]
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        List {
            ForEach(todayDatas){ todayData in
                Section(header: Text("\(todayData.timestamp.formattedMonthDayString_JP)")) {
                    ForEach(todayData.routineTitles){ title in
                        ForEach(title.routines){ routine in
                            Text("\(routine.name)")
                        }
                        
                    }
                }
            }
        }
    }
}

#Preview {
    TodayDataBugFixView()
        .modelContainer(for: TodayData.self)
}
