# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- macOS menu bar app with roster (grouped friends, default tab), meeting finder, settings
- Friend persistence via UserDefaults; groups, color dots, sort order
- Launch at login via `SMAppService` (macOS 13+)
- App Store submission readiness: Sandbox + Hardened Runtime + Privacy Manifest (`PrivacyInfo.xcprivacy`)
- Fumadocs docs site deployed to GitHub Pages at `mrdemonwolf.github.io/dentime`
- Landing page (customer-focused), dual-audience docs (users + developers), legal pages (ToS, Privacy)
- GitHub Actions: CI, docs deploy, manual TestFlight upload
- Turborepo + bun workspaces with shared ESLint / Prettier / TypeScript config
- Solo-main branch protection
