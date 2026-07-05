import SwiftUI

struct RenameExerciseView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var appData: AppData

    let exercise: Exercise
    @State private var name: String = ""

    var body: some View {
        NavigationStack {
            Form {
                TextField("Exercise name", text: $name)
            }
            .navigationTitle("Rename Exercise")
            .onAppear {
                name = exercise.name
            }
            .toolbar {
                Button("Cancel") {
                    dismiss()
                }

                Button("Save") {
                    appData.renameExercise(exercise, to: name)
                    dismiss()
                }
            }
        }
    }
}
