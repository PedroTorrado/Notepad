import SwiftUI

struct ContentView: View {
    
    @State private var notes: [Note] = []
    @State private var selectedNote: Note?
    
    var body: some View {
        NavigationSplitView {
            NotesListView(notes: $notes, selectedNote: $selectedNote)
                .frame(minWidth: 200)
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button(action: addNewNote) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title)
                        }
                    }
                }
        } detail: {
            if let note = selectedNote {
                NoteDetailView(note: Binding(
                    get: { note },
                    set: { updatedNote in
                        // This closure runs every time the note is edited in the detail view.
                        
                        // First, update the note in the main array.
                        if let index = notes.firstIndex(where: { $0.id == updatedNote.id }) {
                            notes[index] = updatedNote
                        }
                        
                        // This is the crucial fix:
                        // Update the `selectedNote` state variable to prevent the title from reverting.
                        self.selectedNote = updatedNote
                    }
                ))
            } else {
                Text("Select a note")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onAppear {
            loadNotesFromFile()
        }
        .onChange(of: notes) { _ in
            saveNotesToFile()
        }
        .background(Color(UIColor.systemBackground))
    }
    
    // MARK: - Note Management
    
    private func addNewNote() {
        let newNote = Note(title: "Untitled", body: "")
        notes.append(newNote)
        selectedNote = newNote
    }
    
    // The binding(for:) function is no longer needed.
    // It has been replaced by the direct Binding in the detail view.
    
    // MARK: - File Persistence
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func saveNotesToFile() {
        do {
            let url = getDocumentsDirectory().appendingPathComponent("notes.json")
            let data = try JSONEncoder().encode(notes)
            try data.write(to: url)
            print("Notes successfully saved to file at \(url)")
            
            let savedData = try Data(contentsOf: url)
            print("Saved data: \(String(data: savedData, encoding: .utf8) ?? "Error decoding")")
        } catch {
            print("Failed to save notes to file: \(error.localizedDescription)")
        }
    }
    
    private func loadNotesFromFile() {
        let url = getDocumentsDirectory().appendingPathComponent("notes.json")
        
        do {
            if !FileManager.default.fileExists(atPath: url.path) {
                print("File does not exist at path: \(url.path)")
                return
            }
            
            let data = try Data(contentsOf: url)
            
            if let dataString = String(data: data, encoding: .utf8) {
                print("Loaded raw data from file: \(dataString)")
            } else {
                print("Could not decode data into a string.")
            }
            
            let decodedNotes = try JSONDecoder().decode([Note].self, from: data)
            
            if decodedNotes.isEmpty {
                print("Decoded an empty array from the file. No notes loaded.")
            } else {
                self.notes = decodedNotes
                print("Successfully loaded \(notes.count) notes from file.")
            }
            
        } catch {
            print("Failed to load notes from file: \(error.localizedDescription)")
        }
    }
}

#Preview {
    ContentView()
}
