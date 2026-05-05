---
name: smart-commit
description: Commit staged files with a proper commit message.
compatibility: Requires git and access to internet.
metadata:
  author: fagom
  version: "1.0"
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

## Steps

Run the appropriate script:

- **Bash**: `scripts/ai-commit.sh`
- **PowerShell**: `scripts/ai-commit.ps1`
