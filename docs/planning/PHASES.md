# Phases

Twelve phases, ~66 hours of build time. Short sections, real estimates, tick things off.

**Nothing is blocked on design any more.** The v2 mockup landed and was reviewed on 2026-08-05 — it lives in [`docs/design`](../design/README.md). Phases 7, 8 and 10 were previously marked "blocked on mockups"; they are now design-ready.

---

## 📊 At a glance

| # | Phase | Est. | Status |
|---|---|---|---|
| 1 | Repo scaffold, CI, docs site skeleton | 4h | ✅ done |
| 2 | CloudKit container, schema in dashboard, indexes | 3h | ⬜ |
| 3 | `DenTimeCore` — models, `FriendCode`, `TimePeek` + tests | 6h | ✅ done |
| 4 | Sign in with Apple + CloudKit account status | 4h | ⬜ |
| 5 | `UserProfile` create, publish, friend-code lookup | 4h | ⬜ |
| 6 | Roster + packs — private DB CRUD | 6h | ⬜ |
| 7 | Den tab UI | 8h | ⬜ |
| 8 | Time Peek scrubber UI | 4h | ⬜ |
| 9 | Meetups — `CKShare` create, join, RSVP | 8h | ⬜ |
| 10 | Meetups UI, including the host results view | 8h | ⬜ |
| 11 | Settings, Block, Report, Delete account, Rotate code | 6h | ⬜ |
| 12 | App Store prep — demo data, screenshots, reviewer notes | 5h | ⬜ |

**Start next:** phase 2. It is three hours of dashboard clicking that everything from phase 4 onward depends on, and it cannot be automated.

---

## 🧱 Phase 1 — Repo scaffold ✅

**4h · done 2026-08-06**

- [x] Bun workspaces + Turborepo, Biome, pinned toolchain
- [x] `packages/DenTimeCore` Swift package
- [x] `apps/apple` XcodeGen project, macOS target
- [x] `apps/docs` Fumadocs site with placeholder pages
- [x] CI, docs deploy, Dependabot, issue and PR templates
- [x] Planning docs committed in-tree

---

## ☁️ Phase 2 — CloudKit container and schema

**3h · no design dependency · do this next**

All of this is done by hand in the CloudKit dashboard. Follow [CLOUDKIT-SCHEMA.md](CLOUDKIT-SCHEMA.md) field for field.

- [ ] Create container `iCloud.com.mrdemonwolf.dentime`
- [ ] Public: `UserProfile` with its four fields
- [ ] **Mark `UserProfile.friendCode` queryable and add its index** — the one that fails silently in production if you forget
- [ ] Private: `Pack`, `RosterEntry`, `Block`, `Settings`
- [ ] Shared: `Meetup`, `MeetupSlot`, `MeetupResponse`
- [ ] Repeat every index in the production environment, not just development
- [ ] Write down what you clicked — there is no migration file to read later

☕ **Break point.** This phase is tedious and error-prone. Do it in one sitting while you still have the schema in your head.

---

## 🧮 Phase 3 — DenTimeCore ✅

**6h · done 2026-08-06**

- [x] Models: `Profile`, `Pack`, `RosterEntry`, `Meetup`, `MeetupSlot`, `MeetupResponse`, `Block`, `Settings`
- [x] `FriendCode` and `JoinCode` — Crockford base32, parse, format, validate, with tests
- [x] `TimeZoneResolver` and `TimePeek` — pure functions, with DST tests that lean on the transitions hard
- [x] `Vocabulary` — the seven nouns
- [x] CloudKit store protocols, bodies still `fatalError("unimplemented")`

---

## 🔑 Phase 4 — Sign in with Apple + account status

**4h · no design dependency**

- [ ] Sign in with Apple, the only sign-in method
- [ ] Implement `CloudAccountObserving` against `CKContainer.accountStatus`
- [ ] Handle every case: no account, restricted, could-not-determine, temporarily unavailable
- [ ] A signed-out state that explains itself instead of showing an empty den

⚠️ Most people hitting a broken DenTime will be hitting a signed-out iCloud, not a bug. Spend the time on those messages.

---

## 👤 Phase 5 — UserProfile

**4h · no design dependency**

- [ ] Create and publish the signed-in user's public profile
- [ ] `lookup(friendCode:)` — verify the index from phase 2 actually works
- [ ] Rotate friend code, and confirm the old one stops resolving
- [ ] Delete own profile

---

## 🏠 Phase 6 — Roster and packs

**6h · no design dependency**

- [ ] Private DB CRUD for `Pack`, `RosterEntry`, `Block`, `Settings`
- [ ] Reorder, and move entries between packs
- [ ] Add by friend code, and add manually
- [ ] Block and unblock, filtering applied client-side

---

## 🖥️ Phase 7 — Den tab UI

**8h · design-ready — build against `DenTime App v2.dc.html`**

- [ ] Person rows with avatar, name, local time, zone, day of week
- [ ] Collapsible packs, drag between them
- [ ] Row `…` menu: Edit / Block / Remove
- [ ] **Remove uses an undo toast, not a confirmation** — open review finding
- [ ] Asleep state: dimmed + ☾ + label, never colour alone
- [ ] Empty state that gives you something to do

---

## 🎚️ Phase 8 — Time Peek scrubber

**4h · design-ready**

- [ ] Scrubber at the top of the Den, ±12h
- [ ] Every row re-renders live while dragging
- [ ] Day-delta indicator when a zone rolls into a different calendar day
- [ ] Keyboard support, and something that tells the user it exists — open review finding
- [ ] Reset-to-now affordance

`TimePeek` already does the maths. This phase is the control and the wiring.

---

## 🤝 Phase 9 — Meetups back end

**8h · no design dependency**

- [ ] Create a meetup with 2–5 slots, wrapped in a `CKShare`
- [ ] Join by code
- [ ] RSVP yes / no / maybe, and change your mind
- [ ] Leave; host removes a participant
- [ ] Rotate and disable the join code
- [ ] Close and settle

---

## 📋 Phase 10 — Meetups UI

**8h · design-ready**

- [ ] Meetup list, rendered as "[Host]'s meetup" plus date range
- [ ] Slot creation, 2–5, each in the host's own zone
- [ ] Join-by-code entry with a real error for a bad code
- [ ] RSVP controls, cyan for the selected segment
- [ ] **Host results view** — this is the hard one. Six participants × five slots does not fit as a literal grid at 360pt. See [OPEN-QUESTIONS.md](OPEN-QUESTIONS.md)
- [ ] "Who's in" list with `…` → Block

---

## ⚙️ Phase 11 — Settings, safety, account

**6h · no design dependency**

- [ ] Settings window on ⌘, — General, Account, Blocked, About
- [ ] Vocabulary segmented control with a live preview line
- [ ] Launch at login, time format, menu bar icon
- [ ] Friend code with Rotate
- [ ] **Delete account** — public profile + private zone + every owned share. Guideline 5.1.1(v), auto-reject if missing
- [ ] **Report** — one menu item opening a prefilled email. 15 minutes, and it satisfies the report requirement
- [ ] Blocked list with unblock

---

## 🚀 Phase 12 — App Store prep

**5h**

- [ ] Seeded demo account and reviewer notes — **do this first, not last**
- [ ] Screenshots, Den mode only
- [ ] Privacy nutrition label
- [ ] App Store Connect: $9.99, Universal Purchase, Family Sharing
- [ ] Real privacy policy and support pages, replacing the placeholders
- [ ] Run the `app-store-review-audit` skill

Full checklist in [APPLE.md](APPLE.md).

---

## 🧭 If you have an hour and no plan

Phase 2 in three sittings, or the Report menu item from phase 11 — that one is genuinely fifteen minutes and removes a submission blocker.
