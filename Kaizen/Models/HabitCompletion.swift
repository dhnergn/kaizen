import Foundation
import SwiftData

@Model
final class HabitCompletion {
    var id: UUID
    var habitId: UUID
    var date: Date
    var completed: Bool
    var completedAt: Date?
    var reflection: String

    init(
        id: UUID = UUID(),
        habitId: UUID,
        date: Date,
        completed: Bool = false,
        completedAt: Date? = nil,
        reflection: String = ""
    ) {
        self.id = id
        self.habitId = habitId
        self.date = date
        self.completed = completed
        self.completedAt = completedAt
        self.reflection = reflection
    }
}
