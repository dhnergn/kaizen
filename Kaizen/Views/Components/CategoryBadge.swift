import SwiftUI

struct CategoryBadge: View {
    let category: HabitCategory
    var compact: Bool = false
    
    var body: some View {
        Label {
            if !compact {
                Text(category.rawValue)
                    .font(.caption2)
                    .fontWeight(.semibold)
            }
        } icon: {
            Image(systemName: category.icon)
                .font(compact ? .caption2 : .caption)
        }
        .foregroundStyle(category.color)
        .padding(.horizontal, compact ? 6 : 8)
        .padding(.vertical, compact ? 3 : 4)
        .background(category.color.opacity(0.12))
        .clipShape(Capsule())
    }
}
