# Claude Code: Build DenTime MVP1

## Context

You're building **DenTime** — a macOS menu bar app for finding the best time to meet across timezones with your pack, plus a Fumadocs docs/landing site.

**Owner:** Nathanial / MrDemonWolf, Inc. Has ADHD and Asperger's. Be specific, work in numbered phases, use your todo list religiously. Push back when wrong. No corporate filler. Never say "I'd be happy to."

**Reference repo:** `~/Code/fangdash` (public: `github.com/MrDemonWolf/fangdash`). Use its patterns for monorepo structure, Fumadocs-on-GitHub-Pages deployment, tsconfig.base.json, turbo.json, .editorconfig, .prettierrc.json, eslint.config.mjs, vitest.workspace.ts, CI workflows. Read files from fangdash before inventing patterns.

## Goal

Ship MVP1: an **App Store-submittable** macOS menu bar app (local-only, no backend) AND a deployed docs site at `https://mrdemonwolf.github.io/dentime` with landing + docs + legal pages.

The GitHub repo `github.com/MrDemonWolf/dentime` should be fully configured with description, topics, and branch protection (via the `gh-solo-main-protection` skill) by the end.

## Constraints — in scope

- macOS menu bar app (`MenuBarExtra`, macOS 13+), local-only storage
- **Default tab on launch: Roster** (friends list grouped, current times live)
- Find a Time tab as secondary
- Groups feature in roster (user-defined, e.g. Work / Pack / Family)
- Fumadocs docs site at `apps/docs/` → static export → GitHub Pages
- Turborepo + bun workspaces monorepo (match fangdash)
- App Store submittable (Sandbox + Hardened Runtime + Privacy Manifest)
- Full GitHub repo config: description, topics, solo-main protection

## Constraints — out of scope (all of this is in `CC-MVP2.md`)

- Cloudflare Workers API, Hono, D1, Drizzle, Better Auth, tRPC
- Apple Sign In
- Friend codes, roster sync
- Meetups (Doodle-style polls)
- iCal / .ics export
- Calendar integrations (EventKit)
- iOS app (scaffold empty folder only)
- Sparkle auto-update
- Deep link handler
- Paywall / StoreKit / subscriptions

## Tech

### macOS app

- Swift 5.9+, SwiftUI (no AppKit unless unavoidable)
- macOS 13.0 minimum (required for `MenuBarExtra`)
- Zero third-party dependencies
- Bundle ID: `com.mrdemonwolf.dentime`
- Team: MrDemonWolf, Inc.

### Docs site

- Next.js 15+ (App Router)
- Fumadocs MDX (match fangdash's Fumadocs patterns)
- TypeScript strict mode
- Tailwind v4
- `output: "export"` — static export only, no server
- Deployed via GitHub Actions to `gh-pages` branch
- URL: `https://mrdemonwolf.github.io/dentime`

### Repo tooling (match fangdash)

- bun (not pnpm, not npm)
- Turborepo
- bun workspaces
- ESLint flat config
- Prettier
- Vitest
- EditorConfig

## Target repo layout

```
dentime/
├── .editorconfig
├── .github/
│   └── workflows/
│       ├── ci.yml              ← typecheck, lint, test on PR
│       └── deploy-docs.yml     ← build + deploy docs to gh-pages
├── .gitignore
├── .prettierignore
├── .prettierrc.json
├── apps/
│   ├── docs/                   ← Fumadocs Next.js site
│   │   ├── src/
│   │   │   ├── app/
│   │   │   │   ├── (home)/
│   │   │   │   ├── docs/
│   │   │   │   ├── legal/
│   │   │   │   │   ├── terms/
│   │   │   │   │   └── privacy/
│   │   │   │   └── layout.tsx
│   │   │   ├── lib/
│   │   │   │   └── source.ts
│   │   │   └── mdx-components.tsx
│   │   ├── content/
│   │   │   └── docs/
│   │   ├── public/
│   │   ├── next.config.mjs
│   │   ├── source.config.ts
│   │   ├── tailwind.config.ts
│   │   ├── tsconfig.json
│   │   └── package.json
│   ├── macOS/
│   │   └── DenTime/
│   │       ├── DenTime.xcodeproj
│   │       └── DenTime/
│   │           ├── App/
│   │           ├── Models/
│   │           ├── Storage/
│   │           ├── Views/
│   │           │   ├── Roster/
│   │           │   ├── MeetingFinder/
│   │           │   ├── AddFriend/
│   │           │   └── Settings/
│   │           ├── Resources/
│   │           │   ├── Assets.xcassets
│   │           │   └── PrivacyInfo.xcprivacy
│   │           └── Info.plist
│   └── iOS/
│       ├── .gitkeep
│       └── README.md
├── assets/
│   ├── logo.svg
│   └── logo-mono.svg
├── bun.lock
├── bunfig.toml
├── CHANGELOG.md
├── CLAUDE.md                   ← your own brief; copy pattern from fangdash
├── eslint.config.mjs
├── HACKATON.md
├── LICENSE                     ← MIT
├── package.json                ← root, workspace config
├── README.md
├── TODO.md
├── tsconfig.base.json
├── turbo.json
└── vitest.workspace.ts
```

## Brand

- Navy `#091533` — dark backgrounds, hero, popover
- Cyan `#0FACED` — primary buttons, accents, active tab
- Paw tick mark — `assets/logo.svg` color, `assets/logo-mono.svg` monochrome menu bar

---

## Build phases — use your todo list religiously

Pause after each phase for verification. Don't bundle phases.

### Phase 1 — Monorepo scaffold (match fangdash patterns)

Read fangdash's root files first: `~/Code/fangdash/package.json`, `turbo.json`, `tsconfig.base.json`, `bunfig.toml`, `.editorconfig`, `.prettierrc.json`, `.prettierignore`, `eslint.config.mjs`, `vitest.workspace.ts`, `.gitignore`. Replicate structure, adapt names.

- [ ] Root `package.json` with bun workspaces: `["apps/*", "packages/*"]`
- [ ] `turbo.json` with tasks: `dev`, `build`, `lint`, `test`, `typecheck`, `format`, `format:check`, `check`, `clean`
- [ ] `tsconfig.base.json` (strict mode, target ES2022, moduleResolution bundler)
- [ ] `.editorconfig`, `.prettierrc.json`, `.prettierignore`, `eslint.config.mjs` (flat config), `vitest.workspace.ts`
- [ ] `bunfig.toml`
- [ ] `.gitignore` with Swift/Xcode artifacts + Node/Next.js + Turborepo cache
- [ ] `LICENSE` = MIT, `© 2026 MrDemonWolf, Inc.`
- [ ] Root `README.md` — brief project description, link to `HACKATON.md`, install/dev instructions

### Phase 2 — Xcode project scaffold

- [ ] Create Xcode project at `apps/macOS/DenTime/` using `xcodegen` if available, otherwise prompt Nathanial to create via Xcode UI with these exact settings:
    - Template: macOS App, SwiftUI, Swift
    - Product Name: `DenTime`
    - Team: MrDemonWolf, Inc.
    - Bundle Identifier: `com.mrdemonwolf.dentime`
    - Minimum Deployment: macOS 13.0
- [ ] Info.plist: `LSUIElement = YES`, `CFBundleDisplayName = DenTime`
- [ ] Signing & Capabilities: enable App Sandbox (default entitlements only), Hardened Runtime
- [ ] Verify `xcodebuild -project apps/macOS/DenTime/DenTime.xcodeproj -scheme DenTime build` succeeds

### Phase 3 — Asset catalog

- [ ] Read `assets/logo.svg`, generate PNGs at 16, 32, 64, 128, 256, 512, 1024 with @1x and @2x per `AppIcon.appiconset` spec (use `rsvg-convert`, `qlmanage`, or similar available tool)
- [ ] Drop into `Assets.xcassets/AppIcon.appiconset` with correct Contents.json
- [ ] Read `assets/logo-mono.svg`, generate a `MenuBarIcon` image set at 22×22 and 44×44 (@2x). Mark as **Template Image** in Contents.json (`"template-rendering-intent": "template"`)
- [ ] Color set `BrandNavy` = `#091533`, Color set `BrandCyan` = `#0FACED` in Assets.xcassets

### Phase 4 — Data models

File: `apps/macOS/DenTime/DenTime/Models/Friend.swift`

```swift
struct Friend: Identifiable, Codable, Hashable {
  let id: UUID
  var name: String
  var timezoneIdentifier: String
  var groupName: String?       // nil = Ungrouped
  var colorHex: String?
  var sortOrder: Int

  var timezone: TimeZone { TimeZone(identifier: timezoneIdentifier) ?? .current }
}
```

File: `apps/macOS/DenTime/DenTime/Models/TimeFormat.swift`

```swift
enum TimeFormat: String, Codable, CaseIterable { case twelveHour, twentyFourHour }
```

File: `apps/macOS/DenTime/DenTime/Models/TimeStatus.swift`

```swift
enum TimeStatus { case working, edge, sleep }
// computed from hour-of-day + settings working hours
```

- [ ] All structs Codable + Hashable
- [ ] Unit tests in `DenTimeTests/` for Friend encoding/decoding, timezone resolution, TimeStatus classification

### Phase 5 — Storage layer

File: `apps/macOS/DenTime/DenTime/Storage/FriendStore.swift`

```swift
@MainActor
final class FriendStore: ObservableObject {
  @Published private(set) var friends: [Friend] = []

  private let defaults: UserDefaults
  private let key = "dentime.friends.v1"

  init(defaults: UserDefaults = .standard) { … }

  func add(_ friend: Friend) { … }
  func update(_ friend: Friend) { … }
  func delete(id: UUID) { … }
  func move(from: IndexSet, to: Int) { … }

  // Groups
  var groupedFriends: [(group: String, friends: [Friend])] {
    // Group by groupName, "Friends" for nil, sort groups alphabetically with "Friends" last
  }
  var knownGroups: [String] {
    // Distinct non-nil groupName values
  }
}
```

File: `apps/macOS/DenTime/DenTime/Storage/SettingsStore.swift` (use `@AppStorage` under the hood or an `ObservableObject` wrapping `UserDefaults`):

- `timeFormat: TimeFormat` (default 12h)
- `workingHoursStart: Int` (default 9)
- `workingHoursEnd: Int` (default 18)
- `refreshIntervalSeconds: Int` (default 30)
- `launchAtLogin: Bool` (default false) — write path for this hooks to `SMAppService`

- [ ] Unit tests for FriendStore CRUD + grouping

### Phase 6 — Menu bar shell

File: `apps/macOS/DenTime/DenTime/App/DenTimeApp.swift`

```swift
@main
struct DenTimeApp: App {
  @StateObject private var friendStore = FriendStore()
  @StateObject private var settings = SettingsStore()

  var body: some Scene {
    MenuBarExtra("DenTime", image: "MenuBarIcon") {
      RootView()
        .environmentObject(friendStore)
        .environmentObject(settings)
        .frame(width: 360, height: 520)
    }
    .menuBarExtraStyle(.window)
  }
}
```

`RootView` has a segmented picker at top: **[ Now | Find a Time | ⚙ ]**. **Default selection on launch: `Now`** (the roster — per Nathanial's explicit preference, not meeting finder).

### Phase 7 — Roster view with groups (DEFAULT TAB)

File: `apps/macOS/DenTime/DenTime/Views/Roster/RosterView.swift`

Layout:

- Top: "+ Add friend" button, refresh indicator
- Scrollable list: for each group in `friendStore.groupedFriends`, a section header with group name + count, then rows
- Friend row: avatar dot (colorHex), name (bold), timezone abbreviation + current time + delta from user's zone (+Nh / -Nh) colored by TimeStatus
- Empty state: "No pack members yet. Hit + to add someone."
- "You" row at bottom: current user's local time, static, visually distinct

Refresh:

- Timer publisher tied to `settings.refreshIntervalSeconds`
- Every tick: force `ObservableObject` refresh to recompute time strings

Interactions:

- Click row → copy to NSPasteboard: `"It's \(time) \(dayOfWeek) for \(name) in \(city)"` (city derived from timezone identifier's last segment, underscores → spaces). Show "Copied!" toast for 1.5s.
- Right-click → Context menu: Edit, Copy current time, Move to group → (submenu: existing groups + "New group…" + "Ungrouped"), Delete
- Drag-to-reorder within a group via `.onMove`

### Phase 8 — Add/Edit Friend sheet

File: `apps/macOS/DenTime/DenTime/Views/AddFriend/AddFriendView.swift`

Fields:

- Name (TextField)
- Timezone (searchable picker populated from `TimeZone.knownTimeZoneIdentifiers.sorted()`, show current time preview as user selects)
- Group (picker: existing groups + "Ungrouped" + "New group…" → text field appears)
- Color (optional, 8 preset swatches)

Validation:

- Name not empty
- Timezone identifier valid

Modes:

- `.add` — new UUID, append
- `.edit(Friend)` — update in place

Triggers:

- `+` button in roster header
- `⌘N` keyboard shortcut
- Right-click → Edit on a row

### Phase 9 — Find a Time view

File: `apps/macOS/DenTime/DenTime/Views/MeetingFinder/MeetingFinderView.swift`

Layout:

- Top: `DatePicker` for date + time in user's local zone (default: next round half-hour ≥ now)
- Below: list of friends grouped the same way as roster, each showing:
    - Name
    - Converted time in their zone
    - `+Nd` / `-Nd` day-boundary badge if applicable
    - Background tint by TimeStatus (green / yellow / red)
    - Checkbox on left to include/exclude from copy-summary
- Bottom: "Copy as text" button → NSPasteboard with:
  `"\(dayOfWeek) \(monthShort) \(dayNum) at \(timeLocal) \(cityLocal) is \(timeA) \(cityA), \(timeB) \(cityB), …"`

Only checked friends appear in the summary string.

### Phase 10 — Settings view

File: `apps/macOS/DenTime/DenTime/Views/Settings/SettingsView.swift`

Sections:

- **Display** — time format (12h/24h Picker), show delta column (Toggle)
- **Working hours** — start/end Steppers, 0-23
- **Refresh** — Picker 15s/30s/60s
- **Startup** — Launch at login (Toggle, wired to `SMAppService.mainApp.register()` / `.unregister()` — use this, not deprecated `LSSharedFileList`)
- **About** — version from `CFBundleShortVersionString`, build, "© 2026 MrDemonWolf, Inc.", link to `https://mrdemonwolf.github.io/dentime`, "Quit DenTime" button (`⌘Q`)

### Phase 11 — Keyboard shortcuts + commands

- `⌘N` — Add Friend sheet
- `⌘1` — Now tab
- `⌘2` — Find a Time tab
- `⌘,` — Settings tab
- `⌘Q` — Quit (via `NSApplication.shared.terminate(nil)`)

Wire via `.keyboardShortcut(_:modifiers:)` and `CommandGroup` where appropriate.

### Phase 12 — Privacy manifest + hardening

File: `apps/macOS/DenTime/DenTime/Resources/PrivacyInfo.xcprivacy`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>NSPrivacyCollectedDataTypes</key>
  <array/>
  <key>NSPrivacyTrackingDomains</key>
  <array/>
  <key>NSPrivacyTracking</key>
  <false/>
  <key>NSPrivacyAccessedAPITypes</key>
  <array>
    <dict>
      <key>NSPrivacyAccessedAPIType</key>
      <string>NSPrivacyAccessedAPICategoryUserDefaults</string>
      <key>NSPrivacyAccessedAPITypeReasons</key>
      <array><string>CA92.1</string></array>
    </dict>
  </array>
</dict>
</plist>
```

Verify:

- [ ] Sandbox entitlements file has only `com.apple.security.app-sandbox = true`
- [ ] No other entitlements (no network, no file access, no contacts, no calendars — all MVP2)
- [ ] Hardened Runtime enabled
- [ ] `xcodebuild archive` succeeds and Organizer validates successfully (prompt Nathanial to verify this manually since archiving requires his signing identity)

### Phase 13 — macOS polish

- [ ] Navy `BrandNavy` popover background when in dark mode, subtle off-white in light mode
- [ ] Cyan `BrandCyan` active tab indicator, primary buttons, row hover state
- [ ] Smooth popover open/close (default system animation is fine)
- [ ] Verify dark + light mode rendering
- [ ] Every user-facing string reviewed — no placeholders

### Phase 14 — iOS folder stub

- [ ] `apps/iOS/.gitkeep` in place
- [ ] `apps/iOS/README.md`:

    ```
    # DenTime iOS

    Scaffolded in MVP2. See `../../CC-MVP2.md` Phase 17.
    Will import `packages/DenTimeCore` once extracted.
    ```

### Phase 15 — macOS README

File: `apps/macOS/README.md`

Sections:

- Requirements: Xcode 15+, macOS 13+, bundle ID `com.mrdemonwolf.dentime`
- Build: `xcodebuild -project DenTime/DenTime.xcodeproj -scheme DenTime build`
- Run: open in Xcode, `⌘R`
- Archive: Product → Archive → Validate
- MVP1 limitations: local-only (no sync), macOS-only (no iOS yet), no auth, no calendar integration

---

## Docs site phases

Read `~/Code/fangdash/apps/docs/` fully before starting. Fumadocs setup, next.config.mjs with static export config, tailwind.config, GitHub Actions deploy workflow — all there. Replicate and adapt.

### Phase 16 — Fumadocs scaffold (copy fangdash's structure)

- [ ] `cd apps && bun create next-app docs --ts --tailwind --app --eslint --src-dir --import-alias "@/*" --no-turbopack`
- [ ] `cd docs && bun add fumadocs-ui fumadocs-core fumadocs-mdx`
- [ ] Replicate from `~/Code/fangdash/apps/docs/`:
    - `source.config.ts`
    - `src/lib/source.ts`
    - `src/mdx-components.tsx`
    - `next.config.mjs` (with Fumadocs MDX plugin — adapt the static export config below)
    - `tailwind.config.ts` with Fumadocs preset + brand colors
    - `tsconfig.json` extending `../../tsconfig.base.json`

### Phase 17 — Static export config for GitHub Pages

`apps/docs/next.config.mjs`:

```js
import { createMDX } from "fumadocs-mdx/next";

const withMDX = createMDX();

/** @type {import('next').NextConfig} */
const config = {
	output: "export",
	basePath: process.env.NODE_ENV === "production" ? "/dentime" : "",
	images: { unoptimized: true },
	trailingSlash: true,
	reactStrictMode: true,
};

export default withMDX(config);
```

- [ ] `basePath: "/dentime"` only in production (local dev runs at root)
- [ ] `images: { unoptimized: true }` because GitHub Pages can't run Next image optimizer
- [ ] `trailingSlash: true` for proper GitHub Pages routing

### Phase 18 — Landing page

`apps/docs/src/app/(home)/page.tsx`:

Sections top-to-bottom:

1. **Nav** — logo + "Docs" + "Terms" + "Privacy" + external GitHub link
2. **Hero** — navy bg, paw tick logo (large), headline "Timezones for your pack", subhead "Find the best time to meet across zones. Menu bar for Mac, Home screen for iPhone.", CTA button "Download for Mac" (disabled-ish with "Coming to App Store" label for now)
3. **Features (3 cards)**:
    - "Menu bar at a glance" — roster with current times, grouped by Work / Pack / Family
    - "Meeting finder that actually works" — pick a time, see it everywhere, green/yellow/red at a glance
    - "Privacy-first" — nothing leaves your Mac in MVP1. No account. No tracking.
4. **Screenshots** — 2-3 placeholder boxes (aspect 16:10), comment `// TODO: drop screenshots when submitted to App Store`
5. **Footer** — © 2026 MrDemonWolf, Inc. · Made with ❤️ in Beloit, WI · links to Terms, Privacy, GitHub, mrdemonwolf.com

Use brand colors (`bg-[#091533]` hero, `bg-[#0FACED]` CTAs). All Tailwind utility classes, no component library.

### Phase 19 — Docs content (MDX)

`apps/docs/content/docs/`:

- [ ] `meta.json` with page ordering
- [ ] `index.mdx` — docs home
- [ ] `getting-started.mdx` — install, first run
- [ ] `adding-friends.mdx` — including groups
- [ ] `finding-a-meeting-time.mdx` — with green/yellow/red explanation
- [ ] `settings.mdx`
- [ ] `faq.mdx` — includes: "Do you collect data?" (no, MVP1 is local-only), "Does it sync?" (no, MVP2), "iPhone?" (MVP2), "iCal export?" (MVP2)
- [ ] `roadmap.mdx` — MVP2 preview: sync, meetups, iOS, calendar integrations

### Phase 20 — Legal pages

`apps/docs/src/app/legal/layout.tsx` — centered prose layout (not docs sidebar), max-w-2xl.

`apps/docs/src/app/legal/terms/page.tsx` — Terms of Service:

- Last updated: today's date
- Plain language, no legalese
- Cover: acceptance of terms, license to use, local-only nature (MVP1), no warranty, limitation of liability, governing law (Wisconsin, USA — Nathanial is in Beloit, WI), changes to terms, contact `support@mrdemonwolf.com`
- Keep under 800 words

`apps/docs/src/app/legal/privacy/page.tsx` — Privacy Policy:

- Last updated: today's date
- Plain language
- **Lead with:** "DenTime for macOS (MVP1) collects nothing. Everything stays on your device."
- Cover: what we don't collect (everything), what's stored locally (friend names, timezones, groups in UserDefaults), docs site analytics (none in MVP1; note if we add Plausible/Umami later we'll update), cookies (none), third parties (none), data requests (N/A — we have no data), contact `support@mrdemonwolf.com`
- **MVP2 forward-reference section:** "When sync ships in MVP2, we'll collect: Apple anonymous identifier, display name you choose, timezone, your roster and meetups. This policy will be updated then."
- Keep under 600 words

### Phase 21 — Theming + favicon

- [ ] `apps/docs/tailwind.config.ts`: extend colors with `brand-navy: #091533`, `brand-cyan: #0FACED`
- [ ] Fumadocs theme override in `src/app/layout.tsx` using brand colors for primary/accent
- [ ] Default to dark mode, light mode toggle available
- [ ] `apps/docs/public/favicon.ico` from `assets/logo.svg` (32×32 ICO)
- [ ] `apps/docs/public/apple-touch-icon.png` 180×180 from `assets/logo.svg`
- [ ] `apps/docs/public/og.png` 1200×630 — navy bg, centered paw tick, "DenTime" wordmark, tagline
- [ ] `apps/docs/src/app/layout.tsx` metadata: title, description, OG, Twitter card, canonical
- [ ] `robots.ts` and `sitemap.ts` (respect `basePath`)

### Phase 22 — GitHub Actions deploy workflow

`.github/workflows/deploy-docs.yml` — read fangdash's equivalent workflow first, adapt:

```yaml
name: Deploy Docs to GitHub Pages

on:
    push:
        branches: [main]
        paths:
            - "apps/docs/**"
            - "packages/**"
            - ".github/workflows/deploy-docs.yml"
    workflow_dispatch:

permissions:
    contents: read
    pages: write
    id-token: write

concurrency:
    group: pages
    cancel-in-progress: false

jobs:
    build:
        runs-on: ubuntu-latest
        steps:
            - uses: actions/checkout@v4
            - uses: oven-sh/setup-bun@v2
            - run: bun install --frozen-lockfile
            - run: cd apps/docs && bun run build
            - uses: actions/configure-pages@v5
            - uses: actions/upload-pages-artifact@v3
              with:
                  path: apps/docs/out

    deploy:
        needs: build
        runs-on: ubuntu-latest
        environment:
            name: github-pages
            url: ${{ steps.deployment.outputs.page_url }}
        steps:
            - id: deployment
              uses: actions/deploy-pages@v4
```

- [ ] Create workflow file
- [ ] Add Nathanial reminder: must enable GitHub Pages in repo settings → Source: "GitHub Actions"

### Phase 23 — CI workflow

`.github/workflows/ci.yml` — read fangdash's CI workflow, replicate. Runs on every PR:

- [ ] Typecheck (`bun typecheck`)
- [ ] Lint (`bun lint`)
- [ ] Format check (`bun format:check`)
- [ ] Test (`bun test`)

### Phase 24 — Docs polish + accessibility

- [ ] All internal links work
- [ ] External links open in new tab with `rel="noopener noreferrer"`
- [ ] Mobile responsive (test via Chrome devtools at 375, 768, 1280)
- [ ] Semantic HTML (proper heading hierarchy, `<main>`, `<nav>`, `<footer>`)
- [ ] Focus states visible on all interactive elements
- [ ] Skip-to-content link at top
- [ ] Alt text on all images
- [ ] Lighthouse ≥90 for all four categories

---

## Final phases — repo hygiene

### Phase 25 — Root CLAUDE.md

Read `~/Code/fangdash/CLAUDE.md`. Write our equivalent at `dentime/CLAUDE.md`:

- [ ] Project overview (2-3 sentences)
- [ ] Monorepo structure map
- [ ] Conventions: TypeScript strict, no `any`, Tailwind utilities only, brand colors
- [ ] Testing: Vitest, write tests for logic-heavy code
- [ ] Build commands
- [ ] What's in scope right now (MVP1), what's not (MVP2)

### Phase 26 — CHANGELOG.md

```markdown
# Changelog

## [Unreleased]

### Added

- macOS menu bar app with roster (grouped) and meeting finder
- Fumadocs docs site deployed to GitHub Pages
- Terms of Service and Privacy Policy
- App Store submission readiness (Sandbox + Hardened Runtime + Privacy Manifest)
```

### Phase 27 — GitHub repo configuration via `gh` CLI

Run `gh` commands to set repo metadata:

```bash
gh repo edit MrDemonWolf/dentime \
  --description "Menu bar app for finding the best time to meet across timezones. macOS + iOS." \
  --homepage "https://mrdemonwolf.github.io/dentime" \
  --add-topic "macos" \
  --add-topic "ios" \
  --add-topic "swiftui" \
  --add-topic "menubar" \
  --add-topic "timezone" \
  --add-topic "productivity" \
  --add-topic "typescript" \
  --add-topic "nextjs" \
  --add-topic "fumadocs" \
  --add-topic "turborepo" \
  --add-topic "bun" \
  --add-topic "swift" \
  --add-topic "apple-silicon" \
  --add-topic "cloudflare-workers" \
  --add-topic "hono" \
  --enable-issues \
  --enable-wiki=false \
  --enable-discussions
```

- [ ] If `gh` isn't authenticated, prompt Nathanial: "Run `gh auth login` and re-run me."
- [ ] Confirm `github.com/MrDemonWolf/dentime` shows description + topics

### Phase 28 — Commit + push everything

- [ ] `git add .`
- [ ] `git commit -m "feat: MVP1 - macOS menu bar app + Fumadocs docs site`

    ```

    macOS:
    - SwiftUI menu bar app, macOS 13+
    - Roster with groups (default tab)
    - Meeting time finder
    - Settings (time format, working hours, launch at login)
    - App Store submittable (Sandbox + Hardened Runtime + Privacy Manifest)

    Docs:
    - Fumadocs + Next.js static export
    - Deployed to GitHub Pages at mrdemonwolf.github.io/dentime
    - Landing, docs, legal (TOS + Privacy)

    Tooling:
    - Turborepo + bun workspaces (fangdash pattern)
    - Vitest, ESLint flat config, Prettier
    - GitHub Actions for CI + docs deploy
    "`
    ```

- [ ] `git push origin main`

### Phase 29 — Apply solo-main branch protection (USE THE SKILL)

**Invoke the `gh-solo-main-protection` skill now.** Do not roll your own branch protection rules — use the skill exactly as defined.

- [ ] Execute skill
- [ ] Verify `github.com/MrDemonWolf/dentime/settings/rules` shows the ruleset active

### Phase 30 — Summary

Print:

1. File counts: Swift files, TS files, MDX files, total lines
2. Phases completed vs skipped (with reasons for any skips)
3. What Nathanial needs to do manually:
    - Open Xcode, verify signing
    - Enable GitHub Pages in repo Settings → Pages → Source: GitHub Actions
    - Wait for GitHub Actions to finish first deploy (~3 min)
    - Verify `https://mrdemonwolf.github.io/dentime` loads
    - Run Archive → Validate in Xcode
4. Known rough edges
5. Status: **"MVP1 hackathon-shippable. macOS app App Store-submittable pending Nathanial's validation. Docs site deployed pending GitHub Pages source config."**

---

## Apple guidelines (non-negotiable)

- **2.1** Functional, not beta
- **2.4.5** Mac apps must be sandboxed → done
- **2.5.1** Public APIs only → done (UserDefaults, SwiftUI, SMAppService all public)
- **4.0** Design quality — no placeholders in shipped build
- **5.1.1** Privacy policy URL required → `https://mrdemonwolf.github.io/dentime/legal/privacy/`
- **5.1.2** Data minimization → we collect nothing in MVP1

Menu bar specifics:

- `LSUIElement = YES` hides dock
- `⌘Q` wired
- `SMAppService.mainApp` for launch-at-login (not deprecated `LSSharedFileList`)

Privacy Manifest (`PrivacyInfo.xcprivacy`) required as of May 2024:

- Declare UserDefaults use with reason `CA92.1`
- `NSPrivacyTracking = false`, empty arrays for everything else in MVP1
