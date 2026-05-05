#!/bin/bash

set -e

# --- CONFIG ---
MAX_DIFF_LINES=200          # limit size
REDACT_PATTERNS="api[_-]?key|token|secret|password|authorization"            # default ON, but gated by consent

# --- GET DIFF ---
DIFF=$(git diff --cached)

if [ -z "$DIFF" ]; then
  echo "❌ No staged files"
  exit 1
fi

# --- REDACT SECRETS ---
SAFE_DIFF=$(echo "$DIFF" | sed -E "s/($REDACT_PATTERNS)=?[A-Za-z0-9_\-]+/[REDACTED]/gi")

# --- LIMIT SIZE ---
SAFE_DIFF=$(echo "$SAFE_DIFF" | head -n $MAX_DIFF_LINES)

# --- CONSENT CHECK ---
if [ "$SMART_COMMIT_ENABLED" != "true" ]; then
  echo "⚠️  Sending to Claude API is disabled by default for security."
  echo "Enable with: export SMART_COMMIT_ENABLED=true"
  exit 1
fi

echo "🤖 Generating commit message..."

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
$SAFE_DIFF
EOF
)

MSG=$(echo "$PROMPT" | claude)

MSG=$(echo "$MSG" | tr -d '\r' | sed '/^$/d')

if [ -z "$MSG" ]; then
  echo "❌ Failed to generate commit message"
  exit 1
fi

echo "📦 $MSG"

git commit -m "$MSG"

echo "✅ Committed"