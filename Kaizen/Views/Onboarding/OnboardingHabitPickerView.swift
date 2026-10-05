import SwiftUI

struct OnboardingHabitPickerView: View {
    let selectedCategories: Set<HabitCategory>
    @Binding var selectedTemplates: Set<UUID>
    let onFinish: () -> Void
    let onBack: () -> Void
    
    private var availableTemplates: [HabitTemplate] {
        if selectedCategories.isEmpty {
            return HabitLibraryData.all
        }
        return HabitLibraryData.all.filter { selectedCategories.contains($0.category) }
    }
    
    private var grouped: [(HabitCategory, [HabitTemplate])] {
        var result: [(HabitCategory, [HabitTemplate])] = []
        for category in HabitCategory.allCases {
            let templates = availableTemplates.filter { $0.category == category }
            if !templates.isEmpty {
                result.append((category, templates))
            }
        }
        return result
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                VStack(spacing: 6) {
                    Text("Choose your starting habits")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("Select any that interest you. You can change these anytime.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 16)
                .padding(.horizontal, 24)
                
                List {
                    ForEach(grouped, id: \.0.id) { (category, templates) in
                        Section {
                            ForEach(templates) { template in
                                TemplatePickerRow(
                                    template: template,
                                    isSelected: selectedTemplates.contains(template.id)
                                ) {
                                    if selectedTemplates.contains(template.id) {
                                        selectedTemplates.remove(template.id)
                                    } else {
                                        selectedTemplates.insert(template.id)
                                    }
                                }
                            }
                        } header: {
                            Label(category.rawValue, systemImage: category.icon)
                                .foregroundStyle(category.color)
                                .font(.subheadline.weight(.semibold))
                        }
                    }
                }
                .listStyle(.insetGrouped)
                
                HStack(spacing: 12) {
                    Button("Back", action: onBack)
                        .buttonStyle(.bordered)
                        .tint(.secondary)
                        .frame(maxWidth: .infinity)
                    Button("Start Kaizen →") {
                        // Auto-select one habit per chosen category when nothing was picked
                        if selectedTemplates.isEmpty {
                            for category in selectedCategories {
                                if let first = HabitLibraryData.templates(for: category).first {
                                    selectedTemplates.insert(first.id)
                                }
                            }
                        }
                        onFinish()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.kaizenAccent)
                    .frame(maxWidth: .infinity)
                }
                .controlSize(.large)
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
                .padding(.top, 8)
            }
        }
    }
}

// MARK: - TemplatePickerRow

struct TemplatePickerRow: View {
    let template: HabitTemplate
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: template.iconName)
                    .foregroundStyle(template.category.color)
                    .frame(width: 24)
                VStack(alignment: .leading, spacing: 2) {
                    Text(template.name)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.primary)
                    Text("\(template.duration) min")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(isSelected ? template.category.color : .secondary)
                    .font(.title3)
            }
        }
        .buttonStyle(.plain)
    }
}
