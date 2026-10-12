#!/usr/bin/env bash
# UserPromptSubmit hook: tells Claude to begin its reply with the current timestamp,
# prefixed by a colored dot that shows the time of day.

# 8 colors, dark/cold early -> red at the end of the day. Red starts at 20:00.
emojis=(⚫ 🟤 🔵 🟣 🟢 🟡 🟠 🔴)
#       hour: 0 1 2 3 4 5 6 7 8 9 . . . . . . . . 18 19 20 21 22 23
hourmap=(     0 0 0 1 1 1 2 2 2 3 3 3 4 4 4 5 5 5  6  6  7  7  7  7 )
h=$((10#$(date +%H)))
e=${emojis[hourmap[h]]}
stamp=$(date '+%Y-%m-%d %H:%M')
full=$(date '+%Y-%m-%d %H:%M:%S %Z')

# The text contains no quotes or backslashes, so it is valid inside a JSON string as is.
ctx="MANDATORY: begin your very next reply with this exact line and nothing before it: ${e} ${stamp}  (then a blank line, then your answer). The leading dot is a time-of-day indicator (dark/cold = early, red = late/end of day), keep whichever dot is given here. Full datetime for reference: ${full}"

printf '{"hookSpecificOutput":{"hookEventName":"UserPromptSubmit","additionalContext":"%s"}}\n' "$ctx"
