# 🐺 START HERE — DenTime Quick-Start

> **If you're lost, read this.** Everything you need, in order.

---

## 📋 What's in this package

```
dentime-hackathon.zip
├── START_HERE.md      ← you are here
├── HACKATON.md        ← what we're building
├── TODO.md            ← your manual checklist
├── CC-MVP1.md         ← Claude Code prompt (hackathon)
├── CC-MVP2.md         ← Claude Code prompt (future)
└── assets/
    ├── logo.svg       ← color paw tick
    └── logo-mono.svg  ← monochrome (menu bar)
```

---

## 🏃 The 5-minute version

1. Unzip this into a new folder.
2. Read `HACKATON.md` so you know what's getting built.
3. Open `TODO.md` and work **Section 1** (create the GitHub repo).
4. Keep going through `TODO.md` **in order**. Don't skip around.
5. When you hit `TODO.md` **Section 6** — that's where Claude Code takes over.

---

## 🎯 Run order (explicit steps)

### Today — setup (≈ 30 min)

```bash
# 1. Create the repo on github.com/new (Public, name: dentime)

# 2. Clone and move into it
cd ~/Code
git clone https://github.com/MrDemonWolf/dentime.git
cd dentime

# 3. Drop these files into the repo
#    (HACKATON.md, TODO.md, CC-MVP1.md, CC-MVP2.md go in root)
#    (logo.svg + logo-mono.svg go in assets/)

mkdir -p apps/macOS apps/iOS apps/docs assets
touch apps/macOS/.gitkeep apps/iOS/.gitkeep apps/docs/.gitkeep
# ... then copy files in ...

# 4. First commit
git add .
git commit -m "chore: hackathon planning docs + brand marks"
git push
```

### Today — Apple Developer (≈ 10 min)

Do `TODO.md` **Section 2** — register the App ID and App Store Connect record.

### Today — reference repo (≈ 1 min)

```bash
cd ~/Code
git clone https://github.com/MrDemonWolf/fangdash.git
```

Claude Code will read this for monorepo patterns. Without it, MVP1 Phase 1 will stall.

### When ready to build — hackathon session (≈ 2-6 hr)

```bash
cd ~/Code/dentime
claude
```

Paste this exact message to start:

> Read the file `CC-MVP1.md` and work through every phase. Use your todo list to track phases. Pause after each phase so I can verify it builds before you continue. Fangdash is at `~/Code/fangdash` — use its patterns. My Cloudflare Workers subdomain is `mrdemonwolf`.

Claude Code will:
- Phase 1-15: scaffold macOS app + Xcode project
- Phase 16-24: scaffold Fumadocs docs site + GitHub Pages deploy
- Phase 25-29: repo hygiene + GitHub description/topics + solo-main protection

**Your job during the build:**
- After each phase, verify (open Xcode, hit `⌘B`, confirm it builds; check the docs site in a local `bun dev`)
- If something's wrong, tell Claude Code to fix it
- If it tries to build MVP2 features, stop it: "That's out of scope for MVP1, skip."

### After Claude Code finishes MVP1

1. Open Xcode → DenTime target → Signing & Capabilities → confirm Team is MrDemonWolf, Inc.
2. Go to `github.com/MrDemonWolf/dentime/settings/pages` → Source: **GitHub Actions**
3. Wait ~3 minutes for GitHub Actions to deploy the docs
4. Visit `https://mrdemonwolf.github.io/dentime` — should load
5. Back in Xcode: Product → Archive → Validate App → make sure it passes

**🎉 MVP1 shipped.** Submit to App Store when ready.

### Later — MVP2 session

**Do not start MVP2 until MVP1 is in App Store review or approved.**

```bash
cd ~/Code/dentime
claude
```

Paste:

> Read `CC-MVP2.md` and work through every phase. Use your todo list. Pause between phases. Fangdash at `~/Code/fangdash` — use its Better Auth + Hono + monorepo patterns as reference.

---

## 💰 Pricing (locked in)

- **Monthly:** $1.99 USD
- **Yearly:** $16.99 USD (saves 29%)
- **Free trial:** 14 days
- **MVP1 is free.** Paywall only activates in MVP2 when sync + meetups ship.

Free tier (MVP2+): roster, find-a-time, sign-in, sync, up to 3 groups
Premium tier: meetups, iCal export, calendar integration, unlimited groups

---

## 🧭 If you get lost

| Problem | Where to look |
|---|---|
| What are we building? | `HACKATON.md` |
| What's my next step? | `TODO.md` (it's checked and numbered) |
| Claude Code is going off-script | Tell it: "Stop. That's MVP2. Skip it and continue." |
| Build fails | Paste the error to Claude Code: "Build fails with: [error]. Fix it." |
| Overwhelmed | Close the laptop. Walk. Come back in an hour. |

---

## 🐾 Notes from me (Claude)

- **Don't add features mid-hackathon.** Write them down for MVP2 and keep shipping.
- **Solo-main protection is important** — it prevents you from force-pushing to main and losing history when you're tired. Claude Code runs the skill in Phase 29.
- **Fangdash is the blueprint.** When Claude Code looks confused about monorepo setup, remind it: "Check fangdash's pattern."
- **Pricing on $1.99/$16.99 is aggressive-but-fair.** Lower than market, but enough to cover Cloudflare Workers at scale. If adoption is slower than expected, raise to $2.99/$24.99 for new subs in ~6 months (grandfather existing subs).

Now close this file and open `HACKATON.md`. 🚀
