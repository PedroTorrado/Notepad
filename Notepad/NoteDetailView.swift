import SwiftUI

struct NoteDetailView: View {
    @Binding var note: Note
    @FocusState private var isTitleFocused: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            // Title Section: Black background with white text
            TextField("Enter title", text: $note.title)
                .font(.title)
                .padding()
                .background(Color.black) // Black background
                .foregroundColor(.white) // White text color
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.2), radius: 5) // Optional shadow for depth
                .focused($isTitleFocused)
                .padding(.horizontal)
                .onAppear { isTitleFocused = true }
            
            Divider()
                .background(Color.gray.opacity(0.3)) // Divider for separation
                .padding(.horizontal)
            
            // Body Section: Black background with white text for TextEditor
            TextEditor(text: $note.body)
                .padding()
                .background(Color.black) // Black background
                .foregroundColor(.white) // White text color
                .cornerRadius(12)
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
    NoteDetailView(note: .constant(Note(title: "Sample Note", body: "This is the note content.")))
}
