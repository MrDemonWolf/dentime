import Foundation
import SwiftUI

enum TimeStatus {
    case working
    case edge
    case sleep

    /// Classify an hour-of-day (0-23) against configured working hours.
    /// Within [start, end): working. One hour before/after window: edge. Else: sleep.
    static func classify(hour: Int, workingStart: Int, workingEnd: Int) -> TimeStatus {
        let normalized = ((hour % 24) + 24) % 24
        if normalized >= workingStart && normalized < workingEnd {
            return .working
        }
        if normalized == ((workingStart - 1 + 24) % 24) || normalized == (workingEnd % 24) {
            return .edge
        }
        return .sleep
    }

    var tintColor: Color {
        switch self {
        case .working: return .green
        case .edge: return .yellow
        case .sleep: return .red
        }
    }

    var label: String {
        switch self {
        case .working: return "Working hours"
        case .edge: return "Edge of day"
        case .sleep: return "Sleeping"
        }
    }
}
