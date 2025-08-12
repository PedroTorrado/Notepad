import SwiftUI

struct NotesListView: View {
    @Binding var notes: [Note]
    @Binding var selectedNote: Note?
    
    var body: some View {
        List(selection: $selectedNote) {
            ForEach(notes) { note in
                Text(note.title)
                    .tag(note)
            }
            .onDelete(perform: deleteNote)
        }
        .navigationTitle("My Notes")
        .listStyle(.sidebar)
        .background(Color(UIColor.systemBackground))
    }
    
    private func deleteNote(at offsets: IndexSet) {
        notes.remove(atOffsets: offsets)
        
        // This logic ensures that if the deleted note was selected, the selection is updated.
        if let selected = selectedNote, !notes.contains(selected) {
            selectedNote = notes.first
        }
    }
}
