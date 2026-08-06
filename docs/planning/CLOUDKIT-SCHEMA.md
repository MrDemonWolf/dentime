# CloudKit schema

Container: **`iCloud.com.mrdemonwolf.dentime`**

There is no other backend. See [DECISIONS.md](DECISIONS.md), decision 1.

---

## Public database

Only what must be resolvable by a stranger holding a friend code.

| Record type | Fields | Notes |
|---|---|---|
| `UserProfile` | `friendCode` (String, **queryable + indexed**)<br>`displayName` (String)<br>`timeZoneIdentifier` (String)<br>`avatarEmoji` (String) | The only public record type. No email, no location beyond an IANA time zone identifier, no history. **This is the entire public blast radius of DenTime.** |

`avatarEmoji` rather than an image is deliberate: no uploads means no image moderation.

---

## Private database

The user's own data. Never visible to anyone else, ever.

| Record type | Fields |
|---|---|
| `Pack` | `name`, `sortOrder`, `isCollapsed` |
| `RosterEntry` | `packRef` (Reference, optional)<br>`sortOrder`<br>`linkedProfileRef` (Reference to public `UserProfile`, optional)<br>`manualName` (optional)<br>`manualTimeZone` (optional) |
| `Block` | `blockedFriendCode`, `createdAt` |
| `Settings` | `vocabulary` (String: `den` \| `team`), `timeFormat`, `launchAtLogin` |

### The RosterEntry constraint

A `RosterEntry` has **either** `linkedProfileRef` — a real DenTime user added by friend code — **or** `manualName` plus `manualTimeZone`, for someone who does not use the app. Never both. Never neither.

CloudKit has no check constraints, so this is enforced in `DenTimeCore` instead, by making the two cases an enum rather than four optionals that could all be nil at once:

```swift
public enum RosterEntryKind {
    case linked(friendCode: FriendCode, profileRecordName: String?)
    case manual(name: String, timeZoneIdentifier: String)
}
```

A linked row's name and zone come from the live public profile, so it updates when that person travels. A manual row's stay put.

`Block` stores the **code**, not a record reference, so a block survives the other person deleting and recreating their profile.

---

## Shared database, via `CKShare`

One share per meetup, owned by the host.

| Record type | Fields |
|---|---|
| `Meetup` (share root) | `createdAt`, `status`, `joinCode`, `hostDisplayName` — **no title, no description** |
| `MeetupSlot` | `meetupRef`, `startsAtUTC`, `durationMinutes` |
| `MeetupResponse` | `slotRef`, `participantRecordID`, `participantDisplayName`, `response` (`yes` \| `no` \| `maybe`), `respondedAt` |

`startsAtUTC` is an instant, never a wall-clock time plus a zone. Every participant renders the same moment in their own local time and nobody has to reason about whose zone the number was written in.

**Why `CKShare` and not the public database:** the share URL *is* the join link, and removing a participant from a share is enforced by CloudKit at the storage layer. That gives real, enforced kick — the one place blocking genuinely bites.

`hostDisplayName` and `participantDisplayName` are denormalised so the host's results view renders in one pass rather than one profile lookup per row.

---

## Things that will bite

### Queryable fields need indexes set by hand

CloudKit does not create them for you, and there is no build-time check. **`UserProfile.friendCode` is the critical one** — without its index, adding someone by friend code fails at runtime, in production, with an error that does not obviously point at a missing index.

Set it in the CloudKit dashboard, in both the development and production environments.

### The schema lives in a dashboard, not in git

There is no migration file, no schema-as-code, and dev→prod is a manual promote step. Nothing in this repo can verify that the deployed schema matches what the code expects.

**Unsolved.** Recorded in [OPEN-QUESTIONS.md](OPEN-QUESTIONS.md). Treat this document as the closest thing to a schema of record and update it in the same commit as any field change.

### Account deletion has three parts, and all three must succeed

Apple auto-rejects apps without working in-app account deletion — guideline 5.1.1(v).

1. Delete the public `UserProfile`.
2. Purge the private zone — packs, roster entries, blocks, settings.
3. Delete **every share the user owns**, which also removes their meetups for everyone who joined.

Missing any one of these leaves the account partially alive. See [APPLE.md](APPLE.md).

### Record names are optional in the models until first save

Every model in `DenTimeCore` has `recordName: String?`, nil until CloudKit assigns one. Code that assumes a record name exists will crash on freshly created objects.
