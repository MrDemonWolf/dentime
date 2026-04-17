# DenTime — Things Only You Can Do

Claude handled everything that can be scripted. This file is the short list
of things that require *your* credentials, accounts, or physical presence.
Tick them off in order.

---

## 1. Local tooling

- [ ] `brew install xcodegen` — needed to regenerate `apple/DenTime.xcodeproj`
- [ ] `bun install` at the repo root (installs every workspace)
- [ ] `cd apple && xcodegen generate && open DenTime.xcodeproj`
- [ ] In Xcode, for each target (`DenTime-iOS`, `DenTime-macOS`):
      Signing & Capabilities → pick your Team → verify Sign in with Apple
      and Push Notifications are enabled.

## 2. Apple Developer account

- [ ] Enroll / confirm MrDemonWolf, Inc. org account is active.
- [ ] Register App ID `com.mrdemonwolf.dentime` with capabilities:
      Sign in with Apple, Push Notifications, App Groups
      (`group.com.mrdemonwolf.dentime` for widgets in Phase 5).
- [ ] Create two App Store Connect app records (one iOS, one macOS) with
      that bundle ID and the name `DenTime`.
- [ ] Generate an App-specific password at appleid.apple.com
      (for `altool` uploads from CI).
- [ ] Export a Developer ID → Apple Distribution certificate as .p12
      (with password); save both. Base64-encode the .p12 for the GH secret.
- [ ] Download an App Store provisioning profile for each target.

## 3. Cloudflare account

- [ ] Create a Cloudflare account if you don't have one.
- [ ] Create a D1 database: `bunx wrangler d1 create dentime`.
  (Alchemy will pick this up — the first `bun run deploy` declares it.)
- [ ] Create a scoped API token with Workers + D1 write perms.
      Save the token and your account ID — both go into GitHub secrets.

## 4. RevenueCat (paid features)

- [ ] Create a RevenueCat project `DenTime`.
- [ ] Add both apps (iOS + macOS) under one project so one entitlement
      spans both.
- [ ] Create the `pro` entitlement and two products:
      `dentime_monthly` ($0.99/mo, 1-week trial),
      `dentime_annual` ($10.99/yr, 1-week trial).
- [ ] Set up an App Store Connect shared secret in RC.
- [ ] Configure a webhook: `https://dentime.mrdemonwolf.workers.dev/webhooks/revenuecat`
      with HMAC auth — save the shared secret.
- [ ] Grant yourself a **lifetime promotional entitlement** on `pro` so
      you never pay yourself. Mirror in the backend with
      `OWNER_APPLE_SUBS` (see secrets below).

## 5. Better Stack (logging)

- [ ] Create a source in Better Stack (log type: HTTP).
- [ ] Save the source token and the ingest URL.

## 6. GitHub repo setup

- [ ] Push this repo to `github.com/mrdemonwolf/dentime` (run
      `git remote add origin …` + `git push -u origin main`).
- [ ] Repo **Settings → Pages → Build & deployment → Source: GitHub Actions**.
      (Do **not** set a custom domain — we're on the project page.)
- [ ] Repo **Settings → Actions → General** → Allow all workflows.

### GitHub Secrets to add (Settings → Secrets and variables → Actions)

**Cloudflare (api-deploy)**
- [ ] `CLOUDFLARE_API_TOKEN`
- [ ] `CLOUDFLARE_ACCOUNT_ID`

**Apple (apple-testflight)**
- [ ] `APPLE_ID`                       - your Apple Developer account email
- [ ] `APPLE_APP_SPECIFIC_PW`          - from appleid.apple.com
- [ ] `APPLE_TEAM_ID`                  - 10-char team id
- [ ] `APPLE_DIST_CERT_P12`            - base64 of your .p12
- [ ] `APPLE_DIST_CERT_PW`             - password you set on the .p12
- [ ] `APPLE_PROVISION_PROFILE`        - base64 of the .mobileprovision

## 7. Cloudflare Worker secrets (via `wrangler secret put` or alchemy)

Run once locally after first deploy:

```bash
cd packages/infra
bunx wrangler secret put JWT_SECRET --name dentime       # 32 random bytes, base64
bunx wrangler secret put APPLE_AUDIENCES --name dentime  # com.mrdemonwolf.dentime
bunx wrangler secret put BETTER_STACK_TOKEN --name dentime
bunx wrangler secret put BETTER_STACK_INGEST --name dentime
bunx wrangler secret put REVENUECAT_WEBHOOK_SECRET --name dentime
bunx wrangler secret put OWNER_APPLE_SUBS --name dentime # your Apple sub (comma-list)
bunx wrangler secret put APNS_KEY_P8 --name dentime      # APNs .p8 key (multiline)
bunx wrangler secret put APNS_KEY_ID --name dentime
bunx wrangler secret put APNS_TEAM_ID --name dentime
```

> `OWNER_APPLE_SUBS` is populated **after** you sign in to your own app
> for the first time — grab the Apple `sub` from the Worker logs and
> paste it here. Until then, set it to the empty string.

## 8. First end-to-end smoke test

After the above is done:

1. Push to `main` → `api-deploy` workflow runs → Worker live at
   `https://dentime.mrdemonwolf.workers.dev`.
2. Push any change to `apps/docs/**` → site live at
   `https://mrdemonwolf.github.io/dentime/`.
3. `curl https://dentime.mrdemonwolf.workers.dev/health` should return:
   ```json
   {"status":"ok","service":"dentime-api","timestamp":"..."}
   ```

## 9. Legal review (required before App Store submission)

- [ ] Send the TOS and Privacy Policy drafts (in `apps/docs/app/legal/`
      — currently placeholders) to qualified counsel.
- [ ] Replace placeholders in
      `apps/docs/app/legal/terms/page.tsx` and
      `apps/docs/app/legal/privacy/page.tsx` with counsel-reviewed copy.

## 10. App Store pre-submission (before first TestFlight build)

- [ ] Design app icon set (1024 and all mac sizes) → drop into
      `apple/DenTime/Assets.xcassets/AppIcon.appiconset/`.
- [ ] Design menu bar template icon (22×22 @1x/2x/3x, monochrome).
- [ ] Write App Review Notes including the long-press-version reviewer
      bypass (Phase 6 work, but capture it somewhere).
- [ ] Run `/anthropic-skills:app-store-review-audit` and
      `/coderabbit:greenlight` against both targets; fix findings.
- [ ] Fill out Privacy Nutrition Label in App Store Connect.

---

**If you get stuck on any of these, tell me which step and I'll walk you
through it or automate what can be automated.**
