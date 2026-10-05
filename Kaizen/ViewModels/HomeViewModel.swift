import Foundation
import SwiftData
import SwiftUI

@MainActor
@Observable
final class HomeViewModel {
    
    // MARK: - Published State
    var todaysPlan: DailyPlan?
    var todaysHabits: [Habit] = []
    var todaysCompletions: [HabitCompletion] = []
    var settings: UserSettings?
    var currentStreak: Int = 0
    var bestStreak: Int = 0
    var isLoading: Bool = false
    
    private var modelContext: ModelContext?
    
    var completedCount: Int {
        todaysCompletions.filter { $0.completed }.count
    }
    
    var totalCount: Int {
        todaysHabits.count
    }
    
    var progressFraction: Double {
        guard totalCount > 0 else { return 0 }
        return Double(completedCount) / Double(totalCount)
    }
    
    var greetingName: String {
        settings?.userName.isEmpty == false ? settings!.userName : "there"
    }
    
    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good morning"
        case 12..<17: return "Good afternoon"
        case 17..<21: return "Good evening"
        default: return "Good night"
        }
    }
    
    var oneThing: String {
        todaysPlan?.oneThing ?? ""
    }
    
    // MARK: - Load
    func load(
        habits: [Habit],
        completions: [HabitCompletion],
        plans: [DailyPlan],
        settings: UserSettings?,
        context: ModelContext
    ) {
        self.modelContext = context
        self.settings = settings
        
        let today = Date().startOfDay
        
        // Find or create today's plan
        if let plan = plans.first(where: { Calendar.current.isDate($0.date, inSameDayAs: today) }) {
            self.todaysPlan = plan
        } else if let settings = settings {
            let plan = PersistenceService.loadOrCreateDailyPlan(
                for: today,
                habits: habits,
                settings: settings,
                completions: completions,
                context: context
            )
            self.todaysPlan = plan
        }
        
        // Habits for today
        guard let plan = todaysPlan else {
            todaysHabits = []
            todaysCompletions = []
            return
        }
        
        todaysHabits = plan.habitIds.compactMap { id in
            habits.first { $0.id == id }
        }
        
        todaysCompletions = completions.filter {
            Calendar.current.isDate($0.date, inSameDayAs: today)
        }
        
        // Streaks
        let streak = StreakService.calculate(completions: completions)
        currentStreak = streak.current
        bestStreak = streak.best
    }
    
    // MARK: - Toggle Completion
    func toggleCompletion(for habit: Habit, context: ModelContext) {
        let today = Date().startOfDay
        
        let allCompletions: [HabitCompletion] = (try? context.fetch(FetchDescriptor<HabitCompletion>())) ?? []
        let completion = PersistenceService.getOrCreateCompletion(
            for: habit.id,
            on: today,
            completions: allCompletions,
            context: context
        )
        
        completion.completed.toggle()
        completion.completedAt = completion.completed ? Date() : nil
        
        try? context.save()
        
        // Refresh local completions list
        if completion.completed && !todaysCompletions.contains(where: { $0.id == completion.id }) {
            todaysCompletions.append(completion)
        } else if !completion.completed {
            todaysCompletions = todaysCompletions.map { c in
                c.id == completion.id ? completion : c
            }
        }
    }
    
    func isCompleted(_ habit: Habit) -> Bool {
        todaysCompletions.first(where: { $0.habitId == habit.id })?.completed ?? false
    }
    
    func saveOneThing(_ text: String, context: ModelContext) {
        todaysPlan?.oneThing = text
        try? context.save()
    }
    
    func regeneratePlan(habits: [Habit], settings: UserSettings, completions: [HabitCompletion], context: ModelContext) {
        let today = Date().startOfDay
        let newIds = HabitGenerationService.generatePlan(
            habits: habits,
            settings: settings,
            for: today,
            existingCompletions: completions
        )
        todaysPlan?.habitIds = newIds
        todaysHabits = newIds.compactMap { id in habits.first { $0.id == id } }
        try? context.save()
    }
}
