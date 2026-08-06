# UI/UX Review: DenTime App v2 (macOS menu bar mockup)

**Reviewed:** 2026-08-05 · **Input:** local code (`DenTime App v2.dc.html`) · **Method:** NN/g heuristic evaluation + guideline review

## Executive summary
- Overall: strong native-macOS feel, unambiguous times (day-of-week everywhere), clean information hierarchy. No catastrophic findings.
- Worst problem: tertiary micro-labels were low-contrast AND tiny (9px `#62666D` on `#191A1D` ≈ 3.0:1 — fails WCAG AA 4.5:1 for small text).
- Two brief-required interactions were missing: the row `…` menu (Edit / Block / Remove) and the participant list with Block in meetup detail.

**Findings:** 🟥 0 catastrophic · 🟧 2 major · 🟨 3 minor · ⬜ 1 cosmetic

## Findings

### 🟧 Severity 3 — Major
#### 1. Micro-labels fail contrast and minimum legible size
- **What:** 9px mono labels (`OFFSET`, `NIGHT ☾`, pack headers, footer code) in `#62666D` on `#191A1D` ≈ **3.0:1**; light mode `#9AA0AE` on `#F6F6F8` ≈ **2.6:1**. Both below 4.5:1 for small text.
- **Where:** every person row meta line, scrubber header, section labels, footer.
- **Guideline:** Legibility — tiny, low-contrast text is illegible and undiscoverable.
- **Evidence:** [Low-Contrast Text Is Not the Answer](https://www.nngroup.com/articles/low-contrast/) — low-contrast text degrades legibility and discoverability; [Legibility, Readability, and Comprehension](https://www.nngroup.com/articles/legibility-readability-comprehension/) — tiny text dooms legibility.
- **Fix:**
  - [x] Dark tertiary `#62666D` → `#8A8F98` (≈5.2:1); light `#9AA0AE` → `#6E7480` (≈4.6:1)
  - [x] Micro-labels 9px → 10px

#### 2. Block/Remove actions missing where the brief requires them
- **What:** No `…` menu on den rows and no participant list with Block in meetup detail — users have no path to block from where the harassment is visible (blocked list existed only in Settings).
- **Where:** Den rows; meetup detail (participant view).
- **Guideline:** User control and freedom; match between system and real-world workflows.
- **Evidence:** [10 Usability Heuristics](https://www.nngroup.com/articles/ten-usability-heuristics/) — support user control where the need arises.
- **Fix:**
  - [x] `…` on each den row → Edit / Block / Remove menu (Block feeds Settings › Blocked)
  - [x] "Who's in" list with `…` → Block on participant view

### 🟨 Severity 2 — Minor
#### 3. RSVP selected state diverges from brief
- **What:** Yes/No/Maybe selected fills were green/red/amber; brief specifies cyan for the selected state (accent = selection).
- **Fix:** [x] Selected segment now cyan for all three; the tally bar keeps semantic colors.

#### 4. Footer icon buttons under comfortable target size
- **What:** `+` and gear were 24×24px. Pointer-first is fine (WCAG 2.5.8 minimum is 24px) but comfort guidance is higher.
- **Evidence:** [Touch Targets on Touchscreens](https://www.nngroup.com/articles/touch-target-size/) — minimum ~1cm targets for fast, accurate selection (and the iPad port shares this codebase).
- **Fix:** [x] Bumped to 28×28px with unchanged icon size.

#### 5. Destructive "Remove" has no confirmation or undo
- **What:** Row menu Remove acts immediately.
- **Guideline:** Error prevention / user control.
- **Fix:** [ ] In production, use an undo toast rather than a confirm (removal is low-cost, reversible via re-add). Noted for the SwiftUI build; mockup acts immediately.

### ⬜ Severity 1 — Cosmetic
#### 6. Scrubber has no keyboard hint
- Arrow keys work on the range input, but nothing communicates it. Consider a one-time tooltip in production.

## Unverified (needs a different input)
- Keyboard focus rings, VoiceOver labels, live-region announcements — mockup-level HTML; verify in the SwiftUI build.
- Drag-between-packs (brief §1) — not implementable in a static mock; flagged for the real app.

## What's working well
- Day-of-week + time everywhere (constraint 3) — the wrong-day failure mode is designed out.
- Times are the visual anchor: 16px tabular mono against 10px meta; hierarchy survives the vocabulary swap.
- Native conventions: real segmented controls, toggles, pop-up button, alert-asks-twice for account deletion.
- Status is never color-only: asleep = dim + ☾ + label, not just a hue change.

## Quick wins
- [x] All applied in this pass (findings 1–4).
