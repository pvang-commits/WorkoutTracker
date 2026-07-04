import SwiftUI

struct TemplateDetailView: View {
    @Binding var template: WorkoutTemplate
    @Binding var exerciseLibrary: [Exercise]

    @State private var showingAddExercise = false

    var body: some View {
        List {
            ForEach(template.exercises) { workoutExercise in
                Text(workoutExercise.exercise.name)
            }
        }
        .navigationTitle(template.name)
        .toolbar {
            Button {
                showingAddExercise = true
            } label: {
                Image(systemName: "plus")
            }
        }
        .sheet(isPresented: $showingAddExercise) {
            AddExerciseView(existingExercises: exerciseLibrary) { exercise in
                if !exerciseLibrary.contains(exercise) {
                    exerciseLibrary.append(exercise)
                }

                template.exercises.append(
                    WorkoutExercise(exercise: exercise)
                )
            }
        }
    }
}

#Preview {
    @Previewable @State var template = WorkoutTemplate(
        name: "Push",
        exercises: [
            WorkoutExercise(exercise: Exercise(name: "Bench Press")),
            WorkoutExercise(exercise: Exercise(name: "Incline Bench"))
        ]
    )

    @Previewable @State var exerciseLibrary = [
        Exercise(name: "Bench Press"),
        Exercise(name: "Incline Bench"),
        Exercise(name: "Lat Pulldown")
    ]

    TemplateDetailView(
        template: $template,
        exerciseLibrary: $exerciseLibrary
    )
}
