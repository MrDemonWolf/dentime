#if os(macOS)
import SwiftUI
import DenTimeCore

struct MenuBarView: View {
    @State private var now = Date()
    private let timer = Timer.publish(every: 30, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("DenTime")
                .font(.headline)
            Text(now, style: .time)
                .font(.system(.title2, design: .rounded, weight: .semibold))
            Divider()
            Text("Sign in with Apple to see your roster.")
                .font(.callout)
                .foregroundStyle(.secondary)
            HStack {
                Button("Settings…") {
                    NSApp.activate(ignoringOtherApps: true)
                    if #available(macOS 14.0, *) {
                        NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
                    } else {
                        NSApp.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)
                    }
                }
                Spacer()
                Button("Quit") { NSApp.terminate(nil) }
            }
        }
        .padding(16)
        .frame(width: 280)
        .onReceive(timer) { now = $0 }
    }
}
#endif
