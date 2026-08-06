# CLAUDE.md

Guidance for Claude Code (claude.ai/code) working in this repository. Read this first.

## What DenTime is

A **$9.99 paid macOS menu bar app**. It keeps a roster of the people you care about — "your den" — shows their local time, and runs Doodle-style polls to pick a time that works for everyone.

Built for **friend groups**: a furry/gaming crew spread across four time zones picking a night for a movie. Not corporate teams. A pack named "Acme Corp" behaves identically to one named "the boys", which is how the same design serves work users without any screen being aimed at them.

## Stack

All-native SwiftUI, zero web views. **CloudKit is the entire backend.** `DenTimeCore` is a Swift package shared across future platforms. Docs are Fumadocs on GitHub Pages. TypeScript exists for tooling and the docs site only — this project is nearly all Swift.

```
apps/apple/            Xcode project (XcodeGen), macOS target only for now
apps/docs/             Fumadocs site → mrdemonwolf.github.io/dentime
packages/DenTimeCore/  Swift package: models, FriendCode, TimePeek, CloudKit stores
docs/planning/         DECISIONS, SPEC, PHASES, APPLE, CLOUDKIT-SCHEMA, OPEN-QUESTIONS, JIRA-BACKLOG
docs/design/           v2 mockup and UI/UX review, reference only
```

## Hard rules — never violate without the owner explicitly saying so

- **No EventKit.** Calendar integration was scoped in and deliberately cut.
- **No StoreKit.** Paid up front. No IAP, no subscription, no free tier, no trial.
- **No server.** CloudKit only. Do not reintroduce Cloudflare Workers, D1, Hono, Drizzle, or Better Auth.
- **No push invites and no notifications**, of any kind. Meetups are join-by-code only.
- **No free-text meetup titles or descriptions.** Ever.
- `apps/apple` and `packages/DenTimeCore` stay **out of the Turborepo build graph** and out of the Bun workspace globs. Xcode builds them; `turbo build` never touches them.
- **Bundle ID `com.mrdemonwolf.dentime` on every platform target, no suffix.** Different IDs per platform sell as separate $9.99 products and break Universal Purchase permanently. Only a future watch target gets a suffix, because Apple requires `.watchkitapp`.

## Language rules

Applies to app copy, docs and the App Store listing.

| Never | Instead |
|---|---|
| Schedule a meeting | Make a plan |
| Availability | Who's around |
| Invite participants | Share the code |
| Organizer | Host |
| Attendees | Who's in |
| Team | Pack |
| Contacts, roster | Your den |

Sample data reads "movie night", never "Q3 planning sync". A *meeting* is work; a *meetup* is social, so that word stays. Sentence case everywhere. No corporate filler, no wolf puns in UI copy.

Blocking copy says **"You won't see them."** It never says "They can't see you" — blocking is client-side filtering, so the second sentence would be a lie.

## Don't re-litigate — the owner has already corrected these

- The Den is the default tab on launch, not the meeting finder.
- Docs go on GitHub Pages, not Cloudflare Pages. There is **no custom domain** — App Store Connect gets the `mrdemonwolf.github.io/dentime` URLs.
- iCal export is deferred, not v1.
- "Friend code" is the only name for that concept. Not "den code".
- Time Peek is a scrubber inside the Den tab, not its own tab.
- The app is paid up front. There is no free tier. This was decided twice.

## Working style

Direct and concrete. Numbered steps with checkboxes. Lead with the top recommendation and a one-line reason rather than listing every option. Push back when something is wrong — the owner asks for this explicitly and acts on it. Personal docs get ADHD-friendly formatting with time estimates and short sections; technical prompts stay dense.

## Brand

Navy `#091533`, cyan `#0FACED`. The mark is a cyan paw on navy with clock hands in the main pad — `assets/logo.svg`, and `assets/logo-mono.svg` for the menu bar as a template image.

## Commands

```bash
bun install
bun run dev          # docs site on :3001
bun run build
bun run typecheck
bun run test
bun run check        # Biome lint + format
bun run check:fix

swift build --package-path packages/DenTimeCore
swift test --package-path packages/DenTimeCore

cd apps/apple && USER=$(whoami) xcodegen generate && open DenTime.xcodeproj
```

`DenTime.xcodeproj` is generated from `apps/apple/project.yml` and is gitignored. Never hand-edit it.

## Where to look

- **`docs/planning/DECISIONS.md` is the source of truth.** When documents disagree, it wins.
- `docs/planning/PHASES.md` — the twelve phases and what is blocked on what.
- `docs/planning/CLOUDKIT-SCHEMA.md` — record types, and the manual dashboard steps that will bite.
- `docs/planning/APPLE.md` — the seven things that must exist before submission.
- `docs/planning/OPEN-QUESTIONS.md` — everything genuinely unsolved. Add to it rather than guessing.
- `docs/design/` — the v2 mockup. Reference only; no SwiftUI has been built from it yet.

## Conventions

- **Swift**: 4-space indent, SwiftUI-first, no AppKit unless required, no third-party dependencies.
- **TypeScript**: strict, tabs, double quotes, Biome. No `any`.
- **Tailwind v4 only** in the docs site — no shadcn, no Radix. Theme via `@theme inline` in `apps/docs/src/app/global.css`.
- **Conventional commits** (`feat:`, `fix:`, `chore:`, `docs:`, `test:`, `ci:`).
- Superseded planning docs move to `docs/planning/archive/` rather than being deleted. Knowing why a stack was dropped is worth more later than knowing that it was.
