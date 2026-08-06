# Jira backlog — MDW DenTime

Ticket ideas for the **MDW DenTime** Jira project, key **`TIME`**.

**No board exists yet.** This is the source document; [`prompts/CLAUDE-CHROME-JIRA-SETUP.md`](prompts/CLAUDE-CHROME-JIRA-SETUP.md) is the prompt that creates the project and the issues from it. Issue keys below (`TIME-1`, `TIME-9`, …) are the expected numbering if issues are created in the order listed — they are not real keys until the board is made.

## Conventions

Copied from **MDW FangDash (`FD`)**, which is the house pattern.

- **Project:** team-managed software project, category **Platform**, lead Nathanial Henniges
- **Epics** get a one-paragraph prose description. No headings inside.
- **Tasks** get this exact description structure:

  ```
  ## Description
  One or two sentences.

  ## Acceptance Criteria
  * …
  * …

  ## Labels
  phase-3, core, swift
  ```

- **Priority:** Medium on everything unless stated
- **Assignee:** Nathanial Henniges
- **Status:** To Do, except where marked ✅ below — those are already done and should be created in Done
- **Labels:** one phase label (`phase-1` … `phase-12`, mirroring FangDash's `day-N`) plus area labels

Area labels in use: `setup`, `ci`, `docs`, `cloudkit`, `core`, `swift`, `auth`, `den`, `timepeek`, `meetups`, `settings`, `safety`, `appstore`, `design`.

## Epic map

| Epic | Key | Phases | Tasks |
|---|---|---|---|
| Setup & Infrastructure | TIME-1 | 1 | TIME-9 … TIME-16 |
| CloudKit Foundation | TIME-2 | 2 | TIME-17 … TIME-22 |
| DenTimeCore | TIME-3 | 3 | TIME-23 … TIME-28 |
| Identity & Profile | TIME-4 | 4, 5 | TIME-29 … TIME-35 |
| Den — Roster, Packs & Time Peek | TIME-5 | 6, 7, 8 | TIME-36 … TIME-49 |
| Meetups | TIME-6 | 9, 10 | TIME-50 … TIME-61 |
| Settings, Safety & Account | TIME-7 | 11 | TIME-62 … TIME-69 |
| App Store & Release | TIME-8 | 12 | TIME-70 … TIME-77 |

---

# Epics

### TIME-1 · Setup & Infrastructure

> Monorepo scaffold, Swift package, Xcode project, docs site and CI. Bun workspaces with Turborepo for the TypeScript side; `apps/apple` and `packages/DenTimeCore` deliberately sit outside the build graph because Xcode builds them. Everything else depends on this epic. Largely complete as of 2026-08-06.

### TIME-2 · CloudKit Foundation

> The container, the record types and the indexes. All of it is done by hand in the CloudKit dashboard — there is no schema-as-code and no migration file, so this epic is clicking plus careful documentation. `UserProfile.friendCode` needs a queryable index or adding people by code fails at runtime in production. Nothing from TIME-4 onward works until this is done.

### TIME-3 · DenTimeCore

> The shared Swift package: models, friend and join codes, time-zone maths, vocabulary and the CloudKit store protocols. Pure logic with no UI and no network, which is why it is where the real test coverage lives. Complete as of 2026-08-06 apart from the store bodies, which are `fatalError("unimplemented")` until their phases land.

### TIME-4 · Identity & Profile

> Sign in with Apple, iCloud account status handling, and the one public record type. Most people hitting a broken DenTime are hitting a signed-out iCloud rather than a bug, so the failure states carry as much weight here as the happy path. Friend-code lookup and rotation are the payload of this epic.

### TIME-5 · Den — Roster, Packs & Time Peek

> The default tab and everything behind it: private-database CRUD for packs and roster entries, adding people by friend code or by hand, blocking, and the Time Peek scrubber. Day-of-week appears on every row because the wrong-day failure mode is the one bug that would kill this app. Design-ready — build against `docs/design/DenTime App v2.dc.html`.

### TIME-6 · Meetups

> Doodle-style polls over two to five slots, each meetup wrapped in its own `CKShare` owned by the host. Join-by-code only: no push, no notification, no way for a stranger to reach anyone. No title field and no description field, which is what keeps display names the only user-written text in the app. The host results view is the hard part.

### TIME-7 · Settings, Safety & Account

> The Settings window, the Den/Team vocabulary swap, and the safety surface Apple requires: Block, Report, and account deletion that purges all three stores. Delete account is an auto-reject under guideline 5.1.1(v) if it is missing, so this epic is not optional polish.

### TIME-8 · App Store & Release

> Everything between a working app and a submitted one. The seeded demo account and reviewer notes come first because they defuse three rejection risks at once — a reviewer who lands in a populated den never wonders whether this is just a world clock.

---

# TIME-1 · Setup & Infrastructure

### TIME-9 — Scaffold Bun + Turborepo monorepo with Biome ✅

```
## Description

Set up the repository root: Bun workspaces, Turborepo, Biome, pinned toolchain and a .gitignore covering Bun, Turborepo and Xcode.

## Acceptance Criteria

* `package.json` lists workspaces explicitly as `["apps/docs"]`, not a glob — a glob would pull `apps/apple` into the Bun workspace
* `turbo.json` defines build, dev, typecheck, test, lint and clean
* Biome replaces ESLint and Prettier; `bun run check` passes
* `.editorconfig`, `.tool-versions` and `packageManager` pin the toolchain
* `.gitignore` covers `node_modules`, `.turbo`, `.next`, `out`, `.source`, `xcuserdata`, `DerivedData` and `.build`
* No `Packages/` rule in `.gitignore` — macOS is case-insensitive and it would ignore this repo's own `packages/`
* `bun install` succeeds from a clean clone

## Labels

phase-1, setup
```

### TIME-10 — Create the DenTimeCore Swift package skeleton ✅

```
## Description

Create `packages/DenTimeCore` with the directory layout, platform declarations and empty targets, so later tickets have somewhere to land.

## Acceptance Criteria

* `swift-tools-version:5.10`, platforms macOS 14 / iOS 17 / watchOS 10 declared now so the package stays portable
* Source groups: `Models`, `TimeMath`, `CloudKit`, `Codes`, `Vocabulary`
* `Tests/DenTimeCoreTests` exists
* No third-party dependencies
* `swift build` and `swift test` succeed

## Labels

phase-1, setup, core
```

### TIME-11 — Create the apps/apple Xcode project via XcodeGen ✅

```
## Description

Create the Xcode project with one macOS target, generated from a committed `project.yml`.

## Acceptance Criteria

* `apps/apple/project.yml` is the source of truth; `DenTime.xcodeproj` is generated and gitignored
* One target, `DenTimeMac`, macOS 14+
* `MenuBarExtra` scene with `LSUIElement = true` — no Dock icon
* Root view is a single `Text("DenTime")` and nothing more
* Links `DenTimeCore` as a local package dependency
* Shared `.xcconfig` carries version, team ID and deployment target
* Asset catalog defines `BrandNavy` #091533 and `BrandCyan` #0FACED; app icons left as placeholders
* Entitlements: CloudKit on `iCloud.com.mrdemonwolf.dentime`, Sign in with Apple, App Sandbox with `com.apple.security.network.client`
* Bundle ID is `com.mrdemonwolf.dentime` with no suffix
* No EventKit, StoreKit, contacts, location, camera or microphone entitlements

## Labels

phase-1, setup, swift
```

### TIME-12 — Build the Fumadocs docs site with placeholder pages ✅

```
## Description

Stand up `apps/docs` as a static Fumadocs site exported to GitHub Pages, with stub pages so the routes exist.

## Acceptance Criteria

* Next.js static export with `basePath: "/dentime"` in production
* Brand colours in the theme via `@theme inline`
* Pages exist and build: index, getting-started, friend-codes, meetups, privacy, support
* Each page is a heading plus a one-line TODO — no real copy yet
* `/docs/privacy` and `/docs/support` return 200; App Review opens both
* No `CNAME` — GitHub Pages only, no custom domain
* `bun run --filter @dentime/docs dev` serves the site on :3001

## Labels

phase-1, setup, docs
```

### TIME-13 — Add CI, docs deploy, Dependabot and templates ✅

```
## Description

Add the GitHub Actions workflows and repository configuration.

## Acceptance Criteria

* `ci.yml` runs Biome, typecheck, test and docs build on ubuntu-latest
* `ci.yml` runs `swift build` and `swift test` for DenTimeCore on macos-15 — not the Xcode target, which is too slow per push
* `ci.yml` fails the build on any `import EventKit` or `import StoreKit`
* `ci.yml` fails the build on a resurrected backend dependency or config file
* `docs-deploy.yml` deploys `apps/docs/out` to GitHub Pages with `.nojekyll`
* Dependabot covers npm and github-actions, weekly, grouped
* Bug and feature issue templates, PR template, CODEOWNERS → @MrDemonWolf

## Labels

phase-1, setup, ci
```

### TIME-14 — Write the planning docs and CLAUDE.md ✅

```
## Description

Commit the project's memory in-tree so every future session and subagent reads the same thing.

## Acceptance Criteria

* `CLAUDE.md` at the repo root, under 150 lines
* `docs/planning/` contains DECISIONS, SPEC, PHASES, APPLE, CLOUDKIT-SCHEMA and OPEN-QUESTIONS
* DECISIONS.md is stated as the source of truth when documents disagree
* Superseded MVP1/MVP2 material moved to `docs/planning/archive/` rather than deleted, with a README saying what is dead and why
* Nothing is gitignored — a fresh clone or git worktree sees all of it

## Labels

phase-1, setup, docs
```

### TIME-15 — Import the v2 design into docs/design ✅

```
## Description

Copy the reviewed v2 mockup out of the Claude Design project and into the repo as reference material.

## Acceptance Criteria

* `docs/design/` contains the v2 mockup, the design system file, `support.js` and the UI/UX review
* A README names the canonical file and records the two review findings that are still open
* Superseded v1 mockup deliberately not copied, and the reason stated
* No SwiftUI written from it in this ticket — reference only

## Labels

phase-1, design, docs
```

### TIME-16 — Configure GitHub Pages and verify the deploy

```
## Description

Turn on GitHub Pages for the repository and confirm the docs site is actually reachable at the URLs App Store Connect will be given.

## Acceptance Criteria

* Pages source set to GitHub Actions
* `docs-deploy.yml` runs green on a push to main
* `https://mrdemonwolf.github.io/dentime/` loads
* `https://mrdemonwolf.github.io/dentime/docs/privacy/` returns 200
* `https://mrdemonwolf.github.io/dentime/docs/support/` returns 200
* Repository stays public — GitHub Pages needs it on the free plan

## Labels

phase-1, setup, ci, docs
```

---

# TIME-2 · CloudKit Foundation

### TIME-17 — Create the iCloud.com.mrdemonwolf.dentime container

```
## Description

Create the CloudKit container and connect it to the macOS target.

## Acceptance Criteria

* Container `iCloud.com.mrdemonwolf.dentime` exists in the Apple Developer account
* Container identifier matches the entitlements file exactly
* The container appears in both the development and production environments
* App launches and reports a usable account status on a signed-in Mac

## Labels

phase-2, cloudkit
```

### TIME-18 — Define UserProfile in the public database

```
## Description

Create the only public record type. Its four fields are the entire public blast radius of DenTime.

## Acceptance Criteria

* `UserProfile` created in the public database
* Fields: `friendCode` (String), `displayName` (String), `timeZoneIdentifier` (String), `avatarEmoji` (String)
* No email, no location beyond an IANA identifier, no history fields
* Field names match `Profile` in DenTimeCore exactly

## Labels

phase-2, cloudkit
```

### TIME-19 — Add the queryable index on UserProfile.friendCode

```
## Description

Mark `friendCode` queryable and add its index. This is the single index the app cannot work without, and its absence fails at runtime rather than at build time.

## Acceptance Criteria

* `UserProfile.friendCode` marked queryable
* A queryable index added on that field
* Done in the development environment and again in production
* A test lookup by friend code returns a record rather than an index error

## Labels

phase-2, cloudkit
```

### TIME-20 — Define the private database record types

```
## Description

Create the record types that hold the user's own data and are never visible to anyone else.

## Acceptance Criteria

* `Pack`: `name`, `sortOrder`, `isCollapsed`
* `RosterEntry`: `packRef`, `sortOrder`, `linkedProfileRef`, `manualName`, `manualTimeZone`
* `Block`: `blockedFriendCode`, `createdAt`
* `Settings`: `vocabulary`, `timeFormat`, `launchAtLogin`
* The either-linked-or-manual rule on RosterEntry is documented as enforced in DenTimeCore, since CloudKit has no check constraints
* Field names match the DenTimeCore models exactly

## Labels

phase-2, cloudkit
```

### TIME-21 — Define the shared database record types for meetups

```
## Description

Create the meetup record types that live inside each host's `CKShare`.

## Acceptance Criteria

* `Meetup` as the share root: `createdAt`, `status`, `joinCode`, `hostDisplayName`
* `Meetup` has no title field and no description field
* `MeetupSlot`: `meetupRef`, `startsAtUTC`, `durationMinutes`
* `MeetupResponse`: `slotRef`, `participantRecordID`, `participantDisplayName`, `response`, `respondedAt`
* `startsAtUTC` stores an instant, never a wall-clock time plus a zone

## Labels

phase-2, cloudkit, meetups
```

### TIME-22 — Promote the schema to production and document what was clicked

```
## Description

Promote the development schema to production and write down the steps, because there is no migration file to read later.

## Acceptance Criteria

* Schema promoted from development to production
* Every index recreated in production, verified rather than assumed
* `docs/planning/CLOUDKIT-SCHEMA.md` updated to match exactly what was deployed
* The promote procedure written down step by step so the next promote is repeatable

## Labels

phase-2, cloudkit, docs
```

---

# TIME-3 · DenTimeCore

### TIME-23 — Implement FriendCode and JoinCode with Crockford base32 ✅

```
## Description

Implement the two eight-symbol code types, generated on device with no server involvement.

## Acceptance Criteria

* Crockford base32 alphabet, 32 symbols, excluding I, L, O and U
* `FriendCode` displays as `DEN·XXXX-XXXX`; `JoinCode` as `HOWL·XXXX-XXXX`
* Parse is case-insensitive and tolerates the prefix, hyphens, spaces and surrounding whitespace
* Parse rejects I, L, O and U outright rather than decoding them, and the deviation from canonical Crockford is recorded in OPEN-QUESTIONS.md
* Parse rejects the wrong prefix with a distinct error
* A code beginning with its own prefix letters is not truncated
* Codes encode as a bare JSON string, not an object
* Generation accepts an injected random generator so tests are deterministic

## Labels

phase-3, core, swift
```

### TIME-24 — Implement TimeZoneResolver and TimePeek ✅

```
## Description

Pure time-zone maths over `TimeZone` and `Date`. No network, no CloudKit, no reads of `TimeZone.current` inside the functions.

## Acceptance Criteria

* Offset in seconds and a display label covering whole, half and quarter-hour zones
* Relative offset between two zones computed at a specific instant, not from a table
* Civil day number and day delta computed on calendar dates, never by dividing seconds by 86,400
* Helpers for wall-clock times that do not exist and wall-clock times that happen twice
* `TimePeek.rows` renders every row for one instant with hour, minute, weekday, weekday symbol, day delta, offset label, abbreviation, night flag and preformatted time
* Scrub clamps to ±12 hours
* Time formatting is composed by hand rather than via `DateFormatter`, so a locale cannot break the tabular column

## Labels

phase-3, core, swift, timepeek
```

### TIME-25 — Add DST boundary tests ✅

```
## Description

Test the transitions hard rather than sampling mid-season. Someone showing up on the wrong day is the one bug that kills this app.

## Acceptance Criteria

* US spring-forward and fall-back covered, including the hour that does not exist and the hour that happens twice
* A European transition on a different date, proving offsets are not assumed to move together
* Half-hour and 45-minute zones covered
* Lord Howe covered — its DST shift is thirty minutes, not an hour
* A southern-hemisphere zone covered, running opposite the north
* A 23-hour calendar day advances the day number by exactly one
* A scrub that crosses midnight in one zone but not another
* Tests use a fixed-locale calendar so weekday symbols do not depend on the machine

## Labels

phase-3, core, swift, timepeek
```

### TIME-26 — Define the model layer ✅

```
## Description

Value types for every record, matching the CloudKit schema field for field.

## Acceptance Criteria

* `Profile`, `Pack`, `RosterEntry`, `Meetup`, `MeetupSlot`, `MeetupResponse`, `Block`, `Settings`
* All Equatable, Sendable and Codable
* `RosterEntry` uses an enum for linked-versus-manual so the either/or rule cannot be violated
* `recordName` is optional on every model, nil until first save
* `MeetupSlot` exposes the two-to-five slot bounds as constants
* Slot validation covers count, duplicate starts and non-positive durations, and runs before any network call

## Labels

phase-3, core, swift
```

### TIME-27 — Implement Vocabulary ✅

```
## Description

The Den/Team noun swap. Seven nouns, and nothing else.

## Acceptance Criteria

* Den mode: Den, Pack, Host, Meetup, Friend code, Who's in, Make a plan
* Team mode: Team, Group, Organizer, Meeting, Member code, Attending, Schedule
* The terms are a fixed struct, not a dictionary, so adding an eighth is a visible code change
* A preview string is exposed for the segmented control in Settings
* Tests assert all seven differ between modes
* Den is the default

## Labels

phase-3, core, swift
```

### TIME-28 — Declare the CloudKit store protocols ✅

```
## Description

Protocols and signatures for the four stores, with bodies left unimplemented until their phases.

## Acceptance Criteria

* `ProfileStoring`, `RosterStoring`, `MeetupStoring`, `ShareCoordinating` and `CloudAccountObserving` declared
* Concrete types conform with `fatalError("unimplemented")` bodies
* CloudKit imports guarded with `#if canImport(CloudKit)` so the package still compiles elsewhere
* An `AccountDeleting` protocol exists and documents that all three stores must be purged
* A `CloudAccountStatus` enum models every account state the UI has to handle

## Labels

phase-3, core, swift, cloudkit
```

---

# TIME-4 · Identity & Profile

### TIME-29 — Add Sign in with Apple

```
## Description

Sign in with Apple is the only sign-in method DenTime offers, which by itself satisfies App Store guideline 4.8.

## Acceptance Criteria

* Sign in with Apple entitlement wired and working on device
* No email/password, no other social provider, no anonymous mode
* Sign-in state persists across launches
* Sign out available from Settings → Account
* No credentials stored by the app itself

## Labels

phase-4, auth
```

### TIME-30 — Implement CloudAccountObserving over CKContainer.accountStatus

```
## Description

Read iCloud account state and map it onto the app's own status enum.

## Acceptance Criteria

* All of available, no account, restricted, could-not-determine and temporarily unavailable are mapped
* Status is re-read when the app becomes active and when the account changes
* The signed-in user's CloudKit record name is available to callers
* Transient failures are retried rather than surfaced immediately as an error

## Labels

phase-4, auth, cloudkit
```

### TIME-31 — Build the signed-out and account-unavailable states

```
## Description

Most people hitting a broken DenTime are hitting a signed-out iCloud, not a bug. These screens are where that gets explained.

## Acceptance Criteria

* Each account status shows a distinct message that names the actual problem
* A signed-out user sees a sign-in prompt, not an empty den
* Restricted and temporarily unavailable are distinguished — they need different fixes
* Copy follows the language rules; no error codes shown without plain-language text
* Recovery action provided where one exists, e.g. opening System Settings

## Labels

phase-4, auth, den
```

### TIME-32 — Create and publish the user's public UserProfile

```
## Description

Write the signed-in user's public profile so other people can resolve them by friend code.

## Acceptance Criteria

* On first sign-in, generate a friend code and create the public `UserProfile`
* Display name, time zone identifier and avatar emoji captured during onboarding
* Time zone identifier updates when the device's zone changes
* Editing a display name updates the public record
* Creation is idempotent — a second launch does not create a second profile

## Labels

phase-5, auth, cloudkit
```

### TIME-33 — Implement friend-code lookup

```
## Description

Resolve a stranger's public profile from a friend code. This is the only query DenTime ever runs against the public database.

## Acceptance Criteria

* `lookup(friendCode:)` returns the matching profile or nil
* A malformed code fails locally, before any network call
* A missing index surfaces as a diagnosable error rather than a generic failure
* Blocked codes return nothing, filtered client-side
* Looking up your own code is handled rather than adding yourself

## Labels

phase-5, auth, cloudkit
```

### TIME-34 — Implement friend-code rotation

```
## Description

Issue a new friend code and invalidate the old one. This is what gives blocking real teeth.

## Acceptance Criteria

* Rotate generates a new code and updates the public profile in one operation
* The old code no longer resolves to anything afterwards
* People who already have you in their den keep working — they hold a profile reference, not a code
* The UI warns that anyone holding the old code will lose the ability to add you
* Rotation is available from Settings → Account

## Labels

phase-5, auth, safety
```

### TIME-35 — Implement public profile deletion

```
## Description

Delete the public `UserProfile`. One of the three things account deletion has to purge.

## Acceptance Criteria

* The public record is deleted and no longer resolves by friend code
* Deletion is idempotent and does not fail when the record is already gone
* Failure is reported rather than swallowed — a partly-deleted account is worse than a failed delete
* Covered by the account-deletion flow in TIME-66

## Labels

phase-5, auth, safety
```

---

# TIME-5 · Den — Roster, Packs & Time Peek

### TIME-36 — Implement private database CRUD for Pack

```
## Description

Create, read, update and delete packs in the user's private database.

## Acceptance Criteria

* Fetch returns packs in sort order
* Create, rename and delete work
* Deleting a pack leaves its entries ungrouped rather than deleting them
* Collapsed state persists across launches
* Sort order survives reordering

## Labels

phase-6, den, cloudkit
```

### TIME-37 — Implement private database CRUD for RosterEntry

```
## Description

Create, read, update and delete roster entries.

## Acceptance Criteria

* Fetch returns entries in sort order
* Linked and manual entries both round-trip correctly
* The either-linked-or-manual rule is enforced by the model, not by a runtime check
* Deleting an entry does not touch the linked person's public profile
* Entries survive an app restart

## Labels

phase-6, den, cloudkit
```

### TIME-38 — Implement reordering and moving entries between packs

```
## Description

Persist manual ordering, and moving people from one pack to another.

## Acceptance Criteria

* Reordering within a pack persists
* Moving between packs updates both the pack reference and the sort order
* A batched reorder is a single save, not one write per row
* Order is stable when two entries have the same sort value
* Moving to "no pack" works

## Labels

phase-6, den, cloudkit
```

### TIME-39 — Implement add-by-friend-code

```
## Description

Add a real DenTime user to the den by entering their friend code.

## Acceptance Criteria

* A valid code resolves and creates a linked roster entry
* The row's name and zone come from the live public profile, so it updates when they travel
* An unknown code shows a clear message rather than a silent failure
* A blocked code cannot be added
* Adding someone who is already in the den is a no-op with a message, not a duplicate
* Adds are one-way — nothing is written to the other person's den

## Labels

phase-6, den
```

### TIME-40 — Implement add-manually

```
## Description

Add someone who does not use DenTime, by name and time zone.

## Acceptance Criteria

* Name and IANA time zone captured, with a searchable zone picker
* The entry renders identically to a linked one apart from having no friend code
* Name and zone stay put — a manual entry never updates itself
* A manual entry can be edited later
* A manual entry can be replaced by a linked one if that person later joins

## Labels

phase-6, den
```

### TIME-41 — Implement Block and unblock

```
## Description

Client-side blocking, backed by the `Block` record type.

## Acceptance Criteria

* Blocking a friend code creates a `Block` record and removes them from the den
* Blocked codes are filtered out of lookups and out of meetup participant lists
* Unblocking restores lookup but does not re-add them to the den
* The block stores the code, not a record reference, so it survives them recreating a profile
* UI copy says "You won't see them" and never "They can't see you"

## Labels

phase-6, den, safety
```

### TIME-42 — Build the Den tab person rows

```
## Description

The core row of the app: avatar, name, local time, zone and day of week.

## Acceptance Criteria

* Time is the visual anchor — large tabular monospaced digits against small meta text
* Day of week appears on every row, no exceptions
* Zone abbreviation or offset label shown when there is no meaningful abbreviation
* Asleep state is dimmed plus ☾ plus a label — never colour alone
* Micro-labels meet WCAG AA contrast; the v2 review raised this and it must not regress
* Row layout survives the Den/Team vocabulary swap without relayout

## Labels

phase-7, den, design
```

### TIME-43 — Build collapsible packs with drag between them

```
## Description

Packs as collapsible groups in the Den, LocalWP-style, with drag to move people.

## Acceptance Criteria

* Packs collapse and expand, and the state persists
* People drag between packs and to the ungrouped area
* Pack header shows the pack name and a count
* Create, rename and delete a pack from the Den
* Drag has a visible drop target and does not lose a row on a failed drop

## Labels

phase-7, den, design
```

### TIME-44 — Build the row … menu

```
## Description

Per-row actions: Edit, Block, Remove.

## Acceptance Criteria

* `…` appears on every den row
* Edit opens the right editor for a linked versus a manual entry
* Block feeds Settings → Blocked and removes the row
* Remove is styled destructively
* Menu is reachable by keyboard as well as by pointer

## Labels

phase-7, den, safety, design
```

### TIME-45 — Implement an undo toast for Remove

```
## Description

Removing someone acts immediately with an undo affordance rather than asking for confirmation first. Open finding from the v2 UI/UX review.

## Acceptance Criteria

* Remove takes effect immediately, with a toast offering undo
* Undo restores the entry with its original pack and sort order
* The toast dismisses on its own after a few seconds
* No confirmation dialog — removal is low-cost and reversible, so a modal is the wrong weight
* Removing several people in a row does not stack toasts unreadably

## Labels

phase-7, den, design
```

### TIME-46 — Build the Den empty state

```
## Description

What a new user sees before they have added anyone. This is also the screen an App Review reviewer might land on, which is why the demo account matters.

## Acceptance Criteria

* Explains what a den is in one line, without corporate filler
* Offers both add paths: by friend code and manually
* Shows the user their own friend code so they have something to share
* Never reads as an error state
* Copy follows the language rules — den, pack, who's around

## Labels

phase-7, den, design
```

### TIME-47 — Build the Time Peek scrubber control

```
## Description

The scrubber at the top of the Den tab. Not its own tab.

## Acceptance Criteria

* Range is ±12 hours around now
* Current offset is displayed while dragging
* A reset-to-now affordance exists and is obvious
* Fully client-side — no network call, no CloudKit read while scrubbing
* Position resets to now when the popover reopens

## Labels

phase-8, timepeek, den, design
```

### TIME-48 — Wire Time Peek to live row updates and the day delta

```
## Description

Every row re-renders live as the scrubber moves, including when a zone rolls into a different calendar day.

## Acceptance Criteria

* Every row updates on every scrubber change with no visible lag on a full den
* Day-delta indicator appears when a row's calendar day differs from the user's
* Weekday symbol updates along with the time
* Asleep state re-evaluates as the scrubbed time crosses the night window
* Scrubbing across a DST transition shows the correct wall-clock jump rather than a naive hour

## Labels

phase-8, timepeek, den
```

### TIME-49 — Add keyboard support and a discoverability hint to the scrubber

```
## Description

The scrubber responds to arrow keys but nothing tells the user so. Open finding from the v2 UI/UX review.

## Acceptance Criteria

* Arrow keys move the scrubber in fixed increments; shift-arrow moves in larger ones
* The control is reachable by tab and shows a visible focus ring
* A one-time hint communicates keyboard control without nagging
* VoiceOver announces the current offset and the resulting time
* Reduced-motion preference respected

## Labels

phase-8, timepeek, design
```

---

# TIME-6 · Meetups

### TIME-50 — Create a meetup with 2–5 slots inside a CKShare

```
## Description

Host-side meetup creation. Each meetup is the root record of its own share.

## Acceptance Criteria

* Two to five slots enforced locally before any network call
* Duplicate slot starts and non-positive durations rejected with distinct errors
* A `CKShare` is created with the meetup as its root record
* A join code is generated locally and stored on the meetup
* `startsAtUTC` stores an instant, so every participant sees the same moment in their own zone
* No title field and no description field anywhere in the flow

## Labels

phase-9, meetups, cloudkit
```

### TIME-51 — Implement join-by-code

```
## Description

Join a meetup by typing its code. There is no invitation and no notification.

## Acceptance Criteria

* A valid `HOWL·` code resolves and accepts the share
* An unknown, rotated or disabled code shows a clear message
* A `DEN·` code entered here fails with a message saying it is a friend code
* Joining twice is a no-op rather than a duplicate participant
* Nothing is sent to anyone at any point in this flow

## Labels

phase-9, meetups, cloudkit
```

### TIME-52 — Implement RSVP create and update

```
## Description

Record a participant's yes/no/maybe for each slot, and let them change their mind.

## Acceptance Criteria

* One response row per participant per slot
* Changing an answer updates the existing row rather than appending
* Responses sync to the host without a manual refresh
* Responding to a closed meetup is refused with a message
* `respondedAt` is recorded

## Labels

phase-9, meetups, cloudkit
```

### TIME-53 — Implement leave and host-side participant removal

```
## Description

Both directions of exit. Removal by the host is the one place blocking genuinely bites, because CloudKit enforces it.

## Acceptance Criteria

* A participant can leave a meetup they joined
* A host can remove a participant from the share
* A removed participant loses access at the storage layer, not just in the UI
* A removed participant's RSVPs stop counting in the host's tally
* A host cannot remove themselves — they close or delete the meetup instead

## Labels

phase-9, meetups, safety
```

### TIME-54 — Implement join-code rotation and disable

```
## Description

Let a host cut off new joins without disrupting people who are already in.

## Acceptance Criteria

* Rotate issues a new code and stops the old one resolving
* Disable stops all new joins while leaving existing participants in place
* Existing participants are unaffected by either action
* The UI explains what each does before it happens
* Both are available from the meetup's own screen

## Labels

phase-9, meetups, safety
```

### TIME-55 — Implement meetup status transitions

```
## Description

Open, closed and settled, and what each one means for participants.

## Acceptance Criteria

* Open accepts joins and RSVPs
* Closed stops new joins; existing participants still see the meetup
* Settled records the chosen slot and is visible to everyone
* Only the host can change status
* Status is reflected in the meetup list without a refresh

## Labels

phase-9, meetups
```

### TIME-56 — Build the meetups list

```
## Description

The Meetups tab: everything you host and everything you have joined.

## Acceptance Criteria

* Each row renders as "[Host name]'s meetup" plus its date range
* Hosted and joined meetups are visually distinguishable
* Status is visible at a glance
* Empty state explains how to create one or join with a code
* Sorted with the soonest relevant meetup first

## Labels

phase-10, meetups, design
```

### TIME-57 — Build slot creation

```
## Description

The host's flow for proposing two to five times.

## Acceptance Criteria

* Add, edit and delete slots up to the five-slot ceiling
* Slots entered in the host's own zone and stored as instants
* Duration set per slot
* Fewer than two slots blocks creation with a clear message
* Duplicate start times are caught before saving

## Labels

phase-10, meetups, design
```

### TIME-58 — Build the join-by-code entry sheet

```
## Description

Where someone pastes the code their friend sent them.

## Acceptance Criteria

* Accepts a pasted code with or without the `HOWL·` prefix, hyphens or spaces
* Validates locally as the user types
* A wrong-prefix code says so specifically
* Paste from clipboard works, including from Discord's formatting
* Success lands the user directly in the meetup

## Labels

phase-10, meetups, design
```

### TIME-59 — Build the RSVP controls

```
## Description

Yes, no, maybe — per slot, in the participant's own local time.

## Acceptance Criteria

* Each slot shows the participant's own local time, weekday and any day delta
* Selected segment is cyan for all three answers; the tally bar keeps semantic colours
* Changing an answer is immediate and visibly confirmed
* Controls are keyboard reachable with a visible focus ring
* Answers survive closing and reopening the popover

## Labels

phase-10, meetups, design
```

### TIME-60 — Design and build the host results view at 360pt

```
## Description

Who is in on what, inside a menu bar panel. Six participants by five slots does not fit as a literal grid — this needs a design answer before it needs code. Open question.

## Acceptance Criteria

* A layout is chosen and the reasoning recorded in OPEN-QUESTIONS.md
* Six participants by five slots is readable at 360pt without horizontal scrolling of the whole panel
* Per-slot totals are visible without expanding anything
* Individual answers are reachable in one interaction
* Works with two participants and with fifteen
* Never relies on colour alone to convey yes/no/maybe

## Labels

phase-10, meetups, design
```

### TIME-61 — Build the "who's in" participant list with Block

```
## Description

The participant list, and the safety action on it.

## Acceptance Criteria

* Lists participants with their display names and avatar emoji
* `…` menu on each row offers Block
* Blocking from here also blocks in the Den
* The host additionally sees Remove from meetup
* Blocked participants disappear from the list for the person who blocked them

## Labels

phase-10, meetups, safety, design
```

---

# TIME-7 · Settings, Safety & Account

### TIME-62 — Build the Settings window shell

```
## Description

A standard settings window on ⌘, — not a third tab.

## Acceptance Criteria

* Opens with ⌘, and from the menu bar
* Panes: General, Account, Blocked, About
* Standard macOS window behaviour, sized to its content
* Closing and reopening returns to the last pane
* Reachable when the popover is closed

## Labels

phase-11, settings
```

### TIME-63 — Build General settings

```
## Description

Launch at login, time format and menu bar icon.

## Acceptance Criteria

* Launch at login toggles and survives a reboot
* 12/24-hour switch applies everywhere immediately
* Menu bar icon choice applies without a restart
* Settings persist through the private database and sync
* Defaults are Den vocabulary, 12-hour, launch at login off

## Labels

phase-11, settings
```

### TIME-64 — Build the Vocabulary segmented control with live preview

```
## Description

Den/Team, with a preview line so the effect is visible before committing.

## Acceptance Criteria

* Segmented control offering Den (default) and Team
* A preview line underneath shows the swapped nouns
* Switching updates every surface immediately, with no relayout
* Only the seven nouns change — verbs, buttons, errors and tone stay identical
* The choice persists and syncs

## Labels

phase-11, settings
```

### TIME-65 — Build the Account pane

```
## Description

Apple ID, friend code, and the two destructive actions.

## Acceptance Criteria

* Shows the signed-in Apple ID
* Shows the friend code in `DEN·XXXX-XXXX` form with a copy button
* Rotate is present and explains what it costs before acting
* Delete account is styled destructively and sits behind a confirmation
* Sign out is available and distinct from delete

## Labels

phase-11, settings, auth
```

### TIME-66 — Implement Delete account across all three stores

```
## Description

Guideline 5.1.1(v) — auto-reject if missing. All three stores must be purged or the account is only partly gone.

## Acceptance Criteria

* Deletes the public `UserProfile`
* Purges the private zone: packs, roster entries, blocks, settings
* Deletes every share the user owns, which removes their meetups for everyone who joined
* Two taps deep from Settings → Account, behind a confirmation that says what will be lost
* Partial failure is reported clearly and can be retried
* The app returns to a clean signed-out state afterwards

## Labels

phase-11, settings, safety, cloudkit
```

### TIME-67 — Add the Report menu item

```
## Description

One menu item that opens a prefilled email. Fifteen minutes, and it satisfies the report requirement.

## Acceptance Criteria

* Report available from the app menu and from participant and roster row menus
* Opens the default mail client with a prefilled recipient and subject
* Body includes app version and the reported friend code where the context has one
* Never sends anything automatically
* The support page states that reports are acted on within 24 hours

## Labels

phase-11, settings, safety
```

### TIME-68 — Build the Blocked list with unblock

```
## Description

Everyone you have blocked, with a way back.

## Acceptance Criteria

* Lists blocked friend codes with the display name where one is known
* Unblock removes the block record
* Unblocking restores lookup but does not re-add them to the den
* Empty state is plain, not alarming
* Copy says "You won't see them", never "They can't see you"

## Labels

phase-11, settings, safety
```

### TIME-69 — Build the About pane

```
## Description

Version, build and the links a reviewer and a user both need.

## Acceptance Criteria

* Shows marketing version and build number
* Links to the docs, the privacy policy and the support page
* Links use the real GitHub Pages URLs and open in a browser
* Copyright line reads MrDemonWolf, Inc.
* Includes an acknowledgement that there are no third-party dependencies

## Labels

phase-11, settings, docs
```

---

# TIME-8 · App Store & Release

### TIME-70 — Seed a demo account and write reviewer notes

```
## Description

Do this early. It defuses three rejection risks at once — a reviewer who lands in a populated den never wonders whether this is just a world clock.

## Acceptance Criteria

* A demo Apple ID with a populated den across at least four time zones
* At least two packs, and at least one manual entry alongside linked ones
* An open meetup with several slots and some RSVPs already recorded
* Sample data reads "movie night", never "Q3 planning sync"
* Reviewer notes explain what DenTime is in two sentences and how to reach the meetup flow
* Credentials recorded somewhere the submission can reach them

## Labels

phase-12, appstore
```

### TIME-71 — Write the real privacy policy page

```
## Description

Replace the placeholder at `/docs/privacy`. The reviewer will open it.

## Acceptance Criteria

* States that data lives in the user's own iCloud and that there is no DenTime server
* Lists exactly what is in the public profile: friend code, display name, time zone identifier, avatar emoji
* States that there is no tracking, no analytics and no third-party SDKs
* Explains what account deletion removes
* Matches the App Store privacy nutrition label exactly
* Returns 200 at the URL given to App Store Connect

## Labels

phase-12, appstore, docs
```

### TIME-72 — Write the real support page

```
## Description

Replace the placeholder at `/docs/support`. Also the reviewer's second click.

## Acceptance Criteria

* Carries a working contact address
* States that reports are acted on within 24 hours
* Explains how to block and how to report from inside the app
* Explains what rotating a friend code does
* Returns 200 at the URL given to App Store Connect

## Labels

phase-12, appstore, docs, safety
```

### TIME-73 — Render app icons from the brand mark

```
## Description

Turn `assets/logo.svg` into the ten macOS icon sizes. Currently placeholders.

## Acceptance Criteria

* All ten macOS sizes rendered, 16 through 512 at 1x and 2x
* Cyan paw on navy with clock hands in the main pad
* Legible at 16pt — the clock hands are the first thing that stops working small
* Asset catalog has no missing-image warnings
* App builds with zero warnings afterwards

## Labels

phase-12, appstore, design
```

### TIME-74 — Wire the menu bar template icon

```
## Description

Replace the SF Symbol placeholder with the monochrome brand mark.

## Acceptance Criteria

* `assets/logo-mono.svg` rendered into the asset catalog as a template image
* Tints correctly in both light and dark menu bars
* Legible at menu bar size, and next to a crowded menu bar
* Respects the increased-contrast accessibility setting
* Icon choice in General settings still works

## Labels

phase-12, appstore, design
```

### TIME-75 — Capture App Store screenshots

```
## Description

Screenshots for the listing, all in Den mode.

## Acceptance Criteria

* Den mode only — Team vocabulary never appears in a screenshot
* The Den tab, the Time Peek scrubber, a meetup and the host results view are all shown
* Sample data is social, not corporate
* No real people's names or real friend codes
* Sizes and formats match App Store Connect requirements

## Labels

phase-12, appstore, design
```

### TIME-76 — Configure App Store Connect

```
## Description

The listing itself.

## Acceptance Criteria

* Price set to $9.99, paid, with no in-app purchases configured
* Universal Purchase enabled before first submission — it cannot be retrofitted
* Family Sharing enabled
* Privacy nutrition label filled in and matching the privacy policy
* Privacy and support URLs point at the live GitHub Pages pages
* App name checked against existing listings, and the title does not lead with "Meetups" — Meetup.com holds that trademark

## Labels

phase-12, appstore
```

### TIME-77 — Run the app-store-review-audit skill

```
## Description

Run the audit twice: after the first TestFlight build, and again on the day of submission.

## Acceptance Criteria

* First run completed after the first TestFlight upload, findings logged
* Second run completed on submission day
* Every finding either fixed or explicitly accepted with a reason
* The seven items in APPLE.md are all ticked
* No `import EventKit` and no `import StoreKit` anywhere in the repo
* Bundle ID verified as `com.mrdemonwolf.dentime` with no suffix

## Labels

phase-12, appstore
```
