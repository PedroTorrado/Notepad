import SwiftUI

struct ContentView: View {
    @State private var notes: [Note] = []
    @State private var selectedNote: Note?
    @State private var isShowingTrash = false
    
    var displayedNotes: [Note] {
        isShowingTrash ? notes.filter { $0.state } : notes.filter { !$0.state }
    }

    var body: some View {
        NavigationSplitView {
            // Sidebar
            List(selection: $selectedNote) {
                ForEach(displayedNotes) { note in
                    Text(note.title.isEmpty ? "Untitled" : note.title)
                        .lineLimit(1)
                        .tag(note)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            if !isShowingTrash {
                                Button(role: .destructive) {
                                    markAsTrashed(note)
                                } label: {
                                    Label("Trash", systemImage: "trash")
                                }
                            }else{
                                Button(role: .cancel) {
                                    removeFromTrashed(note)
                                } label: {
                                    Label("restore", systemImage: "chevron.backward").tint(.green)
                                }
                            }
                        }
                }
            }
            .frame(minWidth: 200)
            .navigationTitle(isShowingTrash ? "Trash" : "My Notes")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    HStack {
                        // Add new note button
                        if !isShowingTrash {
                            Button(action: addNewNote) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 20))
                            }
                        }
                        // Trash toggle button
                        Button(action: toggleTrashView) {
                            Image(systemName: isShowingTrash ? "arrowshape.left.fill" : "line.3.horizontal.decrease")
                                .font(.system(size: 20))
                        }
                    }
                }
            }
        } detail: {
            if let note = selectedNote,
               let index = notes.firstIndex(where: { $0.id == note.id }) {
                NoteDetailView(note: $notes[index])
            } else {
                Text("Select a note")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onAppear { loadNotesFromFile() }
        .onChange(of: notes) { _ in saveNotesToFile() }
    }

    // MARK: - Note Management
    private func addNewNote() {
        let newNote = Note(title: "Untitled", body: "", state: false)
        notes.append(newNote)
        selectedNote = newNote
    }

    private func toggleTrashView() {
        isShowingTrash.toggle()
    }

    private func markAsTrashed(_ note: Note) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index].state = true
        }
    }
    
    private func removeFromTrashed(_ note: Note) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index].state = false
        }
    }

    // MARK: - File Persistence
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    private func saveNotesToFile() {
        do {
            let url = getDocumentsDirectory().appendingPathComponent("notes.json")
            let data = try JSONEncoder().encode(notes)
            try data.write(to: url)
        } catch {
            print("Failed to save notes to file: \(error.localizedDescription)")
        }
    }

    private func loadNotesFromFile() {
        let url = getDocumentsDirectory().appendingPathComponent("notes.json")
        guard FileManager.default.fileExists(atPath: url.path) else { return }
        do {
            let data = try Data(contentsOf: url)
            notes = try JSONDecoder().decode([Note].self, from: data)
        } catch {
            print("Failed to load notes from file: \(error.localizedDescription)")
        }
    }
}

#Preview {
    ContentView()
}
