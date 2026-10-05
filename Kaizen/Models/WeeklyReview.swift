import Foundation
import SwiftData

@Model
final class WeeklyReview {
    var id: UUID
    var weekStartDate: Date
    var whatWorked: String
    var whatToChange: String
    var mainFocus: String
    var completionRate: Double
    var completedCount: Int
    var totalCount: Int

    init(
        id: UUID = UUID(),
        weekStartDate: Date,
        whatWorked: String = "",
        whatToChange: String = "",
        mainFocus: String = "",
        completionRate: Double = 0,
        completedCount: Int = 0,
        totalCount: Int = 0
    ) {
        self.id = id
        self.weekStartDate = weekStartDate
        self.whatWorked = whatWorked
        self.whatToChange = whatToChange
        self.mainFocus = mainFocus
        self.completionRate = completionRate
        self.completedCount = completedCount
        self.totalCount = totalCount
    }
}
