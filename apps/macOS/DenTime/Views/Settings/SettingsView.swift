import SwiftUI
import AppKit

struct SettingsView: View {
    @EnvironmentObject var settings: SettingsStore

    private let refreshOptions = [15, 30, 60]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                section("Display") {
                    Picker("Time format", selection: $settings.timeFormat) {
                        ForEach(TimeFormat.allCases) { f in
                            Text(f.label).tag(f)
                        }
                    }
                    .pickerStyle(.segmented)
                    Toggle("Show delta column (+Nh)", isOn: $settings.showDeltaColumn)
                }

                section("Working hours") {
                    HStack {
                        Stepper(
                            "Start: \(formatHour(settings.workingHoursStart))",
                            value: $settings.workingHoursStart,
                            in: 0...23
                        )
                    }
                    HStack {
                        Stepper(
                            "End: \(formatHour(settings.workingHoursEnd))",
                            value: $settings.workingHoursEnd,
                            in: 1...24
                        )
                    }
                }

                section("Refresh") {
                    Picker("", selection: $settings.refreshIntervalSeconds) {
                        ForEach(refreshOptions, id: \.self) { s in
                            Text("\(s)s").tag(s)
                        }
                    }
                    .pickerStyle(.segmented)
                    .labelsHidden()
                }

                section("Startup") {
                    Toggle("Launch DenTime at login", isOn: $settings.launchAtLogin)
                }

                section("About") {
                    Text("DenTime v\(versionString)")
                        .font(.caption)
                    Text("© 2026 MrDemonWolf, Inc.")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    Link("mrdemonwolf.github.io/dentime",
                         destination: URL(string: "https://mrdemonwolf.github.io/dentime")!)
                        .font(.caption)
                    Button("Quit DenTime") {
                        NSApplication.shared.terminate(nil)
                    }
                    .keyboardShortcut("q", modifiers: .command)
                }
            }
            .padding(12)
        }
    }

    private func section<Content: View>(
        _ title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title.uppercased())
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
            content()
        }
    }

    private func formatHour(_ hour: Int) -> String {
        let h = ((hour % 24) + 24) % 24
        return String(format: "%02d:00", h)
    }

    private var versionString: String {
        let short = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "0"
        return "\(short) (\(build))"
    }
}
