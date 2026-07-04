import SwiftUI

struct ContentView: View {
    @State private var templates: [WorkoutTemplate] = []
    @State private var exerciseLibrary: [Exercise] = []
    @State private var showingAddTemplate = false

    var body: some View {
        NavigationStack {
            List {
                ForEach($templates) { $template in
                    NavigationLink {
                        TemplateDetailView(
                            template: $template,
                            exerciseLibrary: $exerciseLibrary
                        )
                    } label: {
                        Text(template.name)
                    }
                }
            }
            .navigationTitle("Templates")
            .toolbar {
                Button {
                    showingAddTemplate = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddTemplate) {
                AddTemplateView { name in
                    templates.append(WorkoutTemplate(name: name))
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
