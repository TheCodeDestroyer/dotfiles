---
tracker: clickup
clickup-account: zelogic
clickup-lists: 901223321732
---

# Issue tracker: ClickUp

Issues and specs for this repo are ClickUp tasks in workspace **Zelogic**, space **Dev Tools** (`901210937944`), list **Bin** (`901223321732`).
Run every command as `clickup zelogic ...` (see the `ops:clickup` skill). Never pass `--token` or `--workspace`.

- Statuses: `to do` → `in progress` → `complete`.
- Epic = parent task. Tickets = subtasks in the same list.
- Task descriptions are plain text. Markdown shows as literal characters. Only comments render markdown (`--markdown`).
- A wrong task ID gives `401 Team not authorized`, not a 404.
- Your own user ID: `308596868` (`clickup zelogic auth whoami`).

## Conventions

- **Create an issue**: `clickup zelogic task create --list 901223321732 --name "..." --description @body.txt --tag needs-triage`
- **Read an issue**: `clickup zelogic task get <id> --markdown --output json | jq '.[0] | {name, status: .status.status, tags: [.tags[].name], parent, markdown_description}'`, then `clickup zelogic comment list --task <id> --output json`.
- **List issues**: `clickup zelogic task list --list 901223321732 --subtasks --all --output json`. Filter with `--tag`, `--status`, `--include-closed`.
- **Make an issue a subtask of a parent**: `task create --parent <parent-id> ...`, or `task update <child-id> --parent <parent-id>` afterwards.
- **Comment on an issue**: `clickup zelogic comment create --task <id> --text @body.md --markdown`
- **Apply / remove labels**: `clickup zelogic task add-tag <id> <tag>` / `task remove-tag <id> <tag>`. Tags belong to the Dev Tools space. Make a missing tag with `tag create --space 901210937944 --name <tag>`. Never put `#` in a tag name.
- **Close**: comment with the reason, then `clickup zelogic task update <id> --status complete`.

## Pull requests as a triage surface

**PRs as a request surface: no.** _(Set to `yes` to triage external PRs on GitHub `TheCodeDestroyer/dotfiles` with `gh pr view` / `gh pr comment` / `gh pr close`. Labels then go on the PR with `gh pr edit --add-label`.)_

## When a skill says "publish to the issue tracker"

Create a ClickUp task in the Bin list. Confirm with the user first: writes are live.

## When a skill says "fetch the relevant ticket"

Read it as in **Read an issue** above.

## Wayfinding operations

Used by `/wayfinder`. The **map** is one parent task. Its **children** are subtasks.

- **Map**: a task in Bin with tag `wayfinder:map`. Its description holds Notes / Decisions so far / Fog (plain text).
- **Child ticket**: a subtask of the map (`--parent <map-id>`) with tag `wayfinder:<type>` (`research` / `prototype` / `grilling` / `task`).
- **Blocking**: native ClickUp dependencies. `clickup zelogic task add-dep <child-id> --depends-on <blocker-id>`. Read them from `task get ... | jq '.[0].dependencies'`. A ticket is unblocked when every blocker is `complete`.
- **Frontier query**: list the map's open subtasks (`task list --list 901223321732 --subtasks --output json | jq '[.[] | select(.parent == "<map-id>")]'`). Drop any with an open blocker or an assignee. First in list order wins.
- **Claim**: `clickup zelogic task update <id> --add-assignee 308596868 --status "in progress"` as the session's first write.
- **Resolve**: comment the answer, set status `complete`, then add a short pointer (gist + task link) to the map's Decisions so far with `task update <map-id> --description @map.txt`.
