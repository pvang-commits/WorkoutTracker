import Foundation

class AppData: ObservableObject {
    @Published var templates: [WorkoutTemplate] = []
    @Published var exerciseLibrary: [Exercise] = []

    @Published var currentWorkout: WorkoutSession?
    @Published var workoutHistory: [WorkoutSession] = []
    
    init() {
        if let savedData = PersistenceService.load() {
            templates = savedData.templates
            exerciseLibrary = savedData.exerciseLibrary
            workoutHistory = savedData.workoutHistory
        }
    }

    func addTemplate(named name: String) {
        templates.append(WorkoutTemplate(name: name))
        saveData()
    }

    func addExerciseToLibraryIfNeeded(_ exercise: Exercise) {
        if !exerciseLibrary.contains(where: { $0.name.caseInsensitiveCompare(exercise.name) == .orderedSame }) {
            exerciseLibrary.append(exercise)
            saveData()
        }
    }
    
    func startWorkout(from template: WorkoutTemplate) {
        let workoutExercises = template.exercises.map { templateExercise in
            let previousSets = previousSets(for: templateExercise.exercise)

            let newSets = previousSets.map { previousSet in
                LoggedSet(
                    tag: previousSet.tag,
                    rawInput: "",
                    weight: nil,
                    reps: nil
                )
            }

            return WorkoutExercise(
                exercise: templateExercise.exercise,
                sets: newSets
            )
        }

        currentWorkout = WorkoutSession(
            templateName: template.name,
            exercises: workoutExercises
        )
    }
    
    func finishCurrentWorkout() {
        guard let workout = currentWorkout else { return }

        for workoutExercise in workout.exercises {
            addExerciseToLibraryIfNeeded(workoutExercise.exercise)
        }

        workoutHistory.append(workout)
        currentWorkout = nil
        saveData()
    }
    
    func previousSets(for exercise: Exercise) -> [LoggedSet] {
        for workout in workoutHistory.reversed() {
            if let matchingExercise = workout.exercises.first(where: {
                $0.exercise.name.caseInsensitiveCompare(exercise.name) == .orderedSame
            }) {
                return matchingExercise.sets
            }
        }

        return []
    }
    
    func addExerciseToCurrentWorkout(_ exercise: Exercise) {
        addExerciseToLibraryIfNeeded(exercise)

        let previousSets = previousSets(for: exercise)

        let newSets = previousSets.map { previousSet in
            LoggedSet(
                tag: previousSet.tag,
                rawInput: "",
                weight: nil,
                reps: nil
            )
        }

        let workoutExercise = WorkoutExercise(
            exercise: exercise,
            sets: newSets
        )

        currentWorkout?.exercises.append(workoutExercise)
    }
    
    func addedExercisesComparedToTemplate() -> [Exercise] {
        guard let workout = currentWorkout,
              let template = templates.first(where: { $0.name == workout.templateName }) else {
            return []
        }

        let templateExerciseNames = Set(
            template.exercises.map { $0.exercise.name.lowercased() }
        )

        return workout.exercises
            .map { $0.exercise }
            .filter { !templateExerciseNames.contains($0.name.lowercased()) }
    }

    func addNewWorkoutExercisesToTemplate() {
        guard let workout = currentWorkout,
              let templateIndex = templates.firstIndex(where: { $0.name == workout.templateName }) else {
            return
        }

        let addedExercises = addedExercisesComparedToTemplate()

        for exercise in addedExercises {
            templates[templateIndex].exercises.append(
                TemplateExercise(exercise: exercise)
            )
        }
        saveData()
        
    }
    
    func mostRecentSets(for exercise: Exercise) -> [LoggedSet] {
        for workout in workoutHistory.reversed() {
            if let matchingExercise = workout.exercises.first(where: {
                $0.exercise.name.caseInsensitiveCompare(exercise.name) == .orderedSame
            }) {
                return matchingExercise.sets
            }
        }

        return []
    }
    func renameExercise(_ exercise: Exercise, to newName: String) {
        let trimmedName = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }

        for index in exerciseLibrary.indices {
            if exerciseLibrary[index].id == exercise.id {
                exerciseLibrary[index].name = trimmedName
                saveData()
            }
        }

        for templateIndex in templates.indices {
            for exerciseIndex in templates[templateIndex].exercises.indices {
                if templates[templateIndex].exercises[exerciseIndex].exercise.id == exercise.id {
                    templates[templateIndex].exercises[exerciseIndex].exercise.name = trimmedName
                }
            }
        }

        if currentWorkout != nil {
            for exerciseIndex in currentWorkout!.exercises.indices {
                if currentWorkout!.exercises[exerciseIndex].exercise.id == exercise.id {
                    currentWorkout!.exercises[exerciseIndex].exercise.name = trimmedName
                }
            }
        }

        for workoutIndex in workoutHistory.indices {
            for exerciseIndex in workoutHistory[workoutIndex].exercises.indices {
                if workoutHistory[workoutIndex].exercises[exerciseIndex].exercise.id == exercise.id {
                    workoutHistory[workoutIndex].exercises[exerciseIndex].exercise.name = trimmedName
                }
            }
        }
    }
    
    func saveData() {
        let data = StoredAppData(
            templates: templates,
            exerciseLibrary: exerciseLibrary,
            workoutHistory: workoutHistory
        )

        PersistenceService.save(data)
    }
}
