# Open questions

Genuinely unsolved things, and everything stubbed during the scaffold. Add to this file rather than guessing.

---

## Unsolved — will cause problems

### CloudKit schema versioning

The schema lives in the CloudKit dashboard, not in git. There is no migration file, no schema-as-code, and dev→prod is a manual promote step. Nothing in this repo can verify that the deployed schema matches what the code expects, and a missing index fails at runtime in production rather than at build time.

No plan yet. [CLOUDKIT-SCHEMA.md](CLOUDKIT-SCHEMA.md) is currently the closest thing to a schema of record — keep it in the same commit as any field change.

### Meetup share-link previews

Someone without DenTime who clicks a share link sees a generic "Get DenTime" page rather than the meetup details. The good version needs CloudKit Web Services. Deferred, not solved.

### Host results view at 360pt

Six participants × five slots does not fit as a literal grid inside a menu bar panel. The mockup does not settle this either. Options not yet evaluated: per-slot summary rows that expand, a horizontally scrollable grid, or collapsing to "4 yes, 1 maybe" with the names behind a tap. Phase 10.

### App Store name not checked

The name has not been checked against existing App Store listings. Also outstanding: confirming the title does not lead with "Meetups", which Meetup.com holds as a trademark.

---

## Open review findings from the v2 design

Both are obligations for the SwiftUI build, not mockup fixes. Full context in [`docs/design/uiux-review.md`](../design/uiux-review.md).

### Destructive Remove has no undo

The row menu's Remove acts immediately in the mockup. In the real app it should show an undo toast rather than a confirmation dialog — removing someone is low-cost and reversible by re-adding, so a modal is the wrong weight. Phase 7.

### Accessibility is unverified

Keyboard focus rings, VoiceOver labels and live-region announcements cannot be demonstrated in a static HTML mockup. They have to be checked in the SwiftUI build. Related: the Time Peek scrubber responds to arrow keys but nothing tells the user so. Phases 7 and 8.

---

## Decided during the scaffold, worth knowing

### Crockford base32 is applied more strictly than the specification

Canonical Crockford says a *decoder* should treat `I` and `L` as `1` and `O` as `0`, rejecting only `U`. DenTime rejects all four outright.

The reason: a silently-corrected code means two different strings both resolve to one person, and support conversations about "the code I sent you" get much harder. A code is either exactly right or clearly wrong.

Implemented in `CrockfordBase32.ambiguousCharacters` and covered by tests. If this ever turns out to annoy real users, this is the entry to revisit.

### Time formatting deliberately ignores locale

`TimeFormat.string(hour:minute:)` composes `9:05 PM` and `21:05` by hand rather than using `DateFormatter`. These strings sit in a tabular monospaced column next to each other, and a locale that inserts a narrow no-break space or reorders the meridiem breaks the alignment.

Vocabulary and locale change the nouns around the time. They do not change the digits. Revisit if DenTime is ever localised properly.

### Settings is a model, though it was not in the original file list

`CLOUDKIT-SCHEMA.md` calls for a `Settings` record in the private database, so `Models/Settings.swift` exists alongside the seven models the scaffold brief named.

---

## Stubbed during the scaffold

- **`DEVELOPMENT_TEAM` is blank** in `apps/apple/Config/Shared.xcconfig`, so a clean clone builds locally without signing setup. CI and release builds have to supply it.
- **App icons are placeholders.** `AppIcon.appiconset` declares the slots and contains no images. The brand mark is in `assets/logo.svg`; it has not been rendered to the ten macOS icon sizes.
- **The menu bar icon is SF Symbol `clock`**, not the paw mark. `assets/logo-mono.svg` is the intended template image and has not been wired in.
- **`apps/docs` pages are one-line TODOs.** `privacy` and `support` exist so the routes return 200, which App Review needs, but neither has real copy yet.
- **CloudKit store bodies are `fatalError("unimplemented")`.** Protocols and signatures are settled; nothing talks to CloudKit yet.
- **No iOS, iPadOS or watchOS targets.** Phase 2 of the product, and each must reuse `com.mrdemonwolf.dentime` with no suffix when it lands.
- **`DenTime.xcodeproj` has never been generated or opened.** The scaffold was authored on Linux, which has no Xcode. `xcodegen generate` needs to run once on a Mac to confirm `project.yml` is valid, and `xcodebuild` to confirm the target builds with zero warnings. This is the last unverified piece of the scaffold.
- **No Jira board exists.** [JIRA-BACKLOG.md](JIRA-BACKLOG.md) holds the ticket ideas and [`prompts/CLAUDE-CHROME-JIRA-SETUP.md`](prompts/CLAUDE-CHROME-JIRA-SETUP.md) is the prompt that creates the board. Neither has been run.

---

## Closed

### ~~DenTimeCore had never been compiled~~

Resolved 2026-08-06. The scaffold was written on Linux with no Swift toolchain, so the macOS CI job was the first thing to compile it. It passed on the first run: `swift build` clean, and 44 tests green across `FriendCodeTests`, `ModelTests`, `TimePeekTests` and `TimeZoneResolverTests`, including every DST boundary case.

### ~~`dentime.mrdemonwolf.com` DNS~~

Dropped 2026-08-06. GitHub Pages at `mrdemonwolf.github.io/dentime` is the only host, and App Store Connect gets those URLs. See [DECISIONS.md](DECISIONS.md), decision 13.

### ~~Blocked on mockups~~

Resolved 2026-08-05. The reviewed v2 design landed; phases 7, 8 and 10 are design-ready. See [`docs/design`](../design/README.md).
