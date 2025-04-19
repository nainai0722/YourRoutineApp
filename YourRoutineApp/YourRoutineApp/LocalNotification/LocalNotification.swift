//
//  LocalNotification.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/04/18.
//

import UserNotifications

func requestNotificationPermission() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
        #if DEBUG
        if granted {
            print("通知の許可がされました！")
        } else {
            print("通知の許可がされませんでした")
        }
        #endif
    }
}

func scheduleNotification(title: String, body: String, hour: Int, minute: Int) {
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = body
    content.sound = .default

    var dateComponents = DateComponents()
    dateComponents.hour = hour
    dateComponents.minute = minute

    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            print("通知の登録に失敗: \(error.localizedDescription)")
        } else {
            print("通知が登録されました！")
        }
    }
}
