//
//  CircleAnimationView.swift
//  YourRoutineApp
//
//  Created by 指原奈々 on 2025/04/24.
//

import SwiftUI

struct CircleAnimationView: View {
    @State var progress: Double = 2.0
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        VStack {
            Circle()
                .trim(from:0.0, to: progress)
                .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .rotationEffect(.degrees(180))
                .foregroundStyle(.blue)
                .animation(.linear(duration: 5.5))
        }
    }
}

extension Animation {
    static var customForTimer: Animation {
        .timingCurve(.linear, duration: 0.5)
    }
}

#Preview {
    CircleAnimationView()
}
