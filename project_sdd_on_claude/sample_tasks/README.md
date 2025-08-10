# SDD Sample Task Blueprints

This directory contains sample task blueprints that demonstrate different development scenarios and serve as examples for Human Architects learning the SDD methodology.

## Blueprint Categories

### CLI Command Development
- **SAMPLE-CLI-001_Create_Help_Command.md**: Demonstrates creating Claude Code slash commands for user interaction and information display
- Shows proper command file structure, frontmatter requirements, and user experience design patterns

### Agent Development
- **SAMPLE-AGENT-001_Create_Formatter_Agent.md**: Demonstrates creating specialized sub-agents for code quality enhancement
- Shows sub-agent configuration, specialized task processing, and integration with the assembly line workflow

### Integration and Workflow
- **SAMPLE-INTEGRATION-001_Add_Logging_Integration.md**: Demonstrates adding cross-cutting concerns to existing workflows
- Shows workflow enhancement patterns, system integration approaches, and observability implementation

### Validation and Enhancement
- **SAMPLE-VALIDATION-001_Add_Performance_Testing.md**: Demonstrates enhancing validation pipelines with additional quality gates
- Shows validation enhancement patterns, performance measurement integration, and quality assurance improvements

## Usage Guidelines

### For Human Architects
- Use these samples as templates when creating new task blueprints
- Each sample demonstrates proper Given/When/Then behavior specification
- All samples follow exact SDD task blueprint template structure
- Reference these examples to understand contract writing and requirement specification

### For Testing and Validation
- These samples are designed to be executed through the complete SDD workflow
- Each blueprint includes realistic implementation requirements that can be fulfilled by the Coder Agent
- Use these samples to validate system functionality and identify workflow issues

### For Training and Education
- Study the behavior specification patterns used across different development scenarios
- Understand how context bundle requirements vary by task type
- Learn how verification context should be structured for different validation needs

## Blueprint Structure

All sample blueprints follow the standard SDD task blueprint template:

1. **YAML Frontmatter**: Contains task metadata, milestone/requirement references, and workflow configuration
2. **Task Overview & Goal**: Clear narrative description with context and objectives
3. **The Contract**: Behavioral requirements in Given/When/Then format with testable acceptance criteria
4. **Context Bundle**: Manifest of files to be provided by Bundler and Security Consultant agents
5. **Verification Context**: Guidance for Validator Agent on testing scope and requirements

## Implementation Notes

- All sample tasks are designed to work within Claude Code platform constraints
- No external dependencies or APIs are required
- File-based state management patterns are used throughout
- Each sample demonstrates realistic development scenarios appropriate for AI-assisted implementation

## Quality Standards

- All blueprints are validated for template compliance
- YAML frontmatter follows established patterns and naming conventions
- Behavioral requirements are specific and testable
- Context bundle requirements are achievable by bundling agents
- Verification guidance provides clear validation scope for each testing level