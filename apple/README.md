# DenTime — Apple targets

Two app targets (iOS and macOS) + a shared `DenTimeCore` Swift package.

## Generating the Xcode project

We do **not** commit `.xcodeproj`. Generate it with
[XcodeGen](https://github.com/yonaskolb/XcodeGen):

```bash
brew install xcodegen
cd apple
xcodegen generate
open DenTime.xcodeproj
```

Re-run `xcodegen generate` any time `project.yml` changes.

## Targets

| Target         | Platform | Bundle ID                     |
| -------------- | -------- | ----------------------------- |
| DenTime-iOS    | iOS 17+  | `com.mrdemonwolf.dentime`     |
| DenTime-macOS  | macOS 14+| `com.mrdemonwolf.dentime`     |

macOS target has `LSUIElement=YES` (menu-bar-only, no Dock icon) and is
sandboxed. iOS target runs in standard sandbox.

Both targets embed:

- `DenTimeCore` — shared Swift package (local path).
- `RevenueCat` — SPM, for StoreKit 2 subscriptions (MVP2+).

## First-time Xcode setup

1. Open `DenTime.xcodeproj` in Xcode.
2. Select each target → **Signing & Capabilities** → set your Team.
3. Verify capabilities: Sign in with Apple, Push Notifications, App Groups
   (for widgets — Phase 5).
4. `⌘B` to make sure both targets build.
