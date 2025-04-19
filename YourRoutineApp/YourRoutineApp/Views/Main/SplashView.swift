//
//  SplashView.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/04/17.
//

import SwiftUI


struct SplashView: View {
    @State private var animate = false
    
    var body: some View {
        VStack {
            Image(systemName: "sparkles")
                .resizable()
                .frame(width: 80, height: 80)
                .scaleEffect(animate ? 1.2 : 1.0)
                .animation(.easeInOut(duration: 1.0).repeatForever(), value: animate)
            Text("読み込み中...")
                .padding()
        }
        .onAppear {
            animate = true
        }
    }
}



#Preview {
    SplashView()
}
