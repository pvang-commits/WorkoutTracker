import Foundation

enum SetTag: String, CaseIterable, Identifiable {
    case warmup
    case working
    case drop

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .warmup: return "Warmup"
        case .working: return "Working"
        case .drop: return "Drop"
        }
    }
}
