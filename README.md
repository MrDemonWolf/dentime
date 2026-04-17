# DenTime - Timezones, but friendly

DenTime is a native SwiftUI app for macOS and iOS that lets you share your
timezone with the people you choose, see their local times at a glance, peek
at any future moment across your roster, and run Doodle-style meetup polls
that respect everyone's wall clock. Built for remote friends, distributed
teams, and anyone tired of doing timezone math in their head.

Stop converting times in your head. Start meeting on time.

## Features

- **Roster** - Share a short friend code and see the current local time for
  everyone you've added, right from the menu bar.
- **Time Peek** - Pick any future moment in your timezone and instantly see
  what it'll be for every friend. 100% client-side, no round trips.
- **Meetups** - Propose 3-6 time slots, invite friends (or a whole group),
  let each invitee RSVP in their own local time. Finalize to save straight
  into Calendar via EventKit or download an `.ics` file.
- **Groups** - Organize your roster into custom groups ("Family", "Work EU")
  and invite a whole group to a meetup in one tap.
- **Push notifications** - Meetup invites, RSVP updates, and finalized-slot
  alerts via APNs. No Firebase, no third parties.
- **Widgets** - Home-screen widgets on iOS and Notification Center widgets
  on macOS show 3-5 friends' current times at a glance.
- **Calendar integration** - Read-only "busy until X" hints next to your
  clock and one-tap save to Calendar on meetup finalize (EventKit).
- **Native everywhere** - Zero web views. SwiftUI on iOS and macOS, sharing
  a single `DenTimeCore` Swift package.
- **Sign in with Apple** - The only auth in v1. Your email stays private if
  you want it to.
- **Cross-platform subscription** - One purchase unlocks both the macOS and
  iOS apps, with a 7-day free trial.

## Getting Started

Full docs live at [mrdemonwolf.github.io/dentime](https://mrdemonwolf.github.io/dentime).

1. Install the macOS or iOS app from the App Store (coming soon).
2. Sign in with Apple.
3. Copy your friend code from Settings and share it with someone.
4. Paste their code into `Add a friend` to see their local time.

## Usage

### Menu bar actions (macOS)

| Action           | What it does                                                      |
| ---------------- | ----------------------------------------------------------------- |
| Click a friend   | Copies "It's `3:42 PM` for Alex" to your clipboard.               |
| Pick a time...   | Opens Time Peek - pick a future moment, see it for everyone.      |
| Make a meetup    | Start a Doodle-style poll from the currently-peeked time.         |
| Your code        | Shows your friend code as a scannable QR in Settings.             |

### Deep links

| Link                                             | What it does                             |
| ------------------------------------------------ | ---------------------------------------- |
| `dentime://add/<code>`                           | Opens the Add Friend sheet pre-filled.   |
| `https://mrdemonwolf.github.io/dentime/u/<code>` | Public web profile with live clock.      |

## Tech Stack

| Layer                         | Technology                                           |
| ----------------------------- | ---------------------------------------------------- |
| Monorepo                      | Bun + Turborepo (Better-T-Stack)                     |
| API                           | Hono on Cloudflare Workers                           |
| Database                      | Cloudflare D1 + Drizzle ORM                          |
| Auth                          | Sign in with Apple + HS256 session JWT               |
| Subscriptions                 | RevenueCat + StoreKit 2                              |
| Logging                       | Better Stack (`@logtail/edge`)                       |
| Docs / landing / web profiles | Fumadocs (Next.js static export) on GitHub Pages     |
| macOS + iOS apps              | Native SwiftUI, shared `DenTimeCore` Swift package   |
| CI/CD                         | GitHub Actions                                       |

## Development

### Prerequisites

- Bun 1.1+
- Node.js 20+ (for Fumadocs tooling)
- Xcode 15+ on a macOS 14+ host (for the Apple targets)
- Wrangler CLI (`bun add -g wrangler`)
- A Cloudflare account with Workers and D1 enabled
- An Apple Developer account (Sign in with Apple and App Store builds)
- A RevenueCat account (free tier is fine)

### Setup

1. Clone the repo and install dependencies.

   ```bash
   git clone git@github.com:mrdemonwolf/dentime.git
   cd dentime
   bun install
   ```

2. Create the D1 database and apply migrations.

   ```bash
   bun run --cwd apps/api db:create
   bun run --cwd apps/api db:migrate
   ```

3. Configure Worker secrets.

   ```bash
   bun run --cwd apps/api wrangler secret put JWT_SECRET
   bun run --cwd apps/api wrangler secret put APPLE_AUDIENCES
   bun run --cwd apps/api wrangler secret put BETTER_STACK_TOKEN
   bun run --cwd apps/api wrangler secret put BETTER_STACK_INGEST
   bun run --cwd apps/api wrangler secret put REVENUECAT_WEBHOOK_SECRET
   bun run --cwd apps/api wrangler secret put OWNER_APPLE_SUBS
   ```

4. Start every dev server in parallel.

   ```bash
   bun run dev
   ```

5. Open the Apple project.

   ```bash
   open apple/DenTime.xcodeproj
   ```

### Development Scripts

- `bun run dev` - Run `apps/api` and `apps/docs` dev servers in parallel via
  Turborepo.
- `bun run --cwd apps/api dev` - Start only the Worker dev server on
  `http://localhost:8787`.
- `bun run --cwd apps/api db:generate` - Generate a new Drizzle migration
  from schema changes.
- `bun run --cwd apps/api db:migrate` - Apply migrations to the local D1.
- `bun run --cwd apps/api db:migrate:prod` - Apply migrations to production
  D1.
- `bun run --cwd apps/api test` - Run the Vitest + Miniflare API E2E suite.
- `bun run --cwd apps/docs dev` - Start Fumadocs on `http://localhost:3000`.
- `bun run --cwd apps/docs build` - Produce the static export at
  `apps/docs/out/`.

### Code Quality

- Strict TypeScript across the API and docs site.
- Vitest + Miniflare for API E2E tests, with a fresh D1 per run.
- XCUITest suites for both iOS and macOS app targets.
- Full-stack golden-path E2E under `e2e/` gated behind `workflow_dispatch`.
- Biome for formatting and linting on TypeScript.
- SwiftLint on the Apple targets.
- `anthropic-skills:app-store-review-audit` and `coderabbit:greenlight` run
  before every TestFlight build.

## Project Structure

```
dentime/
├── apps/
│   ├── api/                   # Hono Worker - Cloudflare Workers + D1
│   │   ├── src/               # Routes, middleware, db schema, lib
│   │   ├── drizzle/           # Generated migrations
│   │   └── wrangler.jsonc
│   └── docs/                  # Fumadocs - landing, docs, legal, /u/[code]
│       ├── app/
│       └── next.config.mjs    # basePath: '/dentime'
├── apple/
│   ├── DenTime.xcodeproj      # Two targets: DenTime-macOS, DenTime-iOS
│   ├── DenTime/               # Shared SwiftUI app code
│   └── DenTimeCore/           # Swift package - API client, stores, models
├── e2e/                       # Full-stack golden-path tests
├── .github/workflows/         # api-deploy, docs-deploy, apple-testflight
├── turbo.json
├── package.json
└── CLAUDE.md                  # In-repo quick reference for contributors
```

## License

![GitHub license](https://img.shields.io/github/license/mrdemonwolf/dentime.svg?style=for-the-badge&logo=github)

## Contact

Questions or feedback? [Join my server](https://mrdwolf.net/discord).

---

Made with love by [MrDemonWolf, Inc.](https://www.mrdemonwolf.com)
