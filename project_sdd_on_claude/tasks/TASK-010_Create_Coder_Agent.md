---
id: TASK-010
title: "Create .claude/agents/coder.md sub-agent with TDD-focused implementation logic"
milestone_id: "M2-Core-Execution"
requirement_id: "REQ-005"
slice: "Slice 3: Coder Agent and Code Generation Pipeline"
status: "pending"
branch: "feature/TASK-010-coder-agent"
---

## 1. Task Overview & Goal

**What it is:** This task creates the Coder Agent as a Claude Code sub-agent responsible for transforming task bundles into working code following Test-Driven Development (TDD) principles. The Coder Agent is the core implementation engine in the SDD assembly line pattern.

**Context:** This is the first task in Slice 3, beginning the implementation of code generation capabilities. The Coder Agent receives comprehensive context bundles from the Bundler Agent and must produce working, tested code that fulfills the task blueprint contract while adhering to architectural guidance.

**Goal:** Create a sub-agent file (`.claude/agents/coder.md`) that implements TDD-focused code generation logic, capable of creating failing tests first, then implementing code that makes tests pass, while ensuring architectural compliance and integration with existing codebase interfaces.

## 2. The Contract: Requirements & Test Cases

**What it is:** The specific, testable requirements for the Coder Agent sub-agent implementation.

* **Behavior 1: Sub-Agent Configuration and Model Selection**
  * **Given:** The coder.md file is created in `.claude/agents/`
  * **When:** The sub-agent is invoked
  * **Then:** It must use `claude-opus-4-1-20250805` model for superior code quality with curated context (per NFR-PERF-006)
  * **And:** It must include proper YAML frontmatter with description and allowed tools
  * **And:** It must operate with clean context isolation using Claude Code's Task tool
  * **And:** It must be configured to focus on creative code generation tasks

* **Behavior 2: Test-Driven Development Implementation**
  * **Given:** A complete task bundle with context files and task blueprint
  * **When:** The Coder Agent processes the bundle
  * **Then:** It must first generate failing unit tests that reflect the task blueprint contract (Given/When/Then behaviors)
  * **And:** It must create comprehensive tests covering all specified behaviors and edge cases
  * **And:** It must then implement code that makes all tests pass
  * **And:** Generated tests must be executable and follow project testing conventions

* **Behavior 3: Architectural Compliance and Context Integration**
  * **Given:** The task bundle contains `bundle_architecture.md` and `bundle_code_context.md`
  * **When:** The Coder Agent generates implementation code
  * **Then:** It must strictly adhere to all architectural rules from `bundle_architecture.md`
  * **And:** It must use exact interfaces and signatures from `bundle_code_context.md`
  * **And:** It must integrate cleanly with existing codebase patterns and conventions
  * **And:** Generated code must follow established error handling and integration approaches

* **Behavior 4: Code Quality and Documentation**
  * **Given:** The implementation code has been generated
  * **When:** The Coder Agent completes code generation
  * **Then:** It must include appropriate inline documentation and comments explaining complex logic
  * **And:** It must follow project coding standards and style conventions
  * **And:** It must implement proper error handling for expected failure scenarios
  * **And:** Generated code must be production-ready with appropriate logging and monitoring hooks

## 3. Context Bundle (Agent-Populated Sibling Files)

**What it is:** Context files that will be provided by other agents for this task.

* **`bundle_architecture.md`:** TDD methodology and testing patterns appropriate for the project technology stack, code generation strategies that ensure architectural compliance, and sub-agent design patterns for creative implementation tasks
* **`bundle_security.md`:** Secure coding practices for generated implementation code, input validation and sanitization patterns, secure error handling approaches, and security-conscious code generation guidelines
* **`bundle_code_context.md`:** Existing Coder Agent examples and patterns, TDD implementation examples from similar systems, Claude Code sub-agent creation patterns, and code generation interfaces and tooling integration patterns

## 4. Verification Context

**What it is:** Guidance for validating this task's completion.

* **Unit Test Scope:** The Validator Agent must verify that the coder.md sub-agent file follows Claude Code sub-agent specifications, includes proper TDD workflow logic, and contains appropriate model selection and tool configuration
* **Integration Test Scope:** The Validator Agent must test sub-agent invocation through Claude Code's Task tool, verify TDD workflow produces failing tests then passing implementation, and validate architectural compliance checking mechanisms
* **Project-Wide Checks:** The Validator Agent must ensure the sub-agent integrates properly with the SDD assembly line pattern, follows project file organization conventions, and maintains consistency with other sub-agent implementations in the system