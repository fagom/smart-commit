---
name: smart-commit
description: Commit staged files with a proper commit message.
compatibility: Requires git and Claude CLI (installed and authenticated).
metadata:
  author: fagom
  version: "1.0.2"
---

## ⚠️ SECURITY WARNING

**This tool sends your staged git diff to Claude API.** Do not use on:

- Proprietary or classified code
- Repositories containing secrets, API keys, or tokens
- Sensitive customer data or business logic

This tool is designed for open-source or non-sensitive codebases only.

Before using, review your staged changes to ensure they are safe to send to an external service.

---

## Input Assumption

- The input WILL contain a git diff
- Base your analysis ONLY on the provided diff
- DO NOT assume additional context

---

## Failure Condition

If the input diff is empty or missing:

Output EXACTLY:
ERROR: NO_STAGED_FILES

---

## Setup

Enable the skill by setting the environment variable:

- **Bash**: `export SMART_COMMIT_ENABLED=true`
- **PowerShell**: `$env:SMART_COMMIT_ENABLED = 'true'`

This is required for security — the script will not send your code to Claude API without explicit opt-in.

## Steps

Run the appropriate script:

- **Bash**: `scripts/ai-commit.sh`
- **PowerShell**: `scripts/ai-commit.ps1`
