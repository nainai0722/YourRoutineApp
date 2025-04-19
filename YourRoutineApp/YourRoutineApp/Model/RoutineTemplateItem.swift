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
    
    static let mockWearRoutine = RoutineTemplateItem(name: "きがえる", done: true, imageName: "wear")
    static let mockEatRoutine = RoutineTemplateItem(name: "たべる", done: false, imageName: "eat")
    static let mockEToiletRoutine = RoutineTemplateItem(name: "トイレ", done: false, imageName: "toilet")
    static let mockBottleRoutine = RoutineTemplateItem(name: "水筒", done: false, imageName: "bottle")
    static let mockGoodsRoutine = RoutineTemplateItem(name: "給食セット", done: false, imageName: "goods")
    static let scale = RoutineTemplateItem(name: "けんおん", done: false, imageName: "scale")
    static let mock2 = RoutineTemplateItem(name: "カレンダー", done: false, imageName: "calender")
    static let mock3 = RoutineTemplateItem(name: "お風呂", done: false, imageName: "bath")
    static let mock4 = RoutineTemplateItem(name: "お風呂", done: false, imageName: "bath")
    static let mock5 = RoutineTemplateItem(name: "かみをかわかす", done: false, imageName: "dry")
    static let mock6 = RoutineTemplateItem(name: "はみがきをする", done: false, imageName: "hamigaki")
    // タオル
    static let mock7 = RoutineTemplateItem(name: "タオル", done: false, imageName: "towel_kake")
    // 箸
    static let mock8 = RoutineTemplateItem(name: "おはし", done: false, imageName: "syokki_hashi_woman")
    // 給食セット
    static let mock9 = RoutineTemplateItem(name: "給食セット", done: false, imageName: "kyusyoku_fukuro")
    
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
