import Foundation

class AppData: ObservableObject {
    @Published var templates: [WorkoutTemplate] = []
    @Published var exerciseLibrary: [Exercise] = []

    @Published var currentWorkout: WorkoutSession?
    @Published var workoutHistory: [WorkoutSession] = []

    func addTemplate(named name: String) {
        templates.append(WorkoutTemplate(name: name))
    }

    func addExerciseToLibraryIfNeeded(_ exercise: Exercise) {
        if !exerciseLibrary.contains(where: { $0.name.caseInsensitiveCompare(exercise.name) == .orderedSame }) {
            exerciseLibrary.append(exercise)
        }
    }
    
    func startWorkout(from template: WorkoutTemplate) {

        let workoutExercises = template.exercises.map { templateExercise in
            WorkoutExercise(
                exercise: templateExercise.exercise
            )
        }

        currentWorkout = WorkoutSession(
            templateName: template.name,
            exercises: workoutExercises
        )
    }
}
