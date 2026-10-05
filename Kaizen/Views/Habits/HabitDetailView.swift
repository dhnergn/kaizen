import SwiftUI
import SwiftData

struct HabitDetailView: View {
    let habit: Habit
    let viewModel: HomeViewModel
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var completions: [HabitCompletion]
    
    @State private var reflectionText = ""
    @State private var showReflection = false
    
    private var todayCompletion: HabitCompletion? {
        completions.first {
            $0.habitId == habit.id && Calendar.current.isDateInToday($0.date)
        }
    }
    
    private var isCompleted: Bool {
        todayCompletion?.completed ?? false
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // MARK: - Header
                    KaizenCard {
                        VStack(alignment: .leading, spacing: 14) {
                            HStack(spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(habit.categoryEnum.color.opacity(0.12))
                                        .frame(width: 48, height: 48)
                                    Image(systemName: habit.iconName)
                                        .font(.title3)
                                        .foregroundStyle(habit.categoryEnum.color)
                                }
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(habit.name)
                                        .font(.title3)
                                        .fontWeight(.bold)
                                    CategoryBadge(category: habit.categoryEnum)
                                }
                            }
                            
                            Text(habit.habitDescription)
                                .font(.body)
                                .foregroundStyle(.secondary)
                            
                            if habit.duration > 0 {
                                Label("\(habit.duration) minutes", systemImage: "clock")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // MARK: - Why It Matters
                    if !habit.whyItMatters.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            SectionLabel("WHY IT MATTERS")
                            KaizenCard {
                                Text(habit.whyItMatters)
                                    .font(.body)
                                    .lineSpacing(4)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // MARK: - Today's Instruction
                    if !habit.todayInstruction.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            SectionLabel("TODAY'S INSTRUCTION")
                            KaizenCard {
                                Text(habit.todayInstruction)
                                    .font(.body)
                                    .lineSpacing(4)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // MARK: - Complete Button
                    Button {
                        viewModel.toggleCompletion(for: habit, context: modelContext)
                        if !isCompleted {
                            showReflection = true
                        }
                    } label: {
                        HStack {
                            Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                            Text(isCompleted ? "Completed" : "Mark as Complete")
                        }
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isCompleted ? Color.kaizenAccent.opacity(0.12) : Color.kaizenAccent)
                        .foregroundStyle(isCompleted ? .kaizenAccent : .white)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }
                    .padding(.horizontal)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isCompleted)
                    
                    // MARK: - Reflection
                    if !habit.reflectionPrompt.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            SectionLabel("REFLECTION")
                            KaizenCard {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text(habit.reflectionPrompt)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                        .italic()
                                    
                                    TextEditor(text: $reflectionText)
                                        .font(.body)
                                        .frame(minHeight: 80)
                                        .onChange(of: reflectionText) { _, newValue in
                                            saveReflection(newValue)
                                        }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom, 40)
            }
            .navigationTitle(habit.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .tint(.kaizenAccent)
                        .fontWeight(.semibold)
                }
            }
        }
        .onAppear {
            reflectionText = todayCompletion?.reflection ?? ""
        }
    }
    
    private func saveReflection(_ text: String) {
        guard let completion = todayCompletion else { return }
        completion.reflection = text
        try? modelContext.save()
    }
}

// MARK: - Section Label Helper
struct SectionLabel: View {
    let text: String
    init(_ text: String) { self.text = text }
    var body: some View {
        Text(text)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundStyle(.secondary)
            .tracking(1.5)
    }
}
