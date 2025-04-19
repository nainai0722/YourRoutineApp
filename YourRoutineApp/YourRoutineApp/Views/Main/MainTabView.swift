//
//  SwiftUIView.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/04.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var moneys: [Money]
    @State private var selectedTab = 1  // 初期タブのインデックスを設定
    var body: some View {
        TabView {
            DoneRoutineView()
                .tabItem {
                    Label("おしたく", systemImage: "books.vertical")
                }
                .tag(1)
            RoutineCalendarView()
                .tabItem {
                    Label("カレンダー", systemImage: "calendar")
                }
                .tag(2)
            KindergartenCalendarView()
                .tabItem {
                    Label("ようちえん", systemImage: "figure.and.child.holdinghands")
                }
                .tag(3)
            SettingView()
                .tabItem {
                    Label("設定", systemImage: "gearshape")
                }
            
        }
    }
}

#Preview {
    MainTabView()
        .modelContainer(for: [
            Money.self,
            UserInfo.self,
            TodayData.self,
            Routine.self,
            RoutineTitle.self
        ])
}

