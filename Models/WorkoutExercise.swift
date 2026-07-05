import Foundation

struct WorkoutExercise: Identifiable, Codable {
    var id = UUID()
    var exercise: Exercise
    var sets: [LoggedSet] = []
}
