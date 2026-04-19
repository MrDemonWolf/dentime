# DenTime macOS

SwiftUI menu bar app. macOS 13+. Zero third-party dependencies.

## Requirements

- Xcode 15+
- macOS 13.0+ (runtime and SDK)
- [XcodeGen](https://github.com/yonaskolb/XcodeGen) — `brew install xcodegen`
- Bundle ID: `com.mrdemonwolf.dentime`

## Build

```bash
cd apps/macOS
xcodegen generate
xcodebuild -project DenTime.xcodeproj -scheme DenTime \
  -configuration Debug -destination 'platform=macOS' build
```

## Run

```bash
open DenTime.xcodeproj
# Then ⌘R in Xcode.
```

## Test

```bash
xcodebuild -project DenTime.xcodeproj -scheme DenTime \
  -destination 'platform=macOS' test
```

## Archive (App Store submission)

1. Open project in Xcode
2. Select your Apple Developer team in project → Signing & Capabilities
3. Product → Archive
4. Organizer → Validate App → upload to App Store Connect

TestFlight uploads are also available via `.github/workflows/apple-testflight.yml` — manual dispatch once required repo secrets are populated (see root `TODO.md`).

## MVP1 limitations

- **Local-only**: nothing leaves your Mac. No sync. No account.
- **macOS-only**: iOS lands in MVP2.
- **No calendar integration**: EventKit + iCal export are MVP2.
- **No auto-update**: Sparkle lands in MVP2.

## Structure

```
apps/macOS/
├── project.yml               XcodeGen config
├── DenTime/
│   ├── App/                  @main entry, AppState
│   ├── Models/               Friend, TimeFormat, TimeStatus
│   ├── Storage/              FriendStore, SettingsStore
│   ├── Views/
│   │   ├── RootView.swift
│   │   ├── Roster/
│   │   ├── MeetingFinder/
│   │   ├── AddFriend/
│   │   └── Settings/
│   ├── Resources/
│   │   ├── Assets.xcassets
│   │   └── PrivacyInfo.xcprivacy
│   ├── Info.plist
│   └── DenTime.entitlements  App Sandbox only
└── DenTimeTests/
```

## Privacy

- **App Sandbox** enabled (entitlement only).
- **Hardened Runtime** enabled.
- **Privacy Manifest** (`PrivacyInfo.xcprivacy`) declares UserDefaults usage only (reason `CA92.1`); zero data collection, no tracking.
