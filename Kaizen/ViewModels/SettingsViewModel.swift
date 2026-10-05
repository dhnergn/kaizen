import Foundation
import SwiftData
import SwiftUI

@MainActor
@Observable
final class SettingsViewModel {
    
    var showWeeklyReview: Bool = false
    
    func updateDailyLimit(_ limit: Int, settings: UserSettings, context: ModelContext) {
        settings.dailyHabitLimit = limit
        try? context.save()
    }
    
    func toggleCategory(_ category: HabitCategory, settings: UserSettings, context: ModelContext) {
        if settings.selectedCategories.contains(category.rawValue) {
            settings.selectedCategories.removeAll { $0 == category.rawValue }
        } else {
            settings.selectedCategories.append(category.rawValue)
        }
        try? context.save()
    }
    
    func toggleNotifications(_ enabled: Bool, settings: UserSettings, context: ModelContext) {
        settings.notificationsEnabled = enabled
        try? context.save()
        if enabled {
            Task {
                let granted = await NotificationService.shared.requestAuthorization()
                if granted {
                    NotificationService.shared.scheduleMorningReminder()
                    NotificationService.shared.scheduleEveningReminder()
                }
            }
        } else {
            NotificationService.shared.cancelAllNotifications()
        }
    }
    
    func weeklyReview(from reviews: [WeeklyReview]) -> WeeklyReview? {
        let weekStart = Date().weekStartDate
        return reviews.first { Calendar.current.isDate($0.weekStartDate, inSameDayAs: weekStart) }
    }
    
    func computeWeeklyStats(
        plans: [DailyPlan],
        completions: [HabitCompletion]
    ) -> (completedCount: Int, totalCount: Int, rate: Double) {
        let weekDates = Date().datesOfWeek()
        let weekPlans = plans.filter { plan in
            weekDates.contains { Calendar.current.isDate($0, inSameDayAs: plan.date) }
        }
        let total = weekPlans.reduce(0) { $0 + $1.habitIds.count }
        let completed = completions.filter { c in
            c.completed && weekDates.contains { Calendar.current.isDate($0, inSameDayAs: c.date) }
        }.count
        let rate = total > 0 ? Double(completed) / Double(total) : 0
        return (completed, total, rate)
    }
}
