import Foundation

struct StoredAppData: Codable {
    var templates: [WorkoutTemplate]
    var exerciseLibrary: [Exercise]
    var workoutHistory: [WorkoutSession]
}
