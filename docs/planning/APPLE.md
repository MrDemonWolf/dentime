# App Store readiness

Seven things must exist before submission. None of them is architectural — roughly a day of work in total.

---

## The seven

- [ ] **Delete account, in the app.** Guideline 5.1.1(v) — **auto-reject if missing.** Settings → Account, two taps deep. Must purge the public `UserProfile`, the private zone, *and* every share the user owns. All three, or the account is only partly gone. **~2h**

- [ ] **Bundle ID identical across every platform target.** Universal Purchase. `com.mrdemonwolf.dentime`, no suffix, on macOS, iOS and iPadOS; only a future watch target gets `.watchkitapp` because Apple requires it. **~5 min now, unfixable after launch.** Turn on Family Sharing while you are in there.

- [ ] **Block, on roster rows and on meetup participant rows.** Guideline 1.2, triggered by display names being user-written content shown to other people. Copy says "You won't see them" — **never** "They can't see you", because that would not be true. **~3h**

- [ ] **Report — one menu item opening a prefilled email.** Satisfies "a mechanism to report offensive content". **~15 min.** Cheapest item on this list; do it early.

- [ ] **Privacy policy and support pages live and returning 200.** Both get opened by the reviewer. The support page carries contact details and a commitment to act on reports within 24 hours. Currently placeholders at `/docs/privacy` and `/docs/support`. **~2h**

- [ ] **Seeded demo account and reviewer notes.** **Do this early — it defuses three separate rejection risks at once.** A reviewer who opens DenTime and lands in a populated den with a live meetup never wonders whether this is "just a world clock". **~2h**

- [ ] **App Store Connect configuration.** $9.99, Universal Purchase enabled, Family Sharing on, privacy nutrition label filled in, screenshots in Den mode only. Check the app name against existing listings, and **do not lead the title with "Meetups"** — Meetup.com holds that trademark.

---

## URLs the reviewer will open

There is no custom domain. These are the real, final URLs:

| Purpose | URL |
|---|---|
| Privacy policy | `https://mrdemonwolf.github.io/dentime/docs/privacy/` |
| Support | `https://mrdemonwolf.github.io/dentime/docs/support/` |

Both must return 200 before submission. Both are placeholders right now.

---

## Already handled by design — eight problems that no longer exist

1. **No calendar permissions at all.** No EventKit, no purpose strings, no per-calendar toggles, nothing for a reviewer to take on trust.
2. **Sign in with Apple is the only sign-in method**, which by itself satisfies guideline 4.8.
3. **Join-by-code means no unsolicited contact.** Nobody can reach you without you typing their code.
4. **No free-text meetup titles**, so display names are the only user-written content in the app.
5. **Paid up front**, so most of guideline 3.1 barely applies.
6. **No tracking SDKs**, so no ATT prompt.
7. **CloudKit means minimal data collection** and a short, honest nutrition label — the data is in the user's own iCloud.
8. **Submitted by MrDemonWolf, Inc.**, not a personal account.

---

## Watch for

**Guideline 4.2, minimum functionality.** A paid menu bar app has to justify itself immediately, and there is no free mode to soften the first impression. The seeded demo account and the reviewer notes are the entire mitigation — a reviewer who sees an empty den and a scrubber has been handed a world clock.

**Guideline 2.1, free app that is really a demo.** Not applicable here *because* the app is paid on the listing. It becomes applicable the moment anyone suggests a free download with a paywall behind it. Don't.

**The privacy nutrition label must match reality.** Data is stored in the user's iCloud, not collected by MrDemonWolf, Inc. `PrivacyInfo.xcprivacy` declares no tracking, no collected data types, and UserDefaults access with reason code `CA92.1`.

---

## Run the audit twice

Run the `app-store-review-audit` skill:

1. After the first TestFlight build.
2. Again on the day of submission.

The second run catches things that drifted in during the last week of changes, which is exactly when they drift in.
