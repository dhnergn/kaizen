import Foundation
import SwiftData

@Model
final class JournalEntry {
    var id: UUID
    var date: Date
    var morningIntention: String
    var eveningReflection: String
    var importantThoughts: String
    var goals: String

    init(
        id: UUID = UUID(),
        date: Date = Date().startOfDay,
        morningIntention: String = "",
        eveningReflection: String = "",
        importantThoughts: String = "",
        goals: String = ""
    ) {
        self.id = id
        self.date = date
        self.morningIntention = morningIntention
        self.eveningReflection = eveningReflection
        self.importantThoughts = importantThoughts
        self.goals = goals
    }

    var isEmpty: Bool {
        morningIntention.isEmpty && eveningReflection.isEmpty &&
        importantThoughts.isEmpty && goals.isEmpty
    }
}
