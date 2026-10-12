#!/usr/bin/env bash
# Manual install without the plugin system: copies the hook to ~/.claude/hooks/
# and registers it as a UserPromptSubmit hook in ~/.claude/settings.json.
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
HOOKS="$HOME/.claude/hooks"
SETTINGS="$HOME/.claude/settings.json"

mkdir -p "$HOOKS"
cp "$HERE/hooks/datetime-prompt.sh" "$HOOKS/datetime-prompt.sh"
chmod +x "$HOOKS/datetime-prompt.sh"

[ -f "$SETTINGS" ] || echo '{}' > "$SETTINGS"
cp "$SETTINGS" "$SETTINGS.bak-$(date +%Y%m%d%H%M%S)"

python3 - "$SETTINGS" <<'PY'
import json, sys
path = sys.argv[1]
with open(path) as f:
    s = json.load(f)
cmd = "$HOME/.claude/hooks/datetime-prompt.sh"
groups = s.setdefault("hooks", {}).setdefault("UserPromptSubmit", [])
if any(h.get("command") == cmd for g in groups for h in g.get("hooks", [])):
    print("Hook already registered.")
else:
    groups.append({"hooks": [{"type": "command", "command": cmd, "timeout": 5}]})
    with open(path, "w") as f:
        json.dump(s, f, indent=2)
        f.write("\n")
    print("Hook registered.")
PY

echo "Done. Restart Claude Code, the next reply starts with dot and time."
