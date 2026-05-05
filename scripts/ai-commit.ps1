# Get staged diff
$DIFF = git diff --cached

if ([string]::IsNullOrWhiteSpace($DIFF)) {
    Write-Host "❌ No staged files"
    exit 1
}

Write-Host "🤖 Generating commit message..."

# Multi-line prompt using here-string
$PROMPT = @"
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
"@

# Call Claude
$MSG = $PROMPT | claude

# Trim output (important)
$MSG = $MSG -replace "`r", ""
$MSG = $MSG.Trim()

# Validate
if ([string]::IsNullOrWhiteSpace($MSG)) {
    Write-Host "❌ Failed to generate commit message"
    exit 1
}

Write-Host "📦 $MSG"

# Commit
git commit -m "$MSG"

Write-Host "✅ Committed"