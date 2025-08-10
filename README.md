# SDD (Spec-Driven Development)

Create a specification-driven development model to achieve semi-automated coding with LLMs while preserving quality and security.

## What is SDD?

SDD is a methodology for AI-assisted software development that uses formal specifications to orchestrate human architects and AI agents in an "Assembly Line" model:

- **Human Architect** - Defines strategic vision and requirements
- **AI Agents** - Handle research, security, implementation, and validation
- **Claude Code Integration** - Native slash commands and sub-agents
- **Quality Gates** - Only validated work proceeds to the next stage

## Quick Start

### Prerequisites

- **Claude Code** - [Install from claude.ai/code](https://claude.ai/code)
- **Bash 4.0+** and **curl** for installation

### Installation

Choose one method:

**Method 1: One-line install (Recommended)**
```bash
curl -sSL https://raw.githubusercontent.com/kpiteira/spec-driven-development/main/remote-install.sh | bash
```

**Method 2: Secure install (Review scripts before execution)**
```bash
curl -sSL https://raw.githubusercontent.com/kpiteira/spec-driven-development/main/remote-install.sh -o install-sdd.sh
# Review the script contents for security
cat install-sdd.sh
# Run installation after review
bash install-sdd.sh
```

**Method 3: Git clone**
```bash
git clone https://github.com/kpiteira/spec-driven-development.git
cd spec-driven-development
./install.sh
```

### Verify Installation

```bash
# Check templates
ls ~/.sdd/templates/
# Should show: 6 template files

# Check Claude Code commands
ls ~/.claude/commands/init_*
# Should show: init_greenfield.md

# Test in Claude Code
claude
/help  # Should show SDD commands
```

### Your First Project

1. **Create project directory**
   ```bash
   mkdir my-awesome-project
   cd my-awesome-project
   claude
   ```

2. **Initialize with SDD**
   ```
   /init_greenfield "My Awesome Project"
   ```

3. **Follow the guided workflow** - Claude will help you create:
   - Project Vision (`specs/0_Project_Vision.md`)
   - Requirements (`specs/1_Product_Requirements.md`) 
   - Architecture (`specs/2_Architecture.md`)
   - Roadmap (`specs/3_Roadmap.md`)

4. **Plan your first milestone**
   ```
   /plan_milestone M1
   ```

## How SDD Works

### The Specification Hierarchy

```
Project/
├── specs/
│   ├── 0_Project_Vision.md      # Strategic goals and purpose
│   ├── 1_Product_Requirements.md # What needs to be built
│   ├── 2_Architecture.md        # How it will be built  
│   ├── 3_Roadmap.md            # When it will be built
│   ├── milestones/             # Detailed milestone plans
│   └── tasks/                  # Atomic work units
└── .task_bundles/              # Agent workspaces
```

### The Assembly Line Process

Each task follows this workflow:

1. **Bundler Agent** - Researches context and prevents hallucination
2. **Security Consultant** - Provides proactive security guidance  
3. **Coder Agent** - Implements using TDD principles
4. **Validator Agent** - Ensures quality and completeness

### Available Commands

| Command | Purpose | Example |
|---------|---------|---------|
| `/init_greenfield` | Start new project | `/init_greenfield "E-commerce Site"` |
| `/plan_milestone` | Plan milestone execution | `/plan_milestone M1-Foundation` |

## Example Projects

**Web Application:**
```bash
mkdir portfolio-site && cd portfolio-site && claude
/init_greenfield "Professional Portfolio Website"
# Follow guided setup for responsive portfolio with project showcase
```

**API Project:**
```bash
mkdir user-api && cd user-api && claude  
/init_greenfield "User Management API"
# Create RESTful API with authentication and documentation
```

**Mobile App:**
```bash
mkdir fitness-tracker && cd fitness-tracker && claude
/init_greenfield "Personal Fitness Tracker"
# Build cross-platform mobile app with offline sync
```

## Key Benefits

- 🚀 **Faster Development** - AI handles research and boilerplate
- 🛡️ **Built-in Security** - Security consultant reviews every task
- 📋 **Complete Documentation** - Specifications stay current with code
- ✅ **Quality Assured** - TDD and validation gates ensure reliability
- 🔄 **Consistent Process** - Standardized workflow for all projects

## Architecture

SDD leverages Claude Code's native features:

- **Templates** (`~/.sdd/templates/`) - Global specification templates
- **Commands** (`~/.claude/commands/`) - SDD slash commands  
- **Agents** (`~/.claude/agents/`) - Specialized sub-agents
- **File-based State** - No external dependencies or APIs

## Troubleshooting

**Common Issues:**

- **"Command not found"** - Restart Claude Code after installation
- **"Permission denied"** - Check file permissions, never use `sudo`
- **"Templates missing"** - Run installation verification above

For detailed troubleshooting, see [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## Development

**Project Structure:**
```
spec-driven-development/
├── install.sh              # Local installation script
├── remote-install.sh        # Curl-based installation
├── specs/templates/         # Global SDD templates
├── .claude/                # Claude Code integration
│   ├── commands/           # SDD slash commands
│   └── agents/             # SDD sub-agents
├── tests/                  # Installation and workflow tests
├── reports/                # Generated test reports (auto-created, not in git)
└── project_sdd_on_claude/  # SDD applied to itself
```

**Running Tests:**
```bash
# Test installation method comparison (git clone vs curl)
./tests/test-installation.sh

# Test complete user journey from install to first project
./tests/test-end-to-end.sh

# Verify installation security practices and compliance
./tests/verify-installation-security.sh
```

> **Note:** Tests generate reports in the `reports/` directory. These are transient artifacts and are not committed to git.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Follow SDD methodology for your changes:
   - Update relevant specifications first
   - Use the task blueprint process
   - Ensure all tests pass
4. Submit a pull request

## License

[Add your license here]

## Support

- **Issues**: [GitHub Issues](https://github.com/kpiteira/spec-driven-development/issues)
- **Discussions**: [GitHub Discussions](https://github.com/kpiteira/spec-driven-development/discussions)
- **Documentation**: This README + [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

---

**Ready to build better software with AI? Start with `/init_greenfield` today! 🚀**