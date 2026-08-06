## What changed

<!-- One or two sentences. -->

## Why

<!-- Link the phase in docs/planning/PHASES.md, or the decision in DECISIONS.md this serves. -->

## Checks

- [ ] `bun run check`, `bun run typecheck` and `bun run test` pass
- [ ] `swift build` and `swift test` pass in `packages/DenTimeCore` (if Swift changed)
- [ ] No `import EventKit` and no `import StoreKit` anywhere
- [ ] No server, no Cloudflare Workers, no D1, no Hono, no Drizzle, no Better Auth
- [ ] Bundle ID is still `com.mrdemonwolf.dentime` with no suffix
- [ ] Copy follows the language rules in `CLAUDE.md` — den not contacts, pack not team, host not organizer
- [ ] Blocking copy says "You won't see them", never "They can't see you"

## Notes for review

<!-- Screenshots, anything you are unsure about, anything you deliberately left out. -->
