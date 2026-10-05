import Foundation
import SwiftData

@MainActor
struct PersistenceService {
    
    static func loadOrCreateSettings(context: ModelContext) -> UserSettings {
        let descriptor = FetchDescriptor<UserSettings>()
        let results = (try? context.fetch(descriptor)) ?? []
        if let existing = results.first {
            return existing
        }
        let settings = UserSettings()
        context.insert(settings)
        return settings
    }
    
    static func loadOrCreateJournalEntry(for date: Date, context: ModelContext) -> JournalEntry {
        let start = date.startOfDay
        let end = Calendar.current.date(byAdding: .day, value: 1, to: start) ?? start
        var descriptor = FetchDescriptor<JournalEntry>(
            predicate: #Predicate { $0.date >= start && $0.date < end }
        )
        descriptor.fetchLimit = 1
        let results = (try? context.fetch(descriptor)) ?? []
        if let existing = results.first {
            return existing
        }
        let entry = JournalEntry(date: start)
        context.insert(entry)
        return entry
    }
    
    static func loadOrCreateDailyPlan(
        for date: Date,
        habits: [Habit],
        settings: UserSettings,
        completions: [HabitCompletion],
        context: ModelContext
    ) -> DailyPlan {
        let start = date.startOfDay
        let end = Calendar.current.date(byAdding: .day, value: 1, to: start) ?? start
        var descriptor = FetchDescriptor<DailyPlan>(
            predicate: #Predicate { $0.date >= start && $0.date < end }
        )
        descriptor.fetchLimit = 1
        let results = (try? context.fetch(descriptor)) ?? []
        if let existing = results.first {
            return existing
        }
        
        // Generate a new plan
        let habitIds = HabitGenerationService.generatePlan(
            habits: habits,
            settings: settings,
            for: date,
            existingCompletions: completions
        )
        let plan = DailyPlan(date: start, habitIds: habitIds, intensity: "normal")
        context.insert(plan)
        return plan
    }
    
    static func completion(
        for habitId: UUID,
        on date: Date,
        completions: [HabitCompletion]
    ) -> HabitCompletion? {
        let start = date.startOfDay
        return completions.first {
            $0.habitId == habitId && Calendar.current.isDate($0.date, inSameDayAs: start)
        }
    }
    
    static func getOrCreateCompletion(
        for habitId: UUID,
        on date: Date,
        completions: [HabitCompletion],
        context: ModelContext
    ) -> HabitCompletion {
        if let existing = completion(for: habitId, on: date, completions: completions) {
            return existing
        }
        let newCompletion = HabitCompletion(habitId: habitId, date: date.startOfDay)
        context.insert(newCompletion)
        return newCompletion
    }
}
