import SwiftUI
import UserNotifications
import Combine

struct SettingsView: View {
    @AppStorage("sortPreference") private var sortPreference: String = "By Time Added"
    @AppStorage("notificationFrequency") private var notificationFrequency: String = "Daily" {
        didSet {
            handleNotificationPreferenceChange()
        }
    }

    @ObservedObject var viewModel: ProblemViewModel

    let sortOptions = ["By Time Added", "Alphabetical", "By Completed"]
    let notificationOptions = ["Daily", "Every 3 Days", "Weekly", "Off"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("SORTING PREFERENCE").foregroundColor(.orange)) {
                    Picker("Sort Problems By", selection: $sortPreference) {
                        ForEach(sortOptions, id: \ .self) { option in
                            Text(option).foregroundColor(.white)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onChange(of: sortPreference) { _ in
                        applySortPreference()
                    }
                }
                .listRowBackground(Color(white: 0.8))

                Section(header: Text("NOTIFICATION SETTINGS").foregroundColor(.orange)) {
                    Picker("Reminder Frequency", selection: $notificationFrequency) {
                        ForEach(notificationOptions, id: \ .self) { option in
                            Text(option).foregroundColor(.white)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                .listRowBackground(Color(white: 0.8))

                Section(header: Text("DATA MANAGEMENT").foregroundColor(.orange)) {
                    Button {
                        exportProblems()
                    } label: {
                        Text("Export Problems")
                            .foregroundColor(.black)
                    }
                    .listRowBackground(Color(white: 0.8))

                    Button {
                        importProblems()
                    } label: {
                        Text("Import Problems")
                            .foregroundColor(.black)
                    }
                    .listRowBackground(Color(white: 0.8))

                    Button(role: .destructive) {
                        clearAllProblems()
                    } label: {
                        Text("Clear All Problems")
                            .foregroundColor(.red)
                    }
                    .listRowBackground(Color(white: 0.8))
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.black)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
        .background(Color.black.ignoresSafeArea())
        .onAppear {
            NotificationManager.requestPermission()
        }
    }

    func clearAllProblems() {
        viewModel.problems.removeAll()
        viewModel.saveProblems()
    }

    func exportProblems() {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(viewModel.problems)

            let url = getDocumentsDirectory().appendingPathComponent("problems_export.json")
            try data.write(to: url)

            print("Exported to \(url)")
        } catch {
            print("Failed to export: \(error)")
        }
    }

    func importProblems() {
        let url = getDocumentsDirectory().appendingPathComponent("problems_export.json")
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let imported = try decoder.decode([LeetCodeProblem].self, from: data)
            viewModel.problems = imported
            viewModel.saveProblems()
            print("Imported \(imported.count) problems")
        } catch {
            print("Failed to import: \(error)")
        }
    }

    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    func handleNotificationPreferenceChange() {
        switch notificationFrequency {
        case "Daily":
            NotificationManager.scheduleDailyNotification()
        default:
            NotificationManager.cancelNotifications()
        }
    }

    func applySortPreference() {
        switch sortPreference {
        case "Alphabetical":
            viewModel.problems.sort { $0.title.lowercased() < $1.title.lowercased() }
        case "By Completed":
            viewModel.problems.sort { ($0.isCompleted ? 0 : 1) < ($1.isCompleted ? 0 : 1) }
        case "By Time Added":
            viewModel.loadProblems() // restore natural order
        default:
            break
        }
    }
}

struct NotificationManager {
    static func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("✅ Notifications allowed")
            } else {
                print("❌ Notifications denied")
            }
        }
    }

    static func scheduleDailyNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Time to LeetCode 💻"
        content.body = "Let's solve a LC problem today and organize it in our app! :)"
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = 9

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyLCReminder", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Failed to schedule: \(error)")
            } else {
                print("✅ Notification scheduled")
            }
        }
    }

    static func cancelNotifications() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["dailyLCReminder"])
    }
}
