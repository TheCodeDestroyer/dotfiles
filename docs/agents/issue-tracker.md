---
tracker: clickup
clickup-account: zelogic
clickup-space: 901210937944
clickup-lists: 901223321732
---

# Issue tracker: ClickUp

Issues for this repo live in ClickUp, workspace "Zelogic", space **Dev Tools**, list **Bin**.
Not in GitHub Issues, not in beads, not as markdown files. Every skill that
reads or writes "the issue tracker" uses the `clickup zelogic ...` wrapper (the
`ops:clickup` skill). Never pass `--token` or `--workspace`.

Do not create `.scratch/` issue files or a combined tickets markdown file.

Dev Tools is a shared space: it holds lists for other repos. New tasks and bugs
go in the `Bin` list only. Find its ID with
`clickup zelogic list list --space 901210937944`. Priority: 1=urgent, 2=high,
3=normal, 4=low.

- Descriptions are plain text (no markdown). Only comments render markdown
  (`--markdown`).
- A wrong task ID gives `401 Team not authorized`, not a 404.
- Your own user ID comes from `clickup zelogic auth whoami`.

## When a skill says "publish to the issue tracker"

    clickup zelogic task create --list <Bin-list-id> --name "<summary>" \
      --description @/path/to/body.txt --priority 3 --assignee <your-user-id> \
      --tag needs-triage

- Put acceptance criteria and design notes in the body under plain headings.
- Hierarchy: an epic is a parent task; tickets are subtasks via
  `--parent <task-id>`. A subtask must be created in its parent's list.
- Ordering constraints: `clickup zelogic task add-dep <task> --depends-on <blocker>`.
- Triage labels are tags: `--tag <name>` at create, or
  `clickup zelogic task add-tag <task> <name>` / `task remove-tag <task> <name>`.
  See `triage-labels.md`. Tags belong to the Dev Tools space. Make a missing tag
  with `tag create --space 901210937944 --name <tag>`. Never put `#` in a tag name.
- Creates are live writes in a shared workspace: confirm with the user first.

## When a skill says "fetch the relevant ticket"

    clickup-prime
    clickup zelogic task get <task-id> --markdown --output json
    clickup zelogic comment list --task <task-id> --output json

List the `Bin` list with
`clickup zelogic task list --list <Bin-list-id> --subtasks --all --output json`.
Filter with `--tag`, `--status`, `--include-closed`.

## Updating and closing

Follow the status flow in the `ops:clickup` skill ("Task status through a PR"),
with the status order `clickup-prime` prints:

    clickup zelogic task update <task-id> --status "<status>"

- Note progress or a decision:
  `clickup zelogic comment create --task <task-id> --text "..." --markdown`
- Close: comment with the reason, then set the `closed` status.

## Wayfinding operations

Used by `/wayfinder`. The **map** is one parent task. Its **children** are subtasks.

- **Map**: a task in the `Bin` list with tag `wayfinder:map`. Its description holds Notes / Decisions so far / Fog (plain text).
- **Child ticket**: a subtask of the map (`--parent <map-id>`) with tag `wayfinder:<type>` (`research` / `prototype` / `grilling` / `task`).
- **Blocking**: native ClickUp dependencies. `clickup zelogic task add-dep <child-id> --depends-on <blocker-id>`. Read them from `task get ... | jq '.[0].dependencies'`. A ticket is unblocked when every blocker is `closed`.
- **Frontier query**: list the map's subtasks with status type `open` (`task list --list <Bin-list-id> --subtasks --output json | jq '[.[] | select(.parent == "<map-id>")]'`). Drop any with an open blocker or an assignee. First in list order wins.
- **Claim**: `clickup zelogic task update <id> --add-assignee <your-user-id>`, then move it to the start status of the skill's status flow, as the session's first write.
- **Resolve**: comment the answer, set the `closed` status, then add a short pointer (gist + task link) to the map's Decisions so far with `task update <map-id> --description @map.txt`.

## Pull requests as a triage surface

**PRs as a request surface: no.** _(Set to `yes` to triage external PRs on GitHub `TheCodeDestroyer/dotfiles` with `gh pr view` / `gh pr comment` / `gh pr close`. Labels then go on the PR with `gh pr edit --add-label`.)_
