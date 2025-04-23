//
//  RootView.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/04/17.
//

import SwiftUI
import SwiftData

@MainActor
struct RootView: View {
    @State private var isInitialized: Bool = false
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.modelContext) private var modelContext
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true
    var body: some View {
        Group {
//            VStack {
//                PrivacyView()
//                    .opacity(isFirstLaunch ? 1 : 0)
//                Button(action: {
//                    isFirstLaunch = false
//                }){
//                    Text("同意する")
//                        .frame(width: 50, height: 50)
//                }
//                .opacity(isFirstLaunch ? 1 : 0)
//            }
            
//            ImageCountView()
            
            if isInitialized {
                MainTabView()
            } else {
                SplashView()
                    .opacity(isFirstLaunch ? 0 : 1)
            }
            
        }
        .task {
//            AppStatusManager.isFirstLaunch = true
            ImageDataManager.shared.fetchImageData(modelContext: modelContext)
            TodayDataManager.shared.getTodayData(modelContext: modelContext, completion: { (result) in
                WidgetDataManager.shared.saveTodayDataWidgetToAppGroup(todayData:result , modelContext: modelContext)
            })
            await initializeApp()
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .active {
                Task {
                    await checkAndCreateTodayDataIfNeeded()
                }
            } else if newPhase == .inactive {
                saveLastLoadedDate()
            }
        }
    }
    
    func initializeApp() async {
        do {
//            await fetchTodayData()
//            await fetchImageData()
        } catch {
            print(error)
        }
        //初期化処理
        isInitialized = true
    }
    
    func saveLastLoadedDate() {
        let today = Calendar.current.startOfDay(for: Date())
        TodayDataManager.shared.lastLoadedDate = today
    }

    
    func checkAndCreateTodayDataIfNeeded() async {
        let today = Calendar.current.startOfDay(for: Date())
        let lastDate = TodayDataManager.shared.lastLoadedDate // 保存しておく

        if today != lastDate {
            await TodayDataManager.shared.createTodayData(modelContext: modelContext)
        }
    }
    
    /// Debug用
    func printTodayData(todayData: TodayData) {
        #if DEBUG
        print("今日のデータ: \(todayData.timestamp.formatted())")
        print("今日のデータのroutineTitles一覧")
        for title in todayData.routineTitles {
            print("\(title.name)")
            for routine in title.routines {
                print("\(routine.name):done: \(routine.done)")
            }
        }
        #endif
    }
}

#Preview {
    RootView()
}
