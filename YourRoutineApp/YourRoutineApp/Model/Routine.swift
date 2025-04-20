//
//  Routine.swift
//  YourRoutineApp
//
//  Created by 指原奈々 on 2025/03/10.
//

import Foundation
import SwiftData

@Model
final class Routine: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    var templateId: UUID?
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
    
    static let mockWearRoutine = Routine(name: "きがえる", done: true, imageName: "default_image22")
    static let mockEatRoutine = Routine(name: "たべる", done: false, imageName: "default_image8")
    static let mockEToiletRoutine = Routine(name: "トイレ", done: false, imageName: "default_image20")
    static let mockBottleRoutine = Routine(name: "水筒", done: false, imageName: "default_image2")
    static let mockGoodsRoutine = Routine(name: "給食セット", done: false, imageName: "default_image14")
    static let scale = Routine(name: "けんおん", done: false, imageName: "default_image17")
    static let mock2 = Routine(name: "カレンダー", done: false, imageName: "default_image3")
    static let mock3 = Routine(name: "お風呂", done: false, imageName: "default_image1")
    static let mock4 = Routine(name: "お風呂", done: false, imageName: "default_image1")
    static let mock5 = Routine(name: "かみをかわかす", done: false, imageName: "default_image7")
    static let mock6 = Routine(name: "はみがきをする", done: false, imageName: "default_image11")
    // タオル
    static let mock7 = Routine(name: "タオル", done: false, imageName: "default_image21")
    // 箸
    static let mock8 = Routine(name: "おはし", done: false, imageName: "default_image19")
    // 給食セット
    static let mock9 = Routine(name: "給食セット", done: false, imageName: "default_image14")
    
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
