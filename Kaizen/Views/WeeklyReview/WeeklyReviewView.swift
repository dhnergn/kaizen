import SwiftUI
import SwiftData

struct WeeklyReviewView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var reviews: [WeeklyReview]
    @Query private var plans: [DailyPlan]
    @Query private var completions: [HabitCompletion]
    
    @State private var viewModel = SettingsViewModel()
    
    @State private var whatWorked: String = ""
    @State private var whatToChange: String = ""
    @State private var mainFocus: String = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    let stats = viewModel.computeWeeklyStats(plans: plans, completions: completions)
                    
                    // MARK: - Stats
                    KaizenCard {
                        VStack(spacing: 16) {
                            Text("This Week's Consistency")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            
                            HStack(spacing: 40) {
                                VStack {
                                    Text("\(Int(stats.rate * 100))%")
                                        .font(.system(size: 36, weight: .bold))
                                        .foregroundStyle(.kaizenAccent)
                                    Text("Completion Rate")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                
                                VStack {
                                    Text("\(stats.completedCount)")
                                        .font(.system(size: 36, weight: .bold))
                                    Text("Habits Completed")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal)
                    
                    // MARK: - Reflection Form
                    VStack(alignment: .leading, spacing: 20) {
                        reviewField(
                            title: "What worked well this week?",
                            text: $whatWorked
                        )
                        
                        reviewField(
                            title: "What needs to change next week?",
                            text: $whatToChange
                        )
                        
                        reviewField(
                            title: "What is your main focus for next week?",
                            text: $mainFocus
                        )
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Weekly Review")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") { dismiss() }
                        .tint(.secondary)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") { save(stats: stats) }
                        .fontWeight(.semibold)
                        .tint(.kaizenAccent)
                }
            }
            .onAppear {
                if let review = viewModel.weeklyReview(from: reviews) {
                    whatWorked = review.whatWorked
                    whatToChange = review.whatToChange
                    mainFocus = review.mainFocus
                }
            }
        }
    }
    
    private func reviewField(title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            TextEditor(text: text)
                .frame(minHeight: 100)
                .padding(8)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
    }
    
    private func save(stats: (completedCount: Int, totalCount: Int, rate: Double)) {
        if let review = viewModel.weeklyReview(from: reviews) {
            review.whatWorked = whatWorked
            review.whatToChange = whatToChange
            review.mainFocus = mainFocus
            review.completedCount = stats.completedCount
            review.totalCount = stats.totalCount
            review.completionRate = stats.rate
        } else {
            let review = WeeklyReview(
                weekStartDate: Date().weekStartDate,
                whatWorked: whatWorked,
                whatToChange: whatToChange,
                mainFocus: mainFocus,
                completionRate: stats.rate,
                completedCount: stats.completedCount,
                totalCount: stats.totalCount
            )
            modelContext.insert(review)
        }
        try? modelContext.save()
        dismiss()
    }
}
