import SwiftUI

struct ExerciseLibraryView: View {
    @EnvironmentObject var appData: AppData
    @State private var searchText = ""
    @State private var exerciseToRename: Exercise?

    private var filteredExercises: [Exercise] {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return appData.exerciseLibrary.sorted { $0.name < $1.name }
        }

        return appData.exerciseLibrary
            .filter { $0.name.localizedCaseInsensitiveContains(searchText) }
            .sorted { $0.name < $1.name }
    }

    var body: some View {
        List {
            if filteredExercises.isEmpty {
                Text("No exercises found")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(filteredExercises) { exercise in
                    Button {
                        exerciseToRename = exercise
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(exercise.name)
                                .font(.headline)
                                .foregroundStyle(.primary)

                            let recentSets = appData.mostRecentSets(for: exercise)

                            if recentSets.isEmpty {
                                Text("No logged sets yet")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            } else {
                                Text("Last: \(summary(for: recentSets))")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        }
        .navigationTitle("Exercises")
        .searchable(text: $searchText, prompt: "Search exercises")
        
        .sheet(item: $exerciseToRename) { exercise in
            RenameExerciseView(exercise: exercise)
        }
    }

    private func summary(for sets: [LoggedSet]) -> String {
        let validSets = sets.compactMap { set -> String? in
            guard let weight = set.weight, let reps = set.reps else {
                return nil
            }

            return "\(String(format: "%.0f", weight)) × \(reps)"
        }

        return validSets.joined(separator: ", ")
    }
}

#Preview {
    let appData = AppData()
    appData.exerciseLibrary = [
        Exercise(name: "Bench Press"),
        Exercise(name: "Lat Pulldown")
    ]

    return NavigationStack {
        ExerciseLibraryView()
            .environmentObject(appData)
    }
}
