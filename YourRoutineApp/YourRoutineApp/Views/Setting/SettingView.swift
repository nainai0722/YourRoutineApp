//
//  SettingView.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/21.
//

import SwiftUI

struct SettingView: View {
    var settingList: [String] = ["タイトル","したく","スタンプ","画像のお気に入り選択","アプリ情報"]
    var body: some View {
        NavigationStack {
            List {
                ForEach(settingList,id: \.self) { setting in
                    NavigationLink(destination: {
                        if setting == "タイトル" {
                            RoutineTitleListView(title: setting)
                        }
                        if setting == "したく" {
                            RoutineListView(title: setting)
                        }
                        if setting == "スタンプ" {
                            Text("構想を考え中です。アップデートをお待ちください")
                        }
                        if setting == "画像のお気に入り選択" {
                            PinnedImageDataList()
                        }
                        if setting == "アプリ情報" {
                            AppInfoView(title: setting)
                        }
                    }, label: {
                        Text(setting)
                    })
                }
            }
        }
    }
}

#Preview {
    SettingView()
}
