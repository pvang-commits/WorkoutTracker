import Foundation

struct SetParser {
    static func parse(_ input: String) -> (weight: Double, reps: Int)? {
        let cleaned = input
            .lowercased()
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "×", with: "x")
            .replacingOccurrences(of: "*", with: "x")

        let parts = cleaned.split(separator: "x")

        guard parts.count == 2,
              let weight = Double(parts[0]),
              let reps = Int(parts[1]) else {
            return nil
        }

        return (weight, reps)
    }
}
