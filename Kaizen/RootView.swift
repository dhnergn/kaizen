import SwiftUI
import SwiftData

struct RootView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var settingsQuery: [UserSettings]
    
    var settings: UserSettings? { settingsQuery.first }
    
    var body: some View {
        Group {
            if let settings = settings, settings.onboardingCompleted {
                MainTabView(settings: settings)
            } else {
                OnboardingContainerView()
            }
        }
        .onAppear {
            if settingsQuery.isEmpty {
                let s = UserSettings()
                modelContext.insert(s)
                try? modelContext.save()
            }
        }
    }
}
