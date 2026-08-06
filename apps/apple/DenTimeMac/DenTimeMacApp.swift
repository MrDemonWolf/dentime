import DenTimeCore
import SwiftUI

/// DenTime's macOS menu bar app.
///
/// Scaffold only. The Den and Meetups tabs, the Time Peek scrubber and the Settings
/// window are all still to come — see docs/planning/PHASES.md. The mockup they will be
/// built from lives in docs/design.
@main
struct DenTimeMacApp: App {
    var body: some Scene {
        MenuBarExtra("DenTime", systemImage: "clock") {
            RootView()
        }
        .menuBarExtraStyle(.window)
    }
}

/// Placeholder root view. Deliberately nothing more than a label until the Den tab is
/// built against the design.
struct RootView: View {
    /// Popover width from the mockup. The host results view not fitting inside it is a
    /// known open question — see docs/planning/OPEN-QUESTIONS.md.
    static let popoverWidth: CGFloat = 360

    var body: some View {
        Text("DenTime")
            .padding()
            .frame(width: Self.popoverWidth)
            // Exercises the DenTimeCore link at compile time so a broken package
            // reference fails the build rather than surfacing in phase 6.
            .accessibilityIdentifier(Vocabulary.den.terms.collection)
    }
}

#Preview {
    RootView()
}
