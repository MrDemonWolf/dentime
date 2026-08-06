# Decisions

**This document is the source of truth. When any two documents in this repo disagree, this one wins.**

Each entry records what was decided, why, and what it costs. The costs matter as much as the reasons — a decision without a stated price is one nobody can revisit honestly.

All entries accepted **2026-08-05** unless noted otherwise.

---

## 1. CloudKit replaces the entire backend

**Decided:** 2026-08-05

DenTime is Apple-only, forever. CloudKit gives free identity, free storage and free sync with no server to run, no auth code, no secrets and no database limits. It also shortens the App Store privacy label — user data sits in the user's own iCloud — and removes the "backend was in staging during review" rejection risk entirely.

This replaces the earlier Cloudflare Workers + Hono + Drizzle + D1 + Better Auth design outright. That stack is dead; do not reintroduce any part of it.

**Accepted costs:**

- No server-side code means **blocking cannot be enforced server-side** for public profile lookups.
- The schema lives in the CloudKit dashboard rather than in git, with a manual dev→prod promote step.
- Meetup share links have **no rich preview** for people without the app.

---

## 2. $9.99 paid up front. No free tier, no trial, no subscription, no IAP

**Decided:** 2026-08-05

Simplicity. This deletes StoreKit, entitlement checks, paywall screens, Restore Purchases and most of App Store guideline 3.1 from the project before a line of it is written.

**Accepted cost:** everyone who joins a meetup must own the app. DenTime works *inside* a group that has all bought in, not *across* a group where one person owns it. That is deliberate — reach traded for simplicity.

**Note:** a free download that opens onto a paywall is a **2.1 rejection** — Apple treats a non-functional free app as a demo. Paid means paid on the listing; there is no middle ground.

**Why $9.99:** menu bar clocks sell for $0.99–$4. DenTime has sync and a network of people behind it.

---

## 3. Two tabs: Den (default) and Meetups

**Decided:** 2026-08-05

"Find a Time" turned out to be Time Peek under a second name. Time Peek is a scrubber inside the Den tab. One less concept to explain, one less tab to design.

The Den is what opens on launch — not the meeting finder.

---

## 4. Meetups are join-by-code, never invite-by-push

**Decided:** 2026-08-05

A push invite is a channel a stranger holding your friend code can aim at you. Friend codes get shared publicly in Discord and Twitch chat, so that channel would be open by default.

Removing the push removes the abuse vector entirely, matches how people already share Doodle links, and deleted a notification system and an invite state machine from the build.

---

## 5. Meetups have no title and no description field

**Decided:** 2026-08-05

This makes **display names the only user-written text in the entire app**. That single omission collapses the App Store moderation burden from a report queue with a 24-hour SLA down to a Block button.

A meetup renders as "[Host name]'s meetup" plus its date range.

---

## 6. Blocking is client-side filtering, backed by friend-code rotation

**Decided:** 2026-08-05

CloudKit runs no code of yours, so a block cannot be enforced at the storage layer for public profile lookups.

**Mitigations that are real:**

- Rotating your friend code genuinely invalidates the old one.
- Removing someone from a meetup's `CKShare` **is** enforced by CloudKit.

**Copy rule, not negotiable:** the UI says **"You won't see them."** It never says "They can't see you."

**Blast radius if a block leaks:** a display name and a time zone string. There is no messaging in DenTime.

---

## 7. Friend adds are one-way

**Decided:** 2026-08-05

Adding someone to your den does not add you to theirs. No reciprocal request, no accept step, no pending state.

---

## 8. Design for friend groups, market to all three audiences

**Decided:** 2026-08-05

Designing for friends, teams and clients simultaneously makes every screen slightly wrong for everyone. Packs solve it for free: a pack named "Acme Corp" behaves identically to "the boys".

One design language, three landing-page sections.

---

## 9. A Vocabulary setting swaps seven nouns, not the voice

**Decided:** 2026-08-05

Settings → General → **Den (default) / Team**. It swaps Den→Team, Pack→Group, Host→Organizer, Meetup→Meeting, Friend code→Member code, Who's in→Attending, Make a plan→Schedule.

**The voice does not change.** Same verbs, buttons, errors and tone. A work user is not put off by friendly copy — they are put off by screenshotting "your pack" into a client Slack channel. Fix the nouns, leave the voice.

Den mode is the only mode in App Store screenshots.

If this ever needs an eighth noun, that is the signal DenTime has quietly become two products, and the setting should be **cut** rather than extended.

---

## 10. macOS first, alone

**Decided:** 2026-08-05

iOS, iPadOS and watchOS are phase 2. Finish and ship one platform before widening.

**Consequence that cannot be fixed later:** every future platform target must reuse the bundle ID `com.mrdemonwolf.dentime` with **no suffix**. Ship macOS as `.dentime` and iOS as `.dentime.mobile` and they become two separate $9.99 products — Mac buyers pay again on their phone, and Universal Purchase cannot be retrofitted after launch. Only a future watch target gets a suffix, because Apple requires `.watchkitapp`.

---

## 11. RevenueCat is not used, in any version

**Decided:** 2026-08-05

Its value is cross-platform purchase management. DenTime is single-platform by design, and moot anyway now that there is no IAP at all.

---

## 12. No calendar integration

**Decided:** 2026-08-05

Cut for simplicity. It cost two EventKit permissions, purpose strings, a sandbox entitlement, per-calendar toggles, and a privacy claim a reviewer has to take on trust — to save the user about ten seconds.

Busy shading, conflict warnings, "Add to Calendar" and `.ics` export all go with it.

The version worth building later is **shared free/busy**, which is a different product: devices publishing coarse busy blocks so slots show green or red for everyone. Opt-in per pack, busy/free only, never event titles, explicit retention, one-tap purge. Its own release, not a bolt-on. See `SPEC.md`.

---

## 13. Docs on GitHub Pages, no custom domain

**Decided:** 2026-08-06

The docs site is served from `mrdemonwolf.github.io/dentime` and nothing else. No `CNAME`, no DNS to configure, no certificate to renew.

**Accepted cost:** App Store Connect gets `github.io` URLs for the privacy policy and support page rather than a branded domain, and moving hosts later means those links change. Judged not worth the setup and the ongoing DNS dependency.

This supersedes the earlier plan for `dentime.mrdemonwolf.com`, which appears in the archived planning documents.

---

## 14. The Xcode project is generated by XcodeGen

**Decided:** 2026-08-06

`apps/apple/project.yml` is the source of truth; `DenTime.xcodeproj` is generated and gitignored. A `project.yml` diff is reviewable — a `.pbxproj` diff is not, and merge conflicts in one are miserable.

**Accepted cost:** contributors need `brew install xcodegen` before they can open the project.
