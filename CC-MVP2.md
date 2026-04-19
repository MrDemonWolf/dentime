# Claude Code: Build DenTime MVP2

## Context

MVP1 shipped (see `CC-MVP1.md` and `HACKATON.md`): local-only macOS menu bar app + Fumadocs docs on GitHub Pages at `mrdemonwolf.github.io/dentime`.

MVP2 adds backend, cross-device sync, iOS, meetups, iCal, calendar integrations, and the subscription paywall.

**Owner:** Nathanial / MrDemonWolf, Inc. ADHD/Asperger's — direct, numbered phases, use your todo list. Push back when wrong.

**Reference repo:** `~/Code/fangdash` (`github.com/MrDemonWolf/fangdash`). Closest template for this MVP — same stack: Hono on CF Workers + D1 + Drizzle + Better Auth + Fumadocs + Turborepo + bun. Read its `apps/api/` end-to-end before writing a line. Replicate its auth wiring, middleware patterns, migration workflow, deploy scripts.

## Goal

Ship MVP2: full DenTime with sync, meetups, iCal export, iOS app, calendar integrations, and a **$1.99/mo — $16.99/yr paid subscription with 14-day free trial**.

API lives at `https://dentime.mrdemonwolf.workers.dev`.

## Pricing (confirmed)

- Monthly: **$1.99 USD** — product ID `com.mrdemonwolf.dentime.monthly`
- Yearly: **$16.99 USD** — product ID `com.mrdemonwolf.dentime.yearly` (saves 29% vs monthly)
- **14-day free trial** on first-time signup (standard App Store intro offer, applies to either plan)
- One trial per Apple ID (App Store enforces this automatically via `.familyShareable = false` + trial eligibility)

## Features

1. **Cloudflare Workers API** (Hono, TypeScript) at `dentime.mrdemonwolf.workers.dev`
2. **Better Auth with Apple OAuth** — matches fangdash's pattern
3. **Friend codes** — 8-char Crockford base32, displayed `XXXX-XXXX`
4. **Roster sync** across devices
5. **Groups sync** (MVP1 local groups migrate on first sign-in)
6. **Meetups** — Doodle-style polls with per-slot RSVP
7. **iCal (.ics) export** for meetings/slots
8. **Calendar integration** — EventKit for conflict detection + event creation
9. **iOS app** with feature parity
10. **Deep link handler** — `dentime://add/<code>`, `dentime://meetup/<id>`
11. **Universal Links** at `mrdemonwolf.github.io/dentime/add/<code>`
12. **Paywall** — StoreKit 2 + server-side receipt validation
13. **Sparkle auto-update** OR Mac App Store — Nathanial picks in Phase 18

## Free tier vs Premium

**Free:**
- Roster view (any number of friends)
- Find a Time (picking a time, seeing conversions)
- Sign in with Apple, friend code, sync across devices

**Premium ($1.99/mo or $16.99/yr):**
- Meetups (Doodle-style polls)
- iCal export
- Calendar integration (conflict detection + auto-add events)
- Friend groups beyond 3 (cap free tier at 3 groups)
- Priority support

Rationale: core utility stays free so you get word-of-mouth + App Store rating volume. Premium features are the ones with real collaboration value + server cost.

## Repo layout (target after MVP2)

```
dentime/
├── apps/
│   ├── docs/          ← existing
│   ├── macOS/         ← existing, refactored to import DenTimeCore
│   ├── iOS/
│   │   └── DenTime/
│   │       └── …
│   └── api/
│       ├── src/
│       │   ├── index.ts
│       │   ├── routes/
│       │   │   ├── auth.ts
│       │   │   ├── me.ts
│       │   │   ├── roster.ts
│       │   │   ├── meetups.ts
│       │   │   ├── ics.ts
│       │   │   ├── subscriptions.ts
│       │   │   └── webhooks.ts
│       │   ├── lib/
│       │   │   ├── auth.ts
│       │   │   ├── friend-code.ts
│       │   │   ├── ics.ts
│       │   │   └── storekit.ts
│       │   ├── middleware/
│       │   └── db/
│       │       ├── schema.ts
│       │       └── migrations/
│       ├── drizzle.config.ts
│       ├── wrangler.jsonc
│       └── package.json
└── packages/
    ├── DenTimeCore/
    │   ├── Package.swift
    │   └── Sources/DenTimeCore/
    │       ├── Models/
    │       ├── Networking/
    │       ├── Storage/
    │       └── Auth/
    └── shared/
```

---

## Build phases

### Phase 1 — API scaffold (copy fangdash's `apps/api`)

Before coding, read fangdash's `apps/api/` in full: `package.json`, `wrangler.jsonc`, `src/index.ts`, all middleware, `drizzle.config.ts`, `.dev.vars.example`. Replicate the pattern exactly, adapt names.

- [ ] `bun create cloudflare@latest apps/api -- --framework=hono --type=hello-world --ts --deploy=false`
- [ ] `cd apps/api && bun add drizzle-orm better-auth @hono/zod-validator zod`
- [ ] `bun add -d drizzle-kit @cloudflare/workers-types @types/bun wrangler vitest`
- [ ] `wrangler d1 create dentime-db` → capture `database_id` into `wrangler.jsonc`
- [ ] `wrangler.jsonc`: worker name `dentime`, D1 binding `DB`, KV namespace `SESSIONS`, KV namespace `RATE_LIMIT`, compatibility flags `["nodejs_compat"]`
- [ ] `src/index.ts` — Hono app with typed `Bindings`, `/health` route
- [ ] `.dev.vars.example` with all secrets documented
- [ ] `bun run dev` serves at `localhost:8787/health`
- [ ] `package.json` scripts matching fangdash: `dev`, `build`, `deploy`, `test`, `typecheck`, `lint`, `format`, `db:generate`, `db:migrate:local`, `db:migrate:remote`

### Phase 2 — Drizzle schema

File: `apps/api/src/db/schema.ts`. Full schema for users, Better Auth tables, rosterEntries, meetups, meetupSlots, meetupInvites, meetupResponses, subscriptions log.

Key table: `users` with `friendCode` (unique), `timezoneIdentifier`, `subscriptionStatus` enum, `subscriptionRenewsAt`, `trialEndsAt`, `appleOriginalTransactionId` (for StoreKit 2 tracking).

- [ ] Full schema
- [ ] `drizzle.config.ts` pointing at schema, out `./src/db/migrations`, dialect `sqlite`
- [ ] `bun run db:generate` → first migration
- [ ] `bun run db:migrate:local`

### Phase 3 — Better Auth with Apple OAuth

Read fangdash's `apps/api/src/lib/auth.ts` in detail. Replicate with Apple provider instead of Twitch.

- [ ] `src/lib/auth.ts` with `betterAuth({ database: drizzleAdapter(db), socialProviders: { apple: { clientId, clientSecret, teamId, keyId, privateKey } }, … })`
- [ ] Apple OAuth requires a **Services ID** (separate from App ID). Nathanial's TODO: create `com.mrdemonwolf.dentime.auth` Services ID in Apple Developer portal, link to primary App ID, configure redirect URL `https://dentime.mrdemonwolf.workers.dev/api/auth/callback/apple`
- [ ] Apple private key (.p8) generated in Developer portal → stored as `APPLE_PRIVATE_KEY` wrangler secret
- [ ] Auth routes mounted at `/api/auth/*` via Hono's `route()` + Better Auth's handler
- [ ] On user creation hook: generate unique friend code (Phase 4), insert with retry-on-collision
- [ ] Middleware `src/middleware/auth.ts` — verifies session, sets `c.set('user', user)`

### Phase 4 — Friend code generator

File: `apps/api/src/lib/friend-code.ts`

```typescript
const ALPHABET = '0123456789ABCDEFGHJKMNPQRSTVWXYZ';  // Crockford base32, no I/L/O/U

export function generate(): string {
  const bytes = new Uint8Array(8);
  crypto.getRandomValues(bytes);
  return [...bytes].map(b => ALPHABET[b % 32]).join('');
}

export function format(code: string): string {
  return `${code.slice(0, 4)}-${code.slice(4)}`;
}

export function normalize(input: string): string {
  return input.toUpperCase().replace(/[^0-9A-Z]/g, '').slice(0, 8);
}
```

- [ ] Vitest tests: generation entropy, formatting, normalize edge cases, collision retry

### Phase 5 — User routes (`src/routes/me.ts`)

- [ ] `GET /me` → profile + friendCode + subscriptionStatus
- [ ] `PATCH /me` → update name, timezoneIdentifier
- [ ] `POST /me/regenerate-code` → new friend code (rate limit: 1/24h via KV)
- [ ] `DELETE /me` → full account deletion (App Store Guideline 5.1.1(v))

### Phase 6 — Roster routes (`src/routes/roster.ts`)

- [ ] `GET /roster` → my roster with joined friend data (names, timezones)
- [ ] `GET /roster/preview/:code` → preview before adding (rate limit: 10/min)
- [ ] `POST /roster` → add friend by code; body `{ code, groupName?, customLabel?, colorHex? }`
- [ ] `PATCH /roster/:id` → update group, label, color, sortOrder
- [ ] `DELETE /roster/:id`
- [ ] `POST /roster/reorder` → bulk sort update
- [ ] **Free-tier limit:** cap at 3 distinct `groupName` values for free users. Return 402 Payment Required with `{ error: 'groups_limit', upgrade: true }` if exceeded.

### Phase 7 — Meetup routes (`src/routes/meetups.ts`) [PREMIUM]

All routes behind `requireSubscription` middleware.

- [ ] `POST /meetups` → create with `{ title, description?, slots: [...], inviteeIds: string[] }`
- [ ] `GET /meetups` → list where I'm owner or invitee
- [ ] `GET /meetups/:id` → details: slots, invitees, responses
- [ ] `PATCH /meetups/:id` → update (owner only)
- [ ] `DELETE /meetups/:id` → cancel (owner only)
- [ ] `POST /meetups/:id/respond` → `{ slotId, response: 'yes'|'no'|'maybe' }` (invitee only, per-slot)
- [ ] `POST /meetups/:id/close` → finalize, lock responses (owner only)

### Phase 8 — iCal export (`src/routes/ics.ts`) [PREMIUM]

File: `apps/api/src/lib/ics.ts` — hand-roll RFC 5545 output.

- [ ] `buildICS({ uid, summary, description, startsAt, durationMinutes, organizer, attendees })` → valid `.ics` string
- [ ] Escape per RFC 5545 (commas, semicolons, newlines → `\,`, `\;`, `\n`)
- [ ] PRODID: `-//MrDemonWolf Inc//DenTime//EN`
- [ ] DTSTAMP, DTSTART (UTC `Z`), DTEND computed from duration

Routes:
- [ ] `GET /meetups/:id/slots/:slotId.ics` → authenticated
- [ ] `GET /ics/time?start=<iso>&minutes=<int>&title=<str>&tz=<id>` → standalone export
- [ ] Both set `Content-Type: text/calendar; charset=utf-8`, `Content-Disposition: attachment; filename="dentime-<id>.ics"`

### Phase 9 — Subscription + StoreKit 2 validation

`src/routes/subscriptions.ts`:

- [ ] `POST /subscriptions/verify` → body `{ signedTransaction }` — verify against Apple's App Store Server API using JWT auth (private key from App Store Connect), update user's `subscriptionStatus` (`trial`|`active`|`past_due`|`canceled`) and `subscriptionRenewsAt` / `trialEndsAt`
- [ ] `GET /subscriptions/status` → return current status (for client to refresh on launch)

`src/routes/webhooks.ts`:
- [ ] `POST /webhooks/apple` → App Store Server Notifications V2. Verify JWS signature against Apple's public keys. Handle events: `DID_RENEW`, `DID_FAIL_TO_RENEW`, `EXPIRED`, `REFUND`, `SUBSCRIBED`, `DID_CHANGE_RENEWAL_STATUS`, `GRACE_PERIOD_EXPIRED`
- [ ] Log all webhooks (we care about billing history for support)

**Nathanial's TODO (Phase 9 prerequisite):**
- Create App Store Connect subscription group `DenTime Premium`
- Product `com.mrdemonwolf.dentime.monthly` — $1.99 USD, with 14-day intro free trial
- Product `com.mrdemonwolf.dentime.yearly` — $16.99 USD, with 14-day intro free trial
- Generate App Store Server API key (in App Store Connect → Users → Keys → In-App Purchase) → store private key as `STOREKIT_PRIVATE_KEY` wrangler secret
- Note the Key ID and Issuer ID as `STOREKIT_KEY_ID` and `STOREKIT_ISSUER_ID` secrets
- Set App Store Server Notifications URL in App Store Connect → Your App → App Information → `https://dentime.mrdemonwolf.workers.dev/webhooks/apple`

Middleware `src/middleware/subscription.ts`:
- [ ] `requireSubscription` — rejects with 402 if `user.subscriptionStatus` is not `trial` or `active`
- [ ] Attach subscription info to `c.set('subscription', ...)` so downstream handlers can differentiate trial vs active

### Phase 10 — DenTimeCore Swift Package

Create `packages/DenTimeCore/Package.swift`:

```swift
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "DenTimeCore",
    platforms: [.iOS(.v17), .macOS(.v13)],
    products: [.library(name: "DenTimeCore", targets: ["DenTimeCore"])],
    targets: [
        .target(name: "DenTimeCore", path: "Sources/DenTimeCore"),
        .testTarget(name: "DenTimeCoreTests", dependencies: ["DenTimeCore"]),
    ]
)
```

- [ ] Move `Friend`, `TimeFormat`, `TimeStatus`, `FriendStore`, `SettingsStore` from MVP1 macOS app into `Sources/DenTimeCore/`
- [ ] Add new types: `User`, `RosterEntry`, `Meetup`, `MeetupSlot`, `MeetupResponse`, `SubscriptionStatus`
- [ ] `Networking/APIClient.swift` — URLSession, typed endpoints, Bearer token injection, exponential backoff retry on 5xx, `baseURL = "https://dentime.mrdemonwolf.workers.dev"` (overridable for dev)
- [ ] `Auth/AuthStore.swift` — Apple Sign In flow, session persistence
- [ ] `Storage/Keychain.swift` — wrapper over `Security` framework, service `com.mrdemonwolf.dentime.session`
- [ ] `Storage/OfflineCache.swift` — local cache of roster + meetups, last-write-wins reconciliation
- [ ] `Subscription/StoreKitManager.swift` — StoreKit 2 wrapper: fetch products, purchase, refresh status, call `/subscriptions/verify` after successful purchase
- [ ] Update macOS Xcode project to depend on DenTimeCore (local SPM), remove duplicated MVP1 types
- [ ] Unit tests

### Phase 11 — macOS: Apple Sign In + sync migration

- [ ] First-launch onboarding sheet: logo, tagline, "Sign in with Apple" button
- [ ] `ASAuthorizationAppleIDProvider` → POST to Better Auth endpoint
- [ ] On first successful sign-in, detect MVP1 local friends. **Ask Nathanial before writing:** should these become server-synced roster entries (creating stub users for non-DenTime-member friends)? Or stay local-only in a "local notes" section? My rec: migrate to server but mark as `placeholderUser` so they can be upgraded if the friend ever signs up with DenTime.
- [ ] Settings: friend code displayed with big copy button + QR code (`CIQRCodeGenerator`)
- [ ] Offline mode: read from OfflineCache when no network

### Phase 12 — macOS: Add Friend by code

Update AddFriendView:
- [ ] Two modes: "Add by code" (new, requires sign-in) vs "Add local note" (MVP1 flow, always available — use this language on UI so people know the distinction)
- [ ] Paste code → `GET /roster/preview/:code` → show name + timezone → confirm → `POST /roster`
- [ ] QR code scanner: stretch goal, not required

### Phase 13 — macOS: Meetups UI [PREMIUM]

Add "Meetups" tab to RootView (now: Now / Find a Time / Meetups / ⚙).

- [ ] Create meetup flow: title → pick 1-6 slots (reuse Find a Time picker) → pick invitees from roster → submit
- [ ] Meetups list: meetups I own + I'm invited to, sorted by next slot
- [ ] Meetup detail: slot grid, invitee chips with response states, "Close meetup" (owner), "Respond" per-slot (invitee)
- [ ] Local notifications via `UNUserNotificationCenter` when someone responds
- [ ] Gate behind `subscriptionStatus`. Non-subscribers see the tab but content is paywalled: "Unlock meetups with DenTime Premium — 14-day free trial."

### Phase 14 — macOS: iCal export [PREMIUM]

- [ ] Find a Time: "Export .ics" button next to "Copy as text" → `/ics/time` endpoint → save via `NSSavePanel`
- [ ] Meetup detail: per-slot "Export .ics" icon → `/meetups/:id/slots/:slotId.ics`
- [ ] Gated behind subscription

### Phase 15 — macOS: Deep links

- [ ] Register `dentime` URL scheme in Info.plist CFBundleURLTypes
- [ ] `dentime://add/<code>` → open Add Friend sheet with code pre-filled
- [ ] `dentime://meetup/<id>` → open meetup detail (sign-in check first)

### Phase 16 — macOS: Calendar integration (EventKit) [PREMIUM]

- [ ] Sandbox entitlement: `com.apple.security.personal-information.calendars`
- [ ] Info.plist: `NSCalendarsUsageDescription` with clear reason
- [ ] `EKEventStore.requestFullAccessToEvents` on first use
- [ ] Find a Time: "Show my conflicts" toggle → fetch overlapping events → conflict indicator on user row
- [ ] Meetup detail "Add to Calendar" button after slot finalized → insert `EKEvent` with title/description/attendees

### Phase 17 — macOS: Paywall UI

- [ ] StoreKit 2 via `import StoreKit`
- [ ] `PaywallViewModel` `@Observable` — fetches products, handles purchase, calls server verify
- [ ] `PaywallView`: navy hero with paw tick, "DenTime Premium", feature list (Meetups, iCal export, Calendar integration, Unlimited groups), two product buttons:
  - **Yearly $16.99** (highlighted as "Best value — save 29%")
  - Monthly $1.99
- [ ] Big CTA: "Start 14-day free trial" (only shown if user is eligible via StoreKit's `Product.SubscriptionInfo.isEligibleForIntroOffer`)
- [ ] "Restore purchases" link
- [ ] "Manage subscription" link in Settings → opens `https://apps.apple.com/account/subscriptions`
- [ ] Required subscription disclosures below buttons per App Store rules: "Subscription auto-renews until canceled. Cancel anytime in Settings > [Your Name] > Subscriptions."
- [ ] Link to Terms + Privacy from paywall (required)
- [ ] Trial countdown badge in menu bar when `trialEndsAt` is within 3 days

### Phase 18 — macOS: Distribution decision

**Ask Nathanial:** Mac App Store only? Developer ID + Sparkle? Both?

My push-back: **Both.** MAS for discovery + auto-managed updates; Developer ID + Sparkle for faster iteration on power users. You'd maintain two archives per release — not much extra work since the archive process is the same, just two signing configs.

If Developer ID + Sparkle:
- [ ] Add Sparkle via SPM: `https://github.com/sparkle-project/Sparkle`
- [ ] `appcast.xml` served at `https://mrdemonwolf.github.io/dentime/appcast.xml` (static, updated per release via GitHub Actions)
- [ ] Generate EdDSA signing keys (`generate_keys` tool from Sparkle) — **store private key OFFLINE in 1Password, never commit**
- [ ] SUFeedURL in Info.plist
- [ ] Daily auto-check, update UI on new version

### Phase 19 — iOS app scaffold

- [ ] Add iOS target to existing Xcode project (multi-platform) OR new project at `apps/iOS/DenTime/`. My rec: same project, multi-platform targets, to share schemes and signing.
- [ ] Bundle ID `com.mrdemonwolf.dentime`, min iOS 17.0
- [ ] Depend on `DenTimeCore` via local SPM
- [ ] Tab-based UI: Roster / Find a Time / Meetups / Settings
- [ ] Sign in with Apple button on first launch

### Phase 20 — iOS feature parity

- [ ] Roster list with pull-to-refresh, same grouping as macOS
- [ ] Find a Time view
- [ ] Meetups list/detail/create (premium-gated)
- [ ] Settings matching macOS + iOS-specific: notifications permission prompt, app icon alternate (if desired)
- [ ] Calendar integration via EventKit
- [ ] iCal export → `UIActivityViewController` share sheet
- [ ] Paywall (StoreKit 2) — same UI adapted for iOS
- [ ] Deep link handler for `dentime://`

### Phase 21 — iOS: Universal Links

- [ ] Create `apps/docs/public/.well-known/apple-app-site-association` (JSON, no `.json` extension):
  ```json
  {
    "applinks": {
      "apps": [],
      "details": [{
        "appIDs": ["TEAMID.com.mrdemonwolf.dentime"],
        "paths": ["/add/*", "/meetup/*"]
      }]
    }
  }
  ```
- [ ] Nathanial's TODO: replace `TEAMID` with actual Apple Team ID (from developer portal)
- [ ] Enable Associated Domains capability in iOS target: `applinks:mrdemonwolf.github.io`
- [ ] Handle incoming URLs via SwiftUI `.onOpenURL`
- [ ] Test on real device (Universal Links flaky in Simulator)
- [ ] Update docs site build to preserve `.well-known/` directory in static export

### Phase 22 — Docs site updates for MVP2

- [ ] New docs pages: "Signing in with Apple", "Sharing your friend code", "Creating a meetup", "Calendar integration", "Subscription & billing", "Canceling your subscription"
- [ ] Update Privacy Policy — declare what the API collects:
  - Apple anonymous sub + Better Auth session tokens (30-day expiry in KV)
  - Display name (user-provided)
  - Timezone identifier
  - Roster (list of other users' IDs)
  - Meetup data (titles, descriptions, slots, responses)
  - Subscription status + renewal dates
  - Request logs (if Better Stack or similar added later)
- [ ] Retention: account deletion wipes everything within 30 days
- [ ] Update Terms with subscription terms, auto-renewal language per App Store
- [ ] Add "Download on the App Store" badges once apps ship

### Phase 23 — Deploy API

- [ ] `wrangler deploy` → publishes to `dentime.mrdemonwolf.workers.dev`
- [ ] Apply D1 migrations to production: `bun run db:migrate:remote`
- [ ] Set production secrets (use `wrangler secret put`):
  - `BETTER_AUTH_SECRET`
  - `APPLE_CLIENT_ID` (the Services ID)
  - `APPLE_TEAM_ID`
  - `APPLE_KEY_ID`
  - `APPLE_PRIVATE_KEY` (the .p8 file contents)
  - `STOREKIT_KEY_ID`
  - `STOREKIT_ISSUER_ID`
  - `STOREKIT_PRIVATE_KEY` (the App Store Server API .p8)
  - `STOREKIT_BUNDLE_ID = com.mrdemonwolf.dentime`
- [ ] Verify `curl https://dentime.mrdemonwolf.workers.dev/health` returns 200

### Phase 24 — CI + deploy workflow

`.github/workflows/deploy-api.yml`:
- [ ] On push to main with paths `apps/api/**` or `packages/shared/**`: run tests, typecheck, then `wrangler deploy`
- [ ] Uses secret `CLOUDFLARE_API_TOKEN` (Nathanial adds to GitHub repo Secrets)

### Phase 25 — Privacy Manifest update

Update `apps/macOS/DenTime/DenTime/Resources/PrivacyInfo.xcprivacy` and create iOS equivalent:

- [ ] `NSPrivacyCollectedDataTypes`:
  - `NSPrivacyCollectedDataTypeUserID` — linked to user, for App Functionality (our UUID)
  - `NSPrivacyCollectedDataTypeName` — linked, App Functionality (user-provided display name)
  - `NSPrivacyCollectedDataTypeOtherUserContent` — linked, App Functionality (meetups, responses)
  - `NSPrivacyCollectedDataTypePurchaseHistory` — linked, App Functionality (subscription status)
- [ ] `NSPrivacyTracking = false` (still not tracking across apps)
- [ ] `NSPrivacyAccessedAPITypes`: UserDefaults (CA92.1), File Timestamp (C617.1 if OfflineCache uses file dates)

### Phase 26 — App Store submissions

- [ ] macOS archive → validate → upload to App Store Connect
- [ ] iOS archive → validate → upload to App Store Connect
- [ ] App Review metadata:
  - Demo account Apple ID (create a dedicated test account; store creds in Nathanial's 1Password)
  - Review notes: "Use Sign in with Apple with the provided demo account. Friend code will be visible in Settings > Account. To test meetups, create a meetup with any slot and invite demo friend code [XXXX-XXXX] (pre-seeded)."
  - Privacy Nutrition Label updated per Phase 25
  - In-app purchases must be marked "Ready to Submit" before app binary submission
- [ ] Submit both targets together (App Store prefers this for multi-platform apps)

### Phase 27 — Summary

Print:
1. File counts added, Swift + TypeScript LOC added
2. Phases skipped/modified with reasons
3. Nathanial's manual TODOs remaining (Services ID creation, subscription products, App Store Server API key, Team ID in AASA file, TestFlight round)
4. Known rough edges
5. Status: **"MVP2 feature-complete. Ready for App Store review pending Nathanial's TestFlight round and subscription group approval."**

---

## Apple guidelines (beyond MVP1)

- **3.1.1** — IAP must use StoreKit. Subscriptions via App Store Connect only. ✅
- **3.1.2** — Auto-renewing subscription rules. All required disclosures wired in Phase 17 paywall. ✅
- **4.8** — Sign in with Apple must be offered alongside any third-party social login. We're Apple-only → automatic compliance.
- **5.1.1(iii)** — Users must access their subscription from within the app. "Manage subscription" link in Settings. ✅
- **5.1.1(v)** — Account deletion must be available in-app, not email-only. `DELETE /me` wired to Settings → Delete Account. ✅
- **5.1.2** — Data minimization. We collect only what's needed for functionality.
- **Privacy Manifest** — updated in Phase 25.
- **4.2** — Minimum functionality. Meetups + sync + calendar integration clear this easily.

---

## Pricing references (for the App Store Connect side)

Tier mapping (App Store uses tiered pricing):
- $1.99 → US tier 2
- $16.99 → US tier ~16 (check App Store Connect's current tier chart)

Free trial: 14 days, "Customer pays nothing" offer type, applied to both products.
