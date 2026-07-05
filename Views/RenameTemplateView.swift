import SwiftUI

struct RenameTemplateView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var template: WorkoutTemplate

    @State private var name: String = ""

    var body: some View {
        NavigationStack {
            Form {
                TextField("Template name", text: $name)
            }
            .navigationTitle("Rename Template")
            .onAppear {
                name = template.name
            }
            .toolbar {
                Button("Cancel") {
                    dismiss()
                }

                Button("Save") {
                    let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !trimmed.isEmpty else { return }

                    template.name = trimmed
                    dismiss()
                }
            }
        }
    }
}
