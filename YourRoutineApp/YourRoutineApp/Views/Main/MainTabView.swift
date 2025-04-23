//
//  SwiftUIView.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/04.
//

import SwiftUI
import SwiftData

enum TutorialStep {
    case none
    case step1_highlightShitakuButton
    case step2_showSettingsHint
}


struct MainTabView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var selectedTab = 1
    @State private var isAnimated: Bool = true
    @State private var tutorialStep: TutorialStep = .step1_highlightShitakuButton

    var body: some View {
//        #if DEBUG
//        Button("明日分を強制作成") {
//            Task {
//                let yesterday = Calendar.current.date(byAdding: .day, value: +1, to: Date())!
//                await TodayDataManager.shared.forceCheckAndCreate(for: yesterday, context: modelContext)
//            }
//        }
//        #endif
        ZStack {
            TabView {
                DoneRoutineView()
                    .tabItem {
                        Label("おしたく", systemImage: "books.vertical")
                    }
                    .tag(1)
                RoutineCalendarView(isPopover: false, isPresented: false)
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
            
            if AppStatusManager.isHintShown {
                TimedBackgroundView()
                TimedTextView(message: "①おしたくタブを選んで↓")
                    .offset(x:-100, y: 250)
            
                TimedTextView(message: "②したくをえらぶボタンを押そう↑")
                    .offset(x:0, y: -200)
            }
        }
    }
}

import SwiftUI

struct TimedBackgroundView: View {
    @State private var showBackground = true
    var body: some View {
        ZStack {
            if showBackground {
                Color.black.opacity(0.3)
                    .ignoresSafeArea() // 全画面に広げる
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.5), value: showBackground)
                    .onAppear {
                        // 3秒後に非表示にする
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                showBackground = false
                            }
                        }
                    }
            }
        }
    }
    
}

struct TimedTextView: View {
    @State private var showText = true
    let message: String
    var body: some View {
        ZStack {
            if showText {
                Text(message)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 4)
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.5), value: showText)
                    .onAppear {
                        // 3秒後に非表示にする
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                showText = false
                            }
                        }
                    }
            }
        }
    }
}


#Preview {
    MainTabView()
        .modelContainer(for: [
            UserInfo.self,
            TodayData.self,
            Routine.self,
            RoutineTitle.self
        ])
}

