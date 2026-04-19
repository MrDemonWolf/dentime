# 🐺 DenTime — Hackathon Scope (MVP1)

> **You are here.** This doc tells you what we're building. Read it once. Check back when lost.

---

## 🎯 What DenTime is

A menu bar app for macOS (MVP1 hackathon) + iPhone (MVP2 follow-up) that tells you **what time it is right now for everyone in your pack**, and helps you **find the best time to meet** across timezones.

## 🎁 Who it's for

You. Your furry friends scattered across the globe. Your remote-work clients. Anyone who's ever typed "lemme check" before scheduling anything.

---

## 🟢 What ships in MVP1 (this hackathon)

### The macOS app does 3 things:

1. **Roster tab (DEFAULT).** Menu bar → click → see everyone grouped. Current time per person. Auto-refresh every 30s. Click a row → copy "It's 3:42 PM Fri for Alex" to clipboard.

2. **Find a Time tab.** Pick a date+time in your zone → instantly see it in every friend's zone. Green = working hours. Yellow = edges. Red = sleep. Copy the whole summary as one line for Discord/Slack.

3. **Settings.** 12h/24h, working hours, refresh rate, launch-at-login, quit.

### The docs site does 3 things:

Lives at **`mrdemonwolf.github.io/dentime`** (static, GitHub Pages, free).

1. **Landing page** — hero, features, screenshots, "coming soon to App Store" CTA
2. **Docs** — how to use the app
3. **Legal** — `/legal/terms` and `/legal/privacy`

---

## 🔴 What does NOT ship in MVP1

If you catch yourself building any of these, stop and push it to MVP2:

- ❌ Any backend at all (no API, no D1, no Workers)
- ❌ Any authentication (no Apple Sign In)
- ❌ Friend codes / sharing
- ❌ Cross-device sync
- ❌ iPhone app (stub folder only)
- ❌ Meetups / Doodle polls
- ❌ iCal / .ics export
- ❌ Apple Calendar integration
- ❌ Paywall / subscriptions
- ❌ Sparkle auto-updates
- ❌ Deep links (`dentime://…`)

See `CC-MVP2.md` for all of these.

---

## 🧩 Brain dump: how the roster view looks

```
┌──────────────────────────────────┐
│ DenTime                  ⚙  ✕    │
├──────────────────────────────────┤
│ [ Now ]  Find a Time             │
├──────────────────────────────────┤
│ 👥 Pack                          │
│  Alex (Berlin)   10:42 PM  +5h   │
│  Sam (Tokyo)     6:42 AM  +13h   │
│                                  │
│ 💼 Work                          │
│  Jordan (Seattle) 1:42 PM  -2h   │
│  Riley (London)   9:42 PM  +6h   │
│                                  │
│ ⌂ You (Chicago)   3:42 PM        │
├──────────────────────────────────┤
│ + Add friend    ↕ Edit           │
└──────────────────────────────────┘
```

- Groups are user-defined. Ungrouped friends show under "Friends" at top.
- Delta column (+5h, -2h) is hours ahead/behind YOUR zone.
- Click a row → copy "It's 10:42 PM Fri for Alex in Berlin."
- Right-click → Edit / Move to group / Delete.

---

## 🎨 Brand

- **Navy** `#091533` — backgrounds, dark surfaces
- **Cyan** `#0FACED` — accents, buttons, highlights
- **Marks** — `assets/logo.svg` (color) · `assets/logo-mono.svg` (menu bar)

---

## 🛠 Tech (the non-negotiables)

### macOS app
- Swift 5.9+, SwiftUI only
- macOS 13+ (needs `MenuBarExtra`)
- No dependencies (Foundation + SwiftUI)
- Storage: UserDefaults, JSON-encoded
- Bundle: `com.mrdemonwolf.dentime`

### Docs site
- Fumadocs + Next.js 15 (static export)
- TypeScript strict
- Tailwind
- Deployed via GitHub Actions → `gh-pages` branch
- No backend, no server

---

## ✅ MVP1 Definition of Done

You know MVP1 is done when:

- [ ] I can open the menu bar app and see a friend I added yesterday
- [ ] Clicking their name copies a time-string to my clipboard
- [ ] I can group friends into buckets (Work, Pack, Family, etc.)
- [ ] "Find a Time" shows me what 3pm Chicago is in Berlin
- [ ] `mrdemonwolf.github.io/dentime` loads and has TOS + Privacy
- [ ] The Xcode archive passes App Store validation (Sandbox + Hardened Runtime + Privacy Manifest all green)
- [ ] I've pushed everything to `github.com/MrDemonWolf/dentime` and solo-main protection is enabled

That's it. Don't let yourself add "one more thing." Ship.
