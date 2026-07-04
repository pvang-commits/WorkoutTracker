import SwiftUI

struct ContentView: View {
    @State private var templates: [WorkoutTemplate] = []
    @State private var showingAddTemplate = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(templates) { template in
                    NavigationLink {
                        TemplateDetailView(template: template)
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
                    let newTemplate = WorkoutTemplate(name: name)
                    templates.append(newTemplate)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
