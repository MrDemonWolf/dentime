# Design tokens

Extracted from **DenTime Design System v1.0 (Aug 2026)** in the [Claude Design project](https://claude.ai/design/p/642505bd-d89a-4e88-b6c0-6365ef80ebc3).

The design-system HTML itself is **not** copied into this repo. It is a 25 KB document of inline styles whose value is entirely in the values below, and a hand-copied duplicate would drift silently from the original. The design project stays authoritative; this file is the extract worth reading in-tree.

The v2 screen mockup **is** copied, byte for byte, as `DenTime App v2.dc.html`.

> ⚠️ **Two rows in the design system contradict current decisions.** See [Stale in the design system](#stale-in-the-design-system) at the bottom before building from it.

---

## Brand palette

| Name | Hex | Use |
|---|---|---|
| Midnight | `#091533` | Brand anchor, dark surfaces |
| Cerulean | `#0FACED` | **Accent only — never a background** |
| Cornflower | `#6B8BF5` | Secondary accent, links, "maybe" |
| White | `#FFFFFF` | Light surfaces, text on navy |

## Surface ramps

**Dark mode — navy, never grey.**

| Role | Hex |
|---|---|
| Background / panel base | `#091533` |
| Raised / rows | `#0C1B3F` |
| Hover / selected | `#11234B` |
| Controls / wells | `#172B57` |
| Text | `#F2F6FF` |
| Secondary text | `#9FB0D4` |
| Tertiary text | `#5E6F96` |
| Hairline | `rgba(255,255,255,0.08)` |

**Light mode — cool whites, chroma ≤ 0.02.**

| Role | Hex |
|---|---|
| Background / panel base | `#F2F5FB` at 85% blur |
| Raised / rows | `#FFFFFF` |
| Hover / selected | `#E8EDF7` |
| Controls / wells | `#DFE6F3` |
| Text | `#0B1733` |
| Secondary text | `#56648A` |
| Tertiary text | `#8B96B5` |
| Hairline | `rgba(9,21,51,0.10)` |

## Status colours

| State | Dark | Light | Rendering |
|---|---|---|---|
| Awake | `#30D158` | `#248A3D` | — |
| Asleep | `#8FA3CC` | — | Row at **55% opacity + ☾ after the time**. Never hide the row. |
| Winding down | `#FF9F0A` | — | Late evening |
| Error | `#FF453A` | `#D70015` | — |

Status is never colour-only. Asleep is dim **plus** a moon **plus** a label.

## Typography

SF Pro for the interface, with Inter as the off-Mac stand-in. No custom display face.

| Role | Size / weight |
|---|---|
| Window title | 22 / 700 |
| Section header | 15 / 600 |
| Row title — friend name | 13 / 600 |
| Body and controls | 13 / 400 |
| Caption — city, meta, footers | 11 / 400 |

**SF Mono for every clock, offset and code**, with `font-variant-numeric: tabular-nums` so the column never wiggles.

| Element | Treatment |
|---|---|
| Clock | 28 / 500, tabular |
| Offset and day marker | 12, e.g. `+9H / JST · TOMORROW` |
| Friend code | 13, letter-spacing 0.06em, in Cerulean — `DEN·K9WF-7Q2X` |
| Micro-labels | 10, letter-spacing 0.14em, **always uppercase** |

The UI/UX review raised micro-label contrast and size; dark tertiary moved to `#8A8F98`, light to `#6E7480`, and micro-labels went from 9px to 10px. Do not regress that.

## Shape, space and material

**Radii:** panel 14 · sheet 12 · row 8 · control 6 · pill 999 · avatar 50%

**Spacing, on a 4pt grid:** panel inset 12 · row padding 8×10 · row height 44 · gap 8 · footer 36

**Material:** panel is vibrancy blur 30px at 85% tint. No drop-shadow cards — hairlines only. Flat navy, never gradients.

## Controls

- **Primary button** — Cerulean fill, `#051A38` label on dark / `#04263B` on light, radius 6, padding 6×14
- **Secondary button** — surface fill with a hairline border, radius 6
- **Tertiary button** — no fill, Cerulean label on dark / `#0A88BC` on light
- **Segmented control** — well at the darkest surface, selected segment raised with a 1px shadow
- **Toggle** — 38×22, radius 11, accent fill when on, white knob
- **Text field** — mono, letter-spacing 0.05em, radius 6. Error state uses the error colour on the border plus a message below

Error copy from the design system, worth keeping verbatim:

> That code doesn't look right — it should be 8 characters.

## Friend row anatomy

```
[avatar 28×28, 50%]  Name          13/600      23:32        mono 15/500 tabular
                     Berlin · CET  11          WINDING DOWN mono 9, tracked
```

Avatars are initials on muted tints — no photos required, which is also why there is no image moderation problem.

**Badges:** `TODAY`, `+1 TOMORROW`, `−1 YESTERDAY` as mono pills. Tally pills read `✓ 4 yes`, `? 2 maybe`, `Awaiting 3`.

## SwiftUI mapping

| Piece | Approach |
|---|---|
| App shell | `MenuBarExtra(.window)` + `.menuBarExtraStyle(.window)`, `LSUIElement = YES` |
| Panel material | `.background(.ultraThinMaterial)` — vibrancy for free, adapts light/dark |
| Colours | Asset catalog Color Sets with Any/Dark pairs from the ramps above. **Never hard-code hex in views.** Accent is `Color("Cerulean")` |
| Tab switcher | `Picker(selection:)` with `.pickerStyle(.segmented)` |
| Roster list | `ScrollView` + `LazyVStack` of `HStack` rows; times use `.monospacedDigit()` and `.fontDesign(.monospaced)` |
| Time Peek scrubber | `Slider` over a `Canvas` tick ruler, plus `DatePicker(.compact)` for precision |
| Toggles | `Toggle(.switch)`; times via `DatePicker(displayedComponents: .hourAndMinute)` |
| Add friend sheet | `.sheet { Form }` with a `TextField` auto-formatting to `DEN·XXXX-XXXX` on change |
| Settings window | `Settings` scene + `TabView`, `Form` with `.formStyle(.grouped)` |
| Icons | SF Symbols only: `moon.fill`, `gearshape`, `plus`, `person.crop.circle`, `pawprint.fill` as the menu bar template image |

**The rule:** define every colour once as a semantic Color Set. Light and dark then follow the system with no per-view branching.

## Voice

| Yes | No |
|---|---|
| "Your pack, at a glance." | ~~"Team member overview dashboard"~~ |
| "Moss is asleep — try after 09:00 their time." | ~~"User unavailable in current time window"~~ |
| "No events yet. Pin a time for the pack." | ~~"Empty state: 0 records found"~~ |

Casual, warm, short. Pack and den words where natural, never forced. Sentence case everywhere except mono micro-labels.

Note that the third example uses "events" — the current name for that concept is **meetup**. See the language table in [`CLAUDE.md`](../../CLAUDE.md).

---

## Stale in the design system

Two things in the source document predate current decisions and **must not be built**:

1. **An "Add to Calendar" row mapping to EventKit.** Calendar integration is cut entirely — no EventKit, no write-only access, no `.ics`. See [DECISIONS.md](../planning/DECISIONS.md), decision 12. CI fails the build on `import EventKit`.
2. **A three-tab switcher reading Roster / Time Peek / Events.** There are **two** tabs: Den and Meetups. Time Peek is a scrubber inside the Den, not a tab. See DECISIONS.md, decision 3.

The v2 mockup is newer than the design system document and does not carry either mistake. Where the two disagree, the v2 mockup wins — and where the v2 mockup and DECISIONS.md disagree, DECISIONS.md wins.
