import SwiftUI

struct AddExerciseView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var exerciseName = ""

    let existingExercises: [Exercise]
    let onSave: (Exercise) -> Void

    private var suggestions: [Exercise] {
        guard !exerciseName.isEmpty else { return [] }

        return existingExercises.filter {
            $0.name.localizedCaseInsensitiveContains(exerciseName)
        }
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Exercise name", text: $exerciseName)
                }

                if !suggestions.isEmpty {
                    Section("Suggestions") {
                        ForEach(suggestions) { exercise in
                            Button(exercise.name) {
                                onSave(exercise)
                                dismiss()
                            }
                        }
                    }
                }

                let trimmedName = exerciseName.trimmingCharacters(in: .whitespacesAndNewlines)

                if !trimmedName.isEmpty {
                    Section {
                        Button("Create \"\(trimmedName)\"") {
                            onSave(Exercise(name: trimmedName))
                            dismiss()
                        }
                    }
                }
            }
            .navigationTitle("Add Exercise")
            .toolbar {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    AddExerciseView(
        existingExercises: [
            Exercise(name: "Bench Press"),
            Exercise(name: "Incline Bench")
        ]
    ) { _ in }
}
