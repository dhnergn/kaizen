import Foundation
import SwiftData

@MainActor
struct HabitGenerationService {

    /// Generates an ordered list of habit IDs for the given date.
    /// Respects active state, schedule, selected categories, and daily limit.
    /// Habits with fewer recent completions are prioritised; variety across categories
    /// is preferred in the first pass.
    static func generatePlan(
        habits: [Habit],
        settings: UserSettings,
        for date: Date,
        existingCompletions: [HabitCompletion]
    ) -> [UUID] {
        let limit = settings.dailyHabitLimit
        let selectedCategories = Set(settings.selectedCategories)

        // Filter: active, scheduled today, in a selected category
        let eligible = habits.filter {
            $0.isActive &&
            $0.isScheduled(on: date) &&
            selectedCategories.contains($0.category)
        }

        guard !eligible.isEmpty else { return [] }

        // Completion history for the last 7 days – used for recency weighting
        let sevenDaysAgo = date.daysBack(7)
        let recentCompletionsByHabit = Dictionary(
            grouping: existingCompletions.filter { $0.completed && $0.date >= sevenDaysAgo },
            by: \.habitId
        ).mapValues(\.count)

        // Score: fewer recent completions → higher selection priority
        let scored = eligible
            .map { habit -> (Habit, Int) in
                let recentCount = recentCompletionsByHabit[habit.id] ?? 0
                return (habit, recentCount)
            }
            .sorted { $0.1 < $1.1 }

        var selected: [Habit] = []
        var usedCategories: Set<String> = []

        // First pass: one habit per category to maximise variety
        for (habit, _) in scored {
            if selected.count >= limit { break }
            if !usedCategories.contains(habit.category) {
                selected.append(habit)
                usedCategories.insert(habit.category)
            }
        }

        // Second pass: fill remaining slots with least-recently-completed habits
        for (habit, _) in scored {
            if selected.count >= limit { break }
            if !selected.contains(where: { $0.id == habit.id }) {
                selected.append(habit)
            }
        }

        return selected.prefix(limit).map(\.id)
    }
}
