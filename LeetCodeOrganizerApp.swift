import SwiftUI
import UserNotifications

@main
struct LeetCodeOrganizerApp: App {
    init() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("✅ Notifications authorized on launch")
            } else {
                print("❌ Notification permission denied on launch")
            }
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
