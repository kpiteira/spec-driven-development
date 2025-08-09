# SDD System Troubleshooting Guide

**Purpose of this document:** This comprehensive troubleshooting guide helps users diagnose and resolve common issues with SDD system installation, configuration, and usage.

---

## Table of Contents

1. [Installation Issues](#1-installation-issues)
2. [Command Recognition Problems](#2-command-recognition-problems)
3. [File Permission Errors](#3-file-permission-errors)
4. [Network and Download Issues](#4-network-and-download-issues)
5. [Claude Code Integration Problems](#5-claude-code-integration-problems)
6. [Template and Document Issues](#6-template-and-document-issues)
7. [Diagnostic Tools](#7-diagnostic-tools)
8. [Getting Support](#8-getting-support)

---

## 1. Installation Issues

### Issue: "curl: command not found"

**Symptoms:**
```bash
$ curl -sSL [URL] | bash
bash: curl: command not found
```

**Diagnosis:** curl is not installed on your system.

**Solutions by Platform:**

**macOS:**
```bash
# Using Homebrew (recommended)
brew install curl

# Using MacPorts
sudo port install curl

# Verify installation
curl --version
```

**Ubuntu/Debian:**
```bash
sudo apt-get update
sudo apt-get install curl

# Verify installation
curl --version
```

**CentOS/RHEL/Fedora:**
```bash
# RHEL/CentOS
sudo yum install curl

# Fedora
sudo dnf install curl

# Verify installation
curl --version
```

**Windows:**
```bash
# Install Git for Windows (includes curl)
# Download from: https://git-scm.com/download/win

# Or use Windows Subsystem for Linux (WSL)
wsl --install
```

### Issue: "Bash version too old"

**Symptoms:**
```
Error: Bash 4.0+ required, found 3.2.57
```

**Diagnosis:** Your system has an older version of Bash.

**Solutions:**

**macOS (common issue):**
```bash
# Install newer bash via Homebrew
brew install bash

# Add to /etc/shells
echo $(brew --prefix)/bin/bash | sudo tee -a /etc/shells

# Change your default shell
chsh -s $(brew --prefix)/bin/bash

# Verify (restart terminal first)
bash --version
```

**Linux:**
```bash
# Usually not needed, but to update:
sudo apt-get install bash  # Ubuntu/Debian
sudo yum update bash       # RHEL/CentOS
```

### Issue: "Templates directory not created"

**Symptoms:**
```
Error: Templates directory not found: /Users/username/.sdd/templates
Installation verification failed
```

**Diagnosis:** Installation failed to create directory structure.

**Solutions:**

**Check disk space:**
```bash
df -h ~
# Ensure you have at least 50MB free
```

**Check home directory permissions:**
```bash
ls -la ~ | head -5
# Verify you own your home directory
```

**Manual directory creation:**
```bash
mkdir -p ~/.sdd/templates
mkdir -p ~/.claude/{commands,agents}
chmod 755 ~/.sdd ~/.claude ~/.claude/commands ~/.claude/agents

# Re-run installation
./install.sh
```

**Alternative installation location:**
```bash
export TEST_HOME=/tmp/sdd-test
./install.sh
# Then manually copy files to proper locations
```

### Issue: "Installation verification failed"

**Symptoms:**
```
Installation verification failed
No template files found in /Users/username/.sdd/templates
```

**Diagnosis:** Files were not copied correctly during installation.

**Solutions:**

**Check what was actually installed:**
```bash
find ~/.sdd ~/.claude/commands ~/.claude/agents -name "*.md" -ls
```

**Verify file permissions:**
```bash
ls -la ~/.sdd/templates/
# Files should be readable (644 permissions)
```

**Manual verification and repair:**
```bash
# Count expected files
echo "Expected templates: 6"
ls ~/.sdd/templates/*.md | wc -l

echo "Expected commands: 2-3"
ls ~/.claude/commands/*.md | wc -l

echo "Expected agents: 3"
ls ~/.claude/agents/*.md | wc -l

# If counts are wrong, re-run installation:
./install.sh
```

---

## 2. Command Recognition Problems

### Issue: "/init_greenfield command not found"

**Symptoms:**
```
/init_greenfield "My Project"
Command not found or not available
```

**Diagnosis:** Claude Code cannot find the SDD commands.

**Solutions:**

**Verify command installation:**
```bash
ls -la ~/.claude/commands/init_*
# Should show: init_greenfield.md
```

**Check command file format:**
```bash
head -10 ~/.claude/commands/init_greenfield.md
# Should show YAML frontmatter with description field
```

**Restart Claude Code:**
```bash
# Exit Claude Code and restart
# Commands are loaded on session start
```

**Verify Claude Code configuration:**
```bash
# Check if .claude directory exists in project
ls -la .claude/

# Create if missing
mkdir -p .claude

# Verify global commands are accessible
claude --help | grep init_greenfield
```

### Issue: "Commands appear but don't work"

**Symptoms:**
```
/init_greenfield "Test"
Error: Command failed to execute properly
```

**Diagnosis:** Command files may be corrupted or have syntax errors.

**Solutions:**

**Validate command file syntax:**
```bash
# Check for YAML frontmatter syntax
head -20 ~/.claude/commands/init_greenfield.md

# Look for required fields:
# description: "..."
# argument-hint: "[...]"
```

**Re-download command files:**
```bash
# Backup current commands
cp ~/.claude/commands/init_greenfield.md ~/.claude/commands/init_greenfield.md.backup

# Re-install
./install.sh

# Compare files
diff ~/.claude/commands/init_greenfield.md.backup ~/.claude/commands/init_greenfield.md
```

**Check file permissions:**
```bash
chmod 644 ~/.claude/commands/*.md
```

---

## 3. File Permission Errors

### Issue: "Permission denied writing to ~/.sdd"

**Symptoms:**
```
mkdir: /Users/username/.sdd/templates: Permission denied
Failed to create templates directory
```

**Diagnosis:** Insufficient permissions on home directory or disk full.

**Solutions:**

**Check and fix home directory ownership:**
```bash
# Check current ownership
ls -la ~ | head -5

# Fix ownership if needed (replace 'username' with your username)
sudo chown -R username:username ~

# Alternative: use different user's home directory
whoami  # Verify your actual username
```

**Check disk space:**
```bash
df -h ~
# Ensure adequate free space
```

**Try installation to temporary location:**
```bash
export TEST_HOME=/tmp
./install.sh
# Then manually copy files if successful
```

### Issue: "Cannot write to .claude/commands"

**Symptoms:**
```
cp: /Users/username/.claude/commands/init_greenfield.md: Permission denied
```

**Diagnosis:** .claude directory has incorrect permissions.

**Solutions:**

**Fix .claude directory permissions:**
```bash
# Check current permissions
ls -la ~/.claude/

# Fix permissions
chmod 755 ~/.claude ~/.claude/commands ~/.claude/agents
chmod 644 ~/.claude/commands/*.md ~/.claude/agents/*.md
```

**Recreate .claude directory:**
```bash
# Remove and recreate (BE CAREFUL - this removes all Claude Code config)
rm -rf ~/.claude
mkdir -p ~/.claude/{commands,agents}

# Re-run installation
./install.sh
```

---

## 4. Network and Download Issues

### Issue: "curl: Failed to connect"

**Symptoms:**
```
curl: (7) Failed to connect to raw.githubusercontent.com port 443: Connection refused
```

**Diagnosis:** Network connectivity issues or firewall blocking.

**Solutions:**

**Test basic connectivity:**
```bash
# Test general internet
ping -c 4 8.8.8.8

# Test GitHub specifically
curl -I https://github.com
```

**Check firewall/proxy settings:**
```bash
# Check if behind corporate proxy
echo $HTTP_PROXY $HTTPS_PROXY

# Try with proxy if needed
curl -sSL --proxy [proxy-url] [installation-url] | bash
```

**Use alternative download method:**
```bash
# Try wget instead of curl
wget -O- https://raw.githubusercontent.com/[USER]/[REPO]/v1.0.0/remote-install.sh | bash

# Or download manually
curl -sSL [URL] -o install-script.sh
bash install-script.sh
```

### Issue: "SSL certificate verification failed"

**Symptoms:**
```
curl: (60) SSL certificate problem: unable to get local issuer certificate
```

**Diagnosis:** SSL certificate issues.

**Solutions:**

**Update certificates:**
```bash
# macOS
brew install ca-certificates

# Ubuntu/Debian
sudo apt-get update && sudo apt-get install ca-certificates

# CentOS/RHEL
sudo yum update ca-certificates
```

**Temporary workaround (NOT recommended for production):**
```bash
curl -sSL -k [URL] | bash  # -k bypasses SSL verification
```

### Issue: "Download interrupted or incomplete"

**Symptoms:**
```
curl: (18) transfer closed with outstanding read data remaining
Installation failed: Checksum verification failed
```

**Diagnosis:** Network interruption during download.

**Solutions:**

**Retry with better error handling:**
```bash
curl -sSL --retry 3 --retry-delay 2 --max-time 30 [URL] | bash
```

**Download and verify manually:**
```bash
# Download to file first
curl -sSL [URL] -o sdd-install.sh

# Check file size and contents
ls -la sdd-install.sh
head -10 sdd-install.sh

# Execute if looks correct
bash sdd-install.sh
```

---

## 5. Claude Code Integration Problems

### Issue: "Claude Code not found"

**Symptoms:**
```
claude: command not found
```

**Diagnosis:** Claude Code is not installed or not in PATH.

**Solutions:**

**Install Claude Code:**
1. Visit [https://claude.ai/code](https://claude.ai/code)
2. Follow installation instructions for your platform
3. Restart terminal/shell

**Check PATH:**
```bash
echo $PATH
# Should include Claude Code installation directory

# Find Claude Code installation
which claude
whereis claude
```

**Update PATH if needed:**
```bash
# Add to ~/.bashrc, ~/.zshrc, or appropriate shell config
export PATH="$PATH:/path/to/claude/bin"

# Reload shell configuration
source ~/.bashrc  # or ~/.zshrc
```

### Issue: "Claude Code starts but commands missing"

**Symptoms:**
```
claude
# Claude Code interface appears
/help
# SDD commands not listed
```

**Diagnosis:** Commands not properly installed or Claude Code not finding them.

**Solutions:**

**Verify installation location:**
```bash
# Check if commands are in project .claude directory
ls -la .claude/commands/

# Check if commands are in home .claude directory
ls -la ~/.claude/commands/
```

**Force command refresh:**
```bash
# Exit and restart Claude Code
# Or create new session in same directory
cd . && claude
```

**Check command file validity:**
```bash
# Ensure valid YAML frontmatter
grep -A 5 "^---$" ~/.claude/commands/init_greenfield.md
```

---

## 6. Template and Document Issues

### Issue: "Template files missing or empty"

**Symptoms:**
```
ls ~/.sdd/templates/
# Directory exists but no files, or files are empty
```

**Diagnosis:** Template download or installation failed.

**Solutions:**

**Check installation logs:**
```bash
# Look for installation logs
find /tmp -name "sdd-install*.log" -mtime -1

# Review log contents
tail -50 [log-file]
```

**Manual template download:**
```bash
# Download templates individually
mkdir -p ~/.sdd/templates
cd ~/.sdd/templates

# Download each template (replace URL with actual repository)
curl -sSL [REPO]/raw/main/specs/templates/0_Project_Vision_Template.md -o 0_Project_Vision_Template.md
# Repeat for other templates
```

**Verify template structure:**
```bash
# Check template frontmatter
head -10 ~/.sdd/templates/0_Project_Vision_Template.md
# Should show version information and template metadata
```

### Issue: "Templates don't have version information"

**Symptoms:**
```
Warning: File missing version in frontmatter: 0_Project_Vision_Template.md
```

**Diagnosis:** Templates are from older version or corrupted during download.

**Solutions:**

**Check template version:**
```bash
head -15 ~/.sdd/templates/0_Project_Vision_Template.md
# Look for:
# ---
# version: "1.0.0"
# template_type: "..."
# ---
```

**Re-download latest templates:**
```bash
# Force re-download of templates
rm ~/.sdd/templates/*.md
./install.sh
```

---

## 7. Diagnostic Tools

### System Information Script

Create a diagnostic script to gather system information:

```bash
#!/bin/bash
# SDD System Diagnostic Script

echo "=== SDD System Diagnostic ==="
echo "Date: $(date)"
echo

echo "=== System Information ==="
uname -a
echo "Shell: $SHELL"
bash --version | head -1
echo

echo "=== Tool Availability ==="
command -v curl && curl --version | head -1
command -v git && git --version
command -v claude && claude --version 2>/dev/null || echo "Claude Code not found"
echo

echo "=== Installation Status ==="
echo "Templates directory:"
ls -la ~/.sdd/templates/ 2>/dev/null || echo "Not found"

echo -e "\nCommands directory:"
ls -la ~/.claude/commands/init_* 2>/dev/null || echo "No SDD commands found"

echo -e "\nAgents directory:"
ls -la ~/.claude/agents/*specialist* 2>/dev/null || echo "No SDD agents found"

echo -e "\n=== File Counts ==="
echo "Templates: $(find ~/.sdd/templates -name "*.md" 2>/dev/null | wc -l)"
echo "Commands: $(find ~/.claude/commands -name "init_*.md" -o -name "plan_*.md" 2>/dev/null | wc -l)"
echo "Agents: $(find ~/.claude/agents -name "*specialist*.md" 2>/dev/null | wc -l)"

echo -e "\n=== Version Information ==="
if [[ -f ~/.sdd/templates/0_Project_Vision_Template.md ]]; then
    echo "Template version:"
    head -10 ~/.sdd/templates/0_Project_Vision_Template.md | grep "version:"
else
    echo "No templates found for version check"
fi

echo -e "\n=== Disk Space ==="
df -h ~ | head -2

echo -e "\n=== Network Connectivity ==="
curl -sSL --max-time 10 -I https://github.com >/dev/null 2>&1 && echo "✓ GitHub accessible" || echo "✗ GitHub not accessible"
```

Save as `diagnose-sdd.sh` and run:
```bash
chmod +x diagnose-sdd.sh
./diagnose-sdd.sh
```

### Installation Verification Script

Use the existing test script to verify installation:

```bash
# Run full installation test
./test-installation.sh

# Quick verification
ls ~/.sdd/templates/*.md ~/.claude/commands/init_* ~/.claude/agents/*specialist*
```

### Claude Code Command Test

```bash
# Test Claude Code command discovery
claude << 'EOF'
/help
EOF

# Test SDD command execution (in an actual Claude Code session)
# /init_greenfield "Test Project"
```

---

## 8. Getting Support

### Before Seeking Help

1. **Run diagnostics:**
   ```bash
   ./diagnose-sdd.sh > sdd-diagnostic.txt
   ```

2. **Gather error messages:**
   - Full error output from installation
   - Claude Code error messages
   - System logs if relevant

3. **Try basic solutions:**
   - Restart terminal/shell
   - Re-run installation
   - Check file permissions

### When to Create a GitHub Issue

Create an issue on the SDD repository when you have:

- **Reproducible bugs** - Issues that happen consistently
- **Installation failures** on supported platforms
- **Documentation problems** - Unclear or incorrect instructions
- **Feature requests** - Suggestions for improvements

### Issue Template

```markdown
## Problem Description
Brief description of the issue

## System Information
- OS: [macOS 13.5 / Ubuntu 22.04 / Windows 11 WSL]
- Shell: [bash 5.2 / zsh 5.9]  
- Claude Code version: [output of `claude --version`]

## Steps to Reproduce
1. Step one
2. Step two
3. Step three

## Expected Behavior
What you expected to happen

## Actual Behavior
What actually happened

## Error Messages
```
Full error output here
```

## Diagnostic Output
```
Output from ./diagnose-sdd.sh
```

## Additional Context
Any other relevant information
```

### Community Support

- **GitHub Discussions** - For general questions and community help
- **Discord/Slack** - Real-time community support (if available)
- **Stack Overflow** - Tag questions with `sdd` and `claude-code`

### Emergency Workarounds

If you need to get working quickly while waiting for support:

**Manual installation:**
```bash
# Create directories
mkdir -p ~/.sdd/templates ~/.claude/{commands,agents}

# Download files individually (replace URLs with actual repository)
# Templates
curl -sSL [REPO]/raw/main/specs/templates/0_Project_Vision_Template.md -o ~/.sdd/templates/0_Project_Vision_Template.md
# ... repeat for other files

# Commands  
curl -sSL [REPO]/raw/main/.claude/commands/init_greenfield.md -o ~/.claude/commands/init_greenfield.md
# ... repeat for other files

# Agents
curl -sSL [REPO]/raw/main/.claude/agents/architecture-specialist.md -o ~/.claude/agents/architecture-specialist.md
# ... repeat for other files
```

**Alternative tools:**
- Use `wget` instead of `curl`
- Download files via web browser if command line fails
- Use git clone method instead of curl installation

---

## Security Note: Never Use Sudo

**⚠️ Important Security Reminder:** The SDD installation system is designed to work entirely within user permissions and should **never require `sudo` or elevated privileges**. 

If you encounter permission errors:
1. ✅ **Do:** Check file ownership and permissions as shown above
2. ✅ **Do:** Use alternative installation locations if needed
3. ✅ **Do:** Fix home directory ownership issues
4. ❌ **Never do:** Run `sudo ./install.sh` or `sudo bash install-script.sh`

Using sudo with installation scripts poses security risks and is not supported by the SDD system.

---

**Remember:** Most issues are solvable with basic troubleshooting. When in doubt, start with the diagnostic script and check the most common causes first.

---

**Troubleshooting Guide Version:** 1.0.0  
**Last Updated:** $(date)  
**Compatible with:** SDD System v1.0.0+