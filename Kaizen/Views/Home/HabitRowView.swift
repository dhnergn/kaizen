import SwiftUI

struct HabitRowView: View {
    let habit: Habit
    let isCompleted: Bool
    let onToggle: () -> Void
    let onTap: () -> Void
    
    var body: some View {
        KaizenCard {
            HStack(spacing: 14) {
                CheckboxButton(
                    isChecked: isCompleted,
                    color: habit.categoryEnum.color,
                    action: onToggle
                )
                
                Button(action: onTap) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(habit.name)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(isCompleted ? .secondary : .primary)
                            .strikethrough(isCompleted)
                        
                        HStack(spacing: 8) {
                            CategoryBadge(category: habit.categoryEnum, compact: true)
                            if habit.duration > 0 {
                                Text("\(habit.duration) min")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .buttonStyle(.plain)
                
                Spacer()
                
                Image(systemName: habit.iconName)
                    .font(.body)
                    .foregroundStyle(habit.categoryEnum.color.opacity(isCompleted ? 0.4 : 0.8))
            }
        }
        .opacity(isCompleted ? 0.7 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isCompleted)
    }
}
