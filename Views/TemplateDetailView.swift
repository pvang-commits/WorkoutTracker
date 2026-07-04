import SwiftUI

struct TemplateDetailView: View {
    let template: WorkoutTemplate

    var body: some View {
        List {
            ForEach(template.exercises) { exercise in
                Text(exercise.name)
            }
        }
        .navigationTitle(template.name)
        .toolbar {
            Button {
                // Add exercise later
            } label: {
                Image(systemName: "plus")
            }
        }
    }
}

#Preview {
    TemplateDetailView(
        template: WorkoutTemplate(
            name: "Push",
            exercises: [
                WorkoutExercise(name: "Bench Press"),
                WorkoutExercise(name: "Incline Bench")
            ]
        )
    )
}
