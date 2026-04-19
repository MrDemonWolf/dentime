# 🐺 DenTime

> Timezones for your pack. Menu bar app for Mac, docs for everyone else.

[![Docs](https://img.shields.io/badge/docs-mrdemonwolf.github.io%2Fdentime-0FACED)](https://mrdemonwolf.github.io/dentime)
[![License: MIT](https://img.shields.io/badge/license-MIT-091533)](./LICENSE)

DenTime shows you the current time for everyone in your pack — friends, coworkers, family — grouped in a macOS menu bar. Pick a meeting time and see it in every zone instantly. Local-only in MVP1. No account, no tracking, nothing leaves your Mac.

## Quick start

```bash
bun install
bun run dev           # runs all apps
bun run build         # builds everything
bun run test          # runs tests
bun run typecheck     # type-checks all packages
bun run lint          # eslint
bun run format        # prettier --write
bun run check         # eslint + prettier --check
```

## Monorepo layout

```
apps/
  macOS/        SwiftUI menu bar app (XcodeGen project.yml)
  iOS/          Scaffold only (MVP2)
  docs/         Next.js 15 + Fumadocs → GitHub Pages
packages/
  shared/       (placeholder, MVP2 will populate)
assets/         Brand marks (logo.svg, logo-mono.svg)
```

## Scope

- **MVP1** (shipping now): See [`HACKATON.md`](./HACKATON.md) and [`CC-MVP1.md`](./CC-MVP1.md)
- **MVP2** (next): See [`CC-MVP2.md`](./CC-MVP2.md)

## Build the macOS app

```bash
cd apps/macOS
xcodegen generate
xcodebuild -project DenTime.xcodeproj -scheme DenTime build
```

Open `DenTime.xcodeproj` in Xcode, hit ⌘R. Requires macOS 13+, Xcode 15+.

## Build the docs site

```bash
bun run --filter @dentime/docs dev     # http://localhost:3001
bun run --filter @dentime/docs build   # static export → apps/docs/out/
```

## License

MIT © 2026 MrDemonWolf, Inc.
