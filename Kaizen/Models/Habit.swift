import Foundation
import SwiftData

@Model
final class Habit {
    var id: UUID
    var name: String
    var habitDescription: String
    var category: String
    var duration: Int
    var frequencyRaw: String
    var customDays: [Int]
    var difficulty: String
    var colorHex: String
    var iconName: String
    var isFromLibrary: Bool
    var isActive: Bool
    var sortOrder: Int
    var createdAt: Date
    var whyItMatters: String
    var todayInstruction: String
    var reflectionPrompt: String

    init(
        id: UUID = UUID(),
        name: String,
        habitDescription: String,
        category: String,
        duration: Int = 5,
        frequencyRaw: String = "daily",
        customDays: [Int] = [],
        difficulty: String = "medium",
        colorHex: String = "4A7C59",
        iconName: String = "checkmark.circle",
        isFromLibrary: Bool = false,
        isActive: Bool = true,
        sortOrder: Int = 0,
        createdAt: Date = Date(),
        whyItMatters: String = "",
        todayInstruction: String = "",
        reflectionPrompt: String = ""
    ) {
        self.id = id
        self.name = name
        self.habitDescription = habitDescription
        self.category = category
        self.duration = duration
        self.frequencyRaw = frequencyRaw
        self.customDays = customDays
        self.difficulty = difficulty
        self.colorHex = colorHex
        self.iconName = iconName
        self.isFromLibrary = isFromLibrary
        self.isActive = isActive
        self.sortOrder = sortOrder
        self.createdAt = createdAt
        self.whyItMatters = whyItMatters
        self.todayInstruction = todayInstruction
        self.reflectionPrompt = reflectionPrompt
    }

    var categoryEnum: HabitCategory {
        HabitCategory(rawValue: category) ?? .discipline
    }

    var frequencyEnum: HabitFrequency {
        HabitFrequency(rawValue: frequencyRaw) ?? .daily
    }

    /// Returns true if this habit should appear on the given date
    func isScheduled(on date: Date) -> Bool {
        switch frequencyEnum {
        case .daily:
            return true
        case .weekdays:
            let weekday = Calendar.current.component(.weekday, from: date)
            return (2...6).contains(weekday) // Mon–Fri
        case .weekends:
            let weekday = Calendar.current.component(.weekday, from: date)
            return weekday == 1 || weekday == 7 // Sun or Sat
        case .custom:
            // customDays stores 0=Sun, 1=Mon … 6=Sat
            let weekday = Calendar.current.component(.weekday, from: date) - 1
            return customDays.contains(weekday)
        }
    }
}

// MARK: - Frequency

enum HabitFrequency: String, CaseIterable, Codable {
    case daily    = "daily"
    case weekdays = "weekdays"
    case weekends = "weekends"
    case custom   = "custom"

    var displayName: String {
        switch self {
        case .daily:    return "Every Day"
        case .weekdays: return "Weekdays"
        case .weekends: return "Weekends"
        case .custom:   return "Custom Days"
        }
    }
}

// MARK: - Difficulty

enum HabitDifficulty: String, CaseIterable, Codable {
    case easy   = "easy"
    case medium = "medium"
    case hard   = "hard"

    var displayName: String {
        switch self {
        case .easy:   return "Easy"
        case .medium: return "Medium"
        case .hard:   return "Hard"
        }
    }

    var icon: String {
        switch self {
        case .easy:   return "1.circle.fill"
        case .medium: return "2.circle.fill"
        case .hard:   return "3.circle.fill"
        }
    }
}
