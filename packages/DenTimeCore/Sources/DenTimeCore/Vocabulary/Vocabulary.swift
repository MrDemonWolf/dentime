import Foundation

/// Den or Team wording.
///
/// This setting swaps **seven nouns and nothing else**. The voice does not change: same
/// verbs, same buttons, same errors, same tone. A work user is not put off by friendly
/// copy — they are put off by screenshotting "your pack" into a client Slack channel.
///
/// If this ever needs an eighth noun, that is the signal DenTime has quietly become two
/// products, and the setting should be cut rather than extended. See
/// docs/planning/DECISIONS.md, decision 9.
public enum Vocabulary: String, Equatable, Sendable, Codable, CaseIterable {
    case den
    case team

    /// The seven nouns, and only the seven nouns.
    public var terms: VocabularyTerms {
        switch self {
        case .den:
            return VocabularyTerms(
                collection: "Den",
                group: "Pack",
                host: "Host",
                gathering: "Meetup",
                code: "Friend code",
                attending: "Who's in",
                planVerb: "Make a plan"
            )
        case .team:
            return VocabularyTerms(
                collection: "Team",
                group: "Group",
                host: "Organizer",
                gathering: "Meeting",
                code: "Member code",
                attending: "Attending",
                planVerb: "Schedule"
            )
        }
    }

    /// The one-line preview shown beside the segmented control in Settings.
    public var settingsPreview: String {
        let terms = self.terms
        return "\(terms.collection) · \(terms.group) · \(terms.gathering) · \(terms.attending)"
    }
}

/// The seven swappable nouns. Deliberately a fixed-size struct rather than a dictionary,
/// so adding an eighth is a visible code change and not a quiet config edit.
public struct VocabularyTerms: Equatable, Sendable {
    /// Den → Team. The roster as a whole.
    public let collection: String
    /// Pack → Group. A collapsible subset of the roster.
    public let group: String
    /// Host → Organizer. Whoever created the meetup.
    public let host: String
    /// Meetup → Meeting. The poll itself.
    public let gathering: String
    /// Friend code → Member code.
    public let code: String
    /// Who's in → Attending. The participant list.
    public let attending: String
    /// Make a plan → Schedule. The primary action.
    public let planVerb: String

    public init(
        collection: String,
        group: String,
        host: String,
        gathering: String,
        code: String,
        attending: String,
        planVerb: String
    ) {
        self.collection = collection
        self.group = group
        self.host = host
        self.gathering = gathering
        self.code = code
        self.attending = attending
        self.planVerb = planVerb
    }
}
