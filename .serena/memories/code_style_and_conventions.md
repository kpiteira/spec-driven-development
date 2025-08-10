# Code Style and Conventions

## File Naming Conventions

### System Documentation
- **Format**: `NN_SYSTEM_Topic.md` (where NN is 00-99)
- **Examples**: `00_SYSTEM_Vision.md`, `01_SYSTEM_How_It_Works.md`
- **Immutable**: These are nearly immutable, only change for strategic pivots

### Templates  
- **Format**: `N_Type_Template.md` (where N is 0-5)
- **Examples**: `0_Project_Vision_Template.md`, `5_Task_Blueprint_Template.md`
- **Purpose**: Standardized templates for all specification documents

### Project Implementation
- **Format**: Match template naming but remove `_Template` suffix
- **Examples**: `0_Project_Vision.md`, `2_Architecture.md`
- **Evolution**: Requirements are living documents, Architecture evolves with ADRs

### Task Blueprints
- **Format**: `TASK-NNN_Description.md` (where NNN is 001-999)
- **Examples**: `TASK-007_Create_Bundler_Agent.md`
- **Atomic**: Each task should be atomic and testable

## Document Structure Standards

### YAML Frontmatter (Required)
```yaml
---
version: "1.0.0"
description: "Brief description"
created: "YYYY-MM-DD"
updated: "YYYY-MM-DD"
---
```

### Required Fields for Command Files
- `description:` field is mandatory for all Claude Code commands
- Version field required for version management
- Proper markdown structure with headers

## Content Conventions

### Documentation Style
- **Concrete Examples**: Use concrete examples rather than abstract descriptions
- **Mermaid Diagrams**: Use for visualizing workflows and architecture
- **Template Consistency**: Follow established document templates
- **Specification Hierarchy**: Maintain top-down flow (changes flow from vision → requirements → architecture → tasks)

### Code Examples
- When showing code examples, use appropriate language identifiers:
  ```python
  # Python examples
  ```
  
  ```bash
  # Shell script examples
  ```

## Security Requirements

### File Permissions
- **Documentation files**: 644 (readable by all, writable by owner)
- **Script files**: 755 (executable by all, writable by owner)
- **Directory permissions**: 755

### Path Validation
- All installation scripts implement path traversal protection
- Validate paths before file operations
- Use realpath for absolute path resolution

## Version Management

### Semantic Versioning
- Use semantic versioning (major.minor.patch)
- Version comparison implemented in installation scripts
- Prevents accidental downgrades during installation

### Installation Behavior
- Only install files with newer or equal versions
- Log version changes during installation
- Skip downgrades with warning messages

## Error Handling Standards

### Bash Scripts
```bash
set -euo pipefail  # Exit on error, undefined vars, pipe failures
```

### Logging Functions
```bash
log_info() { echo -e "${GREEN}[INFO]${NC} $*"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }  
log_error() { echo -e "${RED}[ERROR]${NC} $*" >&2; }
log_debug() { echo -e "${BLUE}[DEBUG]${NC} $*"; }
```

## File Content Guidelines

### No Executable Code
- This repository contains **no source code to build or test**
- All "development" work involves editing Markdown specification documents
- Templates should be updated to reflect methodology improvements

### Template Updates
- Update templates based on methodology improvements
- Maintain consistency across specification hierarchy
- Ensure examples demonstrate methodology effectively