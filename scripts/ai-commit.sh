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


echo "🤖 Generating commit message..."

PROMPT=$(cat <<EOF
Generate a commit message from this diff.

Rules:
- Format: <type>(scope): <summary>
- Max 72 chars
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