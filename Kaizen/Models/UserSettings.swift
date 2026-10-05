import Foundation
import SwiftData

@Model
final class UserSettings {
    var dailyHabitLimit: Int
    var selectedCategories: [String]
    var notificationsEnabled: Bool
    var darkModePreference: String
    var startOfWeek: Int
    var onboardingCompleted: Bool
    var userName: String

    init(
        dailyHabitLimit: Int = 5,
        selectedCategories: [String] = HabitCategory.allCases.map(\.rawValue),
        notificationsEnabled: Bool = true,
        darkModePreference: String = "system",
        startOfWeek: Int = 1,
        onboardingCompleted: Bool = false,
        userName: String = ""
    ) {
        self.dailyHabitLimit = dailyHabitLimit
        self.selectedCategories = selectedCategories
        self.notificationsEnabled = notificationsEnabled
        self.darkModePreference = darkModePreference
        self.startOfWeek = startOfWeek
        self.onboardingCompleted = onboardingCompleted
        self.userName = userName
    }
}
