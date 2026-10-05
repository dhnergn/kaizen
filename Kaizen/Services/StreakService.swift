import Foundation
import SwiftData

@MainActor
struct StreakService {

    struct StreakResult {
        var current: Int
        var best: Int
    }

    /// Calculates the current and best completion streaks from a list of completions.
    static func calculate(
        completions: [HabitCompletion],
        from today: Date = Date()
    ) -> StreakResult {
        let calendar = Calendar.current
        let dayStart = today.startOfDay

        // Build a set of unique days that had at least one completed entry
        let completedDays = Set(
            completions
                .filter { $0.completed }
                .map { calendar.startOfDay(for: $0.date) }
        )

        // Current streak: walk backwards from today
        var currentStreak = 0
        var checkDate = dayStart
        while completedDays.contains(checkDate) {
            currentStreak += 1
            checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate) ?? checkDate.daysBack(1)
        }

        // Best streak: single pass over sorted days
        var bestStreak = 0
        var runningStreak = 0
        var previousDay: Date? = nil

        for day in completedDays.sorted() {
            if let prev = previousDay,
               let expectedNext = calendar.date(byAdding: .day, value: 1, to: prev),
               calendar.isDate(expectedNext, inSameDayAs: day) {
                runningStreak += 1
            } else {
                runningStreak = 1
            }
            bestStreak = max(bestStreak, runningStreak)
            previousDay = day
        }

        return StreakResult(current: currentStreak, best: bestStreak)
    }
}
