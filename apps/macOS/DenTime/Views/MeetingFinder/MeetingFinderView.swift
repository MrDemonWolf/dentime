import SwiftUI
import AppKit

struct MeetingFinderView: View {
    @EnvironmentObject var friendStore: FriendStore
    @EnvironmentObject var settings: SettingsStore
    @EnvironmentObject var appState: AppState

    @State private var meetingDate: Date = MeetingFinderView.defaultDate()
    @State private var includedIDs: Set<UUID> = []

    var body: some View {
        VStack(spacing: 0) {
            picker
            Divider()
            if friendStore.friends.isEmpty {
                Spacer()
                Text("Add friends in the Now tab first.")
                    .font(.caption).foregroundStyle(.secondary)
                Spacer()
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(friendStore.groupedFriends, id: \.group) { group in
                            Section {
                                ForEach(group.friends) { friend in
                                    row(for: friend)
                                }
                            } header: {
                                Text(group.group.uppercased())
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.secondary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, 12)
                                    .padding(.top, 10)
                                    .padding(.bottom, 4)
                            }
                        }
                    }
                }
            }
            Divider()
            Button {
                copySummary()
            } label: {
                Label("Copy as text", systemImage: "doc.on.clipboard")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(Color("BrandCyan"))
            .disabled(friendStore.friends.isEmpty)
            .padding(12)
        }
        .onAppear {
            includedIDs = Set(friendStore.friends.map(\.id))
        }
    }

    private var picker: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Meeting time (\(TimeZone.current.abbreviation() ?? "local"))")
                .font(.caption).foregroundStyle(.secondary)
            DatePicker("", selection: $meetingDate, displayedComponents: [.date, .hourAndMinute])
                .labelsHidden()
                .datePickerStyle(.compact)
        }
        .padding(12)
    }

    private func row(for friend: Friend) -> some View {
        let converted = convertedString(for: friend)
        let statusBG = statusColor(for: friend).opacity(0.15)

        return HStack(spacing: 8) {
            Toggle("", isOn: Binding(
                get: { includedIDs.contains(friend.id) },
                set: { isOn in
                    if isOn { includedIDs.insert(friend.id) } else { includedIDs.remove(friend.id) }
                }
            ))
            .labelsHidden()
            .toggleStyle(.checkbox)

            VStack(alignment: .leading, spacing: 1) {
                Text(friend.name).font(.subheadline.weight(.medium))
                Text(friend.city).font(.caption2).foregroundStyle(.secondary)
            }
            Spacer()
            if let badge = dayBadge(for: friend) {
                Text(badge)
                    .font(.caption2.monospacedDigit())
                    .padding(.horizontal, 4)
                    .background(Color.secondary.opacity(0.2))
                    .clipShape(Capsule())
            }
            Text(converted)
                .font(.system(.subheadline, design: .monospaced))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(statusBG)
    }

    private func convertedString(for friend: Friend) -> String {
        let f = DateFormatter()
        f.dateFormat = settings.timeFormat.dateFormat
        f.timeZone = friend.timezone
        return f.string(from: meetingDate)
    }

    private func dayBadge(for friend: Friend) -> String? {
        var local = Calendar(identifier: .gregorian)
        local.timeZone = TimeZone.current
        var there = Calendar(identifier: .gregorian)
        there.timeZone = friend.timezone

        let localDay = local.startOfDay(for: meetingDate)
        let thereDayRaw = there.startOfDay(for: meetingDate)
        // Express both as days-from-reference.
        let days = local.dateComponents([.day], from: localDay, to: thereDayRaw).day ?? 0
        if days == 0 { return nil }
        return days > 0 ? "+\(days)d" : "\(days)d"
    }

    private func statusColor(for friend: Friend) -> Color {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = friend.timezone
        let hour = cal.component(.hour, from: meetingDate)
        return TimeStatus.classify(
            hour: hour,
            workingStart: settings.workingHoursStart,
            workingEnd: settings.workingHoursEnd
        ).tintColor
    }

    private func copySummary() {
        let localFmt = DateFormatter()
        localFmt.dateFormat = "EEEE MMM d"
        localFmt.timeZone = TimeZone.current
        let dayStr = localFmt.string(from: meetingDate)

        let timeFmt = DateFormatter()
        timeFmt.dateFormat = settings.timeFormat.dateFormat

        timeFmt.timeZone = TimeZone.current
        let localCity = (TimeZone.current.identifier.split(separator: "/").last ?? "local")
            .replacingOccurrences(of: "_", with: " ")
        let localTime = timeFmt.string(from: meetingDate)

        let others = friendStore.friends
            .filter { includedIDs.contains($0.id) }
            .sorted { $0.name < $1.name }
            .map { friend -> String in
                timeFmt.timeZone = friend.timezone
                return "\(timeFmt.string(from: meetingDate)) \(friend.city)"
            }
            .joined(separator: ", ")

        let summary = others.isEmpty
            ? "\(dayStr) at \(localTime) \(localCity)"
            : "\(dayStr) at \(localTime) \(localCity) is \(others)"

        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(summary, forType: .string)

        appState.toastMessage = "Copied!"
        Task {
            try? await Task.sleep(nanoseconds: 1_500_000_000)
            await MainActor.run { appState.toastMessage = nil }
        }
    }

    private static func defaultDate() -> Date {
        let now = Date()
        let cal = Calendar.current
        var comps = cal.dateComponents([.year, .month, .day, .hour, .minute], from: now)
        let minute = comps.minute ?? 0
        if minute == 0 || minute == 30 {
            comps.minute = minute
        } else if minute < 30 {
            comps.minute = 30
        } else {
            comps.minute = 0
            comps.hour = (comps.hour ?? 0) + 1
        }
        return cal.date(from: comps) ?? now
    }
}
