import Foundation

class TemplateViewModel: ObservableObject {
    @Published var template: WorkoutTemplate

    init(template: WorkoutTemplate) {
        self.template = template
    }

    func addExercise(named name: String) {
        let exercise = WorkoutExercise(name: name)
        template.exercises.append(exercise)
    }
}
