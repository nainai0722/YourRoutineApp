//
//  TodayDataManager.swift
//  YourRoutineApp
//
//  Created by 指原奈々 on 2025/04/22.
//

import Foundation
import SwiftData

#if DEBUG
extension TodayDataManager {
    func forceCheckAndCreate(for date: Date, context: ModelContext) async {
        let targetDay = Calendar.current.startOfDay(for: date)
        if targetDay != lastLoadedDate {
            await createTodayData(modelContext: context)
        }
    }
}
#endif


class TodayDataManager {
    static let shared = TodayDataManager()

    private(set) var todayData: TodayData?
    
    var lastLoadedDate: Date {
        get {
            UserDefaults.standard.object(forKey: "lastLoadedDate") as? Date ?? Date.distantPast
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "lastLoadedDate")
        }
    }
    
    func createTodayData(modelContext: ModelContext) async {
        do {
            let templates = try modelContext.fetch(FetchDescriptor<RoutineTitleTemplate>())
            try await getRoutineTitlesFromTemplateAsync(templates, modelContext: modelContext, completion: { routineTitles in
                
                let routine = routineTitles
                let todayData = TodayData(timestamp: Date(), routineTitles: routine)
                for title in todayData.routineTitles {
                    print("\(title.name)")
                    print("done: \(title.done)")
                }
                modelContext.insert(todayData) // SwiftDataに保存
                do {
                    try modelContext.save()
                } catch {
                    print(error)
                }
                // 前回ロードしたデータを上書きしておく
                TodayDataManager.shared.lastLoadedDate = Calendar.current.startOfDay(for: Date())
                
                
            })
        } catch {
            print(error)
        }
    }
    
    /// ルーティンを取得する
    /// - Parameter routineTitles: テンプレートのルーティン
    /// - Returns: TodayData用のルーティンを返す
    func getRoutineTitlesFromTemplateAsync (_ routineTitles: [RoutineTitleTemplate], modelContext: ModelContext, completion:(([RoutineTitle]) -> Void)) async throws {
        var todayRoutineTitle: [RoutineTitle] = []
//        if routineTitles.isEmpty {
        if try modelContext.fetchCount(FetchDescriptor<RoutineTitleTemplate>()) == 0 {
            await fetchTemplateData(modelContext: modelContext, completion: { (templates) in
                for title in templates {
                    todayRoutineTitle.append(convertTemplateToRoutine(title))
                }
                completion(todayRoutineTitle)
            })
        } else {
            for title in routineTitles {
                todayRoutineTitle.append(convertTemplateToRoutine(title))
            }
            completion(todayRoutineTitle)
        }
    }
    
    /// テンプレートがないときにデフォルトの内容を追加する
    /// - Returns: デフォルトテンプレートを返却
    @discardableResult
    func fetchTemplateData(modelContext: ModelContext, completion:(([RoutineTitleTemplate]) -> Void)) async{
        print("テンプレート作成中！！")
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
            completion([title1, title2, title3])
        } catch {
            print("エラー: \(error.localizedDescription)")
        }
    }
    
    func fetchTodayData(modelContext: ModelContext) async {
        do {
            let templates = try modelContext.fetch(FetchDescriptor<RoutineTitleTemplate>())
            let allDays = try modelContext.fetch(FetchDescriptor<TodayData>())
                let today = Calendar.current.startOfDay(for: Date()) // 今日の0:00のタイムスタンプ
                if let todayData = allDays.first(where: { Calendar.current.isDate($0.timestamp, inSameDayAs: today) }) {
                    if todayData.routineTitles.isEmpty {
                        try await TodayDataManager.shared.getRoutineTitlesFromTemplateAsync(templates, modelContext: modelContext,completion: { (routineTitles) in
                            todayData.routineTitles = routineTitles
                        })
                    }
                } else {
                    #if DEBUG
                    print("今日のデータがないので新規作成")
                    #endif
                    await createTodayData(modelContext: modelContext)
                }
            
        }catch {
            print(error)
        }
    }
}
