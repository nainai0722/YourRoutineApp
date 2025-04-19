//
//  KindarGardenCalendarView.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/17.
//

import SwiftUI
import SwiftData

#Preview {
    KindergartenCalendarView()
        .modelContainer(for: TodayData.self)
}

struct KindergartenCalendarView: View {
    var body: some View {
        VStack {
            BubbleView(text: "幼稚園に行ったら、スタンプを押そう")
                .padding()
            CustomCalendarViewView()
            
            Spacer()
        }
    }
}

@MainActor
struct CustomCalendarViewView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var todayDatas: [TodayData]
    @Query private var routineTitles: [RoutineTitleTemplate]
    @State private var selectedDates: Set<DateComponents> = []
    let weekLabel:[String] = ["月","火","水","木","金","土","日"]
    var body: some View {
        VStack {
            let calendar = Calendar(identifier: .gregorian)
            let today = Date()
            let days = getMonthDays(for: today, calendar: calendar)

            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 7), spacing: 10) {
                
                ForEach(weekLabel, id: \.self) { week in
                                    Text(week)
                                        .font(.headline)
                                        .frame(width: 40, height: 40)
                                        .foregroundStyle(.white)
                                        .background(Color.green)
                                        .clipShape(Circle())
                                }
                
                ForEach(days, id: \.self) { day in
                    VStack {
                        if let dayNumber = day.day{
                            Text("\(dayNumber)")
                                .font(.headline)
                                .frame(width: 40, height: 30)
                                .background(Color.gray.opacity(0.2))
                                .clipShape(Circle())
                                .onTapGesture {
                                    toggleDateSelection(day)
                                    updateSelectedDates(day)
                                }
                            let isGoneDay = todayDatas.contains {
                                            Calendar.current.isDate($0.timestamp, inSameDayAs: dateComponentsToDate(day) ?? Date()) && $0.kindergartenCalendarGone
                            }
                            let isSameDay = selectedDates.contains(where: { isSameDate($0, day) })

                            if isGoneDay || isSameDay {
                                DoneTypeMonthlyStampView()
                            } else {
                                MonthlyNoStampView()
                            }
                        }
                    }
                }
            }
            .padding()
        }
    }
    
    // 選択状態をトグルする
    private func toggleDateSelection(_ date: DateComponents) {
        if let existingDate = selectedDates.first(where: { isSameDate($0, date) }) {
            selectedDates.remove(existingDate)
        } else {
            selectedDates.insert(date)
        }
    }
    
    private func updateSelectedDates(_ date: DateComponents) {
        // TodayDataモデルから同じ日付のデータがないか調べる
        let selectedTodayData = fetchSelectedData(date)
        // 存在していれば、TodayDataのkindergartenCalendarGoneを更新する
        selectedTodayData.kindergartenCalendarGone.toggle()
        selectedTodayData.kindergartenCalendarType = selectedTodayData.kindergartenCalendarGone ? .gone : .notGone

        // modelContextを更新する
        do {
            try modelContext.save()
        } catch {
            print("保存に失敗: \(error.localizedDescription)")
        }
    }

    private func fetchSelectedData(_ dateComponents: DateComponents) -> TodayData {
        let fetchDescriptor = FetchDescriptor<TodayData>()
        
        guard let date = dateComponentsToDate(dateComponents) else {
//            fatalError("無効な DateComponents: \(dateComponents)")
            return TodayData(timestamp: Date(), routineTitles: [])
        }
        
        do {
            let allDays = try modelContext.fetch(fetchDescriptor)
            let selectedDay = Calendar.current.startOfDay(for: date) // 0:00 のタイムスタンプ
            
            if let todayData = allDays.first(where: { Calendar.current.isDate($0.timestamp, inSameDayAs: selectedDay) }) {
                return todayData
            }
        } catch {
            print("データの取得に失敗: \(error.localizedDescription)")
        }
        print("選択した日付のデータを新規作成")
        let todayRoutineTitle: [RoutineTitle] = getRoutineTitlesFromTemplate(routineTitles)
        
        let newData = TodayData(timestamp: date, routineTitles: todayRoutineTitle)
        modelContext.insert(newData)
        return newData
    }
    
    func getRoutineTitlesFromTemplate(_ routineTitles: [RoutineTitleTemplate]) -> [RoutineTitle] {
        var todayRoutineTitle: [RoutineTitle] = []
        if routineTitles.isEmpty {
            let morningRoutines = Routine.mockMorningRoutines.map { $0.cloned() }
            let title1 = RoutineTitle(name: "あさのしたく", routines: morningRoutines)

            let mockSleepTimeRoutines = Routine.mockSleepTimeRoutines.map { $0.cloned() }
            let title2 = RoutineTitle(name: "ねるまえのしたく", routines: mockSleepTimeRoutines)

            let mockEveningRoutines = Routine.mockEveningRoutines.map { $0.cloned() }
            let title3 = RoutineTitle(name: "ゆうがたのしたく", routines: mockEveningRoutines)

            
            todayRoutineTitle.append(contentsOf: [title1, title2, title3])
            print("なにもないので、デフォルトを追加")
            print(todayRoutineTitle.count)
            for title in todayRoutineTitle {
                print("\(title.name)")
            }
            print("追加終わり")
        } else {
            for title in routineTitles {
                todayRoutineTitle.append(convertTemplateToRoutine(title))
            }
        }
        return todayRoutineTitle
    }
    
    // 現在の月の日付を取得（正しい月曜始まり）
    private func getMonthDays(for date: Date, calendar: Calendar) -> [DateComponents] {
        guard let monthRange = calendar.range(of: .day, in: .month, for: date),
              let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: date)) else {
            return []
        }

        let firstWeekday = calendar.component(.weekday, from: firstDay) // 1:日曜, 2:月曜, ..., 7:土曜
        let offset = (firstWeekday + 5) % 7  // 月曜始まりにするためのオフセット

        var days: [DateComponents] = []

        // 空白セルを埋める
        for _ in 0..<offset {
            days.append(DateComponents())
        }

        // 月の日付を追加
        for day in monthRange {
            var components = calendar.dateComponents([.year, .month], from: date)
            components.day = day
            days.append(components)
        }

        return days
    }

    // DateComponents の比較（年月日だけを見る）
    private func isSameDate(_ lhs: DateComponents, _ rhs: DateComponents) -> Bool {
        return lhs.year == rhs.year && lhs.month == rhs.month && lhs.day == rhs.day
    }
}


/// カレンダー用のスタンプ画面
struct DoneTypeMonthlyStampView: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(.red.opacity(0.85))
                .frame(width: 40, height: 40) // サイズを指定
            Text("OK")
                .foregroundStyle(.white)
                .rotationEffect(.degrees(-45))
                .font(.system(size: 13))
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue.opacity(0.1))
        }
        .frame(width: 50, height: 60)
    }
}

struct MonthlyNoStampView: View {
    var body: some View {
        ZStack {
            Text("  ")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue.opacity(0.1))
        }
        .frame(width: 50, height: 60)
    }
}
