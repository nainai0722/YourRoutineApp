//
//  ImageDataManager.swift
//  YourRoutineApp
//
//  Created by 指原奈々 on 2025/04/23.
//

import Foundation
import SwiftData

public final class ImageDataManager {
    static let shared = ImageDataManager()
    
    func printImageData(imageDatas: [ImageData]) {
        print("画像の数\(imageDatas.count)")
        for imageData in imageDatas {
            print("\(imageData.fileName)")
        }
    }
    
    func checkAndFetchImageData(modelContext: ModelContext) {
        
        fetchImageData(modelContext: modelContext)
    }
    
    func addDefaultsImageData(modelContext: ModelContext, addNum: Int, addNumMax: Int) {
        do {
            let allImageDatas = try modelContext.fetch(FetchDescriptor<ImageData>())
            
            let defaultsData = allImageDatas.filter({$0.category == .defaults})
            
            
            if defaultsData.count < addNum {
                for i in addNum...addNumMax {
                    let imageData = ImageData(fileName: "default_image\(i)", category: .defaults, isPinned: true, timestamp: Date())
                    modelContext.insert(imageData)
                    print("default_image\(i)を追加")
                }
            }
            try modelContext.save()
            
        } catch {
            print(error)
        }
    }
    
    func fetchImageData(modelContext: ModelContext) {
        do {
            let allImageData = try modelContext.fetch(FetchDescriptor<ImageData>())
            
            let defaultsData = allImageData.filter({$0.category == .defaults})
            if defaultsData.isEmpty {
                for i in 1...22 {
                    let imageData = ImageData(fileName: "default_image\(i)", category: .defaults, isPinned: true, timestamp: Date())
                    modelContext.insert(imageData)
                }
            }
            
            // データが格納されているとき早期リターン
            if !allImageData.isEmpty {
                print("データが格納されているので早期リターン")
                return
            }
            
            // すべてのデータを投入する
            for i in 1...70 {
                let imageData = ImageData(fileName: "food-drink_image\(i)", category: .foodDrink, isPinned: false, timestamp: Date())
                modelContext.insert(imageData)
            }
            for i in 1...70 {
                let imageData = ImageData(fileName: "event_image\(i)", category: .event, isPinned: false, timestamp: Date())
                modelContext.insert(imageData)
            }
            for i in 1...88 {
                let imageData = ImageData(fileName: "school_image\(i)", category: .school, isPinned: false, timestamp: Date())
                modelContext.insert(imageData)
            }
            for i in 1...88 {
                let imageData = ImageData(fileName: "life_image\(i)", category: .life, isPinned: false, timestamp: Date())
                modelContext.insert(imageData)
            }
            
//            for i in 1...22 {
//                let imageData = ImageData(fileName: "default_image\(i)", category: .defaults, isPinned: true, timestamp: Date())
//                modelContext.insert(imageData)
//            }
            // データベースに保存
            try modelContext.save()
            
            #if DEBUG
            let allImageData2 = try modelContext.fetch(FetchDescriptor<ImageData>())
//            print("画像データの数 : \(allImageData2.count)")
            for data in allImageData2 {
//                print("fetchImageData: \(data.fileName)")
            }
            #endif
            
        } catch {
            print(error)
        }
    }
}
