import SwiftUI

struct NotesListView: View {
    @Binding var notes: [Note]
    @Binding var selectedNote: Note?
    @Binding var trashNotes: [Note]
    
    var body: some View {
        List(selection: $selectedNote) {
            ForEach(notes) { note in
                Text(note.title)
                    .tag(note)
            }
            .onDelete(perform: moveToTrash)
        }
        .navigationTitle("My Notes")
        .listStyle(.sidebar)
        .background(Color(UIColor.systemBackground))
    }
    
    private func moveToTrash(at offsets: IndexSet) {
        let deletedNotes = offsets.map { notes[$0] }
        
        // Add deleted notes to trash
        trashNotes.append(contentsOf: deletedNotes.map {
            Note(title: $0.title, body: $0.body, state: true)
        })

        // Remove from main list
        notes.remove(atOffsets: offsets)
        
        if let selected = selectedNote, !notes.contains(selected) {
            selectedNote = notes.first
        }
    }
}
