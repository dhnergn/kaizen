import SwiftUI
import SwiftData

struct JournalEditorView: View {
    let date: Date
    let entry: JournalEntry
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var morningIntention: String = ""
    @State private var eveningReflection: String = ""
    @State private var importantThoughts: String = ""
    @State private var goals: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextEditor(text: $morningIntention)
                        .frame(minHeight: 100)
                } header: {
                    Text("Morning Intention")
                } footer: {
                    Text("How will you make today meaningful?")
                }
                
                Section {
                    TextEditor(text: $eveningReflection)
                        .frame(minHeight: 100)
                } header: {
                    Text("Evening Reflection")
                } footer: {
                    Text("What went well? What did you avoid?")
                }
                
                Section {
                    TextEditor(text: $importantThoughts)
                        .frame(minHeight: 100)
                } header: {
                    Text("Important Thoughts")
                }
                
                Section {
                    TextEditor(text: $goals)
                        .frame(minHeight: 100)
                } header: {
                    Text("Long-Term Goals")
                }
            }
            .navigationTitle(date.formatted_MMMM_d_yyyy)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") { dismiss() }
                        .tint(.secondary)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") { save() }
                        .fontWeight(.semibold)
                        .tint(.kaizenAccent)
                }
            }
            .onAppear {
                morningIntention = entry.morningIntention
                eveningReflection = entry.eveningReflection
                importantThoughts = entry.importantThoughts
                goals = entry.goals
            }
        }
    }
    
    private func save() {
        entry.morningIntention = morningIntention
        entry.eveningReflection = eveningReflection
        entry.importantThoughts = importantThoughts
        entry.goals = goals
        try? modelContext.save()
        dismiss()
    }
}
