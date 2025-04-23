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
            ImageData.self,
            ImageCount.self,
            WidgetTodayData.self
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
                        WidgetDataManager.shared.saveImageToAppGroup(image: image, fileName: "default_image1.png")
                    }
                    
                    if let data = UserDefaults(suiteName: "group.com.nanasashihara.yourroutineapp")?.data(forKey: "pinnedImageData") {
                        print("💾 pinnedImageDataあります！サイズ: \(data.count)")
                    } else {
                        print("❌ pinnedImageDataが見つからない")
                    }
                }
        }
        .modelContainer(sharedModelContainer)
    }
        
    @AppStorage("colorSchemeMode") private var colorSchemeMode: String = "system"
    init (){
        FirebaseApp.configure()
        UserDefaults.standard.set(true, forKey: "FIRAnalyticsDebugEnabled")

//        resetDatabase()
    }
    
    private func resolveColorScheme() -> ColorScheme? {
        switch colorSchemeMode {
        case "dark": return .dark
        case "light": return .light
        default: return nil
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
