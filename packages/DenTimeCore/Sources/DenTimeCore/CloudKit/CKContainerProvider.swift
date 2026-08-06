import Foundation

#if canImport(CloudKit)
    import CloudKit

    /// The CloudKit container DenTime uses. There is no other backend — no Workers, no D1,
    /// no Hono, no Better Auth. See docs/planning/DECISIONS.md, decision 1.
    public enum CKContainerProvider {
        /// Container identifier. Matches the app's bundle ID with the `iCloud.` prefix.
        public static let containerIdentifier = "iCloud.com.mrdemonwolf.dentime"

        /// The shared container.
        public static var container: CKContainer {
            CKContainer(identifier: containerIdentifier)
        }

        /// Public database — only `UserProfile` lives here.
        public static var publicDatabase: CKDatabase { container.publicCloudDatabase }
        /// Private database — packs, roster entries, blocks, settings.
        public static var privateDatabase: CKDatabase { container.privateCloudDatabase }
        /// Shared database — meetups the user has joined but does not own.
        public static var sharedDatabase: CKDatabase { container.sharedCloudDatabase }
    }
#endif

/// Whether the user's iCloud account can be used right now.
///
/// Modelled separately from CloudKit's own enum so the UI layer can switch over a stable
/// set of cases, and so this type is available on platforms without CloudKit.
public enum CloudAccountStatus: Equatable, Sendable {
    /// Signed in and usable.
    case available
    /// No iCloud account on the device.
    case noAccount
    /// Restricted by parental controls or an MDM profile.
    case restricted
    /// CloudKit could not say — usually a transient network problem.
    case couldNotDetermine
    /// Signed in, but iCloud Drive or the app's sync is switched off.
    case temporarilyUnavailable
}

/// Reads iCloud account state. Implemented in phase 4.
public protocol CloudAccountObserving: Sendable {
    /// The current account status.
    func currentStatus() async throws -> CloudAccountStatus
    /// The signed-in user's own CloudKit record name, when available.
    func currentUserRecordName() async throws -> String
}
