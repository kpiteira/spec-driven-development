---
id: TASK-007
title: "Create .claude/agents/bundler.md sub-agent with local codebase analysis capabilities using Serena MCP and bash commands"
milestone_id: "M2-Core-Execution"
requirement_id: "REQ-006"
slice: "Slice 2: MVP Bundler Agent with Local Context Analysis"
status: "completed"
branch: "feature/TASK-007-bundler-agent"
---

## 1. Task Overview & Goal

**What it is:** This task creates the MVP Bundler Agent as a Claude Code sub-agent that analyzes the local codebase to extract context for code generation. The Bundler Agent is responsible for creating comprehensive context bundles that enable the Coder Agent to generate high-quality code without hallucination.

**Context:** This is the first task in Slice 2 of the M2 milestone, establishing the foundation for context analysis and bundle creation. The Bundler Agent is a critical component in the SDD assembly line pattern, serving as the bridge between task blueprints and code generation by providing comprehensive, accurate context.

**Goal:** Create a sub-agent file (`.claude/agents/bundler.md`) that can analyze local codebases using Serena MCP for semantic search and bash commands for file system operations, extracting relevant architectural rules, code patterns, and interface documentation needed for task implementation.

## 2. The Contract: Requirements & Test Cases

**What it is:** The specific, testable requirements for the Bundler Agent sub-agent implementation.

* **Behavior 1: Sub-Agent Configuration and Model Selection**
  * **Given:** The bundler.md file is created in `.claude/agents/`
  * **When:** The sub-agent is invoked
  * **Then:** It must use `claude-sonnet-4-20250514` model for cost-efficient information processing (per NFR-PERF-006)
  * **And:** It must include proper YAML frontmatter with description and allowed tools
  * **And:** It must operate with clean context isolation using Claude Code's Task tool

* **Behavior 2: Local Codebase Analysis Capabilities**
  * **Given:** A task blueprint exists in a task bundle
  * **When:** The Bundler Agent processes the bundle
  * **Then:** It must use Serena MCP for semantic code search to find relevant existing code
  * **And:** It must use bash commands for file system exploration and analysis
  * **And:** It must extract exact function signatures, class definitions, and API interfaces
  * **And:** It must identify similar implementations and patterns in the codebase

* **Behavior 3: Context Bundle File Creation**
  * **Given:** The Bundler Agent has analyzed the codebase
  * **When:** It completes its analysis
  * **Then:** It must create `bundle_architecture.md` with relevant architectural rules
  * **And:** It must create `bundle_code_context.md` with exact signatures and documentation
  * **And:** Context files must be comprehensive enough for code generation without additional research
  * **And:** All context must be accurate and avoid hallucination through grounding in actual codebase content

* **Behavior 4: Error Handling and Validation**
  * **Given:** The Bundler Agent encounters missing files or analysis failures
  * **When:** Errors occur during processing
  * **Then:** It must report specific, actionable error messages
  * **And:** It must fail gracefully without corrupting the task bundle
  * **And:** It must validate that required context files are created successfully

## 3. Context Bundle (Agent-Populated Sibling Files)

**What it is:** Context files that will be provided by other agents for this task.

* **`bundle_architecture.md`:** Architecture patterns for sub-agent creation, Claude Code sub-agent specifications, and file system conventions for agent organization
* **`bundle_security.md`:** Security considerations for local file system access, input validation requirements for processing task blueprints, and secure practices for bash command execution
* **`bundle_code_context.md`:** Existing sub-agent examples and patterns, Serena MCP integration patterns, bash command usage examples, and file handling interfaces for context bundle creation

## 4. Verification Context

**What it is:** Guidance for validating this task's completion.

* **Unit Test Scope:** The Validator Agent must verify that the bundler.md sub-agent file follows Claude Code sub-agent format specifications and includes all required YAML frontmatter fields
* **Integration Test Scope:** The Validator Agent must test sub-agent invocation through Claude Code's Task tool to ensure clean context isolation and proper model selection
* **Project-Wide Checks:** The Validator Agent must verify the sub-agent file location, naming conventions, and integration with the broader SDD system architecture as defined in the project specifications