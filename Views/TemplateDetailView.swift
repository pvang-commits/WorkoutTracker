import SwiftUI

struct TemplateDetailView: View {
    @EnvironmentObject var appData: AppData
    @Binding var template: WorkoutTemplate

    @State private var showingAddExercise = false
    @State private var showingWorkout = false
    @State private var showingRenameTemplate = false
    @State private var exerciseToRename: Exercise?

    var body: some View {
        List {
            ForEach(template.exercises) { templateExercise in
                Button {
                    exerciseToRename = templateExercise.exercise
                } label: {
                    Text(templateExercise.exercise.name)
                }
            }
            .onDelete { indexSet in
                template.exercises.remove(atOffsets: indexSet)
            }
            .onMove { source, destination in
                template.exercises.move(fromOffsets: source, toOffset: destination)
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
            ToolbarItem(placement: .topBarLeading) {
                EditButton()
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showingAddExercise = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            ToolbarItem(placement: .principal) {
                Button(template.name) {
                    showingRenameTemplate = true
                }
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
        
        .sheet(isPresented: $showingRenameTemplate) {
            RenameTemplateView(template: $template)
        }
        
        .sheet(item: $exerciseToRename) { exercise in
            RenameExerciseView(exercise: exercise)
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
