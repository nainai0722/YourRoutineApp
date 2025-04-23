//
//  ImageCountView.swift
//  YourRoutineApp
//
//  Created by 指原奈々 on 2025/04/23.
//

import SwiftUI
import SwiftData

struct ImageCountView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var imageDatas:[ImageData]
    @Query private var imageCounts: [ImageCount]
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        
        ForEach(imageDatas) { imagedata in
            Text(imagedata.fileName)
        }
        .onAppear {
            ImageDataManager.shared.fetchImageData(modelContext: modelContext)
            fetchImageCount()
        }
    }
    
    func fetchImageCount() {
        do {
            let allImageDatas = try modelContext.fetch(FetchDescriptor<ImageData>())
            
            /*ForEach(ImageCategory.allCases, id:\.self) {*/
            for category in ImageCategory.allCases {
                let items = allImageDatas.filter { $0.category == category }
                
                let itemsCount = ImageCount(count: items.count, category: category)
                
                modelContext.insert(itemsCount)
                print("数は\(itemsCount.count)")
            }
            
            try modelContext.save()
        } catch {
            print(error)
        }
    }
    
}

#Preview {
    ImageCountView()
        .modelContainer(for: [
            ImageData.self,
            ImageCount.self
        ])
    
}
