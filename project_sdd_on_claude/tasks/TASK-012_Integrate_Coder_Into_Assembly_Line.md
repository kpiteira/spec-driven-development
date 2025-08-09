---
id: TASK-012
title: "Integrate Coder Agent into assembly line with proper context handoff from Bundler"
milestone_id: "M2-Core-Execution"
requirement_id: "REQ-005"
slice: "Slice 3: Coder Agent and Code Generation Pipeline"
status: "pending"
branch: "feature/TASK-012-coder-integration"
---

## 1. Task Overview & Goal

**What it is:** This task integrates the Coder Agent into the `/task` command workflow, establishing the second stage of the SDD assembly line pattern. It creates the orchestration logic that receives context bundles from the Bundler Agent and invokes the Coder Agent to generate working code.

**Context:** This is the final task in Slice 3, completing the Coder Agent implementation by connecting it to the task execution workflow. This integration extends the assembly line pattern established in Slice 2, creating the Bundler → Coder workflow that transforms task blueprints into tested code.

**Goal:** Modify the `/task` command to invoke the Coder Agent after successful bundle creation, handle the handoff of context from Bundler to Coder, implement proper error handling for code generation failures, and prepare the results for downstream validation and commit processes.

## 2. The Contract: Requirements & Test Cases

**What it is:** The specific, testable requirements for integrating the Coder Agent into the assembly line workflow.

* **Behavior 1: Coder Agent Invocation and Context Handoff**
  * **Given:** The Bundler Agent has successfully created a complete task bundle
  * **When:** The task command initiates the code generation phase
  * **Then:** It must invoke the Coder Agent using Claude Code's Task tool with `claude-opus-4-1-20250805` model
  * **And:** It must pass the complete task bundle directory path to the Coder Agent
  * **And:** The Coder Agent must have access to all context files created by the Bundler
  * **And:** Context handoff must maintain clean isolation between agent executions

* **Behavior 2: Code Generation Validation and Output Processing**
  * **Given:** The Coder Agent has completed code generation
  * **When:** The task command receives the coder results
  * **Then:** It must validate that required code files and tests have been created
  * **And:** It must verify that generated tests are executable and initially failing (TDD red phase)
  * **And:** It must confirm that implementation code makes tests pass (TDD green phase)
  * **And:** Generated code must be properly placed in the project structure according to architectural conventions

* **Behavior 3: Error Handling and Debugging Support**
  * **Given:** The Coder Agent encounters failures during code generation
  * **When:** Coder errors are reported back to the task command
  * **Then:** The task command must capture detailed error information including generation context
  * **And:** It must preserve the task bundle with partial results for debugging and recovery
  * **And:** It must provide specific, actionable error messages distinguishing between different failure types
  * **And:** Failed operations must not corrupt existing codebase or leave inconsistent state

* **Behavior 4: Assembly Line State Management**
  * **Given:** The Coder Agent has successfully generated working code
  * **When:** The code generation stage is complete
  * **Then:** The task command must update execution state to track progress through the workflow
  * **And:** It must prepare generated code and tests for the next stage in the assembly line (validation)
  * **And:** It must ensure all artifacts are properly organized for downstream processing
  * **And:** The workflow must be ready for validation and commit automation (to be implemented in Slice 4)

## 3. Context Bundle (Agent-Populated Sibling Files)

**What it is:** Context files that will be provided by other agents for this task.

* **`bundle_architecture.md`:** Assembly line orchestration patterns for multi-stage workflows, Claude Code Task tool integration for creative sub-agents, workflow state management across agent executions, and error handling strategies for code generation processes
* **`bundle_security.md`:** Secure handling of generated code artifacts, validation of code generation outputs before integration, secure context passing between agents, and protection against malicious or erroneous code generation
* **`bundle_code_context.md`:** Existing `/task` command implementation with Bundler integration from TASK-009, Claude Code Task tool usage for creative agents, assembly line workflow management patterns, error handling and state tracking interfaces, and code generation result processing examples

## 4. Verification Context

**What it is:** Guidance for validating this task's completion.

* **Unit Test Scope:** The Validator Agent must test Coder Agent invocation with various task bundle scenarios, verify context handoff maintains bundle integrity and accessibility, and validate error handling for code generation failures and invalid outputs
* **Integration Test Scope:** The Validator Agent must test the complete Bundler → Coder workflow from task blueprint through context creation to code generation, verify TDD workflow produces failing tests followed by passing implementation, and test assembly line state management across agent transitions
* **Project-Wide Checks:** The Validator Agent must ensure integration follows SDD assembly line pattern specifications, verify generated code follows project architectural standards and integrates cleanly, and confirm that workflow enables debugging and recovery from code generation failures