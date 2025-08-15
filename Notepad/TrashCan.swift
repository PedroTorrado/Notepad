import SwiftUI

struct TrashCan: View {
    @Binding var notes: [Note]
    @Binding var selectedNote: Note?
    @Binding var trashNotes: [Note]
    
    var body: some View {
        List(selection: $selectedNote) {
            ForEach(trashNotes) { note in
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
        trashNotes.remove(atOffsets: offsets)
        
        // This logic ensures that if the deleted note was selected, the selection is updated.
        if let selected = selectedNote, !notes.contains(selected) {
            selectedNote = notes.first
        }
    }
}


