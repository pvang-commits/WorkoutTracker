import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var appData: AppData

    var body: some View {
        List {
            if appData.workoutHistory.isEmpty {
                Text("No completed workouts yet")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(appData.workoutHistory.indices.reversed(), id: \.self) { index in
                    NavigationLink {
                        EditableWorkoutDetailView(workout: $appData.workoutHistory[index])
                    } label: {
                        VStack(alignment: .leading) {
                            Text(appData.workoutHistory[index].templateName)
                                .font(.headline)

                            Text(appData.workoutHistory[index].date, style: .date)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle("History")
        .navigationTitle("History")
    }

    private func setDescription(_ set: LoggedSet) -> String {
        if let weight = set.weight, let reps = set.reps {
            return "\(set.tag.displayName): \(String(format: "%.0f", weight)) lb x \(reps)"
        } else {
            return "\(set.tag.displayName): \(set.rawInput)"
        }
    }
}

#Preview {
    let appData = AppData()

    var bench = WorkoutExercise(exercise: Exercise(name: "Bench Press"))
    bench.sets = [
        LoggedSet(tag: .working, rawInput: "225x8", weight: 225, reps: 8)
    ]

    appData.workoutHistory = [
        WorkoutSession(templateName: "Push", exercises: [bench])
    ]

    return NavigationStack {
        HistoryView()
            .environmentObject(appData)
    }
}
