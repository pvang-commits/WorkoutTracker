import SwiftUI

struct WorkoutView: View {
    @EnvironmentObject var appData: AppData
    @State private var showingAddExercise = false
    @State private var showingSaveTemplateAlert = false

    var body: some View {
        ZStack(alignment: .bottom) {
            List {
                if let workout = appData.currentWorkout {
                    ForEach(workout.exercises) { workoutExercise in
                        Section(workoutExercise.exercise.name) {
                            ForEach(workoutExercise.sets) { set in
                                LoggedSetRow(
                                    set: bindingForSet(set, in: workoutExercise),
                                    previousSet: previousSet(for: set, in: workoutExercise)
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
            .padding(.bottom, 90)

            WorkoutTimerDrawer()
        }
        .navigationTitle(appData.currentWorkout?.templateName ?? "Workout")
        .toolbar {
            Button {
                showingAddExercise = true
            } label: {
                Image(systemName: "plus")
            }

            Button("Finish") {
                if appData.addedExercisesComparedToTemplate().isEmpty {
                    appData.finishCurrentWorkout()
                } else {
                    showingSaveTemplateAlert = true
                }
            }
        }
        .alert("Update template?", isPresented: $showingSaveTemplateAlert) {
            Button("Don't Update") {
                appData.finishCurrentWorkout()
            }

            Button("Update Template") {
                appData.addNewWorkoutExercisesToTemplate()
                appData.finishCurrentWorkout()
            }
        } message: {
            Text("You added exercises during this workout. Do you want to add them to this template?")
        }
        .sheet(isPresented: $showingAddExercise) {
            AddExerciseView(existingExercises: appData.exerciseLibrary) { exercise in
                appData.addExerciseToCurrentWorkout(exercise)
            }
        }
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
    
    private func previousSet(for set: LoggedSet, in workoutExercise: WorkoutExercise) -> LoggedSet? {
        guard let currentSetIndex = workoutExercise.sets.firstIndex(where: { $0.id == set.id }) else {
            return nil
        }

        let previousSets = appData.previousSets(for: workoutExercise.exercise)

        guard currentSetIndex < previousSets.count else {
            return nil
        }

        return previousSets[currentSetIndex]
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
