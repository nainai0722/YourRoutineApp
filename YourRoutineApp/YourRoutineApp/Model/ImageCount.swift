//
//  ImageCount.swift
//  YourRoutineApp
//
//  Created by 指原奈々 on 2025/04/23.
//

import Foundation
import SwiftData


@Model
public final class ImageCount: Identifiable {
    public var count: Int
    public var category: ImageCategory
    
    public init(count: Int, category: ImageCategory) {
        self.count = count
        self.category = category
    }
}
