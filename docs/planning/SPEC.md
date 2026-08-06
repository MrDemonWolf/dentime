# Product spec

Two tabs and a Settings window. That is the whole app.

Where this and [DECISIONS.md](DECISIONS.md) disagree, DECISIONS.md wins. The mockup these screens are built from is in [`docs/design`](../design/README.md).

---

## Den tab — opens here

Person rows: avatar emoji, name, their local time, time zone abbreviation. The time is the visual anchor — large tabular monospaced digits against small meta text.

**Day-of-week appears on every row.** This is not decoration; it is what designs out the wrong-day failure mode, which is the one bug that would kill this app.

**Packs** are collapsible groups, LocalWP-style. Drag people between them. A pack named "Acme Corp" behaves identically to one named "the boys".

**Time Peek** is a scrubber at the top of this tab, not a tab of its own. Drag it and every row's time updates live. Fully client-side — it never touches the network, never reads CloudKit, and scrubbing your whole den costs nothing.

**Adding someone**, two ways:

- By friend code — `DEN·XXXX-XXXX`. Resolves a real DenTime user, and their row follows their profile when they travel.
- Manually — a name and a time zone, for people who do not use DenTime. That row stays where you put it.

Adds are one-way. Adding someone does not add you to their den.

**Row menu** (`…` on every row): Edit, Block, Remove. Block is here because this is where the problem is visible; it also feeds Settings → Blocked. Remove should show an undo toast rather than a confirmation dialog — removing someone is low-cost and reversible by re-adding, so a modal is the wrong weight.

**Status is never colour-only.** Asleep is dimmed, plus a ☾, plus a label.

---

## Meetups tab

The reason people download it.

**Hosting.** Propose between two and five slots. The app generates a join code — `HOWL·XXXX-XXXX`. The host pastes that wherever their pack already talks: Discord, group chat, wherever. **DenTime sends nothing anywhere.**

**Joining.** Anyone with the code enters it and is in. There is no invitation, no push, no notification, and no way for a stranger to reach you without you typing their code.

**Everyone sees the slots in their own local time**, with the day of the week, and with a marker when a slot lands on a different calendar day for them than for the host.

**RSVP** yes / no / maybe. The selected segment is cyan — accent means selection. The tally bar keeps semantic colours.

**The host sees who's in on what.** Participant rows carry a `…` menu with Block, for the same reason den rows do.

**Leaving** works from either side. A participant can leave; a host can remove a participant, and unlike blocking that removal is enforced by CloudKit.

**The host can rotate or disable the join code.** Rotating genuinely invalidates the old one.

A meetup renders as **"[Host name]'s meetup"** plus its date range. There is no title field and no description field, and there never will be — that is what keeps display names the only user-written text in the app.

---

## Settings window

Opened with ⌘, — a standard window, not a third tab.

**General** — launch at login, 12/24-hour time, menu bar icon, and a **Vocabulary** segmented control (Den / Team) with a live preview line underneath so the effect is visible before committing.

**Account** — the signed-in Apple ID, your friend code with a **Rotate** button, and **Delete account** in destructive styling behind a confirmation. Deleting purges the public profile, the private zone and every share you own.

**Blocked** — the list, with unblock. Copy here says "You won't see them", never "They can't see you".

**About** — version, build, links to the docs, privacy policy and support pages.

---

## Out of scope, and staying out

- Calendar integration in every form — busy shading, conflict warnings, Add to Calendar, `.ics` export
- Subscriptions, trials, free tiers, paywalls
- Push invites and notifications of any kind
- Free-text meetup titles and descriptions
- Per-person availability or working hours
- Recurring meetups
- Web app, Android, team billing, seats

Feature requests for any of these get closed with a pointer to this section.

---

## The one worth building later

**Shared free/busy.** Devices publishing coarse busy blocks so slots show green or red for everyone, without anyone typing their availability in.

This is the version that makes DenTime genuinely magic, and it is a real privacy product rather than a feature bolt-on:

- Opt-in per pack, not globally
- Busy/free only — **never** event titles, never locations, never attendees
- Explicit retention window, stated in plain language
- One-tap purge that actually deletes

It gets its own release, its own privacy review and its own App Store update notes. It is not something to slip into a point release.
