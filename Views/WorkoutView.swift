import SwiftUI

struct WorkoutView: View {
    @EnvironmentObject var appData: AppData

    var body: some View {
        List {
            if let workout = appData.currentWorkout {
                ForEach(workout.exercises) { workoutExercise in
                    Section(workoutExercise.exercise.name) {
                        ForEach(workoutExercise.sets) { set in
                            LoggedSetRow(
                                set: bindingForSet(set, in: workoutExercise)
                            )
                        }

                        Button {
                            addSet(to: workoutExercise)
                        } label: {
                            Label("Add Set", systemImage: "plus")
                        }
                    }
                }
            } else {
                Text("No active workout")
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle(appData.currentWorkout?.templateName ?? "Workout")
    }

    private func addSet(to workoutExercise: WorkoutExercise) {
        guard let exerciseIndex = appData.currentWorkout?.exercises.firstIndex(where: { $0.id == workoutExercise.id }) else {
            return
        }

        appData.currentWorkout?.exercises[exerciseIndex].sets.append(LoggedSet())
    }
    private func bindingForSet(_ set: LoggedSet, in workoutExercise: WorkoutExercise) -> Binding<LoggedSet> {
        Binding(
            get: {
                guard let exerciseIndex = appData.currentWorkout?.exercises.firstIndex(where: { $0.id == workoutExercise.id }),
                      let setIndex = appData.currentWorkout?.exercises[exerciseIndex].sets.firstIndex(where: { $0.id == set.id }) else {
                    return set
                }

                return appData.currentWorkout!.exercises[exerciseIndex].sets[setIndex]
            },
            set: { newValue in
                guard let exerciseIndex = appData.currentWorkout?.exercises.firstIndex(where: { $0.id == workoutExercise.id }),
                      let setIndex = appData.currentWorkout?.exercises[exerciseIndex].sets.firstIndex(where: { $0.id == set.id }) else {
                    return
                }

                appData.currentWorkout!.exercises[exerciseIndex].sets[setIndex] = newValue
            }
        )
    }
}

#Preview {
    let appData = AppData()
    appData.currentWorkout = WorkoutSession(
        templateName: "Push",
        exercises: [
            WorkoutExercise(exercise: Exercise(name: "Bench Press")),
            WorkoutExercise(exercise: Exercise(name: "Incline Bench"))
        ]
    )

    return NavigationStack {
        WorkoutView()
            .environmentObject(appData)
    }
}
