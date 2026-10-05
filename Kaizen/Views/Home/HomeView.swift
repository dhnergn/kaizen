import SwiftUI
import SwiftData

struct HomeView: View {
    let settings: UserSettings
    
    @Environment(\.modelContext) private var modelContext
    @Query private var habits: [Habit]
    @Query private var completions: [HabitCompletion]
    @Query private var plans: [DailyPlan]
    
    @State private var viewModel = HomeViewModel()
    @State private var selectedHabit: Habit? = nil
    @State private var showOneThingEditor = false
    @State private var oneThingText = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // MARK: - Header
                    headerSection
                    
                    // MARK: - Progress
                    progressSection
                    
                    // MARK: - One Thing
                    if !viewModel.oneThing.isEmpty || true {
                        oneThingSection
                    }
                    
                    // MARK: - Today's Habits
                    habitsSection
                    
                    // MARK: - Streak
                    KaizenCard {
                        StreakView(current: viewModel.currentStreak, best: viewModel.bestStreak)
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal)
                    
                }
                .padding(.bottom, 32)
            }
            .background(Color(.systemBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.regeneratePlan(
                            habits: habits,
                            settings: settings,
                            completions: completions,
                            context: modelContext
                        )
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .font(.subheadline)
                    }
                    .tint(.secondary)
                    .accessibilityLabel("Regenerate today's habits")
                }
            }
        }
        .onAppear { reload() }
        .onChange(of: habits.count) { reload() }
        .onChange(of: completions.count) { reload() }
        .sheet(item: $selectedHabit) { habit in
            HabitDetailView(habit: habit, viewModel: viewModel)
        }
        .sheet(isPresented: $showOneThingEditor) {
            OneThingEditorView(text: $oneThingText) { newText in
                viewModel.saveOneThing(newText, context: modelContext)
            }
        }
    }
    
    private func reload() {
        viewModel.load(
            habits: habits,
            completions: completions,
            plans: plans,
            settings: settings,
            context: modelContext
        )
        oneThingText = viewModel.oneThing
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(Date().formatted_EEEE_MMMM_d)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text("\(viewModel.greeting), \(viewModel.greetingName).")
                .font(.title)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
        .padding(.top, 8)
    }
    
    // MARK: - Progress Section
    private var progressSection: some View {
        KaizenCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Today's Progress")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Spacer()
                    Text("\(viewModel.completedCount) / \(viewModel.totalCount) completed")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                ProgressBar(value: viewModel.progressFraction, color: .kaizenAccent)
                
                if viewModel.totalCount > 0 {
                    Text("\(Int(viewModel.progressFraction * 100))% complete")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.horizontal)
    }
    
    // MARK: - One Thing Section
    private var oneThingSection: some View {
        KaizenCard {
            VStack(alignment: .leading, spacing: 10) {
                Label("One Thing", systemImage: "target")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.kaizenAccent)
                
                if viewModel.oneThing.isEmpty {
                    Button {
                        oneThingText = ""
                        showOneThingEditor = true
                    } label: {
                        Text("What is the most important thing you need to do today?")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.leading)
                    }
                    .buttonStyle(.plain)
                } else {
                    Text(viewModel.oneThing)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .onTapGesture {
                            oneThingText = viewModel.oneThing
                            showOneThingEditor = true
                        }
                }
            }
        }
        .padding(.horizontal)
    }
    
    // MARK: - Habits Section
    private var habitsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("TODAY")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
                .tracking(1.5)
                .padding(.horizontal)
            
            if viewModel.todaysHabits.isEmpty {
                KaizenCard {
                    EmptyStateView(
                        icon: "checklist",
                        title: "No habits scheduled",
                        subtitle: "Add habits from the Habits tab or tap the refresh button.",
                        actionTitle: nil
                    )
                }
                .padding(.horizontal)
            } else {
                VStack(spacing: 8) {
                    ForEach(viewModel.todaysHabits) { habit in
                        HabitRowView(
                            habit: habit,
                            isCompleted: viewModel.isCompleted(habit)
                        ) {
                            viewModel.toggleCompletion(for: habit, context: modelContext)
                        } onTap: {
                            selectedHabit = habit
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
}

// MARK: - One Thing Editor Sheet
struct OneThingEditorView: View {
    @Binding var text: String
    let onSave: (String) -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("What is the single task that would make today meaningful if completed?")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                TextEditor(text: $text)
                    .font(.body)
                    .frame(minHeight: 100)
                    .padding(12)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                
                Spacer()
            }
            .padding()
            .navigationTitle("One Thing")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .tint(.secondary)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        onSave(text)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .tint(.kaizenAccent)
                }
            }
        }
        .presentationDetents([.medium])
    }
}
