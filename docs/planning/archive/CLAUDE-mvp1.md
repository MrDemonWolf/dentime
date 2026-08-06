# CLAUDE.md

Guidance for Claude Code (claude.ai/code) when working in this repository.

## Project overview

DenTime is a macOS menu bar app (SwiftUI, macOS 13+) that shows current time for everyone in a user's pack and helps pick meeting times across zones. MVP1 is local-only; MVP2 adds sync, iOS, meetups, iCal export. Turborepo monorepo with bun workspaces.

## Layout

```
apps/
  macOS/   SwiftUI app (XcodeGen → DenTime.xcodeproj, bundle com.mrdemonwolf.dentime)
  iOS/     Stub, MVP2
  docs/    Next.js 15 + Fumadocs, static export → GitHub Pages (/dentime)
packages/
  shared/  Placeholder (MVP2 will populate)
```

## Commands

```bash
bun install
bun run dev          # turbo dev (docs site on :3001)
bun run build        # turbo build
bun run typecheck
bun run lint
bun run test
bun run format       # prettier --write
bun run format:check
bun run check        # eslint + prettier --check

# Single workspace
bun run --filter @dentime/docs dev
bun run --filter @dentime/docs build

# macOS
cd apps/macOS && xcodegen generate && open DenTime.xcodeproj
xcodebuild -project DenTime.xcodeproj -scheme DenTime -destination 'platform=macOS' test
```

If `xcodegen` reports "Couldn't find current username", prefix with `USER=$(whoami)`.

## Conventions

- **TypeScript**: strict mode, tabs (enforced via `.editorconfig`), double quotes (Prettier). No `any` — cast explicitly with a comment if unavoidable.
- **Swift**: 4-space indent, SwiftUI-first, no AppKit unless required, no third-party dependencies.
- **Tailwind v4 only** — no shadcn, no Radix. Theme via `@theme inline` in `apps/docs/src/app/global.css`. Brand colors: navy `#091533`, cyan `#0FACED`.
- **Fumadocs theming** for all docs routes; landing page uses same token palette.
- **Conventional commits** (`feat:`, `fix:`, `chore:`, `docs:`, `test:`, `ci:`).

## MVP1 scope (in)

- Menu bar app: roster (default tab), grouped friends, meeting finder, settings
- Local-only UserDefaults persistence under `dentime.friends.v1`
- App Sandbox + Hardened Runtime + Privacy Manifest
- Docs site: landing + `/docs` + `/legal/{terms,privacy}`
- CI + docs deploy + TestFlight workflows

## MVP2 scope (out — push back)

Sync, Apple Sign In, friend codes, meetups, iCal export, EventKit, iOS app, Sparkle, deep links, paywall. See `CC-MVP2.md`.

## Brand

- Navy `#091533` — hero, popover background (dark mode)
- Cyan `#0FACED` — CTA, accents, active tab
- Paw tick logo at `assets/logo.svg` and `assets/logo-mono.svg` (menu bar, template image)

## Testing

- **Swift**: XCTest in `apps/macOS/DenTimeTests/`. Logic tests for `Friend`, `TimeStatus`, `FriendStore`.
- **TypeScript**: Vitest. `packages/shared` currently has no tests (placeholder).

## Key files

- `apps/macOS/project.yml` — XcodeGen source of truth
- `apps/macOS/DenTime/Storage/FriendStore.swift` — persistence + grouping
- `apps/macOS/DenTime/Resources/PrivacyInfo.xcprivacy` — Apple Privacy Manifest, UserDefaults reason `CA92.1`
- `apps/docs/next.config.mjs` — `basePath: "/dentime"` in production
- `apps/docs/src/app/global.css` — Tailwind + Fumadocs theme overrides
- `.github/workflows/apple-testflight.yml` — manual-dispatch TestFlight upload (needs Apple secrets)
