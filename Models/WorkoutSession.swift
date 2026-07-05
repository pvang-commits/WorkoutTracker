import Foundation

struct WorkoutSession: Identifiable, Codable {
    var id = UUID()
    let date = Date()
    var templateName: String
    var exercises: [WorkoutExercise]
}
