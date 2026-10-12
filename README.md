# time-of-day-dot

Every Claude Code reply starts with date, time and a colored dot:

```
🟣 2026-10-05 11:34

Reply ...
```

The dot changes over the day, from dark in the morning to red after 20:00:

| Hour | Dot |
|---|---|
| 0 to 2 | ⚫ |
| 3 to 5 | 🟤 |
| 6 to 8 | 🔵 |
| 9 to 11 | 🟣 |
| 12 to 14 | 🟢 |
| 15 to 17 | 🟡 |
| 18 to 19 | 🟠 |
| 20 to 23 | 🔴 |

You can see in the history when a reply came in and how long a session has been running.

## Install as a plugin

Inside Claude Code:

```
/plugin marketplace add JanGitHop/time-of-day-dot
/plugin install time-of-day-dot@time-of-day-dot
```

Restart Claude Code. Requires `bash`, works on macOS and Linux.

## Install by hand

```bash
git clone https://github.com/JanGitHop/time-of-day-dot.git
bash time-of-day-dot/install.sh
```

The script copies `hooks/datetime-prompt.sh` to `~/.claude/hooks/` and registers it in
`~/.claude/settings.json`. The old file stays next to it as `settings.json.bak-<time>`. Needs `python3`
for the JSON edit.

Use one of the two ways, not both. With both, the hook runs twice per prompt.

Optional backup line in `~/.claude/CLAUDE.md`:
`Begin every reply with the current datetime: "YYYY-MM-DD HH:MM"`

## How it works

Claude does not know the current time. The hook runs on every prompt before Claude answers and adds
the time and the dot as context, together with the instruction to start the reply with exactly that
line. Colors and hour ranges are in `emojis` and `hourmap` at the top of `hooks/datetime-prompt.sh`.

## Uninstall

- Plugin: `/plugin uninstall time-of-day-dot@time-of-day-dot`
- By hand: remove the entry under `hooks.UserPromptSubmit` in `~/.claude/settings.json`, then delete
  `~/.claude/hooks/datetime-prompt.sh`.

## License

MIT
