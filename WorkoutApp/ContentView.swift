import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appData: AppData
    @State private var showingAddTemplate = false

    var body: some View {
        NavigationStack {
            List {
                ForEach($appData.templates) { $template in
                    NavigationLink {
                        TemplateDetailView(template: $template)
                    } label: {
                        Text(template.name)
                    }
                }
                .onDelete { indexSet in
                    appData.templates.remove(atOffsets: indexSet)
                }
            }
            .navigationTitle("Templates")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink {
                        HistoryView()
                    } label: {
                        Image(systemName: "clock")
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddTemplate = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink {
                        ExerciseLibraryView()
                    } label: {
                        Image(systemName: "dumbbell")
                    }
                }
            }
            .sheet(isPresented: $showingAddTemplate) {
                AddTemplateView { name in
                    appData.addTemplate(named: name)
                }
            }
            .environmentObject(appData)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppData())
}
