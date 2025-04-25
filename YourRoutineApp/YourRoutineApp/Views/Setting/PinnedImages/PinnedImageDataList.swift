//
//  PinnedImageDataList.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/04/18.
//

import SwiftUI
import SwiftData

#Preview {
    PinnedImageDataList()
        .modelContainer(for: ImageData.self)
}

@MainActor
struct PinnedImageDataList: View {
    @Environment(\.modelContext) private var modelContext
    @Query var imageDatas:[ImageData]
    @State var selectedImageData: [ImageData] = []
    @State private var selectedSection: ImageCategory = .defaults
    enum SectionInfo: String, CaseIterable, Identifiable {
        case skill, difficulty, category
        var id: Self { self }
    }
    var body: some View {
        ZStack {
            VStack {
                GridViewWithPinned(imageData:selectedImageData.isEmpty ? imageDatas : selectedImageData, onTap: { image in
                    updateIsPinnedImageData(image)
                })
                .onChange(of: selectedSection) { oldValue, newValue in
                    selectedImageData = imageDatas.filter {
                        $0.category == newValue
                    }
                }
            }
            .onAppear(){
                ImageDataManager.shared.fetchImageData(modelContext: modelContext)
                // 追加したい画像があるときは以下を利用する
                ImageDataManager.shared.addDefaultsImageData(modelContext: modelContext, addNum: 23, addNumMax: 23)
                fetchImageCount()
                #if DEBUG
                ImageDataManager.shared.printImageData(imageDatas: imageDatas)
                #endif
            }
            .navigationTitle("お気に入りの画像を設定する")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        ForEach(ImageCategory.allCases, id:\.self) { category in
                            Button("\(category.rawValue)を表示") { selectedSection = category }
                        }
                        Button("すべて表示") { selectedImageData = [] }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .frame(width: 50, height: 50)
                            .padding(.trailing, 30)
                    }
                }
            }
            VStack {
                Menu {
                    ForEach(ImageCategory.allCases, id:\.self) { category in
                        Button("\(category.rawValue)を表示") { selectedSection = category }
                    }
                    Button("すべて表示") { selectedImageData = [] }
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle.fill")
                        .font(.system(size: 50))
                        .padding(20)
                        .background(.white)
                        .clipShape(Circle())
                        .padding(.trailing, 30)
                }
            }
            .offset(x: 150, y: 350)
        }
    }
        
    func fetchImageCount() {
        do {
            let allImageDatas = try modelContext.fetch(FetchDescriptor<ImageData>())
            let allImageCount = try modelContext.fetch(FetchDescriptor<ImageCount>())
            
            for category in ImageCategory.allCases {
                let items = allImageDatas.filter { $0.category == category }
                
                let imageCount = allImageCount.filter { $0.category == category }
                
                if imageCount.count == items.count {
                    // 差分がない
                  return
                }
                
                if imageCount.count == 0 {
                    let itemsCount = ImageCount(count: items.count, category: category)
                    
                    modelContext.insert(itemsCount)
                    print("\(itemsCount.category.rawValue): 数は\(itemsCount.count)")
                }
            }
            try modelContext.save()
        } catch {
            print(error)
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


