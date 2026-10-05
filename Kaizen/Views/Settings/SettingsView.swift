import SwiftUI
import SwiftData

struct SettingsView: View {
    let settings: UserSettings
    
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = SettingsViewModel()
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Daily Routine") {
                    Picker("Intensity", selection: Binding(
                        get: { DayIntensity.allCases.first { $0.limit == settings.dailyHabitLimit } ?? .normal },
                        set: { viewModel.updateDailyLimit($0.limit, settings: settings, context: modelContext) }
                    )) {
                        ForEach(DayIntensity.allCases, id: \.rawValue) { intensity in
                            Text(intensity.displayName).tag(intensity)
                        }
                    }
                }
                
                Section("Focus Areas") {
                    ForEach(HabitCategory.allCases) { category in
                        Toggle(isOn: Binding(
                            get: { settings.selectedCategories.contains(category.rawValue) },
                            set: { _ in viewModel.toggleCategory(category, settings: settings, context: modelContext) }
                        )) {
                            Label(category.rawValue, systemImage: category.icon)
                                .foregroundStyle(category.color)
                        }
                        .tint(category.color)
                    }
                }
                
                Section("Notifications") {
                    Toggle("Daily Reminders", isOn: Binding(
                        get: { settings.notificationsEnabled },
                        set: { viewModel.toggleNotifications($0, settings: settings, context: modelContext) }
                    ))
                    .tint(.kaizenAccent)
                }
                
                Section {
                    Button {
                        viewModel.showWeeklyReview = true
                    } label: {
                        Label("Conduct Weekly Review", systemImage: "doc.text.magnifyingglass")
                    }
                    .tint(.kaizenAccent)
                }
                
                Section {
                    HStack {
                        Spacer()
                        VStack(spacing: 4) {
                            Text("Kaizen")
                                .font(.headline)
                            Text("Version 1.0")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $viewModel.showWeeklyReview) {
                WeeklyReviewView()
            }
        }
    }
}
