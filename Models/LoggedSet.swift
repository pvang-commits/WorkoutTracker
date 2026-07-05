import Foundation

struct LoggedSet: Identifiable, Codable {
    var id = UUID()
    var tag: SetTag = .working
    var rawInput: String = ""
    var weight: Double?
    var reps: Int?
}
