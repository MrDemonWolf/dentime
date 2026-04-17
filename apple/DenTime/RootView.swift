#if os(iOS)
import SwiftUI
import DenTimeCore

struct RootView: View {
    @State private var now = Date()
    private let timer = Timer.publish(every: 30, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("DenTime")
                    .font(.largeTitle.bold())
                Text(now, style: .time)
                    .font(.system(size: 56, weight: .semibold, design: .rounded))
                Text(TimeZone.current.identifier.replacingOccurrences(of: "_", with: " "))
                    .foregroundStyle(.secondary)
                Spacer()
                Text("Sign in with Apple to see your roster.")
                    .foregroundStyle(.secondary)
                    .padding()
            }
            .padding()
            .navigationTitle("")
            .onReceive(timer) { now = $0 }
        }
    }
}
#endif
