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
            
            if isInitialized {
                MainTabView()
            } else {
                SplashView()
                    .opacity(isFirstLaunch ? 0 : 1)
            }
            
        }
        .task {
//            AppStatusManager.isFirstLaunch = true
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
            await fetchImageData()
        } catch {
            print(error)
        }
        //初期化処理
        
        
        isInitialized = true
    }
    
    func fetchImageData() async {
        do {
            let allImageData = try modelContext.fetch(FetchDescriptor<ImageData>())
            
            let defaultsData = allImageData.filter({$0.category == .defaults})
            if defaultsData.isEmpty {
                for i in 1...22 {
                    let imageData = ImageData(fileName: "default_image\(i)", category: .defaults, isPinned: true, timestamp: Date())
                    modelContext.insert(imageData)
                }
            }
            
            // データが格納されているとき早期リターン
            if !allImageData.isEmpty {
                return
            }
            
            // すべてのデータを投入する
            for i in 1...70 {
                let imageData = ImageData(fileName: "food-drink_image\(i)", category: .foodDrink, isPinned: false, timestamp: Date())
                modelContext.insert(imageData)
            }
            for i in 1...70 {
                let imageData = ImageData(fileName: "event_image\(i)", category: .event, isPinned: false, timestamp: Date())
                modelContext.insert(imageData)
            }
            for i in 1...88 {
                let imageData = ImageData(fileName: "school_image\(i)", category: .school, isPinned: false, timestamp: Date())
                modelContext.insert(imageData)
            }
            for i in 1...88 {
                let imageData = ImageData(fileName: "life_image\(i)", category: .life, isPinned: false, timestamp: Date())
                modelContext.insert(imageData)
            }
            
//            for i in 1...22 {
//                let imageData = ImageData(fileName: "default_image\(i)", category: .defaults, isPinned: true, timestamp: Date())
//                modelContext.insert(imageData)
//            }
            // データベースに保存
            try modelContext.save()
            
            #if DEBUG
            let allImageData2 = try modelContext.fetch(FetchDescriptor<ImageData>())
            print("画像データの数 : \(allImageData2.count)")
            for data in allImageData2 {
                print("fetchImageData: \(data.fileName)")
            }
            #endif
            
        } catch {
            print(error)
        }
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
