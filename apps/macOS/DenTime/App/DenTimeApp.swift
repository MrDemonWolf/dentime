import SwiftUI

@main
struct DenTimeApp: App {
    @StateObject private var friendStore = FriendStore()
    @StateObject private var settings = SettingsStore()
    @StateObject private var appState = AppState()

    var body: some Scene {
        MenuBarExtra("DenTime", image: "MenuBarIcon") {
            RootView()
                .environmentObject(friendStore)
                .environmentObject(settings)
                .environmentObject(appState)
                .frame(width: 360, height: 520)
        }
        .menuBarExtraStyle(.window)
    }
}

enum MainTab: Hashable {
    case now
    case meet
    case settings
}

@MainActor
final class AppState: ObservableObject {
    @Published var selectedTab: MainTab = .now
    @Published var editingFriend: Friend?
    @Published var showingAddSheet: Bool = false
    @Published var toastMessage: String?
}
