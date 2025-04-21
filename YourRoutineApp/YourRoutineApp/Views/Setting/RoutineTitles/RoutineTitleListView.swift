//
//  RoutineTitleListView.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/20.
//

import SwiftUI
import SwiftData

struct RoutineTitleListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var routineTitles: [RoutineTitleTemplate]
    @State var isPresented :Bool = false
    @State var isAlert: Bool = false
    @State private var selectedRoutineTitle: RoutineTitleTemplate?
    @AppStorage("tempRoutineTitleId") var tempRoutineTitleId: String = ""
    @AppStorage("tempRoutineTitleName") var tempRoutineTitleName: String = ""
    let title: String
    var body: some View {
        VStack {
            List {
//                ForEach(routineTitles) { routineTitle in
//                    
//                    Text("\(routineTitle.name)")
//                        .onTapGesture {
//                            selectedRoutineTitle = routineTitle
//                            isPresented.toggle()
//                        }
//                        .onLongPressGesture {
//                            let toDelete = routineTitle
//                            selectedRoutineTitle = toDelete
//                            deleteRoutineTitle(selectedRoutineTitle)
//                        }
//                }
                
                ForEach(routineTitles) { routineTitle in
                    RoutineTitleRow(
                        routineTitle: routineTitle,
                        onTap: {
                            selectedRoutineTitle = routineTitle
                            tempRoutineTitleId = routineTitle.id.uuidString
                            tempRoutineTitleName = routineTitle.name
                            isPresented.toggle()
                        },
                        onLongPress: {
                            selectedRoutineTitle = routineTitle
                            isAlert = true
                            
                        }
                    )
                }
                .alert(isPresented: $isAlert) {
                    Alert(
                        title: Text("確認"),
                        message: Text("\(selectedRoutineTitle?.name ?? "")を削除しますか？"),
                        primaryButton: .default(
                            Text("キャンセル"),
                            action: { }
                        ),
                        secondaryButton: .destructive(
                            Text("削除"),
                            action: {
                                if let title = selectedRoutineTitle {
                                    deleteRoutineTitle(title)
                                }
                            }
                        )
                    )
                }


                Text("新しいしたくタイトルを追加する")
                    .onTapGesture {
                        selectedRoutineTitle = nil
                        isPresented.toggle()
                    }
            }
        }
        .navigationTitle(title)
        .overlay(
            Group {
                if selectedRoutineTitle != nil {
                    EditRoutineTitleView(
                        isPresented: $isPresented,
                        )
                } else {
                    AddRoutineTitleView(isPresented: $isPresented)
                }
            }
        )
    }
    
    
    func deleteRoutineTitle(_ routineTitle: RoutineTitleTemplate) {
        modelContext.delete(routineTitle)
        fetchTodayDataRoutineTitle(routineTitle, isDelete: true)
        do {
            try modelContext.save()
        } catch {
            print("削除エラー: \(error.localizedDescription)")
        }
    }

    func fetchTodayDataRoutineTitle(_ routineTitleTemplate: RoutineTitleTemplate, isDelete: Bool) {
        do {
            let allDays = try modelContext.fetch(FetchDescriptor<TodayData>())
            let today = Calendar.current.startOfDay(for: Date()) // 今日の0:00のタイムスタンプ
            
            if let todayData = allDays.first(where: { Calendar.current.isDate($0.timestamp, inSameDayAs: today) })
            {
                // 今日のデータを取得したら、タイトルを限定し
                if let routineTitle = todayData.routineTitles.first(where: { $0.templateTitleId == routineTitleTemplate.id }) {
                    if isDelete {
                        todayData.routineTitles.removeAll(where: {$0.templateTitleId == routineTitleTemplate.id})
                        
                    } else {
                        routineTitle.name = routineTitle.name
                    }
                } else {
                    let newRoutineTitle = convertTemplateToRoutine(routineTitleTemplate)
                    todayData.routineTitles.append(newRoutineTitle)
                    modelContext.insert(newRoutineTitle)
                }
                    try modelContext.save()
            } else {
                print("同日が見つからない")
            }
            
        } catch {
            print(error)
        }
    }
}

struct RoutineTitleRow: View {
    let routineTitle: RoutineTitleTemplate
    let onTap: () -> Void
    let onLongPress: () -> Void

    var body: some View {
        Text("\(routineTitle.name)")
            .onTapGesture(perform: onTap)
            .onLongPressGesture(perform: onLongPress)
    }
}


#Preview {
    RoutineTitleListView(title:"")
        .modelContainer(for: RoutineTitleTemplate.self)
}

struct AddRoutineTitleView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var isPresented: Bool
    @State private var routineName: String = ""
    @Query private var routineTitles: [RoutineTitleTemplate]
    var body: some View {
        ZStack {
            if isPresented {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        isPresented = false
                        routineName = ""
                    }

                VStack(spacing: 20) {
                    Text("おしたくを追加する")
                        .font(.headline)
                    
                    TextField("タイトルを入力", text: $routineName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 20)

                    HStack(spacing: 20) {
                        Button(action: {
                            isPresented = false
                            routineName = ""
                        }) {
                            Text("キャンセル")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.gray.opacity(0.3))
                                .cornerRadius(8)
                        }

                        Button(action: {
                            if !routineName.isEmpty {
                                addRoutineTitle(name: routineName)
                            }
                            isPresented = false
                            routineName = ""
                        }) {
                            Text("追加")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .frame(width: 300, height: 180)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 10)
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isPresented)
    }

    func addRoutineTitle(name: String) {
        let newRoutineTitle = RoutineTitleTemplate(name: name, routines: RoutineTemplateItem.mockThreeRoutines)
        modelContext.insert(newRoutineTitle)
        
        fetchTodayDataRoutineTitle(newRoutineTitle, isDelete: false)
        print("タイトルを追加しました")
        print("追加後の件数: \(routineTitles.count)") // Listの更新を確認

        do {
            try modelContext.save()
            print("追加後の件数: \(routineTitles.count)") // Listの更新を確認
        } catch {
            print("エラー: \(error.localizedDescription)")
        }
    }
    func fetchTodayDataRoutineTitle(_ routineTitleTemplate: RoutineTitleTemplate, isDelete: Bool) {
        do {
            let allDays = try modelContext.fetch(FetchDescriptor<TodayData>())
            let today = Calendar.current.startOfDay(for: Date()) // 今日の0:00のタイムスタンプ
            
            if let todayData = allDays.first(where: { Calendar.current.isDate($0.timestamp, inSameDayAs: today) })
            {
                // 今日のデータを取得したら、タイトルを限定し
                if let routineTitle = todayData.routineTitles.first(where: { $0.templateTitleId == routineTitleTemplate.id }) {
                    if isDelete {
                        todayData.routineTitles.removeAll(where: {$0.templateTitleId == routineTitleTemplate.id})
                        
                    } else {
                        routineTitle.name = routineTitle.name
                    }
                } else {
                    let newRoutineTitle = convertTemplateToRoutine(routineTitleTemplate)
                    todayData.routineTitles.append(newRoutineTitle)
                    modelContext.insert(newRoutineTitle)
                }
                    try modelContext.save()
            } else {
                print("同日が見つからない")
            }
            
        } catch {
            print(error)
        }
    }
}
struct EditRoutineTitleView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var isPresented: Bool
//    @Binding var routineTitle: RoutineTitleTemplate
    @AppStorage("tempRoutineTitleId") var tempRoutineTitleId: String = ""
    @AppStorage("tempRoutineTitleName") var tempRoutineTitleName: String = ""

    var body: some View {
        ZStack {
            if isPresented {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        isPresented = false
                    }

                VStack(spacing: 20) {
                    Text("おしたくを変更する")
                        .font(.headline)
                    
                    TextField("タイトルを入力", text: $tempRoutineTitleName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 20)

                    HStack(spacing: 20) {
                        Button(action: {
                            isPresented = false
                        }) {
                            Text("キャンセル")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.gray.opacity(0.3))
                                .cornerRadius(8)
                        }

                        Button(action: {
                            saveChanges()
                        }) {
                            Text("更新")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .frame(width: 300, height: 180)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 10)
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isPresented)
    }

    func saveChanges() {
        // 更新処理
        do {
            let titles = try modelContext.fetch(FetchDescriptor<RoutineTitleTemplate>())
            
            
            if let updateRoutineTitle = titles.first(where: { $0.id == UUID(uuidString: tempRoutineTitleId) }) {
                updateRoutineTitle.name = tempRoutineTitleName
                isPresented = false
                fetchTodayDataRoutineTitle(updateRoutineTitle, isDelete: false)
                try modelContext.save()
            }
        } catch {
            print("エラー: \(error.localizedDescription)")
        }
    }
    func fetchTodayDataRoutineTitle(_ routineTitleTemplate: RoutineTitleTemplate, isDelete: Bool) {
        do {
            let allDays = try modelContext.fetch(FetchDescriptor<TodayData>())
            let today = Calendar.current.startOfDay(for: Date()) // 今日の0:00のタイムスタンプ
            
            if let todayData = allDays.first(where: { Calendar.current.isDate($0.timestamp, inSameDayAs: today) })
            {
                // 今日のデータを取得したら、タイトルを限定し
                if let routineTitle = todayData.routineTitles.first(where: { $0.templateTitleId == routineTitleTemplate.id }) {
                    if isDelete {
                        todayData.routineTitles.removeAll(where: {$0.templateTitleId == routineTitleTemplate.id})
                        
                    } else {
                        routineTitle.name = routineTitleTemplate.name
                    }
                } else {
                    let newRoutineTitle = convertTemplateToRoutine(routineTitleTemplate)
                    todayData.routineTitles.append(newRoutineTitle)
                    modelContext.insert(newRoutineTitle)
                }
                    try modelContext.save()
            } else {
                print("同日が見つからない")
            }
            
        } catch {
            print(error)
        }
    }
}
