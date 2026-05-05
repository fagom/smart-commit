#!/bin/bash

# Check staged files
DIFF=$(git diff --cached)

if [ -z "$DIFF" ]; then
  echo "❌ No staged files"
  exit 1
fi

echo "🤖 Generating commit message..."

# Multi-line prompt using heredoc
PROMPT=$(cat <<EOF
Generate a commit message based on the following git diff.

Determine:
- What changed (feature, fix, refactor, chore, etc.)
- Scope (auth, api, ui, db, etc.)
- Impact (bug fix, performance, cleanup)

Format:
<type>(<scope>): <short summary>

Rules:
- Summary ≤ 72 characters
- No trailing period
- Be specific
- Use lowercase type
- Output ONLY the commit message
- No explanation

Diff:
$DIFF
EOF
)

# Call Claude
MSG=$(echo "$PROMPT" | claude)

# Trim (important)
MSG=$(echo "$MSG" | tr -d '\r' | sed '/^$/d')

# Validate
if [ -z "$MSG" ]; then
  echo "❌ Failed to generate commit message"
  exit 1
fi

echo "📦 $MSG"

# Commit
git commit -m "$MSG"

echo "✅ Committed"