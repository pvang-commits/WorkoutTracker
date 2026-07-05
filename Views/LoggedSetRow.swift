import SwiftUI

struct LoggedSetRow: View {
    @Binding var set: LoggedSet

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Picker("Tag", selection: $set.tag) {
                    ForEach(SetTag.allCases) { tag in
                        Text(tag.displayName).tag(tag)
                    }
                }
                .pickerStyle(.menu)

                TextField("225x8", text: $set.rawInput)
                    .keyboardType(.numbersAndPunctuation)
                    .textFieldStyle(.roundedBorder)
                    .onChange(of: set.rawInput) { _, newValue in
                        if let parsed = SetParser.parse(newValue) {
                            set.weight = parsed.weight
                            set.reps = parsed.reps
                        } else {
                            set.weight = nil
                            set.reps = nil
                        }
                    }
            }

            if let weight = set.weight, let reps = set.reps {
                Text("Parsed: \(weight, specifier: "%.0f") lb × \(reps)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    @Previewable @State var set = LoggedSet()

    LoggedSetRow(set: $set)
        .padding()
}
