import Foundation
import UserNotifications

@MainActor
final class NotificationService: ObservableObject {

    static let shared = NotificationService()
    private init() {}

    // MARK: - Authorisation

    func requestAuthorization() async -> Bool {
        let center = UNUserNotificationCenter.current()
        do {
            return try await center.requestAuthorization(options: [.alert, .sound, .badge])
        } catch {
            return false
        }
    }

    // MARK: - Recurring reminders

    func scheduleMorningReminder(hour: Int = 8, minute: Int = 0) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["morning_reminder"])

        let content = UNMutableNotificationContent()
        content.title = "Good morning"
        content.body  = "What is your One Thing today?"
        content.sound = .default

        var dc = DateComponents()
        dc.hour   = hour
        dc.minute = minute
        let trigger = UNCalendarNotificationTrigger(dateMatching: dc, repeats: true)
        let request = UNNotificationRequest(identifier: "morning_reminder", content: content, trigger: trigger)
        center.add(request)
    }

    func scheduleEveningReminder(hour: Int = 21, minute: Int = 0) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["evening_reminder"])

        let content = UNMutableNotificationContent()
        content.title = "End of day"
        content.body  = "Take 5 minutes to reflect on today."
        content.sound = .default

        var dc = DateComponents()
        dc.hour   = hour
        dc.minute = minute
        let trigger = UNCalendarNotificationTrigger(dateMatching: dc, repeats: true)
        let request = UNNotificationRequest(identifier: "evening_reminder", content: content, trigger: trigger)
        center.add(request)
    }

    // MARK: - Cancel all

    func cancelAllReminders() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
