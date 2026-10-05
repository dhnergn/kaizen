import SwiftUI

struct StreakView: View {
    let current: Int
    let best: Int
    
    var body: some View {
        HStack(spacing: 24) {
            streakItem(value: current, label: "Current Streak", icon: "flame.fill", color: .kaizenWarm)
            Divider().frame(height: 40)
            streakItem(value: best, label: "Best Streak", icon: "trophy.fill", color: Color(hex: "E8C547"))
        }
        .padding(.vertical, 4)
    }
    
    private func streakItem(value: Int, label: String, icon: String, color: Color) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundStyle(color)
                .font(.title3)
            VStack(alignment: .leading, spacing: 1) {
                Text("\(value) day\(value == 1 ? "" : "s")")
                    .font(.headline)
                    .fontWeight(.bold)
                Text(label)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
