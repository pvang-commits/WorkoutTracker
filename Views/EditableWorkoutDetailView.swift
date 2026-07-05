import SwiftUI

struct EditableWorkoutDetailView: View {
    @Binding var workout: WorkoutSession

    var body: some View {
        List {
            ForEach($workout.exercises) { $exercise in
                Section(exercise.exercise.name) {
                    ForEach($exercise.sets) { $set in
                        LoggedSetRow(set: $set, previousSet: nil)
                    }

                    Button {
                        exercise.sets.append(LoggedSet())
                    } label: {
                        Label("Add Set", systemImage: "plus")
                    }
                }
            }
        }
        .navigationTitle(workout.templateName)
    }
}

#Preview {
    @Previewable @State var workout = WorkoutSession(
        templateName: "Push",
        exercises: [
            WorkoutExercise(
                exercise: Exercise(name: "Bench Press"),
                sets: [
                    LoggedSet(tag: .working, rawInput: "225x8", weight: 225, reps: 8)
                ]
            )
        ]
    )

    NavigationStack {
        EditableWorkoutDetailView(workout: $workout)
    }
}
