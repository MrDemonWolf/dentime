import SwiftUI
import AppKit

struct RosterView: View {
    @EnvironmentObject var friendStore: FriendStore
    @EnvironmentObject var settings: SettingsStore
    @EnvironmentObject var appState: AppState

    @State private var now: Date = Date()
    @State private var timer: Timer?

    var body: some View {
        VStack(spacing: 0) {
            actionBar
            if friendStore.friends.isEmpty {
                emptyState
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(friendStore.groupedFriends, id: \.group) { group in
                            GroupSection(
                                groupName: group.group,
                                friends: group.friends,
                                now: now
                            )
                        }
                    }
                }
            }
            Divider()
            youRow
        }
        .onAppear { startTimer() }
        .onDisappear { timer?.invalidate() }
        .onChange(of: settings.refreshIntervalSeconds) { _ in startTimer() }
    }

    private var actionBar: some View {
        HStack {
            Button {
                appState.showingAddSheet = true
            } label: {
                Label("Add friend", systemImage: "plus")
            }
            .buttonStyle(.borderless)
            .tint(Color("BrandCyan"))
            Spacer()
            Text("Refreshed \(timeString(now))").font(.caption2).foregroundStyle(.secondary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
    }

    private var emptyState: some View {
        VStack(spacing: 8) {
            Image(systemName: "pawprint")
                .font(.system(size: 36))
                .foregroundColor(Color("BrandCyan"))
            Text("No pack members yet.")
                .font(.headline)
            Text("Hit + to add someone.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }

    private var youRow: some View {
        HStack {
            Circle().fill(Color("BrandCyan")).frame(width: 8, height: 8)
            Text("You")
                .font(.subheadline.bold())
            Text("(\(TimeZone.current.abbreviation() ?? ""))")
                .font(.caption)
                .foregroundStyle(.secondary)
            Spacer()
            Text(timeString(now))
                .font(.system(.subheadline, design: .monospaced))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color("BrandNavy").opacity(0.08))
    }

    private func timeString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = settings.timeFormat.dateFormat
        formatter.timeZone = TimeZone.current
        return formatter.string(from: date)
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(
            withTimeInterval: TimeInterval(settings.refreshIntervalSeconds),
            repeats: true
        ) { _ in
            Task { @MainActor in self.now = Date() }
        }
        now = Date()
    }
}

private struct GroupSection: View {
    let groupName: String
    let friends: [Friend]
    let now: Date

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(groupName.uppercased())
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(friends.count)")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 12)
            .padding(.top, 10)
            .padding(.bottom, 4)

            ForEach(friends) { friend in
                FriendRow(friend: friend, now: now)
            }
        }
    }
}

private struct FriendRow: View {
    @EnvironmentObject var friendStore: FriendStore
    @EnvironmentObject var settings: SettingsStore
    @EnvironmentObject var appState: AppState

    let friend: Friend
    let now: Date

    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(dotColor)
                .frame(width: 8, height: 8)
            VStack(alignment: .leading, spacing: 1) {
                Text(friend.name).font(.subheadline.weight(.medium))
                Text("\(friend.timezone.abbreviation() ?? friend.timezoneIdentifier) · \(friend.city)")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            if settings.showDeltaColumn {
                Text(deltaString)
                    .font(.caption2.monospacedDigit())
                    .foregroundStyle(.secondary)
            }
            Text(timeString)
                .font(.system(.subheadline, design: .monospaced))
                .foregroundColor(statusColor)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .contentShape(Rectangle())
        .onTapGesture { copySummary() }
        .contextMenu {
            Button("Edit") { appState.editingFriend = friend }
            Button("Copy current time") { copySummary() }
            Menu("Move to group") {
                ForEach(friendStore.knownGroups, id: \.self) { g in
                    Button(g) { moveTo(group: g) }
                }
                Divider()
                Button("Ungrouped") { moveTo(group: nil) }
            }
            Divider()
            Button("Delete", role: .destructive) {
                friendStore.delete(id: friend.id)
            }
        }
    }

    private var dotColor: Color {
        if let hex = friend.colorHex, let c = Color(hex: hex) { return c }
        return Color("BrandCyan")
    }

    private var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = settings.timeFormat.dateFormat
        formatter.timeZone = friend.timezone
        return formatter.string(from: now)
    }

    private var deltaString: String {
        let d = friend.hourDelta()
        if d == 0 { return "±0h" }
        return d > 0 ? "+\(d)h" : "\(d)h"
    }

    private var statusColor: Color {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = friend.timezone
        let hour = cal.component(.hour, from: now)
        return TimeStatus.classify(
            hour: hour,
            workingStart: settings.workingHoursStart,
            workingEnd: settings.workingHoursEnd
        ).tintColor
    }

    private func copySummary() {
        let fmt = DateFormatter()
        fmt.dateFormat = settings.timeFormat.dateFormat
        fmt.timeZone = friend.timezone
        let timeStr = fmt.string(from: now)

        let dayFmt = DateFormatter()
        dayFmt.dateFormat = "EEE"
        dayFmt.timeZone = friend.timezone
        let dayStr = dayFmt.string(from: now)

        let summary = "It's \(timeStr) \(dayStr) for \(friend.name) in \(friend.city)"
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(summary, forType: .string)

        appState.toastMessage = "Copied!"
        Task {
            try? await Task.sleep(nanoseconds: 1_500_000_000)
            await MainActor.run { appState.toastMessage = nil }
        }
    }

    private func moveTo(group: String?) {
        var copy = friend
        copy.groupName = group
        friendStore.update(copy)
    }
}

extension Color {
    init?(hex: String) {
        var clean = hex
        if clean.hasPrefix("#") { clean.removeFirst() }
        guard clean.count == 6, let rgb = UInt64(clean, radix: 16) else { return nil }
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0
        self = Color(red: r, green: g, blue: b)
    }
}
