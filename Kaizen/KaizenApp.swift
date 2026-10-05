import SwiftUI
import SwiftData

@main
struct KaizenApp: App {
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            UserSettings.self,
            Habit.self,
            HabitCompletion.self,
            JournalEntry.self,
            DailyPlan.self,
            WeeklyReview.self
        ])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(sharedModelContainer)
    }
}
