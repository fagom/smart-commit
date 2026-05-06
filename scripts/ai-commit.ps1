$ErrorActionPreference = "Stop"

# --- CONFIG ---
$MAX_DIFF_LINES = 200
$REDACT_PATTERN = '(api[_-]?key|token|secret|password|authorization)=?[A-Za-z0-9_\-]+'

# --- GET DIFF ---
$DIFF = git diff --cached

if ([string]::IsNullOrWhiteSpace($DIFF)) {
    Write-Host "`u{274C} No staged files"
    exit 1
}

# --- REDACT SECRETS ---
$SAFE_DIFF = [regex]::Replace($DIFF, $REDACT_PATTERN, "[REDACTED]", "IgnoreCase")

# --- LIMIT SIZE ---
$SAFE_DIFF = ($SAFE_DIFF -split "`n") | Select-Object -First $MAX_DIFF_LINES
$SAFE_DIFF = $SAFE_DIFF -join "`n"

# --- CONSENT CHECK ---
if ($env:SMART_COMMIT_ENABLED -ne "true") {
    Write-Host "`u{26A0}`u{FE0F} Sending to Claude API is disabled by default for security."
    Write-Host "Enable with: `$env:SMART_COMMIT_ENABLED = 'true'"
    exit 1
}

Write-Host "`u{1F916} Generating commit message..."

# --- PROMPT ---
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
$SAFE_DIFF
"@

# --- CALL CLAUDE ---
$MSG = $PROMPT | claude

# --- CLEAN OUTPUT ---
$MSG = $MSG -replace "`r", ""
$MSG = $MSG.Trim()

if ([string]::IsNullOrWhiteSpace($MSG)) {
    Write-Host "`u{274C} Failed to generate commit message"
    exit 1
}

Write-Host "`u{1F4E6} $MSG"

# --- COMMIT ---
git commit -m "$MSG"

Write-Host "`u{2705} Committed"