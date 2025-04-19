//
//  EditRoutineView.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/22.
//

import SwiftUI
import SwiftData
import FirebaseAnalytics

@MainActor
struct EditRoutineView: View {
    @Environment(\.presentationMode) var presentationMode:Binding<PresentationMode>
    @Environment(\.modelContext) private var modelContext
    // ピン留めした画像だけ表示する
    @Query(filter: #Predicate<ImageData> { $0.isPinned == true }) var imageDatas: [ImageData]
    @State var routine:RoutineTemplateItem?
    @State var editTitle: String = ""
    @State var editImage: String = ""
    @State var isEdit: Bool = false
    @State var imageArray:[String] = []
    var routineTitleId : UUID
    var body: some View {
        VStack {
            TextField("タイトルを入力", text: $editTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 20)
            Text("選択中の画像")
            IconView(imageName: editImage, size: 80, fontsize: 10, onTap: {
                print("選択中の画像")
            })
            Text("他の画像を選択する")
            GridView(imageData:imageDatas.filter{ $0.isPinned == true }, onTap: { image in
                editImage = image.fileName
            })
            HStack {
                if isEdit {
                    Button(action: {
                        if let routine = routine {
                            delete(routine)
                        }
                        self.presentationMode.wrappedValue.dismiss()
                    }){
                        Text("削除")
                    }
                }
                Button(action:{
                    if let routine = routine {
                        update(routine)
                    } else {
                        add()
                    }
                    self.presentationMode.wrappedValue.dismiss()
                }){
                    Text(isEdit ?"更新" : "保存")
                }
            }
        }
        .onAppear() {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                print("追加後：", imageArray)
//            }
            if let routine = routine {
                editTitle = routine.name
                editImage = routine.imageName
                isEdit = true
            }
        }
    }
    
    func delete(_ routine: RoutineTemplateItem) {
        routine.name = editTitle
        
        let fetchDescriptor = FetchDescriptor<RoutineTitleTemplate>()
        // 削除処理
        do {
            let routineTitles = try modelContext.fetch(fetchDescriptor)
            let routineTitle = routineTitles.first(where: { $0.id == routineTitleId })
            
            if let routineTitle = routineTitle {
                routineTitle.routines.removeAll(where: { $0.id == routine.id } )
                Analytics.logEvent("deleteRoutine", parameters: [
                    "routineTitle": routineTitle.name,
                    "routineName": routine.name,
                    "imageName": routine.imageName,
                ])
                fetchTodayData(routine,isDelete: true)
            }
            
        } catch {
            print("❌ データの取得または更新に失敗: \(error.localizedDescription)")
        }
    }
    
    func update(_ routine: RoutineTemplateItem) {
        routine.name = editTitle
        routine.imageName = editImage
        
        let fetchDescriptor = FetchDescriptor<RoutineTitleTemplate>()
        // 更新処理
        do {
            let routineTitles = try modelContext.fetch(fetchDescriptor)
            let routineTitle = routineTitles.first(where: { $0.id == routineTitleId })
            
            if let routineTitle = routineTitle, let updateRoutine = routineTitle.routines.first(where: { $0.id == routine.id }) {
                updateRoutine.name = editTitle
                updateRoutine.imageName = editImage
                try modelContext.save()
                Analytics.logEvent("updateRoutine", parameters: [
                    "routineTitle": routineTitle.name,
                    "routineName": updateRoutine.name,
                    "imageName": updateRoutine.imageName,
                ])
                fetchTodayData(routine,isDelete: false)
            }
        } catch {
            print("❌ データの取得または更新に失敗: \(error.localizedDescription)")
        }
    }
    
    func add() {
        let fetchDescriptor = FetchDescriptor<RoutineTitleTemplate>()
        
        if editImage == "" || editTitle == "" {
            print("データを入れてください")
            return
        }
        
        do {
            let routineTitles = try modelContext.fetch(fetchDescriptor)
            let routineTitle = routineTitles.first(where: { $0.id == routineTitleId })
            if let routineTitle = routineTitle {
                let newRoutine = RoutineTemplateItem(name: editTitle, done: false, imageName: editImage)
                routineTitle.routines.append(newRoutine)
                modelContext.insert(newRoutine)
                print("保存処理完了")
                Analytics.logEvent("addRoutine", parameters: [
                    "routineTitle": routineTitle.name,
                    "routineName": newRoutine.name,
                    "imageName": newRoutine.imageName,
                ])
                fetchTodayData(newRoutine,isDelete: false)
            }
            try modelContext.save()
        } catch {
            print("❌ データの追加に失敗: \(error.localizedDescription)")
        }
    }
    
    func fetchTodayData(_ templateRoutine: RoutineTemplateItem, isDelete: Bool) {
        let fetchDescriptor = FetchDescriptor<TodayData>()
        let fetchDescriptor2 = FetchDescriptor<RoutineTitleTemplate>()
        do {
            let allDays = try modelContext.fetch(fetchDescriptor)
            let titleTemplates = try modelContext.fetch(fetchDescriptor2)
            let today = Calendar.current.startOfDay(for: Date()) // 今日の0:00のタイムスタンプ
            
            if let todayData = allDays.first(where: { Calendar.current.isDate($0.timestamp, inSameDayAs: today) }),
               let titleTemplate = titleTemplates.first(where: {$0.id == routineTitleId})
            {
                // 今日のデータを取得したら、タイトルを限定し
                if let routineTitle = todayData.routineTitles.first(where: { $0.name == titleTemplate.name }) {
                    if let existRoutine = routineTitle.routines.first(where: { $0.id == templateRoutine.id }) {
                        if isDelete {
                            routineTitle.routines.removeAll(where: { $0.id == existRoutine.id } )
                        } else {
                            // すでに存在しているルーティンであれば内容を差し替える
                            existRoutine.name = templateRoutine.name
                            existRoutine.imageName = templateRoutine.imageName
                        }
                    } else {
                        let newRoutine = Routine(name: templateRoutine.name, done: false, imageName: templateRoutine.imageName)
                        routineTitle.routines.append(newRoutine)
                        modelContext.insert(newRoutine)
                    }
                    try modelContext.save()
                }
            }
        } catch {
            print(error)
        }
    }
    
    
}
//
//#Preview {
//    EditRoutineView(routineTitleId: UUID())
//        .modelContainer(for: RoutineTitleTemplate.self)
//}

