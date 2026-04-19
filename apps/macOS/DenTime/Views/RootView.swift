import SwiftUI
import AppKit

struct RootView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var friendStore: FriendStore
    @EnvironmentObject var settings: SettingsStore

    var body: some View {
        VStack(spacing: 0) {
            header
            Divider()
            content
            Spacer(minLength: 0)
            if let msg = appState.toastMessage {
                toast(msg)
            }
        }
        .background(hiddenShortcuts)
        .background(Color("BrandNavy").opacity(0.04))
        .sheet(isPresented: $appState.showingAddSheet) {
            AddFriendView(mode: .add)
                .environmentObject(friendStore)
        }
        .sheet(item: $appState.editingFriend) { friend in
            AddFriendView(mode: .edit(friend))
                .environmentObject(friendStore)
        }
    }

    private var header: some View {
        HStack {
            Image("MenuBarIcon")
                .resizable()
                .renderingMode(.template)
                .foregroundColor(Color("BrandCyan"))
                .frame(width: 16, height: 16)
            Text("DenTime").font(.headline)
            Spacer()
            Picker("", selection: $appState.selectedTab) {
                Text("Now").tag(MainTab.now)
                Text("Find a Time").tag(MainTab.meet)
                Image(systemName: "gear").tag(MainTab.settings)
            }
            .pickerStyle(.segmented)
            .frame(width: 220)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
    }

    @ViewBuilder
    private var content: some View {
        switch appState.selectedTab {
        case .now: RosterView()
        case .meet: MeetingFinderView()
        case .settings: SettingsView()
        }
    }

    private var hiddenShortcuts: some View {
        VStack {
            Button("") { appState.selectedTab = .now }
                .keyboardShortcut("1", modifiers: .command)
            Button("") { appState.selectedTab = .meet }
                .keyboardShortcut("2", modifiers: .command)
            Button("") { appState.selectedTab = .settings }
                .keyboardShortcut(",", modifiers: .command)
            Button("") { appState.showingAddSheet = true }
                .keyboardShortcut("n", modifiers: .command)
            Button("") { NSApplication.shared.terminate(nil) }
                .keyboardShortcut("q", modifiers: .command)
        }
        .opacity(0)
        .frame(width: 0, height: 0)
    }

    private func toast(_ msg: String) -> some View {
        Text(msg)
            .font(.caption)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color("BrandCyan").opacity(0.9))
            .foregroundColor(.white)
            .clipShape(Capsule())
            .padding(.bottom, 8)
            .transition(.opacity)
    }
}
