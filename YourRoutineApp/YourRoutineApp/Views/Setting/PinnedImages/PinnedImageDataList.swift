//
//  PinnedImageDataList.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/04/18.
//

import SwiftUI
import SwiftData

@MainActor
struct PinnedImageDataList: View {
    @Environment(\.modelContext) private var modelContext
    @Query var imageDatas:[ImageData]

    var body: some View {
        VStack {
            Text("お気に入りの画像を設定する")
            GridViewWithPinned(imageData:imageDatas, onTap: { image in
                updateIsPinnedImageData(image)
            })
        }
        .onAppear(){
            print("画像の数\(imageDatas.count)")
            for imageData in imageDatas {
                print("\(imageData.fileName)")
            }
        }
    }
    
    func updateIsPinnedImageData(_ imageData:ImageData) {
        do {
            let allImages = try modelContext.fetch(FetchDescriptor<ImageData>())
            if let updateImage = allImages.first(where: { $0.id == imageData.id }) {
                updateImage.isPinned = updateImage.isPinned ? false : true
                try modelContext.save()
            }
        } catch {
            print(error)
        }
    }
}

struct GridViewWithPinned: View {
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    let imageData: [ImageData]
    let onTap: (ImageData) -> Void
    var body: some View {
        ScrollView {
            VStack(alignment:.leading) {
                LazyVGrid(columns: columns) {
                    ForEach(imageData){ image in
                        IconViewWithPinned(imageData: image, size: 80, fontsize: 10, onTap: {
                            print(image.fileName + "tap")
                            onTap(image)
                        })
                    }
                }
            }
        }
    }
}


struct IconViewWithPinned: View {
    @State var imageData: ImageData
    var size: CGFloat = 150
    var fontsize: CGFloat = 20
    let onTap: () -> Void
    var body: some View {
        ZStack {
            VStack {
                Button(action:{
                    onTap()
                }) {
                    VStack(spacing: 0) {
                        if !imageData.fileName.isEmpty {
                            Image(imageData.fileName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: size * 0.95, height: size * 0.95)
                        } else {
                            Image(systemName: "questionmark.square") // デフォルト画像
                                .resizable()
                                .scaledToFit()
                                .frame(width: size * 0.95, height: size * 0.95)
                        }
                    }
                }
            }
            Image(systemName: imageData.isPinned ? "checkmark.circle.fill": "checkmark.circle")
                .offset(x: size * 0.4, y: -size * 0.4)
                .foregroundStyle(imageData.isPinned ? Color.blue : Color.gray)
        }
        .frame(width: size, height: size)
        .padding()
        .background(Color.white) // 背景白にする場合
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray, lineWidth: 3)
        )
        .cornerRadius(12)
    }
}

#Preview {
    PinnedImageDataList()
        .modelContainer(for: ImageData.self)
}
