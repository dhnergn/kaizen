import Foundation
import SwiftData
import SwiftUI

@MainActor
@Observable
final class CalendarViewModel {
    
    var displayedMonth: Date = Date()
    var selectedDate: Date? = nil
    
    var monthYear: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: displayedMonth)
    }
    
    var daysInMonth: [Date?] {
        let calendar = Calendar.current
        guard let monthStart = calendar.date(
            from: calendar.dateComponents([.year, .month], from: displayedMonth)
        ) else { return [] }
        
        let range = calendar.range(of: .day, in: .month, for: monthStart)!
        let firstWeekday = calendar.component(.weekday, from: monthStart) - 1 // 0-indexed
        
        var days: [Date?] = Array(repeating: nil, count: firstWeekday)
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: monthStart) {
                days.append(date)
            }
        }
        return days
    }
    
    func completionRate(for date: Date, completions: [HabitCompletion], plans: [DailyPlan]) -> Double {
        guard let plan = plans.first(where: { Calendar.current.isDate($0.date, inSameDayAs: date) }),
              !plan.habitIds.isEmpty else { return 0 }
        let dayCompletions = completions.filter {
            $0.completed && Calendar.current.isDate($0.date, inSameDayAs: date)
        }
        return Double(dayCompletions.count) / Double(plan.habitIds.count)
    }
    
    func navigateMonth(by value: Int) {
        displayedMonth = Calendar.current.date(
            byAdding: .month, value: value, to: displayedMonth
        ) ?? displayedMonth
    }
}
