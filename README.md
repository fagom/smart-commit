# ⚡ smart-commit

Generate high-quality git commit messages using AI based on your staged changes.

---

![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)

## 🚀 What is this?

**smart-commit** is a lightweight Claude skill + script that:

- Analyzes your **staged git changes**
- Generates a **clean, conventional commit message**
- Optionally commits automatically

### ⚠️ SECURITY & PRIVACY

**This tool sends your staged code to Claude API.** It is designed for open-source and non-sensitive codebases only.

**Do NOT use if your code contains:**
- Secrets, API keys, or authentication tokens
- Proprietary business logic
- Classified or sensitive information
- Personally identifiable information (PII)

The tool includes secret redaction for common patterns (API keys, tokens, passwords), but it **cannot catch all sensitive data**. Always review your staged changes before running this tool.

It helps you avoid vague commits like:

```bash
update stuff
fix bugs
changes
```

And replaces them with:

```bash
feat(auth): add JWT token refresh logic
fix(api): handle null response in user endpoint
refactor(db): simplify query builder logic
```

---

## 🧠 How it works

```text
git diff --cached
        ↓
Claude (with smart-commit skill)
        ↓
Generates commit message
        ↓
git commit
```

> ⚠️ Important: Claude does NOT read your repo automatically. The script pipes your staged diff into Claude.

---

## 📦 Requirements

- Git
- Claude CLI installed and authenticated
- Node.js (for npx)
- Bash (macOS/Linux) or PowerShell (Windows)

---

## ⚙️ Installation

### ✅ Recommended: Install via `npx`

```bash
npx skills add fagom/smart-commit
```

This will:

- Download the repo
- Install `skill.md` into your local Claude skills directory

---

### 📥 Install scripts

```bash
git clone https://github.com/fagom/smart-commit.git
cd smart-commit
```

---

### 🛠 Make script executable (Mac/Linux)

```bash
chmod +x scripts/ai-commit.sh
```

---

### 🧰 Manual skill install (fallback)

If `npx` is not available:

```bash
mkdir -p ~/.claude/skills
cp skill.md ~/.claude/skills/smart-commit.md
```

---

## ⚙️ Enable the Skill (One-Time Setup)

For security, smart-commit requires explicit opt-in before sending code to Claude API:

### Bash/macOS/Linux

```bash
export SMART_COMMIT_ENABLED=true
```

### PowerShell/Windows

```powershell
$env:SMART_COMMIT_ENABLED = 'true'
```

**Note:** Without this, the script will refuse to run and show an error. This is intentional to prevent accidental data exposure.

---

## ▶️ Usage

### 1. Stage your changes

```bash
git add .
```

---

### 2. Run smart commit

```bash
./scripts/ai-commit.sh
```

---

### 💻 PowerShell (Windows)

```powershell
.\scripts\ai-commit.ps1
```

---

## 🧾 Example Output

```bash
feat(auth): add token refresh endpoint
```

---

## 🧩 Commit Format

Follows **Conventional Commits**:

```
<type>(<scope>): <summary>
```

### Types:

- feat
- fix
- refactor
- perf
- chore
- docs
- test

---

## ⚠️ Behavior Notes

- Only analyzes **staged changes**
- Will fail if nothing is staged
- Outputs **message only** (no extra text)
- Does NOT auto-stage files
- Requires diff to be passed from script

---

## 🔧 Customization

You can modify `skill.md` to:

- Enforce team commit conventions
- Add scopes (auth, api, ui, etc.)
- Control verbosity
- Add commit body rules

---

## 🚀 Roadmap Ideas

- [ ] Auto scope detection from folder structure
- [ ] Multi-line commit messages
- [ ] AI-powered code review + fix
- [ ] One-command workflow: review → fix → commit

---

## 🤝 Contributing

PRs and ideas welcome!

---

## 💡 Why this exists

Good commit messages are:

- hard to write
- often skipped
- critical for long-term maintainability

This tool makes them:

> fast, consistent, and automatic

---

## 🧠 Final Note

This is a simple but powerful pattern:

> **AI handles thinking → scripts handle execution**

---

## 📄 License

MIT
