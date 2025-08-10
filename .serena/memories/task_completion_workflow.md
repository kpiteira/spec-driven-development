# Task Completion Workflow

## Important: No Build/Test Commands

**CRITICAL**: This repository contains **NO EXECUTABLE CODE**. There are no build, test, lint, or compilation commands to run. All work involves editing Markdown specification documents.

## When a Task is Completed

### 1. Documentation Validation
Instead of code testing, validate documentation:

```bash
# Check for required YAML frontmatter
head -5 filename.md | grep -q "^---$"

# Verify version field exists
grep -q "^version:" filename.md

# Validate markdown structure
# (Manual review of headers, content structure)
```

### 2. Installation Testing (If Templates Changed)
If you modified templates or system files:

```bash
# Test local installation
./install.sh

# Verify installation
ls ~/.sdd/templates/
ls ~/.claude/commands/

# Run installation tests
./tests/test-installation.sh
```

### 3. Template Consistency Checks
Ensure template updates maintain consistency:

- Check that template changes follow established patterns
- Verify examples in `project_sdd_on_claude/` still match templates
- Maintain specification hierarchy (changes flow top-down)

### 4. Git Workflow
Standard git operations (no pre-commit hooks):

```bash
# Check status
git status

# Add changes  
git add .

# Commit with descriptive message
git commit -m "Update template: Add new field for security requirements"

# Push to remote
git push origin main
```

## Quality Gates

### Documentation Quality
- **Template Compliance**: New documents must follow templates in `specs/templates/`
- **Version Management**: All files must have proper YAML frontmatter with version
- **Consistency**: Changes must maintain specification hierarchy
- **Examples**: Concrete examples preferred over abstract descriptions

### File Structure Validation
- **Naming Conventions**: Follow established patterns (see code_style_and_conventions.md)
- **Directory Structure**: Maintain established directory organization
- **File Permissions**: Ensure proper permissions (644 for docs, 755 for scripts)

### Security Validation
- **Path Safety**: No path traversal vulnerabilities in scripts
- **Permission Safety**: No overly permissive file permissions
- **Content Safety**: No executable code in markdown files

## Error Recovery

### Common Issues and Solutions

**Missing Frontmatter**:
```bash
# Add YAML frontmatter to file
cat > temp_header.md << 'EOF'
---
version: "1.0.0"
description: "Brief description"
created: "$(date +%Y-%m-%d)"
updated: "$(date +%Y-%m-%d)"
---

EOF
cat existing_file.md >> temp_header.md
mv temp_header.md existing_file.md
```

**Template Inconsistencies**:
- Manually review template structure
- Compare with examples in `project_sdd_on_claude/`
- Update to match established patterns

## No Automated Testing

Unlike code projects, this specification repository has:
- **No unit tests** (no code to test)
- **No linting** (markdown content review is manual)
- **No compilation** (markdown files are directly usable)
- **No deployment** (installation scripts deploy templates)

The "testing" is primarily:
1. Installation script testing
2. Template validation
3. Documentation consistency review
4. Manual verification of Claude Code integration