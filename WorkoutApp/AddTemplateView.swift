import SwiftUI

struct AddTemplateView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var templateName = ""

    let onSave: (String) -> Void

    var body: some View {
        NavigationStack {
            Form {
                TextField("Template name", text: $templateName)
            }
            .navigationTitle("New Template")
            .toolbar {
                Button("Cancel") {
                    dismiss()
                }

                Button("Save") {
                    let trimmedName = templateName.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !trimmedName.isEmpty else { return }

                    onSave(trimmedName)
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    AddTemplateView { _ in }
}
