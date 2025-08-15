import SwiftUI

struct NoteDetailView: View {
    @Binding var note: Note
    @FocusState private var isTitleFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Title Section: Dynamic background and text colors
            TextField("Enter title", text: $note.title)
                .font(.title)
                .padding()
                .foregroundColor(.primary) // Uses dynamic text color based on mode
                .background(Color(UIColor.systemBackground)) // Dynamic background for light/dark mode
                .focused($isTitleFocused)
                .padding(.horizontal)
                .onAppear { isTitleFocused = true }
            
            Divider()
                .background(Color.gray.opacity(1)) // Divider for separation
                .padding(.horizontal)
            
            // Body Section: Dynamic background and text colors for TextEditor
            TextEditor(text: $note.body)
                .padding()
                .background(Color(UIColor.systemBackground)) // Dynamic background for light/dark mode
                .foregroundColor(.primary) // Dynamic text color
                .frame(maxHeight: .infinity)
                .padding(.horizontal)
            
            Spacer() // To push the content up
        }
        .padding(.top)
        .navigationTitle("") // Remove the title from the navigation bar
        .navigationBarTitleDisplayMode(.inline) // Keep navigation bar centered correctly
    }
}

#Preview {
    NoteDetailView(note: .constant(Note(title: "Sample Note", body: "This is the note content.", state: true)))
}
