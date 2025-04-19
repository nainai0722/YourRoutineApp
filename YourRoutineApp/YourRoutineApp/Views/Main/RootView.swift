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
    @Environment(\.modelContext) private var modelContext
    var body: some View {
        Group {
            if isInitialized {
                MainTabView()
            } else {
                SplashView()
            }
        }
        .task {
            await initializeApp()
        }
    }
    
    func initializeApp() async {
        do {
            await fetchTodayData()
            await fetchImageData()
//            try await Task.sleep(nanoseconds: 1_000_000_000)
        } catch {
            print(error)
        }
        //初期化処理
        
        
        isInitialized = true
    }
    
    func fetchImageData() async {
        do {
            let allImageData = try modelContext.fetch(FetchDescriptor<ImageData>())
            // データが格納されているとき早期リターン
            if !allImageData.isEmpty {
                return
            }
            // すべてのデータを投入する
            for i in 1...70 {
                let imageData = ImageData(fileName: "food-drink_image\(i)", category: .foodDrink, isPinned: false, timestamp: Date())
                modelContext.insert(imageData)
            }
            for i in 1...20 {
                let imageData = ImageData(fileName: "school_image\(i)", category: .school, isPinned: false, timestamp: Date())
                modelContext.insert(imageData)
            }
            for i in 1...20 {
                let imageData = ImageData(fileName: "life_image\(i)", category: .life, isPinned: false, timestamp: Date())
                modelContext.insert(imageData)
            }
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
    
    /// テンプレートがないときにデフォルトの内容を追加する
    /// - Returns: デフォルトテンプレートを返却
    @discardableResult
    func fetchTemplateData() -> [RoutineTitleTemplate]{
        let morningRoutines = RoutineTemplateItem.mockMorningRoutines.map { $0.cloned() }
        let title1 = RoutineTitleTemplate(name: "あさのしたくテンプレート", routines: morningRoutines)

        let mockSleepTimeRoutines = RoutineTemplateItem.mockSleepTimeRoutines.map { $0.cloned() }
        let title2 = RoutineTitleTemplate(name: "ねるまえのしたくテンプレート", routines: mockSleepTimeRoutines)

        let mockEveningRoutines = RoutineTemplateItem.mockEveningRoutines.map { $0.cloned() }
        let title3 = RoutineTitleTemplate(name: "ゆうがたのしたくテンプレート", routines: mockEveningRoutines)
        
        modelContext.insert(title1)
        modelContext.insert(title2)
        modelContext.insert(title3)

        do {
            try modelContext.save()

        } catch {
            print("エラー: \(error.localizedDescription)")
        }
        
        let templates = try! modelContext.fetch(FetchDescriptor<RoutineTitleTemplate>())
        
        return templates
    }
    
    
    /// ルーティンを取得する
    /// - Parameter routineTitles: テンプレートのルーティン
    /// - Returns: TodayData用のルーティンを返す
    func getRoutineTitlesFromTemplateAsync (_ routineTitles: [RoutineTitleTemplate]) async -> [RoutineTitle] {
        var todayRoutineTitle: [RoutineTitle] = []
        if routineTitles.isEmpty {
            for title in fetchTemplateData() {
                todayRoutineTitle.append(convertTemplateToRoutine(title))
            }
        } else {
            for title in routineTitles {
                todayRoutineTitle.append(convertTemplateToRoutine(title))
            }
        }
        return todayRoutineTitle
    }
    
    private func fetchTodayData() async {
        do {
            let templates = try modelContext.fetch(FetchDescriptor<RoutineTitleTemplate>())
            let allDays = try modelContext.fetch(FetchDescriptor<TodayData>())
                let today = Calendar.current.startOfDay(for: Date()) // 今日の0:00のタイムスタンプ
                if let todayData = allDays.first(where: { Calendar.current.isDate($0.timestamp, inSameDayAs: today) }) {
                    if todayData.routineTitles.isEmpty {
                        todayData.routineTitles = await getRoutineTitlesFromTemplateAsync(templates)
                    }
                } else {
                    #if DEBUG
                    print("今日のデータがないので新規作成")
                    #endif
                    await makeNewTodayData()
                }
            
        }catch {
            print(error)
        }
        
    }
    
    func makeNewTodayData() async {
        do {
            let templates = try modelContext.fetch(FetchDescriptor<RoutineTitleTemplate>())
            let routine = await getRoutineTitlesFromTemplateAsync(templates)
            let todayData = TodayData(timestamp: Date(), routineTitles: routine)

            
            for title in todayData.routineTitles {
                print("\(title.name)")
                print("done: \(title.done)")
            }
            modelContext.insert(todayData) // SwiftDataに保存
            try modelContext.save()
        } catch {
            print(error)
        }
        
    }
//    func convertTemplateToRoutine(_ template: RoutineTitleTemplate) -> RoutineTitle {
//        let convertedRoutines = template.routines.map { item in
//            Routine(name: item.name, done: false, imageName: item.imageName)
//        }
//        return RoutineTitle(name: template.name, routines: convertedRoutines)
//    }
//    
//    func convertRoutineToTemplate(_ routineTitle: RoutineTitle) -> RoutineTitleTemplate {
//        let convertedTemplateRoutines = routineTitle.routines.map { item in
//            RoutineTemplateItem(name: item.name, done: item.done, imageName: item.imageName)
//        }
//        return RoutineTitleTemplate(name: routineTitle.name, routines: convertedTemplateRoutines)
//    }
    
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
