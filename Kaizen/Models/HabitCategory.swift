import SwiftUI

enum HabitCategory: String, CaseIterable, Codable, Identifiable {
    case mind = "Mind"
    case body = "Body"
    case learning = "Learning"
    case productivity = "Productivity"
    case communication = "Communication"
    case purpose = "Purpose"
    case discipline = "Discipline"
    case reflection = "Reflection"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .mind:          return "brain.head.profile"
        case .body:          return "figure.walk"
        case .learning:      return "book.closed.fill"
        case .productivity:  return "target"
        case .communication: return "bubble.left.and.bubble.right.fill"
        case .purpose:       return "star.fill"
        case .discipline:    return "flame.fill"
        case .reflection:    return "moon.stars.fill"
        }
    }

    var color: Color {
        switch self {
        case .mind:          return Color(hex: "7B68EE")
        case .body:          return Color(hex: "4CAF82")
        case .learning:      return Color(hex: "F4A261")
        case .productivity:  return Color(hex: "4A7C59")
        case .communication: return Color(hex: "45B7D1")
        case .purpose:       return Color(hex: "E8C547")
        case .discipline:    return Color(hex: "C17767")
        case .reflection:    return Color(hex: "9B8FB5")
        }
    }
}
