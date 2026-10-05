import SwiftUI
import SwiftData

struct HabitsListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Habit.sortOrder) private var habits: [Habit]
    
    @State private var viewModel = HabitsViewModel()
    @State private var showLibraryPicker = false
    
    var body: some View {
        NavigationStack {
            Group {
                if habits.filter(\.isActive).isEmpty && viewModel.searchText.isEmpty {
                    emptyState
                } else {
                    habitsList
                }
            }
            .navigationTitle("Habits")
            .searchable(text: $viewModel.searchText, prompt: "Search habits…")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button {
                            viewModel.showAddHabit = true
                        } label: {
                            Label("Create Custom Habit", systemImage: "plus")
                        }
                        Button {
                            showLibraryPicker = true
                        } label: {
                            Label("Add from Library", systemImage: "books.vertical")
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                    .tint(.kaizenAccent)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        Button {
                            viewModel.selectedCategory = nil
                        } label: {
                            Label("All Categories", systemImage: viewModel.selectedCategory == nil ? "checkmark" : "")
                        }
                        Divider()
                        ForEach(HabitCategory.allCases) { cat in
                            Button {
                                viewModel.selectedCategory = viewModel.selectedCategory == cat ? nil : cat
                            } label: {
                                Label(cat.rawValue, systemImage: cat.icon)
                            }
                        }
                    } label: {
                        Label(viewModel.selectedCategory?.rawValue ?? "Filter", systemImage: "line.3.horizontal.decrease.circle")
                            .font(.subheadline)
                    }
                    .tint(.secondary)
                }
            }
            .sheet(isPresented: $viewModel.showAddHabit) {
                AddEditHabitView(habit: nil)
            }
            .sheet(item: $viewModel.habitToEdit) { habit in
                AddEditHabitView(habit: habit)
            }
            .sheet(isPresented: $showLibraryPicker) {
                LibraryPickerSheet { templates in
                    viewModel.addHabitsFromLibrary(templates, context: modelContext)
                }
            }
        }
    }
    
    private var habitsList: some View {
        let groups = viewModel.groupedHabits(habits)
        return List {
            ForEach(groups, id: \.0.id) { (category, categoryHabits) in
                Section {
                    ForEach(categoryHabits) { habit in
                        NavigationLink {
                            HabitDetailView(habit: habit, viewModel: HomeViewModel())
                        } label: {
                            HabitListRow(habit: habit)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                viewModel.deleteHabit(habit, context: modelContext)
                            } label: {
                                Label("Remove", systemImage: "trash")
                            }
                        }
                        .swipeActions(edge: .leading) {
                            Button {
                                viewModel.habitToEdit = habit
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.kaizenAccent)
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
    }
    
    private var emptyState: some View {
        EmptyStateView(
            icon: "checklist",
            title: "No Habits Yet",
            subtitle: "Add habits from the library or create your own.",
            actionTitle: "Add from Library"
        ) {
            showLibraryPicker = true
        }
    }
}

struct HabitListRow: View {
    let habit: Habit
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(habit.categoryEnum.color.opacity(0.12))
                    .frame(width: 36, height: 36)
                Image(systemName: habit.iconName)
                    .font(.subheadline)
                    .foregroundStyle(habit.categoryEnum.color)
            }
            VStack(alignment: .leading, spacing: 3) {
                Text(habit.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                HStack(spacing: 6) {
                    Text(habit.frequencyEnum.displayName)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    if habit.duration > 0 {
                        Text("·")
                            .foregroundStyle(.secondary)
                        Text("\(habit.duration) min")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .padding(.vertical, 2)
    }
}

// MARK: - Library Picker Sheet
struct LibraryPickerSheet: View {
    let onAdd: ([HabitTemplate]) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var selected: Set<UUID> = []
    @State private var searchText = ""
    
    private var filtered: [HabitTemplate] {
        guard !searchText.isEmpty else { return HabitLibraryData.all }
        return HabitLibraryData.all.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.category.rawValue.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    private var grouped: [(HabitCategory, [HabitTemplate])] {
        var result: [(HabitCategory, [HabitTemplate])] = []
        for category in HabitCategory.allCases {
            let templates = filtered.filter { $0.category == category }
            if !templates.isEmpty { result.append((category, templates)) }
        }
        return result
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(grouped, id: \.0.id) { (category, templates) in
                    Section {
                        ForEach(templates) { template in
                            TemplatePickerRow(
                                template: template,
                                isSelected: selected.contains(template.id)
                            ) {
                                if selected.contains(template.id) {
                                    selected.remove(template.id)
                                } else {
                                    selected.insert(template.id)
                                }
                            }
                        }
                    } header: {
                        Label(category.rawValue, systemImage: category.icon)
                            .foregroundStyle(category.color)
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search library…")
            .navigationTitle("Habit Library")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .tint(.secondary)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add \(selected.isEmpty ? "" : "(\(selected.count))")") {
                        let templates = HabitLibraryData.all.filter { selected.contains($0.id) }
                        onAdd(templates)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .tint(.kaizenAccent)
                    .disabled(selected.isEmpty)
                }
            }
        }
    }
}
