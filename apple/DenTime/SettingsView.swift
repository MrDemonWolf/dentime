#if os(macOS)
import SwiftUI

struct SettingsView: View {
    var body: some View {
        TabView {
            AccountPane()
                .tabItem { Label("Account", systemImage: "person.crop.circle") }
            GeneralPane()
                .tabItem { Label("General", systemImage: "gear") }
            AboutPane()
                .tabItem { Label("About", systemImage: "info.circle") }
        }
        .frame(width: 520, height: 380)
    }
}

struct AccountPane: View {
    var body: some View {
        Form {
            Text("Sign in flow lands in Phase 2.")
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

struct GeneralPane: View {
    @AppStorage("launchAtLogin") private var launchAtLogin = false
    @AppStorage("showRichTimeline") private var showRichTimeline = false

    var body: some View {
        Form {
            Toggle("Launch at login", isOn: $launchAtLogin)
            Toggle("Show rich timeline under roster", isOn: $showRichTimeline)
        }
        .padding()
    }
}

struct AboutPane: View {
    var body: some View {
        VStack(spacing: 8) {
            Text("DenTime").font(.title)
            Text("Version 0.1.0 (1)").foregroundStyle(.secondary)
            Link("mrdemonwolf.github.io/dentime", destination: URL(string: "https://mrdemonwolf.github.io/dentime")!)
        }
        .padding()
    }
}
#endif
