//
//  AppInfoVIew.swift
//  YourRoutineApp
//
//  Created by 指原奈々 on 2025/04/19.
//

import SwiftUI

struct AppInfoView: View {
    var appInfoList: [String] = ["SDK一覧","お問い合わせ","その他アプリ"]
    let title: String
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(appInfoList,id: \.self) { appInfo in
                        if appInfo == "SDK一覧" {
                            NavigationLink {
                                SDKListView(title: appInfo)
                            } label: {
                                Text(appInfo)
                            }
                        }
                        Text(appInfo)
                    }
                    
                }
            }
        }
        .navigationTitle(title)
    }
}

#Preview {
    AppInfoView(title:"")
}
