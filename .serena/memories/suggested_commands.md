# Suggested Commands for SDD Development

## Installation and Setup Commands

### Local Installation
```bash
# Git clone method
git clone https://github.com/kpiteira/spec-driven-development.git
cd spec-driven-development
./install.sh
```

### Remote Installation  
```bash
# One-line install (recommended)
curl -sSL https://raw.githubusercontent.com/kpiteira/spec-driven-development/main/remote-install.sh | bash

# Secure install (review first)
curl -sSL https://raw.githubusercontent.com/kpiteira/spec-driven-development/main/remote-install.sh -o install-sdd.sh
cat install-sdd.sh  # Review before execution
bash install-sdd.sh
```

## Verification Commands

### Installation Verification
```bash
# Check templates installed
ls ~/.sdd/templates/
# Should show: 6 template files

# Check Claude Code commands
ls ~/.claude/commands/init_*
# Should show: init_greenfield.md

# Test in Claude Code
claude
/help  # Should show SDD commands
```

## Testing Commands

### Run Test Suites
```bash
# Test installation method comparison (git clone vs curl)
./tests/test-installation.sh

# Test complete user journey from install to first project
./tests/test-end-to-end.sh

# Verify installation security practices and compliance
./tests/verify-installation-security.sh

# Test bundler agent behavior
./tests/test_bundler_agent_behavior_1.sh
./tests/test_bundler_agent_behavior_2.sh
./tests/test_bundler_agent_behavior_3.sh
./tests/test_bundler_agent_behavior_4.sh
```

## Development Commands

### File Operations
```bash
# List directory contents
ls -la

# Find files by pattern
find . -name "*.md" -type f

# Search content patterns  
grep -r "pattern" . --include="*.md"

# Change permissions (if needed)
chmod 644 filename.md
chmod 755 script.sh
```

### Git Operations
```bash
# Standard git workflow
git status
git add .
git commit -m "message"
git push origin main

# View recent commits
git log --oneline -10
```

## Claude Code Usage Commands

### SDD Workflow Commands (within Claude Code)
```bash
# Initialize new project
/init_greenfield "Project Name"

# Plan milestone execution
/plan_milestone M1

# Get help
/help
```

## System Information
- **Platform**: Darwin (macOS)
- **Shell**: bash 4.0+
- **Required tools**: curl, git, standard Unix utilities
- **No build/test commands**: This is a specification-only repository