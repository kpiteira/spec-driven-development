# Repository Structure and Tech Stack

## Tech Stack
- **Language**: Bash (for installation scripts), Markdown (for all specifications)
- **Platform**: Claude Code CLI integration
- **Dependencies**: bash 4.0+, curl (for installation)
- **No runtime dependencies**: Pure file-based system

## Repository Structure

```
spec-driven-development/
├── install.sh              # Local installation script
├── remote-install.sh        # Curl-based installation
├── specs/templates/         # Global SDD templates (6 files)
├── .claude/                # Claude Code integration (not in git, deployed)
│   ├── commands/           # SDD slash commands
│   └── agents/             # SDD sub-agents
├── tests/                  # Installation and workflow tests
├── reports/                # Generated test reports (auto-created, not in git)
├── project_sdd_on_claude/  # SDD applied to itself (complete example)
├── src/                    # Empty directory (no source code)
└── System docs (00-04_SYSTEM_*.md)
```

## Key Directories

### `/specs/templates/` - Core Templates (6 files)
- `0_Project_Vision_Template.md`
- `1_Product_Requirements_Template.md` 
- `2_Architecture_Template.md`
- `3_Roadmap_Template.md`
- `4_Milestone_Plan_Template.md`
- `5_Task_Blueprint_Template.md`

### `/project_sdd_on_claude/` - Complete Implementation Example
- Shows SDD methodology applied to building SDD system itself
- Contains complete specification hierarchy from vision to task blueprints
- Demonstrates proper file naming and template usage

### `/tests/` - Installation and Behavior Tests
- `test-installation.sh` - Installation method comparison
- `test-end-to-end.sh` - Complete user journey testing
- `test_bundler_agent_behavior_*.sh` - Agent behavior tests
- `context_extraction/` - Context extraction testing utilities

## File Naming Conventions
- System docs: `NN_SYSTEM_Topic.md`
- Templates: `N_Type_Template.md` 
- Project examples: Match template naming without `_Template` suffix
- Task blueprints: `TASK-NNN_Description.md`