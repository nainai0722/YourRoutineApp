//
//  SettingView.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/21.
//

import SwiftUI

struct SettingView: View {
    var settingList: [String] = ["タイトルを編集する","したくを編集する","スタンプ","画像のお気に入り選択","アプリ情報"]
    @State private var tutorialStep: TutorialStep = .step2_showSettingsHint

    var body: some View {
        VStack {
            NavigationStack {
                ZStack {
                    // 背景色をここで指定
                    Color.gray.opacity(0.1)
                        .ignoresSafeArea() // 全画面に広げる
                    VStack {
                        HStack {
                            Spacer()
                            NavigationLink(destination:{
                                AppInfoView(title: "アプリ情報")
                            },
                                           label: {
                                Image(systemName: "gear")
                                .padding(.trailing, 20)                        })
                        }
                        List {
                            ForEach(settingList,id: \.self) { setting in
                                NavigationLink(destination: {
                                    if setting == "タイトルを編集する" {
                                        RoutineTitleListView(title: setting)
                                    }
                                    if setting == "したくを編集する" {
                                        RoutineListView(title: setting)
                                    }
                                    if setting == "スタンプ" {
                                        Text("構想を考え中です。アップデートをお待ちください")
                                    }
                                    if setting == "画像のお気に入り選択" {
                                        PinnedImageDataList()
                                    }
                                }, label: {
                                    Text(setting)
                                })
//                                if tutorialStep == .step2_showSettingsHint && setting == "したくを編集する" {
//                                    SpeechBubbleView(text: "ここで支度を編集できるよ")
//                                        .offset(x: -150) // 横に少しずらす
//                                }
                            }
                        }
                        .scrollContentBackground(.hidden)
                    }
                }
            }
        }
    }
}

#Preview {
    SettingView()
}
