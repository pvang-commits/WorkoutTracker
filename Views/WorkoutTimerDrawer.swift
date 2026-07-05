import SwiftUI

struct WorkoutTimerDrawer: View {
    @State private var isExpanded = false
    @State private var secondsElapsed = 0
    @State private var isRunning = false

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 12) {
            Capsule()
                .frame(width: 40, height: 5)
                .foregroundStyle(.secondary)
                .padding(.top, 8)

            Text(timeString(secondsElapsed))
                .font(.system(size: isExpanded ? 48 : 22, weight: .bold, design: .monospaced))

            if isExpanded {
                HStack {
                    Button(isRunning ? "Pause" : "Start") {
                        isRunning.toggle()
                    }
                    .buttonStyle(.borderedProminent)

                    Button("Reset") {
                        secondsElapsed = 0
                        isRunning = false
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: isExpanded ? 180 : 70)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 8)
        .padding(.horizontal)
        .onTapGesture {
            withAnimation {
                isExpanded.toggle()
            }
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    withAnimation {
                        if value.translation.height < -30 {
                            isExpanded = true
                        } else if value.translation.height > 30 {
                            isExpanded = false
                        }
                    }
                }
        )
        .onReceive(timer) { _ in
            if isRunning {
                secondsElapsed += 1
            }
        }
    }

    private func timeString(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    VStack {
        Spacer()
        WorkoutTimerDrawer()
    }
}
