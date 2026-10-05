import SwiftUI
import SwiftData

struct OnboardingContainerView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var settingsQuery: [UserSettings]
    
    @State private var currentPage: Int = 0
    @State private var selectedCategories: Set<HabitCategory> = []
    @State private var selectedIntensity: DayIntensity = .normal
    @State private var selectedTemplates: Set<UUID> = []
    @State private var userName: String = ""
    
    var settings: UserSettings? { settingsQuery.first }
    
    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()
            
            Group {
                switch currentPage {
                case 0:
                    OnboardingWelcomeView(userName: $userName, onNext: { currentPage = 1 })
                case 1:
                    OnboardingCategoriesView(
                        selectedCategories: $selectedCategories,
                        onNext: { currentPage = 2 },
                        onBack: { currentPage = 0 }
                    )
                case 2:
                    OnboardingIntensityView(
                        selectedIntensity: $selectedIntensity,
                        onNext: { currentPage = 3 },
                        onBack: { currentPage = 1 }
                    )
                case 3:
                    OnboardingHabitPickerView(
                        selectedCategories: selectedCategories,
                        selectedTemplates: $selectedTemplates,
                        onFinish: completeOnboarding,
                        onBack: { currentPage = 2 }
                    )
                default:
                    EmptyView()
                }
            }
            .transition(.asymmetric(
                insertion: .move(edge: .trailing),
                removal: .move(edge: .leading)
            ))
        }
        .animation(.easeInOut(duration: 0.3), value: currentPage)
    }
    
    private func completeOnboarding() {
        guard let settings = settings else { return }
        settings.userName = userName
        settings.selectedCategories = Array(selectedCategories).map(\.rawValue)
        settings.dailyHabitLimit = selectedIntensity.limit
        settings.onboardingCompleted = true
        
        // Insert selected habits from library
        let templatesToAdd = HabitLibraryData.all.filter { selectedTemplates.contains($0.id) }
        for (i, template) in templatesToAdd.enumerated() {
            let habit = template.toHabit()
            habit.sortOrder = i
            modelContext.insert(habit)
        }
        
        try? modelContext.save()
    }
}
