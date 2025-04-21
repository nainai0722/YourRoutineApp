//
//  AppStatusManager.swift
//  YourRoutineApp
//
//  Created by 指原奈々 on 2025/04/20.
//

import Foundation
import SwiftUI

struct AppStatusManager {
    @AppStorage("isHintShown") static var isHintShown: Bool = true
    @AppStorage("isFirstLaunch") static var isFirstLaunch: Bool = true
    
}

//    static var isFirstLaunch: Bool {
//        get {
//            !UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
//        }
//        set {
//            UserDefaults.standard.set(!newValue, forKey: "hasLaunchedBefore")
//        }
//    }
//
//    static var isHintShown: Bool {
//        get {
//            UserDefaults.standard.bool(forKey: "isHintShown")
//        }
//        set {
//            UserDefaults.standard.set(newValue, forKey: "isHintShown")
//        }
//    }


