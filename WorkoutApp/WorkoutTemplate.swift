import Foundation

struct WorkoutTemplate: Identifiable {
    let id = UUID()
    var name: String
    var exercises: [TemplateExercise] = []
}
