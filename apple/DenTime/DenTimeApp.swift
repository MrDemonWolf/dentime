import SwiftUI
import DenTimeCore

@main
struct DenTimeApp: App {
    var body: some Scene {
        #if os(macOS)
        MenuBarExtra {
            MenuBarView()
        } label: {
            Image(systemName: "clock")
        }
        .menuBarExtraStyle(.window)

        Settings {
            SettingsView()
        }
        #else
        WindowGroup {
            RootView()
        }
        #endif
    }
}
