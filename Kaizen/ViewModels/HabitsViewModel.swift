import Foundation
import SwiftData
import SwiftUI

@MainActor
@Observable
final class HabitsViewModel {
    
    var searchText: String = ""
    var selectedCategory: HabitCategory? = nil
    var showAddHabit: Bool = false
    var habitToEdit: Habit? = nil
    
    func filteredHabits(_ habits: [Habit]) -> [Habit] {
        habits.filter { habit in
            guard habit.isActive else { return false }
            let matchesCategory = selectedCategory == nil || habit.category == selectedCategory!.rawValue
            let matchesSearch = searchText.isEmpty ||
                habit.name.localizedCaseInsensitiveContains(searchText) ||
                habit.habitDescription.localizedCaseInsensitiveContains(searchText)
            return matchesCategory && matchesSearch
        }
        .sorted { $0.sortOrder < $1.sortOrder }
    }
    
    func groupedHabits(_ habits: [Habit]) -> [(HabitCategory, [Habit])] {
        let filtered = filteredHabits(habits)
        var groups: [(HabitCategory, [Habit])] = []
        for category in HabitCategory.allCases {
            let categoryHabits = filtered.filter { $0.category == category.rawValue }
            if !categoryHabits.isEmpty {
                groups.append((category, categoryHabits))
            }
        }
        return groups
    }
    
    func deleteHabit(_ habit: Habit, context: ModelContext) {
        habit.isActive = false
        try? context.save()
    }
    
    func addHabitsFromLibrary(_ templates: [HabitTemplate], context: ModelContext) {
        for (index, template) in templates.enumerated() {
            let habit = template.toHabit()
            habit.sortOrder = index
            context.insert(habit)
        }
        try? context.save()
    }
}
