import Foundation

struct PersistenceService {
    static let fileName = "workout_app_data.json"

    static var fileURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(fileName)
    }

    static func save(_ data: StoredAppData) {
        do {
            let encoded = try JSONEncoder().encode(data)
            try encoded.write(to: fileURL, options: [.atomic])
        } catch {
            print("Failed to save data:", error)
        }
    }

    static func load() -> StoredAppData? {
        do {
            let data = try Data(contentsOf: fileURL)
            return try JSONDecoder().decode(StoredAppData.self, from: data)
        } catch {
            print("No saved data found or failed to load:", error)
            return nil
        }
    }
}
