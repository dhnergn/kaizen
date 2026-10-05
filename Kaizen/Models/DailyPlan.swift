import Foundation
import SwiftData

@Model
final class DailyPlan {
    var id: UUID
    var date: Date
    var habitIds: [UUID]
    var oneThing: String
    var intensity: String

    init(
        id: UUID = UUID(),
        date: Date = Date().startOfDay,
        habitIds: [UUID] = [],
        oneThing: String = "",
        intensity: String = "normal"
    ) {
        self.id = id
        self.date = date
        self.habitIds = habitIds
        self.oneThing = oneThing
        self.intensity = intensity
    }

    var intensityEnum: DayIntensity {
        DayIntensity(rawValue: intensity) ?? .normal
    }

    var limit: Int { intensityEnum.limit }
}

enum DayIntensity: String, CaseIterable, Codable {
    case light  = "light"
    case normal = "normal"
    case deep   = "deep"

    var limit: Int {
        switch self {
        case .light:  return 3
        case .normal: return 5
        case .deep:   return 7
        }
    }

    var displayName: String {
        switch self {
        case .light:  return "Light Day"
        case .normal: return "Normal Day"
        case .deep:   return "Deep Day"
        }
    }

    var subtitle: String {
        switch self {
        case .light:  return "3 habits"
        case .normal: return "5 habits"
        case .deep:   return "7 habits"
        }
    }

    var icon: String {
        switch self {
        case .light:  return "leaf"
        case .normal: return "sun.max"
        case .deep:   return "flame"
        }
    }
}
