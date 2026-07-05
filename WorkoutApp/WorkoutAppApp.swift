import SwiftUI

@main
struct WorkoutAppApp: App {

    @StateObject private var appData = AppData()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appData)
        }
    }
}
