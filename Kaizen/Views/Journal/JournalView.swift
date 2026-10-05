import SwiftUI
import SwiftData

struct JournalView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \JournalEntry.date, order: .reverse) private var allEntries: [JournalEntry]
    
    @State private var viewModel = JournalViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if allEntries.filter({ !$0.isEmpty }).isEmpty && viewModel.searchText.isEmpty {
                    emptyState
                } else {
                    entriesList
                }
            }
            .navigationTitle("Journal")
            .searchable(text: $viewModel.searchText, prompt: "Search journal…")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.selectedDate = Date().startOfDay
                        viewModel.showEditor = true
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                    .tint(.kaizenAccent)
                }
            }
            .sheet(isPresented: $viewModel.showEditor) {
                JournalEditorView(
                    date: viewModel.selectedDate,
                    entry: viewModel.loadOrCreate(for: viewModel.selectedDate, context: modelContext)
                )
            }
        }
    }
    
    private var entriesList: some View {
        let entries = viewModel.entries(from: allEntries, matching: viewModel.searchText)
        return List {
            ForEach(entries) { entry in
                Button {
                    viewModel.selectedDate = entry.date
                    viewModel.showEditor = true
                } label: {
                    JournalEntryRow(entry: entry)
                }
                .buttonStyle(.plain)
            }
            .onDelete(perform: deleteEntries)
        }
        .listStyle(.insetGrouped)
    }
    
    private var emptyState: some View {
        EmptyStateView(
            icon: "book.closed",
            title: "No Entries Yet",
            subtitle: "Write your morning intentions and evening reflections here.",
            actionTitle: "Write Today's Entry"
        ) {
            viewModel.selectedDate = Date().startOfDay
            viewModel.showEditor = true
        }
    }
    
    private func deleteEntries(offsets: IndexSet) {
        let entries = viewModel.entries(from: allEntries, matching: viewModel.searchText)
        for index in offsets {
            modelContext.delete(entries[index])
        }
        try? modelContext.save()
    }
}

struct JournalEntryRow: View {
    let entry: JournalEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(entry.date.formatted_EEEE_MMMM_d)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            if !entry.morningIntention.isEmpty {
                Text(entry.morningIntention)
                    .font(.body)
                    .lineLimit(2)
            } else if !entry.eveningReflection.isEmpty {
                Text(entry.eveningReflection)
                    .font(.body)
                    .lineLimit(2)
            } else if !entry.importantThoughts.isEmpty {
                Text(entry.importantThoughts)
                    .font(.body)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 4)
    }
}
