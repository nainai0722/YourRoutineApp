//
//  SpeechBubbleView.swift
//  YourRoutineApp
//
//  Created by 指原奈々 on 2025/04/21.
//

import SwiftUI

struct SpeechBubbleView: View {
    var text: String

    var body: some View {
        Text(text)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .shadow(radius: 4)
            )
            .overlay(
                Triangle()
                    .fill(Color.white)
                    .frame(width: 20, height: 10)
                    .offset(y: 15),
                alignment: .bottom
            )
    }
}

//struct Triangle: Shape {
//    func path(in rect: CGRect) -> Path {
//        var path = Path()
//        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
//        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
//        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
//        path.closeSubpath()
//        return path
//    }
//}


#Preview {
    SpeechBubbleView(text:"ハロー")
}
