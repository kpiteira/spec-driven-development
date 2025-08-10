---
id: SAMPLE-CLI-001
title: "Create /help command for displaying available SDD commands and usage"
milestone_id: "M1-Project-Initialization"
requirement_id: "REQ-001"
slice: "Slice 1: Basic CLI Command Infrastructure"
status: "pending"
branch: "feature/SAMPLE-CLI-001-help-command"
---

## 1. Task Overview & Goal

**What it is:** Create the `.claude/commands/help.md` file that contains a comprehensive help system to display all available SDD commands, their usage patterns, and examples. This sample demonstrates the fundamental pattern of creating Claude Code slash commands for the SDD system.

**Context:** This sample blueprint illustrates how to create user-facing CLI commands that provide information and guidance. It represents a common development scenario where you need to build help documentation and command discovery functionality that integrates with the platform's native capabilities.

**Goal:** Build a structured help command that demonstrates proper Claude Code command creation, information organization, and user experience design. This sample shows how to create commands that enhance system usability without requiring complex logic or external dependencies.

---

## 2. The Contract: Requirements & Test Cases

**What it is:** The specific, testable requirements for creating a help command that demonstrates CLI command development patterns in the SDD methodology.

* **Behavior 1: Proper Command File Structure**
  * **Given:** The command file is created as `.claude/commands/help.md`
  * **When:** Claude Code scans for available commands
  * **Then:** The command must be discoverable and properly formatted with valid YAML frontmatter
  * **And:** Frontmatter must include appropriate model selection, clear description, and minimal required tools
  * **And:** The command structure must follow SDD command creation patterns

* **Behavior 2: Comprehensive Help Content Generation**
  * **Given:** A user executes `/help` in any SDD project
  * **When:** The help command runs
  * **Then:** It must display all available SDD commands with descriptions and usage examples
  * **And:** Help content must be organized by functional categories (initialization, execution, validation)
  * **And:** Each command entry must include purpose, basic usage, and example scenarios
  * **And:** The help system must be self-updating based on available commands in the workspace

* **Behavior 3: User Experience and Error Handling**
  * **Given:** The help command is executed with various scenarios
  * **When:** Different usage patterns are attempted
  * **Then:** The command must handle requests for specific command help gracefully
  * **And:** Invalid command names must result in helpful error messages with suggestions
  * **And:** The help display must be formatted for easy reading and navigation
  * **And:** Command examples must be copy-pasteable and immediately usable

* **Behavior 4: SDD Integration and Consistency**
  * **Given:** The help command is part of the SDD system
  * **When:** Help content is generated
  * **Then:** All SDD methodology terminology must be used consistently
  * **And:** Command descriptions must align with SDD architectural principles
  * **And:** Help content must reference appropriate specification documents for detailed guidance
  * **And:** The help system must integrate with project detection to show relevant commands only

---

## 3. Context Bundle (Agent-Populated Sibling Files)

**What it is:** Context files that will be provided by other agents for this task.

* **`bundle_architecture.md`:** Claude Code command creation patterns and best practices, SDD command organizational structure and naming conventions, help system design patterns for CLI tools, and user experience guidelines for command-line interfaces
* **`bundle_security.md`:** Input validation patterns for command arguments, secure command execution practices, protection against command injection in help displays, and safe file system operations for command discovery
* **`bundle_code_context.md`:** Existing SDD command examples and their structure, Claude Code frontmatter requirements and formatting, help system implementation patterns from similar CLI tools, and command discovery mechanisms available in Claude Code platform

---

## 4. Verification Context

**What it is:** Guidance for validating this task's completion.

* **Unit Test Scope:** The Validator Agent must verify that the help command file follows proper Claude Code command format, validates YAML frontmatter compliance, and tests help content generation logic for accuracy and completeness
* **Integration Test Scope:** The Validator Agent must test help command execution in different project contexts, verify command discovery functionality works correctly, and validate that help content updates appropriately when new commands are added
* **User Experience Test Scope:** The Validator Agent must verify help output readability and formatting, test error handling for invalid command requests, and confirm that all displayed examples are valid and executable
* **Project-Wide Checks:** The Validator Agent must ensure the help command integrates properly with existing SDD infrastructure, maintains consistency with other command implementations, and follows project documentation standards