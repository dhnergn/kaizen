import Foundation

extension Date {

    /// Midnight of this date in the current calendar
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }

    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }

    var isYesterday: Bool {
        Calendar.current.isDateInYesterday(self)
    }

    /// 1 = Sunday … 7 = Saturday (Gregorian)
    var weekday: Int {
        Calendar.current.component(.weekday, from: self)
    }

    var dayOfMonth: Int {
        Calendar.current.component(.day, from: self)
    }

    func isSameDay(as other: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: other)
    }

    func daysBack(_ count: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: -count, to: self) ?? self
    }

    // MARK: - Formatted strings

    var formatted_EEEE_MMMM_d: String {
        let f = DateFormatter()
        f.dateFormat = "EEEE, MMMM d"
        return f.string(from: self)
    }

    var formatted_MMMM_d_yyyy: String {
        let f = DateFormatter()
        f.dateFormat = "MMMM d, yyyy"
        return f.string(from: self)
    }

    // MARK: - Week helpers

    /// First day of the ISO week that contains this date
    var weekStartDate: Date {
        let calendar = Calendar.current
        let comps = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return calendar.date(from: comps) ?? self
    }

    /// All 7 days of the week that contains this date
    func datesOfWeek() -> [Date] {
        let start = weekStartDate
        return (0..<7).compactMap {
            Calendar.current.date(byAdding: .day, value: $0, to: start)
        }
    }

    // MARK: - Month helpers

    /// Every day in the given calendar month
    static func datesInMonth(year: Int, month: Int) -> [Date] {
        var components = DateComponents()
        components.year  = year
        components.month = month
        components.day   = 1
        guard
            let firstDay = Calendar.current.date(from: components),
            let range    = Calendar.current.range(of: .day, in: .month, for: firstDay)
        else { return [] }

        return range.compactMap { day -> Date? in
            var dc = components
            dc.day = day
            return Calendar.current.date(from: dc)
        }
    }
}
