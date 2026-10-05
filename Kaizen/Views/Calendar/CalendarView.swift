import SwiftUI
import SwiftData

struct CalendarView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var completions: [HabitCompletion]
    @Query private var plans: [DailyPlan]
    
    @State private var viewModel = CalendarViewModel()
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    private let weekDays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // MARK: - Header (Month Navigation)
                    HStack {
                        Button {
                            viewModel.navigateMonth(by: -1)
                        } label: {
                            Image(systemName: "chevron.left")
                                .padding()
                        }
                        
                        Spacer()
                        
                        Text(viewModel.monthYear)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Button {
                            viewModel.navigateMonth(by: 1)
                        } label: {
                            Image(systemName: "chevron.right")
                                .padding()
                        }
                    }
                    .tint(.primary)
                    .padding(.horizontal)
                    
                    // MARK: - Weekday Labels
                    HStack {
                        ForEach(weekDays, id: \.self) { day in
                            Text(day)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.horizontal)
                    
                    // MARK: - Calendar Grid
                    KaizenCard {
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(0..<viewModel.daysInMonth.count, id: \.self) { index in
                                if let date = viewModel.daysInMonth[index] {
                                    DayCell(
                                        date: date,
                                        completionRate: viewModel.completionRate(for: date, completions: completions, plans: plans),
                                        isSelected: viewModel.selectedDate == date,
                                        onTap: { viewModel.selectedDate = date }
                                    )
                                } else {
                                    Color.clear
                                        .frame(height: 40)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // MARK: - Selected Day Detail
                    if let selectedDate = viewModel.selectedDate {
                        DayDetailView(
                            date: selectedDate,
                            plans: plans,
                            completions: completions
                        )
                        .padding(.horizontal)
                    }
                    
                }
                .padding(.vertical)
            }
            .navigationTitle("Calendar")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.systemBackground))
        }
    }
}

struct DayCell: View {
    let date: Date
    let completionRate: Double
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                Circle()
                    .fill(color(for: completionRate))
                    .frame(height: 40)
                    .overlay(
                        Circle()
                            .strokeBorder(isSelected ? Color.primary : Color.clear, lineWidth: 2)
                    )
                
                Text("\(date.dayOfMonth)")
                    .font(.subheadline)
                    .foregroundStyle(textColor(for: completionRate))
            }
        }
        .buttonStyle(.plain)
    }
    
    private func color(for rate: Double) -> Color {
        if rate == 0 { return Color(.tertiarySystemBackground) }
        if rate < 0.5 { return Color.kaizenAccent.opacity(0.3) }
        if rate < 1.0 { return Color.kaizenAccent.opacity(0.6) }
        return Color.kaizenAccent
    }
    
    private func textColor(for rate: Double) -> Color {
        if rate == 0 { return .primary }
        if rate < 0.5 { return .primary }
        return .white
    }
}
