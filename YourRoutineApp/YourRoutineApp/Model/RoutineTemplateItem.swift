//
//  RoutineTemplateItem.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/10.
//

import Foundation
import SwiftData

@Model
final class RoutineTemplateItem: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    var name: String
    var done: Bool
    var imageName: String
    @Relationship(inverse: \RoutineTitleTemplate.routines)
        var title: RoutineTitleTemplate?
    
    init(name: String, done: Bool, imageName: String) {
        self.name = name
        self.done = done
        self.imageName = imageName
    }
    
    static let mockWearRoutine = RoutineTemplateItem(name: "きがえる", done: true, imageName: "default_image22")
    static let mockEatRoutine = RoutineTemplateItem(name: "たべる", done: false, imageName: "default_image8")
    static let mockEToiletRoutine = RoutineTemplateItem(name: "トイレ", done: false, imageName: "default_image20")
    static let mockBottleRoutine = RoutineTemplateItem(name: "水筒", done: false, imageName: "default_image2")
    static let mockGoodsRoutine = RoutineTemplateItem(name: "給食セット", done: false, imageName: "default_image14")
    static let scale = RoutineTemplateItem(name: "けんおん", done: false, imageName: "default_image17")
    static let mock2 = RoutineTemplateItem(name: "カレンダー", done: false, imageName: "default_image3")
    static let mock3 = RoutineTemplateItem(name: "お風呂", done: false, imageName: "default_image1")
    static let mock4 = RoutineTemplateItem(name: "お風呂", done: false, imageName: "default_image1")
    static let mock5 = RoutineTemplateItem(name: "かみをかわかす", done: false, imageName: "default_image7")
    static let mock6 = RoutineTemplateItem(name: "はみがきをする", done: false, imageName: "default_image11")
    // タオル
    static let mock7 = RoutineTemplateItem(name: "タオル", done: false, imageName: "default_image21")
    // 箸
    static let mock8 = RoutineTemplateItem(name: "おはし", done: false, imageName: "default_image19")
    // 給食セット
    static let mock9 = RoutineTemplateItem(name: "給食セット", done: false, imageName: "default_image14")
    
    static let mockThreeRoutines: [RoutineTemplateItem] = [mockEatRoutine, mockEToiletRoutine, mockWearRoutine]
    
    static let mockMorningRoutines: [RoutineTemplateItem] = [
        // きがえる・たべる・トイレ・水筒・給食セット・はみがきをする・タオル・おはし・ランチョンマット・上着
        .mockWearRoutine,
        .mockEatRoutine,
        .mockEToiletRoutine,
        .mockBottleRoutine,
        .mockGoodsRoutine,
        .mock6,
        .mock8,
        .mock9
        
    ]
    
    static let mockEveningRoutines: [RoutineTemplateItem] = [
        .mockWearRoutine,
        .mockEatRoutine,
        .mockEToiletRoutine,
        .mockBottleRoutine,
        .mockGoodsRoutine,
    ]
    
    static let mockSleepTimeRoutines: [RoutineTemplateItem] = [
        mockEToiletRoutine,
        mock3,
        mock2,
        mock5,
        mock6
    ]
}

//
//enum RoutineType: String, CaseIterable, Codable {
//    case morning = "あさのしたく"
//    case evening = "ゆうがたのしたく"
//    case sleepTime = "寝るまえのしたく"
//    
//}
