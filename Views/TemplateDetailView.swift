import SwiftUI

struct TemplateDetailView: View {
    @EnvironmentObject var appData: AppData
    @Binding var template: WorkoutTemplate

    @State private var showingAddExercise = false
    @State private var showingWorkout = false

    var body: some View {
        List {
            ForEach(template.exercises) { templateExercise in
                Text(templateExercise.exercise.name)
            }

            Section {
                Button {
                    appData.startWorkout(from: template)
                    showingWorkout = true
                } label: {
                    Label("Start Workout", systemImage: "play.fill")
                }
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
            AddExerciseView(existingExercises: appData.exerciseLibrary) { exercise in
                appData.addExerciseToLibraryIfNeeded(exercise)

                template.exercises.append(
                    TemplateExercise(exercise: exercise)
                )
            }
        }
        .navigationDestination(isPresented: $showingWorkout) {
            WorkoutView()
        }
    }
}

#Preview {
    @Previewable @State var template = WorkoutTemplate(
        name: "Push",
        exercises: [
            TemplateExercise(exercise: Exercise(name: "Bench Press"))
        ]
    )

    NavigationStack {
        TemplateDetailView(template: $template)
            .environmentObject(AppData())
    }
}
