//
//  RoutineView.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/11.
//

import SwiftUI
import SwiftData

@MainActor
struct DoneRoutineView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var routineTitles: [RoutineTitleTemplate]
    @Query private var todayDatas: [TodayData]
    @State var todayData:TodayData = TodayData()
    @State var routineName: String = ""
    @State var routines :[Routine] = []
    var body : some View {
        ZStack {
            VStack {
                Text(routineName)
                    .font(.title)
                Menu("したくをえらぶ") {
                    ForEach(todayData.routineTitles,id:\.id) { routineTitle in
                        Button(routineTitle.name, action: {
                            routines = routineTitle.routines
                            routineName = routineTitle.name
                        })
                    }
                }
                .menuStyle(ButtonMenuStyle())
                
                BubbleView(text:"できたらスタンプを押してね！" )
                
                RoutineStampView(routines: $routines)
                
                Spacer()
                
                if allDoneCheck() {
                    NavigationLink {
                        RoutineCalendarView()
                    } label: {
                        Text("カレンダーを見る")
                            .modifier(CustomButtonLayoutWithSetColor(textColor: .white, backGroundColor: .red, fontType: .title))
                    }
                }
            }
            if allDoneCheck() {
                AllDone_StampView()
                    .onAppear(){
                        updateRoutinesDone()
                    }
            }
        }
        .onAppear {
            fetchTodayData()
            UIApplication.shared.isIdleTimerDisabled = true
        }
        .onDisappear {
            UIApplication.shared.isIdleTimerDisabled = false
        }
    }
    
    func updateRoutinesDone() {
        #if DEBUG
        print("ルーティンの更新")
        #endif
        let fetchDescriptor = FetchDescriptor<TodayData>()
        do {
            let allDays = try modelContext.fetch(fetchDescriptor)
            let today = Calendar.current.startOfDay(for: Date()) // 今日の0:00のタイムスタンプ
            
            if let todayData = allDays.first(where: { Calendar.current.isDate($0.timestamp, inSameDayAs: today) }) {
                for routine in todayData.routineTitles {
                    print("\(routine.name): \(routine.done)")
                }
                
                // すでに完了済みなら何もしない
                if let selectedRoutine = todayData.routineTitles.filter({ $0.name == routineName }).first, selectedRoutine.done == true {
                    return
                }
                
                // すべてのdoneがtrueなら morningRoutineDone を更新
                if routines.allSatisfy(\.done) {
                    
                    if let selectedRoutine = todayData.routineTitles.filter({ $0.name == routineName }).first, selectedRoutine.done == false {
                        selectedRoutine.done = true
                    }
                    
                    try modelContext.save()
                }
            }
        } catch {
            print("❌ データの取得または更新に失敗: \(error.localizedDescription)")
        }
    }
    
    func allDoneCheck() -> Bool {
        if routines.isEmpty { return false }
        return routines.allSatisfy(\.done)
    }
    
    private func fetchTodayData() {
        let fetchDescriptor = FetchDescriptor<TodayData>()
        if let allDays = try? modelContext.fetch(fetchDescriptor) {
            let today = Calendar.current.startOfDay(for: Date()) // 今日の0:00のタイムスタンプ
            if let todayData = allDays.first(where: { Calendar.current.isDate($0.timestamp, inSameDayAs: today) }) {
                self.todayData = todayData
            }
        }
    }
}

extension Routine {
    func cloned() -> Routine {
        Routine(name: self.name, done: self.done, imageName: self.imageName)
    }
}

extension RoutineTitle {
    func cloned() -> RoutineTitle {
        let newRoutines = self.routines.map { $0.cloned() }
        return RoutineTitle(name: self.name, routines: newRoutines)
    }
}

extension RoutineTemplateItem {
    func cloned() -> RoutineTemplateItem {
        RoutineTemplateItem(name: self.name, done: self.done, imageName: self.imageName)
    }
}

extension RoutineTitleTemplate {
    func cloned() -> RoutineTitleTemplate {
        let newRoutines = self.routines.map { $0.cloned() }
        return RoutineTitleTemplate(name: self.name, routines: newRoutines)
    }
}


#Preview {
    DoneRoutineView()
        .modelContainer(for: [
            TodayData.self,
            RoutineTitle.self,
            RoutineTitleTemplate.self
            
        ])
}

struct AllDone_StampView: View {
    @State private var offsetY: CGFloat = 500 // 画面下に隠しておく
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(.red.opacity(0.85))
                    .frame(width: 300, height: 300) // サイズを指定
                Text("OK")
                    .foregroundStyle(.white)
                    .rotationEffect(.degrees(-40))
                    .font(.system(size: 250))

            }
            .offset(y: offsetY) // 初期位置
                        .onAppear {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.5)) {
                                offsetY = 0 // アニメーションで上に移動
                            }
                        }
        }
    }
}


