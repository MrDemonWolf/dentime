# Archive

**Nothing in this directory is current.** It is kept because knowing *why* a stack was dropped is worth more later than knowing only that it was — otherwise the same idea comes back in six months with nobody able to say what was wrong with it the first time.

If you are looking for what DenTime is now, start at [`CLAUDE.md`](../../../CLAUDE.md) and [`DECISIONS.md`](../DECISIONS.md).

## What is in here

| File | What it was | Why it is dead |
|---|---|---|
| `2026-08-05-dentime-onepager.html` | A single-page summary of the whole project, written the day before the rebuild | Its stack section still describes Hono + Drizzle on Cloudflare Workers + D1, Better Auth, and four platforms across three submissions. Everything else in it — the language rules, the locked decisions, the pricing reasoning, the Apple checklist — survived into the current docs. |
| `CC-MVP1.md` | Build prompt for the local-only MVP1 macOS app | Superseded. MVP1 shipped a `UserDefaults`-backed friend list with no sync; the current design is CloudKit end to end. |
| `CC-MVP2.md` | Build prompt for MVP2 — sync, iOS, meetups, iCal export | Superseded. Its sync design was the Workers/D1 API. iCal export is now cut entirely, not deferred. |
| `HACKATON.md` | Hackathon planning notes | Historical. |
| `START_HERE.md` | Onboarding doc for the MVP1 repo | Replaced by the root `README.md` and `CLAUDE.md`. |
| `TODO.md` | MVP1 task list | Replaced by [`PHASES.md`](../PHASES.md) and [`JIRA-BACKLOG.md`](../JIRA-BACKLOG.md). |
| `CHANGELOG.md` | Changelog for the MVP1 app | Nothing from MVP1 shipped publicly. |
| `CLAUDE-mvp1.md` | The MVP1-era `CLAUDE.md` | Replaced by the root `CLAUDE.md`. Kept because it shows what the local-only scope looked like. |

## What changed between all of that and now

1. **CloudKit replaced the entire backend.** No Cloudflare Workers, no D1, no Hono, no Drizzle, no Better Auth, no `apps/server`.
2. **Calendar integration was cut**, including `.ics` export, which the old docs list as deferred rather than dead.
3. **macOS ships alone first.** The old docs plan four platforms across three submissions from day one.
4. **The app is paid up front at $9.99** with no free tier and no StoreKit at all.
5. **Docs moved to GitHub Pages with no custom domain.** The old docs assume `dentime.mrdemonwolf.com`.
6. **"Find a Time" became Time Peek**, a scrubber inside the Den tab rather than a tab of its own.

The full reasoning for each is in [`DECISIONS.md`](../DECISIONS.md).

## Rule

Superseded documents move here. They do not get deleted, and they do not get quietly updated to match the current plan — an archive that has been edited to look correct is worth nothing.
