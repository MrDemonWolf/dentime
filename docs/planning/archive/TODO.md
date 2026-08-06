# 🐾 DenTime — Your TODO List

> **Do these in order. Don't skip around.** Each step has a time estimate and a "you'll know it worked when…" so you can verify before moving on.

---

## 🧭 How this works

- Steps are numbered. Do them **top to bottom**.
- ⏱ = time estimate
- ✅ = how to verify you finished
- 🚨 = don't skip this
- 💡 = optional optimization

When you finish a section, check it off. **Don't start the next one until the current one is ✅.**

---

## Section 1 — GitHub repo setup

### Step 1.1 — Create the empty repo ⏱ 2 min

- [ ] Go to https://github.com/new
- [ ] Owner: `MrDemonWolf`
- [ ] Repo name: `dentime`
- [ ] Description: `Menu bar app for finding the best time to meet across timezones. macOS + iOS.`
- [ ] Visibility: **Public**
- [ ] Do NOT add README, .gitignore, or license (we'll let Claude Code do that)
- [ ] Click "Create repository"

✅ **Verify:** `github.com/MrDemonWolf/dentime` loads and says "Quick setup".

### Step 1.2 — Clone it locally ⏱ 1 min

```bash
cd ~/Code   # or wherever you keep projects
git clone https://github.com/MrDemonWolf/dentime.git
cd dentime
```

✅ **Verify:** `ls` shows an empty folder (only `.git/`).

### Step 1.3 — Drop in the planning files ⏱ 2 min

From the zip I gave you, copy these files into the repo:

```
dentime/
├── HACKATON.md       ← this file
├── TODO.md           ← that file
├── CC-MVP1.md        ← Claude Code prompt for MVP1
├── CC-MVP2.md        ← Claude Code prompt for MVP2
└── assets/
    ├── logo.svg
    └── logo-mono.svg
```

Create the empty folders Claude Code will fill later:

```bash
mkdir -p apps/macOS apps/iOS apps/docs assets
touch apps/macOS/.gitkeep apps/iOS/.gitkeep apps/docs/.gitkeep
```

✅ **Verify:** `tree -L 2` (or `ls apps/`) shows the structure above.

### Step 1.4 — First commit ⏱ 1 min

```bash
git add .
git commit -m "chore: hackathon planning docs + brand marks"
git push
```

✅ **Verify:** `github.com/MrDemonWolf/dentime` now shows your files.

---

## Section 2 — Apple Developer

> 🚨 **Do this before running Claude Code.** Otherwise Xcode will break halfway through.

### Step 2.1 — Create the App ID ⏱ 3 min

- [ ] Go to https://developer.apple.com/account/resources/identifiers/list
- [ ] Click `+` → **App IDs** → Continue → **App** → Continue
- [ ] Description: `DenTime`
- [ ] Bundle ID: **Explicit** → `com.mrdemonwolf.dentime`
- [ ] Capabilities: leave **everything OFF** (MVP1 doesn't need anything — MVP2 will turn on Sign in with Apple)
- [ ] Continue → Register

✅ **Verify:** `com.mrdemonwolf.dentime` shows in your App IDs list.

### Step 2.2 — Create App Store Connect record ⏱ 4 min

- [ ] Go to https://appstoreconnect.apple.com/apps
- [ ] `+` → New App
- [ ] **Check BOTH platforms: iOS AND macOS** 🚨 (this is how you get one app covering both — skip this and you'll have to register twice)
- [ ] Name: `DenTime`
- [ ] Primary Language: English (U.S.)
- [ ] Bundle ID: pick `com.mrdemonwolf.dentime` from dropdown
- [ ] SKU: `DENTIME001`
- [ ] User Access: Full Access
- [ ] Create

✅ **Verify:** `DenTime` shows in App Store Connect, and clicking it shows tabs for both "iOS App" and "Mac App".

### Step 2.3 — Xcode signing (do after Claude Code runs Phase 1) ⏱ 2 min

After Claude Code creates the Xcode project, open it and:

- [ ] Select the DenTime target → Signing & Capabilities
- [ ] Check "Automatically manage signing"
- [ ] Team: **MrDemonWolf, Inc.**

✅ **Verify:** No red errors in the Signing tab. Build succeeds (`⌘B`).

---

## Section 3 — Cloudflare (MVP2 prep, but do now so it's ready)

> 💡 **You can skip this if you're not touching MVP2 yet.** But doing it now means Claude Code can test-deploy the worker when you hit MVP2 Phase 1.

### Step 3.1 — Confirm account subdomain ⏱ 1 min

- [ ] Log into https://dash.cloudflare.com
- [ ] Workers & Pages → Overview
- [ ] Your worker URL will be `<worker-name>.<your-subdomain>.workers.dev`
- [ ] **Write down your subdomain.** It should be `mrdemonwolf` (so DenTime's worker will be at `dentime.mrdemonwolf.workers.dev`).

✅ **Verify:** You know your Cloudflare Workers subdomain.

---

## Section 4 — Clone fangdash for reference ⏱ 1 min

Claude Code will want to read fangdash to copy the Better Auth + Hono monorepo patterns.

```bash
cd ~/Code
git clone https://github.com/MrDemonWolf/fangdash.git
```

✅ **Verify:** `~/Code/fangdash/apps/api/` exists.

---

## Section 5 — Install Claude Code CLI (if you haven't) ⏱ 3 min

```bash
npm install -g @anthropic-ai/claude-code
claude --version
```

✅ **Verify:** Version prints without error.

> If `claude` command not found after install, check your npm global bin path is in `$PATH`.

---

## Section 6 — 🚀 Run Claude Code for MVP1

This is the moment. Deep breath.

### Step 6.1 — Open Claude Code in the repo ⏱ 30 sec

```bash
cd ~/Code/dentime
claude
```

✅ **Verify:** You see the Claude Code prompt.

### Step 6.2 — Give it the plan ⏱ 30 sec

Paste this exact message:

> Read the file `CC-MVP1.md` and work through every phase. Use your todo list to track phases. Pause after each phase so I can verify it builds/runs before you continue. Fangdash is at `~/Code/fangdash` if you need to reference patterns. My Cloudflare subdomain is `mrdemonwolf` (not needed for MVP1, but mentioning for Phase 17+ context).

✅ **Verify:** Claude Code starts reading `CC-MVP1.md` and creates its todo list.

### Step 6.3 — Let it cook ⏱ 2-6 hours

- Claude Code will work through phases and pause between them.
- After each phase: read what it did, verify it builds (for Xcode phases, open Xcode and hit `⌘B`), say "continue" or correct it.
- If it goes off-script, interrupt and say "stop — that's MVP2, skip it."

✅ **Verify per phase:** Each `[ ]` in Claude Code's todo list becomes `[x]`.

### Step 6.4 — After final commit, run solo-main protection ⏱ 1 min

Once Claude Code says MVP1 is done and has committed + pushed everything, ask it:

> Use the `gh-solo-main-protection` skill to set up branch protection on this repo.

✅ **Verify:** `github.com/MrDemonWolf/dentime/settings/rules` shows the Solo Main Protection ruleset is active.

---

## Section 7 — Post-MVP1 wrap-up

### Step 7.1 — Verify the docs site deployed ⏱ 2 min

- [ ] Wait ~3 min after push for GitHub Actions to finish
- [ ] Go to `https://mrdemonwolf.github.io/dentime`

✅ **Verify:** Landing page loads with paw tick logo.

If it doesn't:

- Check `github.com/MrDemonWolf/dentime/actions` for the deploy workflow status
- Check `github.com/MrDemonWolf/dentime/settings/pages` — Source should be "GitHub Actions"

### Step 7.2 — Test the Xcode archive ⏱ 10 min

In Xcode:

- [ ] Product → Archive
- [ ] Wait for build
- [ ] Window that pops up → Validate App
- [ ] Pick your team, automatic signing → Next
- [ ] Let it upload and validate

✅ **Verify:** "App validated successfully" message.

If validation fails, the error will tell you what's missing (usually a Privacy Manifest field or an icon size).

### Step 7.3 — Jira setup (optional, do whenever) ⏱ 5 min

Want me to create this for you via the Atlassian connector? Just say **"create the Jira project for DenTime"** in chat.

Otherwise, manual:

- [ ] Atlassian → Projects → Create → Kanban
- [ ] Name: `DenTime` · Key: `DEN`
- [ ] Add epics:
    - `Hackathon — MVP1 macOS + Docs`
    - `MVP2 — API + iOS + Meetups`
    - `MVP3 — Calendar integrations`

### Step 7.4 — Google Drive (optional) ⏱ 3 min

Want me to create via connector? Say **"create the DenTime Drive folder"**.

Otherwise:

- [ ] Drive → New folder → `DenTime`
- [ ] Subfolders: `01_Design`, `02_App Store`, `03_Legal`, `04_Brand`, `05_Notes`
- [ ] Drop `logo.svg` + `logo-mono.svg` into `01_Design`

---

## Section 8 — When MVP1 ships, come back for MVP2

Don't start MVP2 until MVP1 is actually **in App Store review or approved.** Shipping something > building more features. Trust me.

When you're ready:

```bash
cd ~/Code/dentime
claude
```

Paste:

> Read `CC-MVP2.md` and work through every phase. Use your todo list. Pause between phases. Fangdash is at `~/Code/fangdash` — use its Better Auth + Hono + monorepo patterns as reference.

---

## 🆘 If you get stuck

- **Xcode won't sign:** Check Step 2.3. Signing happens in Xcode UI, not Claude Code.
- **GitHub Pages shows 404:** GitHub Actions might still be running. Check `github.com/MrDemonWolf/dentime/actions`.
- **Claude Code keeps adding MVP2 features:** Interrupt it with "That's out of scope. Skip it and continue."
- **Something doesn't build:** Ask Claude Code to fix it with "Build fails with: [paste error]. Fix it."
- **Overwhelmed:** Stop. Close the laptop. Walk the dog (the real one). Come back in an hour.

---

## 📦 Files in this package

After you unzip:

| File                   | What it's for                         | When to read                       |
| ---------------------- | ------------------------------------- | ---------------------------------- |
| `HACKATON.md`          | What we're building, in plain English | Right now                          |
| `TODO.md`              | This file — your checklist            | Right now                          |
| `CC-MVP1.md`           | Full build plan for Claude Code       | Paste into Claude Code at Step 6.2 |
| `CC-MVP2.md`           | Future build plan                     | Ignore until MVP1 ships            |
| `assets/logo.svg`      | Color paw tick logo                   | Claude Code uses this              |
| `assets/logo-mono.svg` | Monochrome menu bar logo              | Claude Code uses this              |
| `START_HERE.md`        | Quick run-order summary               | Read if you forget what to do      |

---

**Current state:** You're reading this. Go to Section 1, Step 1.1. Start. 🐺
