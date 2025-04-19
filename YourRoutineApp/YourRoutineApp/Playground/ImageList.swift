//
//  ImageList.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/04/18.
//

import SwiftUI

struct ImageList: View {
    @State var imageArray :[String] = []
    var body: some View {
        List {
            Text("画像数\(imageArray.count)")
            ForEach(imageArray, id:\.self) { image in
                Text(image)
            }
        }.onAppear {
            for i in 1...88 {
                imageArray.append(String("food-drink_image\(i)"))
            }
            
        }
        
    }
    
}

#Preview {
    ImageList()
}
