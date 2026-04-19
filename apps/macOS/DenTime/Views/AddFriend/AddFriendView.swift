import SwiftUI

enum AddFriendMode: Equatable {
    case add
    case edit(Friend)

    var title: String {
        switch self {
        case .add: return "Add Friend"
        case .edit: return "Edit Friend"
        }
    }
}

struct AddFriendView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var friendStore: FriendStore

    let mode: AddFriendMode

    @State private var name: String = ""
    @State private var timezoneQuery: String = ""
    @State private var timezoneIdentifier: String = TimeZone.current.identifier
    @State private var group: String = ""
    @State private var newGroupMode: Bool = false
    @State private var newGroupText: String = ""
    @State private var colorHex: String? = nil
    @State private var editingId: UUID? = nil

    private let swatches = [
        "#0FACED", "#091533", "#22C55E", "#EAB308",
        "#EF4444", "#A855F7", "#EC4899", "#F97316",
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(mode.title).font(.title3.weight(.semibold))

            // Name
            TextField("Name", text: $name)
                .textFieldStyle(.roundedBorder)

            // Timezone
            VStack(alignment: .leading, spacing: 4) {
                Text("Timezone").font(.caption).foregroundStyle(.secondary)
                TextField("Search (e.g. Tokyo)", text: $timezoneQuery)
                    .textFieldStyle(.roundedBorder)
                Picker("", selection: $timezoneIdentifier) {
                    ForEach(filteredTimezones, id: \.self) { tz in
                        Text(tz).tag(tz)
                    }
                }
                .labelsHidden()
                .pickerStyle(.menu)
                Text("Currently: \(previewTime)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            // Group
            VStack(alignment: .leading, spacing: 4) {
                Text("Group").font(.caption).foregroundStyle(.secondary)
                if newGroupMode {
                    HStack {
                        TextField("New group name", text: $newGroupText)
                            .textFieldStyle(.roundedBorder)
                        Button("Done") {
                            group = newGroupText
                            newGroupMode = false
                        }
                    }
                } else {
                    Picker("", selection: $group) {
                        Text("Ungrouped").tag("")
                        ForEach(friendStore.knownGroups, id: \.self) { g in
                            Text(g).tag(g)
                        }
                        Divider()
                        Text("New group…").tag("__new__")
                    }
                    .labelsHidden()
                    .onChange(of: group) { newValue in
                        if newValue == "__new__" {
                            newGroupMode = true
                            newGroupText = ""
                            group = ""
                        }
                    }
                }
            }

            // Color
            VStack(alignment: .leading, spacing: 4) {
                Text("Color").font(.caption).foregroundStyle(.secondary)
                HStack(spacing: 6) {
                    ForEach(swatches, id: \.self) { hex in
                        Circle()
                            .fill(Color(hex: hex) ?? .gray)
                            .frame(width: 20, height: 20)
                            .overlay(
                                Circle().stroke(
                                    colorHex == hex ? Color.primary : Color.clear,
                                    lineWidth: 2
                                )
                            )
                            .onTapGesture { colorHex = hex }
                    }
                    Button {
                        colorHex = nil
                    } label: {
                        Image(systemName: "xmark.circle")
                    }
                    .buttonStyle(.borderless)
                }
            }

            Spacer()

            HStack {
                Spacer()
                Button("Cancel") { dismiss() }
                    .keyboardShortcut(.cancelAction)
                Button(mode == .add ? "Add" : "Save") { save() }
                    .keyboardShortcut(.defaultAction)
                    .disabled(!isValid)
            }
        }
        .padding(16)
        .frame(width: 360, height: 440)
        .onAppear(perform: loadFromMode)
    }

    private var filteredTimezones: [String] {
        let all = TimeZone.knownTimeZoneIdentifiers.sorted()
        guard !timezoneQuery.isEmpty else { return all }
        return all.filter { $0.localizedCaseInsensitiveContains(timezoneQuery) }
    }

    private var previewTime: String {
        guard let tz = TimeZone(identifier: timezoneIdentifier) else { return "—" }
        let f = DateFormatter()
        f.dateFormat = "h:mm a"
        f.timeZone = tz
        return f.string(from: Date())
    }

    private var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
            && TimeZone(identifier: timezoneIdentifier) != nil
    }

    private func loadFromMode() {
        if case .edit(let friend) = mode {
            name = friend.name
            timezoneIdentifier = friend.timezoneIdentifier
            group = friend.groupName ?? ""
            colorHex = friend.colorHex
            editingId = friend.id
        }
    }

    private func save() {
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        let resolvedGroup = group.isEmpty ? nil : group
        switch mode {
        case .add:
            friendStore.add(Friend(
                name: trimmedName,
                timezoneIdentifier: timezoneIdentifier,
                groupName: resolvedGroup,
                colorHex: colorHex
            ))
        case .edit(let original):
            var updated = original
            updated.name = trimmedName
            updated.timezoneIdentifier = timezoneIdentifier
            updated.groupName = resolvedGroup
            updated.colorHex = colorHex
            friendStore.update(updated)
        }
        dismiss()
    }
}
