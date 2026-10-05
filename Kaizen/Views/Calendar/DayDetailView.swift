import SwiftUI
import SwiftData

struct DayDetailView: View {
    let date: Date
    let plans: [DailyPlan]
    let completions: [HabitCompletion]
    
    @Query private var allHabits: [Habit]
    
    private var plan: DailyPlan? {
        plans.first { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
    
    private var dayCompletions: [HabitCompletion] {
        completions.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(date.formatted_EEEE_MMMM_d)
                .font(.headline)
            
            if let plan = plan, !plan.habitIds.isEmpty {
                if !plan.oneThing.isEmpty {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("One Thing")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(plan.oneThing)
                            .font(.subheadline)
                    }
                    .padding(.bottom, 8)
                }
                
                VStack(spacing: 10) {
                    ForEach(plan.habitIds, id: \.self) { habitId in
                        if let habit = allHabits.first(where: { $0.id == habitId }) {
                            let completed = dayCompletions.first(where: { $0.habitId == habitId })?.completed ?? false
                            HStack(spacing: 12) {
                                Image(systemName: completed ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(completed ? habit.categoryEnum.color : .secondary)
                                Text(habit.name)
                                    .font(.subheadline)
                                    .foregroundStyle(completed ? .secondary : .primary)
                                    .strikethrough(completed)
                                Spacer()
                            }
                        }
                    }
                }
            } else {
                Text("No habits scheduled for this day.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}
