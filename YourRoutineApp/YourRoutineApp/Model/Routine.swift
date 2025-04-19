//
//  Routine.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/10.
//

import Foundation
import SwiftData

@Model
final class Routine: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    var name: String
    var done: Bool
    var imageName: String
    @Relationship(inverse: \RoutineTitle.routines)
        var title: RoutineTitle?
    
    init(id: UUID, name: String, done: Bool, imageName: String) {
        self.id = id
        self.name = name
        self.done = done
        self.imageName = imageName
    }
    
    init(name: String, done: Bool, imageName: String) {
        self.name = name
        self.done = done
        self.imageName = imageName
    }
    
    static let mockWearRoutine = Routine(name: "きがえる", done: true, imageName: "wear")
    static let mockEatRoutine = Routine(name: "たべる", done: false, imageName: "eat")
    static let mockEToiletRoutine = Routine(name: "トイレ", done: false, imageName: "toilet")
    static let mockBottleRoutine = Routine(name: "水筒", done: false, imageName: "bottle")
    static let mockGoodsRoutine = Routine(name: "給食セット", done: false, imageName: "goods")
    static let scale = Routine(name: "けんおん", done: false, imageName: "scale")
    static let mock2 = Routine(name: "カレンダー", done: false, imageName: "calender")
    static let mock3 = Routine(name: "お風呂", done: false, imageName: "bath")
    static let mock4 = Routine(name: "お風呂", done: false, imageName: "bath")
    static let mock5 = Routine(name: "かみをかわかす", done: false, imageName: "dry")
    static let mock6 = Routine(name: "はみがきをする", done: false, imageName: "hamigaki")
    // タオル
    static let mock7 = Routine(name: "タオル", done: false, imageName: "towel_kake")
    // 箸
    static let mock8 = Routine(name: "おはし", done: false, imageName: "syokki_hashi_woman")
    // 給食セット
    static let mock9 = Routine(name: "給食セット", done: false, imageName: "kyusyoku_fukuro")
    
    static let mockThreeRoutines: [Routine] = [mockEatRoutine, mockEToiletRoutine, mockWearRoutine]
    
    static let mockMorningRoutines: [Routine] = [
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
    
    static let mockEveningRoutines: [Routine] = [
        .mockWearRoutine,
        .mockEatRoutine,
        .mockEToiletRoutine,
        .mockBottleRoutine,
        .mockGoodsRoutine,
    ]
    
    static let mockSleepTimeRoutines: [Routine] = [
        mockEToiletRoutine,
        mock3,
        mock2,
        mock5,
        mock6
    ]
}


enum RoutineType: String, CaseIterable, Codable {
    case morning = "あさのしたく"
    case evening = "ゆうがたのしたく"
    case sleepTime = "寝るまえのしたく"
    
}
