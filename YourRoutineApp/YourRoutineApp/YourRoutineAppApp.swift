//
//  YourRoutineAppApp.swift
//  YourRoutineApp
//
//  Created by 指原奈々 on 2025/04/19.
//

import SwiftUI
import SwiftData
import FirebaseCore
import FirebaseAnalytics
import YourRoutine

class AppDelegate: NSObject, UIApplicationDelegate {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct YourRoutineAppApp: App {
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.modelContext) private var modelContext
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            UserInfo.self,
            TodayData.self,
            Routine.self,
            RoutineTitle.self,
            RoutineTemplateItem.self,
            RoutineTitleTemplate.self,
            ImageData.self
        ])
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false)
//　マイグレーションエラー対策
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)


        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(\.colorScheme, resolveColorScheme() ?? .light)
                .onAppear() {
                    Analytics.setAnalyticsCollectionEnabled(true)
                    requestNotificationPermission()
                    scheduleNotification(title: "おはよう！", body: "今日の予定を確認しよう☀️", hour: 7, minute: 45)
                    scheduleNotification(title: "おかえり！", body: "おかたづけしよう", hour: 18, minute: 45)
                    if let image = UIImage(named: "default_image1.png") {
                        saveImageToAppGroup(image: image, fileName: "default_image1.png")
                    }
                    if let data = UserDefaults(suiteName: "group.com.nanasashihara.yourroutineapp")?.data(forKey: "pinnedImageData") {
                        print("💾 pinnedImageDataあります！サイズ: \(data.count)")
                    } else {
                        print("❌ pinnedImageDataが見つからない")
                    }
                }
        }
        .modelContainer(sharedModelContainer)
//        .onChange(of: scenePhase) { oldPhase, newPhase in
//            if newPhase == .active {
//                Task {
//                    await checkAndCreateTodayDataIfNeeded()
//                }
//            } else if newPhase == .inactive {
//                saveLastLoadedDate()
//            }
//        }
    }
        
    @AppStorage("colorSchemeMode") private var colorSchemeMode: String = "system"
    init (){
//        resetDatabase()
    }
    
    let appGroupID = "group.com.nanasashihara.yourroutineapp"
    
    private func resolveColorScheme() -> ColorScheme? {
        switch colorSchemeMode {
        case "dark": return .dark
        case "light": return .light
        default: return nil
        }
    }
    
    func saveImageToAppGroup(image: UIImage, fileName: String) -> Bool {
        guard let data = image.pngData() else { return false }
        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupID) else { return false }
        
        let defaults = UserDefaults(suiteName: appGroupID)
        let imageData = ImageData(fileName: "bath", category: .life, isPinned: false, timestamp: Date())
        if let encoded = try? JSONEncoder().encode(imageData) {
            defaults?.set(encoded, forKey: "pinnedImageData")
            print("📦 ImageData 保存成功")
        }

        
        let fileURL = containerURL.appendingPathComponent(fileName)
        
        do {
            try data.write(to: fileURL)
            return true
        } catch {
            print("画像の保存に失敗: \(error)")
            return false
        }
    }

    func resetDatabase() {
        let container = try? ModelContainer(for: TodayData.self)
        let storeURL = container?.configurations.first?.url

        if let storeURL {
            try? FileManager.default.removeItem(at: storeURL)
            print("💾 データベースを削除しました")
        }
    }
}
