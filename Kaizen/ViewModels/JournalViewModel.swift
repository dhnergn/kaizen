import Foundation
import SwiftData

@MainActor
@Observable
final class JournalViewModel {
    
    var searchText: String = ""
    var selectedDate: Date = Date()
    var showEditor: Bool = false
    
    func entries(from allEntries: [JournalEntry], matching search: String) -> [JournalEntry] {
        allEntries
            .filter { !$0.isEmpty }
            .filter {
                search.isEmpty ||
                $0.morningIntention.localizedCaseInsensitiveContains(search) ||
                $0.eveningReflection.localizedCaseInsensitiveContains(search) ||
                $0.importantThoughts.localizedCaseInsensitiveContains(search) ||
                $0.goals.localizedCaseInsensitiveContains(search)
            }
            .sorted { $0.date > $1.date }
    }
    
    func entryForDate(_ date: Date, from allEntries: [JournalEntry]) -> JournalEntry? {
        allEntries.first { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
    
    func loadOrCreate(for date: Date, context: ModelContext) -> JournalEntry {
        PersistenceService.loadOrCreateJournalEntry(for: date, context: context)
    }
}
