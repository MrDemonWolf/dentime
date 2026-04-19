import Foundation
import Combine
import ServiceManagement

@MainActor
final class SettingsStore: ObservableObject {
    @Published var timeFormat: TimeFormat {
        didSet { defaults.set(timeFormat.rawValue, forKey: Keys.timeFormat) }
    }
    @Published var workingHoursStart: Int {
        didSet { defaults.set(workingHoursStart, forKey: Keys.workStart) }
    }
    @Published var workingHoursEnd: Int {
        didSet { defaults.set(workingHoursEnd, forKey: Keys.workEnd) }
    }
    @Published var refreshIntervalSeconds: Int {
        didSet { defaults.set(refreshIntervalSeconds, forKey: Keys.refresh) }
    }
    @Published var showDeltaColumn: Bool {
        didSet { defaults.set(showDeltaColumn, forKey: Keys.showDelta) }
    }
    @Published var launchAtLogin: Bool {
        didSet {
            defaults.set(launchAtLogin, forKey: Keys.launchAtLogin)
            applyLaunchAtLogin()
        }
    }

    private let defaults: UserDefaults

    private enum Keys {
        static let timeFormat = "dentime.settings.timeFormat"
        static let workStart = "dentime.settings.workStart"
        static let workEnd = "dentime.settings.workEnd"
        static let refresh = "dentime.settings.refreshSeconds"
        static let showDelta = "dentime.settings.showDelta"
        static let launchAtLogin = "dentime.settings.launchAtLogin"
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults

        let tfRaw = defaults.string(forKey: Keys.timeFormat) ?? TimeFormat.twelveHour.rawValue
        self.timeFormat = TimeFormat(rawValue: tfRaw) ?? .twelveHour

        self.workingHoursStart = defaults.object(forKey: Keys.workStart) as? Int ?? 9
        self.workingHoursEnd = defaults.object(forKey: Keys.workEnd) as? Int ?? 18
        self.refreshIntervalSeconds = defaults.object(forKey: Keys.refresh) as? Int ?? 30
        self.showDeltaColumn = defaults.object(forKey: Keys.showDelta) as? Bool ?? true
        self.launchAtLogin = defaults.bool(forKey: Keys.launchAtLogin)
    }

    private func applyLaunchAtLogin() {
        guard #available(macOS 13.0, *) else { return }
        do {
            if launchAtLogin {
                try SMAppService.mainApp.register()
            } else {
                try SMAppService.mainApp.unregister()
            }
        } catch {
            // Non-fatal; surface via logging only.
            print("Launch-at-login toggle failed: \(error)")
        }
    }
}
