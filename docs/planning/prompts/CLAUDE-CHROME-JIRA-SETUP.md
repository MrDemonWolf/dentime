# Prompt: create the MDW DenTime Jira board

For **Claude for Chrome**. Paste everything below the line into a Claude for Chrome session with a browser signed in to `mrdemonwolf.atlassian.net`.

It creates a real Jira project and 77 real issues — 8 epics and 69 tasks — in a live site. Read it before running it.

If the board already exists, do not run this — it has no idempotency and will duplicate everything.

---

You are going to create a new Jira project and its backlog in `https://mrdemonwolf.atlassian.net`, matching the conventions of an existing project rather than inventing your own.

## Step 1 — Learn the house pattern before creating anything

Open **MDW FangDash**, project key `FD`:

`https://mrdemonwolf.atlassian.net/jira/software/projects/FD/boards`

Read it and note, from what is actually on screen rather than from my description of it:

- how epics are named and how their descriptions are written
- the exact structure of a task description
- the label style
- the default priority and assignee
- the project category and project type

Then open two individual issues to see the full description formatting — `FD-9` and `FD-25`:

- `https://mrdemonwolf.atlassian.net/browse/FD-9`
- `https://mrdemonwolf.atlassian.net/browse/FD-25`

For reference, **MDW DireWork** (`DW-2`) shows the same house style with a checklist-style body: `https://mrdemonwolf.atlassian.net/browse/DW-2`

**Tell me what you found before continuing.** If FangDash's conventions differ from what I describe below, follow FangDash and say what you changed.

What I expect you will find:

- Team-managed software project, category **Platform**
- Epics have a **single prose paragraph** description, no headings
- Tasks use exactly this structure:

  ```
  ## Description

  One or two sentences.

  ## Acceptance Criteria

  * …
  * …

  ## Labels

  phase-3, core, swift
  ```

- Priority **Medium**, assignee **Nathanial Henniges**, everything starting in **To Do**
- Labels combine a phase or day label with area labels

## Step 2 — Get the backlog

The tickets to create are in a public repository file:

`https://github.com/MrDemonWolf/dentime/blob/main/docs/planning/JIRA-BACKLOG.md`

Open it and read the whole thing. It contains 8 epics and 69 tasks, each with its description, acceptance criteria and labels already written in the FangDash format.

If that page is not reachable, stop and ask me to paste the file contents instead. **Do not invent tickets.**

## Step 3 — Create the project

- **Name:** `MDW DenTime`
- **Key:** `TIME`
- **Type:** team-managed software project
- **Template:** whatever FangDash uses — Kanban unless you find otherwise
- **Category:** Platform
- **Lead:** Nathanial Henniges

If Jira rejects `TIME` because it is taken or reserved, use `DEN` instead and tell me you did. Do not silently pick a third option.

Confirm the project exists before creating any issues.

## Step 4 — Create the eight epics, in order

Create them in this exact order so the keys line up with the backlog document:

1. `TIME-1` Setup & Infrastructure
2. `TIME-2` CloudKit Foundation
3. `TIME-3` DenTimeCore
4. `TIME-4` Identity & Profile
5. `TIME-5` Den — Roster, Packs & Time Peek
6. `TIME-6` Meetups
7. `TIME-7` Settings, Safety & Account
8. `TIME-8` App Store & Release

Each epic's description is the blockquote paragraph under its heading in the backlog document. Paste it as plain prose — no headings, no bullets.

## Step 5 — Create the tasks

Work through the backlog document in order, top to bottom, so the issue numbers match. For each task:

- **Summary:** the text after the em dash in the heading, without the `TIME-nn — ` prefix and without any trailing ✅
- **Description:** the fenced block underneath, pasted verbatim — the `## Description`, `## Acceptance Criteria` and `## Labels` sections exactly as written. Keep the `## Labels` section in the body; FangDash does this too, and it is deliberate.
- **Parent:** the epic whose section the task sits under
- **Labels:** the labels from the `## Labels` line, added as real Jira labels as well as leaving them in the body
- **Priority:** Medium
- **Assignee:** Nathanial Henniges
- **Status:** To Do, **except** where the heading ends in ✅ — those are already done, so create them and transition them to **Done**

There are 13 tickets marked ✅ — seven in Setup & Infrastructure and six in DenTimeCore. They are real work that is already finished, and the board should reflect that rather than starting from a fiction.

Do the tasks epic by epic. After finishing each epic, tell me the key range you created and carry on without waiting for me.

## Step 6 — Verify

When everything is created, check and report:

- [ ] 8 epics exist
- [ ] 69 tasks exist, for 77 issues in total
- [ ] every task has a parent epic — no orphans
- [ ] every task has at least two labels: one phase label and at least one area label
- [ ] the 13 ✅ tasks are in Done and everything else is in To Do
- [ ] every task is assigned to Nathanial Henniges at Medium priority
- [ ] no duplicate summaries
- [ ] issue keys run `TIME-1` through `TIME-77` with no gaps

Then give me the board URL and a one-line summary per epic: key range, task count, how many are Done.

## Rules

- **Do not invent tickets, acceptance criteria or labels.** Everything comes from the backlog document. If something there is ambiguous, ask rather than filling the gap.
- **Do not create a sprint, a board filter or a workflow.** Default configuration only.
- **Do not change anything in FangDash or DireWork.** They are read-only references.
- If you hit a rate limit or an error partway through, stop and tell me which key you reached. Do not restart from the beginning — that would duplicate everything created so far.
