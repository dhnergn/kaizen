import SwiftUI
import SwiftData

struct AddEditHabitView: View {
    var habit: Habit?
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var habitDescription: String = ""
    @State private var selectedCategory: HabitCategory = .mind
    @State private var duration: Int = 5
    @State private var selectedFrequency: HabitFrequency = .daily
    @State private var selectedDifficulty: HabitDifficulty = .medium
    @State private var whyItMatters: String = ""
    @State private var todayInstruction: String = ""
    @State private var reflectionPrompt: String = ""
    @State private var iconName: String = "checkmark.circle"
    @State private var customDays: Set<Int> = []
    
    private var isEditing: Bool { habit != nil }
    private var canSave: Bool { !name.trimmingCharacters(in: .whitespaces).isEmpty }
    
    private let icons = [
        "checkmark.circle", "star.fill", "flame.fill", "bolt.fill",
        "book.fill", "brain.head.profile", "figure.walk", "dumbbell.fill",
        "heart.fill", "mic.fill", "pencil", "lightbulb.fill",
        "target", "moon.stars.fill", "sunrise.fill", "leaf.fill"
    ]
    
    var body: some View {
        NavigationStack {
            Form {
                // MARK: - Basic Info
                Section("Habit") {
                    TextField("Name", text: $name)
                    TextField("Short description", text: $habitDescription, axis: .vertical)
                        .lineLimit(2...4)
                }
                
                // MARK: - Category & Icon
                Section("Category & Icon") {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(HabitCategory.allCases) { cat in
                            Label(cat.rawValue, systemImage: cat.icon).tag(cat)
                        }
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(icons, id: \.self) { icon in
                                Button {
                                    iconName = icon
                                } label: {
                                    Image(systemName: icon)
                                        .font(.title3)
                                        .foregroundStyle(iconName == icon ? .white : selectedCategory.color)
                                        .frame(width: 40, height: 40)
                                        .background(iconName == icon ? selectedCategory.color : selectedCategory.color.opacity(0.1))
                                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                
                // MARK: - Schedule
                Section("Schedule") {
                    Picker("Frequency", selection: $selectedFrequency) {
                        ForEach(HabitFrequency.allCases, id: \.rawValue) { freq in
                            Text(freq.displayName).tag(freq)
                        }
                    }
                    
                    if selectedFrequency == .custom {
                        DayPickerRow(selectedDays: $customDays)
                    }
                    
                    Stepper("Duration: \(duration == 0 ? "No timer" : "\(duration) min")",
                            value: $duration, in: 0...120, step: 5)
                }
                
                // MARK: - Details
                Section("Details") {
                    Picker("Difficulty", selection: $selectedDifficulty) {
                        ForEach(HabitDifficulty.allCases, id: \.rawValue) { diff in
                            Text(diff.displayName).tag(diff)
                        }
                    }
                    
                    TextField("Why it matters", text: $whyItMatters, axis: .vertical)
                        .lineLimit(3...6)
                    TextField("Today's instruction", text: $todayInstruction, axis: .vertical)
                        .lineLimit(3...6)
                    TextField("Reflection prompt", text: $reflectionPrompt, axis: .vertical)
                        .lineLimit(2...4)
                }
            }
            .navigationTitle(isEditing ? "Edit Habit" : "New Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .tint(.secondary)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") { save() }
                        .fontWeight(.semibold)
                        .tint(.kaizenAccent)
                        .disabled(!canSave)
                }
            }
            .onAppear { populateIfEditing() }
        }
    }
    
    private func populateIfEditing() {
        guard let habit else { return }
        name = habit.name
        habitDescription = habit.habitDescription
        selectedCategory = habit.categoryEnum
        duration = habit.duration
        selectedFrequency = habit.frequencyEnum
        selectedDifficulty = HabitDifficulty(rawValue: habit.difficulty) ?? .medium
        whyItMatters = habit.whyItMatters
        todayInstruction = habit.todayInstruction
        reflectionPrompt = habit.reflectionPrompt
        iconName = habit.iconName
        customDays = Set(habit.customDays)
    }
    
    private func save() {
        if let habit {
            habit.name = name
            habit.habitDescription = habitDescription
            habit.category = selectedCategory.rawValue
            habit.duration = duration
            habit.frequencyRaw = selectedFrequency.rawValue
            habit.customDays = Array(customDays)
            habit.difficulty = selectedDifficulty.rawValue
            habit.iconName = iconName
            habit.colorHex = selectedCategory.color.hexString
            habit.whyItMatters = whyItMatters
            habit.todayInstruction = todayInstruction
            habit.reflectionPrompt = reflectionPrompt
        } else {
            let newHabit = Habit(
                name: name,
                habitDescription: habitDescription,
                category: selectedCategory.rawValue,
                duration: duration,
                frequencyRaw: selectedFrequency.rawValue,
                customDays: Array(customDays),
                difficulty: selectedDifficulty.rawValue,
                colorHex: selectedCategory.color.hexString,
                iconName: iconName,
                whyItMatters: whyItMatters,
                todayInstruction: todayInstruction,
                reflectionPrompt: reflectionPrompt
            )
            modelContext.insert(newHabit)
        }
        try? modelContext.save()
        dismiss()
    }
}

// MARK: - Day Picker
struct DayPickerRow: View {
    @Binding var selectedDays: Set<Int>
    private let dayLabels = ["S", "M", "T", "W", "T", "F", "S"]
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<7, id: \.self) { dayIndex in
                Button {
                    if selectedDays.contains(dayIndex) {
                        selectedDays.remove(dayIndex)
                    } else {
                        selectedDays.insert(dayIndex)
                    }
                } label: {
                    Text(dayLabels[dayIndex])
                        .font(.caption)
                        .fontWeight(.semibold)
                        .frame(width: 32, height: 32)
                        .background(selectedDays.contains(dayIndex) ? Color.kaizenAccent : Color(.tertiarySystemBackground))
                        .foregroundStyle(selectedDays.contains(dayIndex) ? .white : .secondary)
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
            }
        }
    }
}
