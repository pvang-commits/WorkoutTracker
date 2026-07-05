import Foundation

struct WorkoutSession: Identifiable {
    let id = UUID()
    let date = Date()
    var templateName: String
    var exercises: [WorkoutExercise]
}
