# Milestone Plan: M2 - Core Task Execution

**Purpose of this document:** This document provides a detailed, tactical plan for executing Milestone 2 of the SDD System on Claude Code. It transforms the foundational specifications created in M1 into the core "inner loop" assembly line that makes task blueprints executable through automated AI agent coordination.

**Link to Roadmap:** [`3_Roadmap.md`](3_Roadmap.md)

---

## 1. Milestone Goals & Success Criteria

**What it is:** This milestone implements the core task execution workflow that transforms task blueprints into working, tested code through automated agent coordination following the assembly line pattern.

**Goal:** To build the `/task [task_id]` command and supporting infrastructure that enables Human Architects to execute individual task blueprints through an automated workflow: Task Blueprint → Context Bundle → Code Generation → Basic Validation → Git Commit.

**Success Criteria:**

* `/task TASK-ID` command successfully processes task blueprints through the complete assembly line workflow
* MVP Bundler Agent creates comprehensive context bundles from local codebase analysis and architectural specifications
* Assembly line pattern (Bundler → Coder → Commit) operates reliably with proper error handling and state management
* Task bundle system (`.task_bundles/TASK-ID/`) provides structured context isolation and debugging capabilities
* Generated code follows project architecture, includes appropriate tests, and integrates cleanly with existing codebase
* Git commits are created automatically for successful tasks, with failed tasks preserved for debugging
* Enhanced notification system reports task completion status to Human Architects with sound notifications via hooks
* System demonstrates end-to-end value: blueprint input → working code output

---

## 2. Scope: Features & Requirements

**What it is:** This milestone focuses on the core task execution loop with MVP-level agents that establish the assembly line pattern and prove the SDD workflow concept.

**Functional Requirements In Scope:**

* `REQ-005`: `/task [task_id]` command triggers full automated task execution workflow
* `REQ-006`: Bundler Agent (MVP version focusing on local codebase analysis only)
* `REQ-009`: Enhanced notification system with sound notifications for task completion status
* Task Bundle system with structured context isolation (`.task_bundles/TASK-ID/`)
* Assembly line orchestration pattern with clean agent handoffs
* File-based state management and coordination
* Sub-agent context isolation using Claude Code Task tool
* Git integration for successful task commits
* Error handling and debugging support for failed tasks

**Non-Functional Requirements In Scope:**

* `NFR-REL-002`: Failure isolation - failed operations leave system in recoverable state
* `NFR-REL-003`: Data integrity - task bundles are atomic (complete or cleanly removed)
* `NFR-PERF-001`: Context efficiency through focused, task-specific contexts
* `NFR-PERF-005`: Implementation efficiency using `claude-sonnet-4-20250514` for orchestration
* `NFR-QUA-001`: Quality gates that cannot be bypassed
* `NFR-UX-001`: Command clarity with progress feedback and failure reporting

**User Stories Fulfilled:**

* "As a Human Architect, I want to initiate a single development task so that the AI can generate code with full context, security guidance, and automated validation"

**Key Architectural Insight:** This milestone establishes the assembly line pattern that will be extended in M3 (full validation/security) and M4 (autonomous milestone execution). The MVP Bundler focuses on local analysis to prove the concept while deferring external dependencies to M5.

**Explicitly Out of Scope for M2:**

* Full Validator Agent implementation (basic validation includes unit tests, linting, type checking, and basic security scanning)
* SecurityConsultant Agent (deferred to M3)
* External dependency analysis in Bundler (deferred to M5)
* `/milestone` autonomous execution (deferred to M4)
* Comprehensive hooks and observability (minimal logging only)
* `/init_brownfield` brownfield support (deferred to M5)

---

## 3. Implementation Plan: Vertical Slices

**What it is:** The work is organized into 4 vertical slices that incrementally build the complete task execution capability, starting with basic infrastructure and culminating in the full automated workflow.

---

### **Slice 1: Task Command Infrastructure & Bundle System**

* **Goal:** Establish the foundation for task execution with the `/task` command, task bundle system, and basic orchestration infrastructure.
* **Acceptance Criteria:**
  * **Given** I have a task blueprint file (`TASK-001_Example_Task.md`)
  * **When** I execute `/task TASK-001`
  * **Then** the system creates a `.task_bundles/TASK-001/` directory with structured context
  * **And** the original task blueprint is copied into the bundle
  * **And** the system provides clear feedback about bundle creation status
  * **And** failed bundle operations are reported with specific error messages
  * **And** the bundle directory structure follows the defined architecture pattern
* **Task Sequence:**
    1. **TASK-005:** Create `.claude/commands/task.md` command with basic orchestration logic and task bundle management
    2. **TASK-006:** Implement task bundle directory creation, validation, and cleanup patterns following architecture specifications

---

### **Slice 2: MVP Bundler Agent with Local Context Analysis**

* **Goal:** Create the MVP Bundler Agent that analyzes local codebase and architecture to create comprehensive context bundles for code generation.
* **Acceptance Criteria:**
  * **Given** a task bundle with a task blueprint exists
  * **When** the Bundler Agent processes the bundle
  * **Then** it creates `bundle_architecture.md` with relevant architectural rules extracted from project specifications
  * **And** it creates `bundle_code_context.md` with exact signatures and documentation of relevant existing code
  * **And** it performs semantic search to find similar implementations and patterns in the codebase using Serena MCP and bash commands for local analysis
  * **And** context files are comprehensive enough for code generation without additional research
  * **And** the bundler operates with clean context isolation using the Task tool
  * **And** local codebase analysis is performed through Serena MCP integration and bash command execution (external dependencies deferred to M5)
* **Task Sequence:**
    1. **TASK-007:** Create `.claude/agents/bundler.md` sub-agent with local codebase analysis capabilities using Serena MCP and bash commands
    2. **TASK-008:** Implement context extraction logic for architecture rules, code patterns, and interface discovery
    3. **TASK-009:** Integrate Bundler Agent into `/task` command workflow with proper error handling

---

### **Slice 3: Coder Agent and Code Generation Pipeline**

* **Goal:** Implement the Coder Agent that transforms task bundles into working code following TDD principles and architectural guidance.
* **Acceptance Criteria:**
  * **Given** a complete task bundle with all context files
  * **When** the Coder Agent processes the bundle
  * **Then** it generates failing unit tests that reflect the task blueprint contract
  * **And** it implements code that makes all tests pass
  * **And** the code follows all architectural rules from `bundle_architecture.md`
  * **And** the code integrates cleanly with existing interfaces from `bundle_code_context.md`
  * **And** implementation includes appropriate error handling and edge case coverage
  * **And** generated code follows project coding standards and conventions
  * **And** git commit messages follow suggested format patterns while preserving Claude Code's flexibility to improve messaging over time
* **Task Sequence:**
    1. **TASK-010:** Create `.claude/agents/coder.md` sub-agent with TDD-focused implementation logic
    2. **TASK-011:** Implement test-first code generation workflow with architectural compliance validation
    3. **TASK-012:** Integrate Coder Agent into assembly line with proper context handoff from Bundler

---

### **Slice 4: Enhanced Validation, Git Integration, and Complete Workflow**

* **Goal:** Complete the task execution workflow with enhanced validation (including type checking and basic security scanning), git commit automation, sound notifications, and end-to-end orchestration with error recovery patterns.
* **Acceptance Criteria:**
  * **Given** the Coder Agent has generated implementation code
  * **When** the validation phase executes
  * **Then** enhanced quality checks run (unit tests, linting, type checking, basic security scanning)
  * **And** successful validation triggers automatic git commit with suggested message format
  * **And** failed validation preserves the task bundle for debugging and executes specific error recovery workflows
  * **And** the Human Architect receives clear notification of task completion status with sound alerts via hooks
  * **And** successful tasks result in clean workspace (bundle removed)
  * **And** the complete workflow operates reliably from `/task TASK-ID` to final commit with defined recovery patterns for common failures
* **Task Sequence:**
    1. **TASK-013:** Implement enhanced validation logic (unit tests, linting, type checking, basic security scanning) and git commit automation
    2. **TASK-014:** Create enhanced notification system with sound notifications via hooks for task completion status
    3. **TASK-015:** Implement specific error recovery workflows for common failure scenarios (validation failures, build errors, context issues)
    4. **TASK-016:** Integrate all components into complete `/task` workflow with comprehensive error handling
    5. **TASK-017:** Create sample task blueprints for testing and validation (no manual creation dependency)
    6. **TASK-018:** Implement end-to-end testing and validation of complete task execution pipeline

---

## 4. Testing & Verification Plan

**What it is:** Quality gates that ensure the task execution workflow operates reliably and produces high-quality code following the SDD methodology.

**Project-Level Checks (Always On):**

* All generated code must pass enhanced validation: unit tests, linting standards, type checking, and basic security scanning
* Task bundle structure must follow architecture specification exactly
* Sub-agent invocations must use proper context isolation patterns
* Git commits follow suggested SDD message format while preserving Claude Code's flexibility for improvement
* Error conditions must be handled gracefully without corrupting workspace, with specific recovery workflows for common failure scenarios

**Per-Slice Checks (Integration & E2E Tests):**

* **Slice 1:** Verify task bundle creation, validation, and cleanup operate correctly for valid and invalid task blueprints
* **Slice 2:** Verify MVP Bundler creates comprehensive context bundles that enable successful code generation
* **Slice 3:** Verify Coder Agent generates working, tested code that integrates with existing codebase
* **Slice 4:** Verify complete workflow from task blueprint to git commit operates reliably with enhanced validation and sound notifications

**Final Milestone Acceptance Tests:**

* **End-to-End Task Execution:** Create a test task blueprint and verify complete workflow produces committed, working code
* **Error Handling Validation:** Test failure scenarios (invalid blueprints, build failures, validation errors) and confirm graceful degradation with specific recovery workflows
* **Context Isolation Verification:** Confirm sub-agents operate with clean contexts and don't pollute each other
* **Bundle System Validation:** Verify task bundles provide sufficient context for debugging failed tasks
* **Architecture Compliance:** Confirm generated code follows project architectural patterns and integrates cleanly

---

## 5. Definition of Done

**Milestone 2 is complete when:**

* All 18 tasks are implemented successfully with passing enhanced validation
* `/task TASK-ID` command executes complete assembly line workflow reliably
* MVP Bundler Agent creates comprehensive context bundles from local codebase analysis
* Coder Agent generates working, tested code following TDD principles and architectural guidance
* Enhanced validation (unit tests, linting, type checking, basic security scanning) and git commit automation operate correctly
* Task bundle system provides effective debugging support for failed tasks
* Enhanced notification system with sound alerts via hooks reports task completion status clearly
* Error handling preserves system integrity and enables recovery from failures through specific recovery workflows for common scenarios
* Generated code integrates cleanly with existing project structure and follows established patterns
* The system demonstrates core SDD value proposition: automated transformation of task blueprints into production-ready code
* End-to-end workflow validation confirms readiness for M3 security and validation enhancements
* Assembly line pattern is established and proven for future milestone and brownfield extensions

**Success Validation:**

* Manual testing with real task blueprints from the SDD project itself demonstrates working end-to-end capability
* Generated code passes all existing project quality standards
* Task failure scenarios are handled gracefully with actionable debugging information
* The system enables Human Architects to focus on strategic planning while AI handles implementation mechanics