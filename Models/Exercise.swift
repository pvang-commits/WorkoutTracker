import Foundation

struct Exercise: Identifiable, Hashable, Codable {
    var id = UUID()
    var name: String
}
