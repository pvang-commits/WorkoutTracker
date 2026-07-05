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
