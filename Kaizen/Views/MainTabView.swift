import SwiftUI
import SwiftData

struct MainTabView: View {
    let settings: UserSettings
    @State private var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(settings: settings)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            HabitsListView()
                .tabItem {
                    Label("Habits", systemImage: "checklist")
                }
                .tag(1)
            
            CalendarView()
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }
                .tag(2)
            
            JournalView()
                .tabItem {
                    Label("Journal", systemImage: "book.closed.fill")
                }
                .tag(3)
            
            SettingsView(settings: settings)
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(4)
        }
        .tint(.kaizenAccent)
    }
}
