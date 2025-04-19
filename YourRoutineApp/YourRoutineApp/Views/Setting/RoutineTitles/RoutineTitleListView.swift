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
    @State private var selectedRoutineTitle: RoutineTitleTemplate?
    var body: some View {
        VStack {
            List {
                ForEach(routineTitles) { routineTitle in
                    Button(action: {
                        selectedRoutineTitle = routineTitle
                        isPresented.toggle()
                    }) {
                        Text("\(routineTitle.name)")
                    }
                }
                Button(action:{
                    selectedRoutineTitle = nil
                    isPresented.toggle()
                }){
                    Text("新しいしたくタイトルを追加する")
                }
            }
        }
        .navigationTitle(Text("おしたくリスト"))
        .overlay(
            Group {
                if var selectedRoutineTitle = selectedRoutineTitle {
                    EditRoutineTitleView(
                        isPresented: $isPresented,
                        routineTitle: Binding(
                            get: { selectedRoutineTitle },
                            set: { selectedRoutineTitle = $0 }
                        )
                    )
                } else {
                    AddRoutineTitleView(isPresented: $isPresented)
                }
            }
        )

    }
    
    func deleteRoutineTitle(_ routineTitle: RoutineTitleTemplate) {
        modelContext.delete(routineTitle)
        do {
            try modelContext.save()
        } catch {
            print("削除エラー: \(error.localizedDescription)")
        }
    }
}

#Preview {
    RoutineTitleListView()
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
        print("タイトルを追加しました")
        print("追加後の件数: \(routineTitles.count)") // Listの更新を確認

        do {
            try modelContext.save()
            print("追加後の件数: \(routineTitles.count)") // Listの更新を確認
        } catch {
            print("エラー: \(error.localizedDescription)")
        }
    }
}
struct EditRoutineTitleView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var isPresented: Bool
    @Binding var routineTitle: RoutineTitleTemplate

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
                    
                    TextField("タイトルを入力", text: $routineTitle.name)
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
            try modelContext.save()
            isPresented = false
        } catch {
            print("エラー: \(error.localizedDescription)")
        }
    }
}
