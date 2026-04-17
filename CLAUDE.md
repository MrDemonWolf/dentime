# DenTime — Claude Code context

Full spec + approved plan: `/Users/nathanialhenniges/.claude/plans/dentime-claude-breezy-kahn.md`. This file is the in-repo quick reference.

## Product

- **V1 ships together:** macOS app (Mac App Store) + iOS app (App Store) + Cloudflare Workers API + Fumadocs docs site.
- Both apps **paid** via RevenueCat: **$0.99/month or $10.99/year, 1-week free trial**. One subscription unlocks both platforms (cross-platform entitlement via RevenueCat App User ID = our `users.id`).
- Features: Roster + Groups, Time Peek, Meetups (w/ `.ics` + EventKit save), APNs push (invites/RSVP/finalize), Widgets (iOS + macOS Notification Center), optional menu-bar 12h timeline with working-hours shading.
- **Not in V1:** Live Activities, Android, Better-Auth.
- Brand: navy `#091533`, cyan `#00ACED`. Logo: paw tick. Menu bar icon = monochrome silhouette.

## Working style (owner: Nathanial)

- TypeScript everywhere; no plain JS.
- Hono + Drizzle + D1 + Cloudflare Workers for the API.
- **100% native SwiftUI** on both iOS and macOS — no web views, no Electron, no Catalyst.
- Shared `DenTimeCore` Swift package: models, `APIClient`, stores, Time Peek math, RevenueCat wrapper. Platform-conditional UI in the app targets.
- Fumadocs for docs + landing + web profiles, deployed to GitHub Pages at `https://mrdemonwolf.github.io/dentime/` (project page → `basePath: '/dentime'`).
- API at `https://dentime.mrdemonwolf.workers.dev` (default Workers domain, no custom domain in V1).
- Better Stack for logs.
- Direct, numbered steps with checkboxes. No corporate filler.

## Identity / hosting constants

- Bundle ID (macOS): `com.mrdemonwolf.dentime`
- Bundle ID (iOS): `com.mrdemonwolf.dentime` (same — separate App Store Connect records, unified RC)
- Worker name: `dentime`
- Web host: `mrdemonwolf.github.io/dentime` (GH Pages project page)
- Deep link scheme: `dentime://add/<code>`
- Single contact: `legal@mrdemonwolf.com`

## Distribution

- **App Stores only.** No Developer ID, no Sparkle, no manual notarization — App Store review covers signing.
- Both targets **sandboxed**. Entitlements: network client, optional user-selected read for `.ics` export, hardened runtime.
- TestFlight for both iOS and macOS during beta.

## Common commands

```bash
# API
cd apps/api && bun run dev
bun run --cwd apps/api db:generate
bun run --cwd apps/api db:migrate
bun run --cwd apps/api db:migrate:prod
bun run --cwd apps/api test           # Vitest + Miniflare E2E

# Docs
bun run --cwd apps/docs dev
bun run --cwd apps/docs build

# Monorepo
bun install
bun run dev

# Apple
open apple/DenTime.xcodeproj
```

## Conventions

- Friend codes stored raw (no dashes); formatted `XXXX-XXXX` only on display. Crockford base32 (`0-9A-Z` minus `I/L/O/U`), 8 chars.
- Friend code collisions handled silently via INSERT-and-retry (`apps/api/src/lib/friend-code.ts`, `createUserWithUniqueCode`).
- All authed endpoints under `/me` or resource root; session JWT (HS256, 24h, no refresh) in `Authorization: Bearer …`.
- D1 migrations in `apps/api/drizzle/`; never hand-edit applied SQL.
- Shared code goes in `DenTimeCore`, not the app targets.
- Time: always store UTC; convert to IANA zones only on display.
- Time Peek is client-side only — no API endpoints.
- Apple first-sign-in: capture `fullName` and `email` immediately — Apple only returns once.
- Display name fallback: auto-generate `DenUser-XXXX` when Apple hides name; editable in Settings.

## Subscriptions (RevenueCat)

- SKUs: `dentime_monthly` ($0.99/mo), `dentime_annual` ($10.99/yr). Both include a 7-day intro free trial.
- Single entitlement: `pro`. Cross-platform via RC App User ID = `users.id`.
- Backend: `/webhooks/revenuecat` HMAC-verified → updates `users.subscription_tier` + `users.subscription_platform`.
- Trial-expired / cancelled state: **read-only** — user keeps roster access but can't add friends or create meetups. Existing meetups still display and RSVP works.
- Paywall UI: RevenueCat Paywall Builder template (covers all 3.1.2 disclosure requirements).
- **Owner comp access:** Worker secret `OWNER_APPLE_SUBS` lists Apple `sub` IDs that get `subscription_tier = 'comp'` on sign-in — permanent, bypasses trial/webhook. Mirror with an RC lifetime promotional entitlement for the same App User ID. No UI exposure.

## Testing

Three layers, all required:
1. **API E2E** — Vitest + Miniflare + fresh D1 per run; blocks deploy on red.
2. **Apple UI E2E** — XCUITest on both iOS simulator and macOS; runs in `apple-testflight.yml` before archive.
3. **Full-stack golden path** — Bun script on `workflow_dispatch`; two seeded users across both platforms, real meetup flow end-to-end, sandbox IAP purchase.

Run `anthropic-skills:app-store-review-audit` and `coderabbit:greenlight` against both app targets before every TestFlight build.

## App Store guardrails

- Account deletion in-app, reachable without paywall (5.1.1(v)).
- No external purchase links inside the apps (3.1.1). OK on the docs site.
- Paywall shows: title, period, price, trial disclosure, auto-renew notice, TOS/Privacy links, restore button (3.1.2).
- No dormant features (2.3.1) — reviewer bypass (long-press version 5×) MUST be documented in App Store Connect review notes.
- Privacy Nutrition Label: Identifiers (Apple sub), Contact Info (optional email), User Content (nicknames, meetup titles). No tracking, no advertising.
- Sign in with Apple only → no 4.8 complications.

## Key paths

- Plan: `~/.claude/plans/dentime-claude-breezy-kahn.md`
- API: `apps/api/src/`
- Docs site: `apps/docs/app/`
- Legal: `apps/docs/app/legal/{terms,privacy}/`
- Apple: `apple/DenTime.xcodeproj`, `apple/DenTimeCore/`
