# docs/design

Reference material only. **No SwiftUI has been written from these files yet** — the app target is still a placeholder. When phases 7, 8 and 10 come round, this is what they are built against.

Source: the DenTime project on [claude.ai/design](https://claude.ai/design/p/642505bd-d89a-4e88-b6c0-6365ef80ebc3), project ID `642505bd-d89a-4e88-b6c0-6365ef80ebc3`. These copies are a snapshot; the design project stays the working surface.

## What is here

| File | Status |
|---|---|
| `DenTime App v2.dc.html` | **Canonical.** The reviewed v2 mockup of the macOS menu bar app, copied byte for byte. |
| `support.js` | The runtime the mockup imports. Open the mockup from this directory and it renders offline. |
| `design-tokens.md` | Palette, ramps, type scale, spacing, controls and SwiftUI mapping, extracted from the design-system document. |
| `uiux-review.md` | NN/g heuristic review of v2. Four of six findings were applied in the mockup itself. |

Two files in the design project were deliberately **not** copied:

- **`DenTime App.dc.html`** — the superseded v1. Still in the design project if a diff is ever needed; duplicating a dead mockup in-tree invites someone building from the wrong one.
- **`DenTime Design System.dc.html`** — 25 KB of inline styles whose value is entirely in the values it encodes. Those are in `design-tokens.md` instead, which is readable in a diff and cannot drift silently from a hand-copied duplicate. The design project stays authoritative for the rendered version.

## Two review findings are still open

These are obligations for the SwiftUI build, not mockup fixes. Both are also listed in [OPEN-QUESTIONS.md](../planning/OPEN-QUESTIONS.md).

1. **Destructive "Remove" has no undo.** The row menu's Remove acts immediately in the mockup. In the real app it should show an undo toast rather than a confirmation dialog — removing someone is low-cost and reversible by re-adding, so a modal is the wrong weight.
2. **Accessibility is unverified.** Keyboard focus rings, VoiceOver labels and live-region announcements cannot be demonstrated in a static HTML mockup. They have to be checked in the SwiftUI build.

A third item is unverifiable by nature: drag-between-packs is a real interaction in the Den tab and cannot be shown in a static mock at all.

## What the mockup already gets right, and must not regress

- **Day-of-week and time on every row.** This is what designs out the wrong-day failure mode, and it is why `TimePeekRow` in `DenTimeCore` carries `weekday`, `weekdaySymbol` and `dayDelta` rather than just an hour and a minute.
- **Times are the visual anchor** — 16px tabular monospaced against 10px meta text. The hierarchy has to survive the Den/Team vocabulary swap without relayout.
- **Status is never colour-only.** Asleep is dimmed, plus a ☾, plus a label — not a hue change on its own.
- **Native controls throughout**: real segmented controls, toggles, a pop-up button, and an alert that asks twice before deleting an account.

## Two things in the design system are stale

The design-system document predates a couple of decisions. Both are called out in `design-tokens.md`, and neither appears in the v2 mockup:

1. An **"Add to Calendar" row mapping to EventKit.** Calendar integration is cut entirely. CI fails the build on `import EventKit`.
2. A **three-tab switcher** reading Roster / Time Peek / Events. There are two tabs — Den and Meetups — and Time Peek is a scrubber inside the Den.

## Rules that outrank the mockup

If a mockup and [DECISIONS.md](../planning/DECISIONS.md) disagree, DECISIONS.md wins. In particular the mockup cannot introduce:

- a meetup title or description field,
- a push invite, notification, or anything that contacts a person who did not enter a code,
- calendar integration or any paywall, trial or upgrade surface,
- copy that says "They can't see you" about blocking. It says "You won't see them."
