//
//  SettingView.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/21.
//

import SwiftUI

struct SettingView: View {
    var settingList: [String] = ["タイトル","したく","スタンプ","画像のお気に入り選択"]
    var body: some View {
        NavigationStack {
            List {
                ForEach(settingList,id: \.self) { setting in
                    NavigationLink(destination: {
                        if setting == "タイトル" {
                            RoutineTitleListView()
                        }
                        if setting == "したく" {
                            RoutineListView()
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
                }
            }
        }
    }
}

#Preview {
    SettingView()
}
