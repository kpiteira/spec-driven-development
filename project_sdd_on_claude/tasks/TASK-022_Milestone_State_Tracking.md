---
id: TASK-022
title: "Enable Claude Code agent to track milestone state using .milestone_bundles/[name]/ directory structure"
milestone_id: "M4-Sequential-Milestone-Execution"
requirement_id: "REQ-004"
slice: "Slice 3: Resume Capability and State Management"
status: "pending"
branch: "feature/TASK-022-state-tracking"
---

## Implementation Context for Claude Code Agents

**Agent Guidance:** This task will be implemented by Claude Code agents using natural language understanding capabilities. When you read instructions to "parse files" or "extract information," interpret this as reading and understanding documents using your natural language comprehension, not building programmatic parsers or extraction systems.

**Process Flow:** This task will be executed through the SDD assembly line: Bundler Specialist (context research) → Coder Specialist (TDD implementation) → Validator Specialist (comprehensive testing). Each specialist uses document comprehension to understand requirements and context.

**Architecture Compliance:** All implementation must follow the project's architecture specifications as understood through document analysis, not through algorithmic rule enforcement.

---

## 1. Task Overview & Goal

**What it is:** This task implements milestone state tracking using a structured `.milestone_bundles/[name]/` directory system that persists milestone execution state, task completion status, and recovery information to enable resume capability.

**Context:** This is the first task in Slice 3, building upon the error handling and progress reporting from Slice 2 to add persistent state management. This creates the foundation for resume capability by tracking milestone execution state in a structured, file-based system that survives interruptions.

**Goal:** Implement a comprehensive milestone state tracking system using `.milestone_bundles/[name]/` directories that persists milestone execution state, tracks task completion status, and provides the foundation for resume capability after interruptions.

---

## 2. Integration Context

### Why This Task Exists
This task enables resume capability for milestone execution by providing persistent state tracking that survives interruptions, allowing Human Architects to continue milestone execution from the correct checkpoint after any interruption.

### Dependencies & Flow
- **Requires**: TASK-019 (Milestone command foundation), TASK-020 (Error handling), TASK-021 (Progress reporting)
- **Enables**: TASK-023 (Resume logic implementation), TASK-024 (State cleanup)
- **Parallel OK**: None (state tracking is foundational for resume capability)

### Architectural Integration
- **Leverages**: Existing task bundle system (.task_bundles/), file-based state management patterns from M2-M3, Claude Code agent file system capabilities
- **Creates**: Milestone state tracking system, .milestone_bundles/ directory structure, persistent execution state management
- **Modifies**: Milestone execution workflow to include state persistence, extends existing bundle system concepts

### Implementation Guidance
- **Approach**: Create structured directory system for milestone state, implement persistent state tracking throughout milestone execution lifecycle
- **Key Files**: `.milestone_bundles/[name]/` directory structure, state tracking utilities, milestone status files
- **Complexity**: Level 3 (requires comprehensive state management and persistence strategy)
- **Time Estimate**: 6 hours (directory structure design + state persistence + tracking logic + integration + testing)

---

## 3. The Contract: Requirements & Test Cases

**What it is:** The specific, testable requirements for milestone state tracking system.

* **Behavior 1: Milestone Bundle Directory Structure Creation**
  * **Given:** A milestone execution is initiated
  * **When:** The milestone command begins processing
  * **Then:** The system must create a `.milestone_bundles/[milestone-name]/` directory structure
  * **And:** The directory structure must include subdirectories for execution state, task status, and recovery information
  * **And:** Directory creation must follow existing bundle system patterns from task bundles
  * **And:** Milestone bundle directories must be clearly distinguished from task bundle directories

* **Behavior 2: Task Completion Status Persistence**
  * **Given:** Tasks are completing during milestone execution
  * **When:** Each task reaches completion or failure
  * **Then:** The system must persist task completion status in the milestone bundle directory
  * **And:** Task status must include completion timestamps, success/failure status, and execution context
  * **And:** Status persistence must be atomic to prevent corruption during interruptions
  * **And:** Task status must reference corresponding task bundle directories for full context

* **Behavior 3: Milestone Execution State Management**
  * **Given:** A milestone is in progress
  * **When:** Execution state changes occur (task start, completion, failure, pause)
  * **Then:** The system must update milestone execution state in persistent storage
  * **And:** Execution state must include current task, completed tasks list, remaining tasks list, and overall milestone status
  * **And:** State updates must be immediately persisted to survive unexpected interruptions
  * **And:** Execution state must provide sufficient information for accurate resume capability

* **Behavior 4: Recovery Information and Context Preservation**
  * **Given:** A milestone execution encounters interruptions or failures
  * **When:** State tracking processes the execution changes
  * **Then:** The system must preserve recovery information including interruption point, execution context, and resume instructions
  * **And:** Recovery information must include sufficient detail to resume execution accurately
  * **And:** Context preservation must maintain links to task bundles and execution history
  * **And:** Recovery data must be structured to support automated resume logic

---

## 4. Context Bundle (Agent-Populated Sibling Files)

**What it is:** Context files that will be provided by other agents for this task.

* **`bundle_architecture.md`:** File-based state management patterns for milestone workflows, directory structure design for persistent state tracking, integration with existing task bundle system, state persistence strategies for resume capability
* **`bundle_security.md`:** Secure state information handling, protection against state corruption or tampering, safe file system operations for milestone bundles, validation of state tracking operations
* **`bundle_code_context.md`:** Existing task bundle system implementation details, file-based state management patterns from M2-M3, directory structure conventions, state persistence utilities and interfaces

---

## 5. Verification Context

**What it is:** Guidance for validating this task's completion.

* **Unit Test Scope:** The Validator Agent must test milestone bundle directory creation and structure, verify task status persistence accuracy and atomicity, validate milestone execution state management and updates, and confirm recovery information preservation and accessibility
* **Integration Test Scope:** The Validator Agent must test state tracking throughout complete milestone execution scenarios, verify state persistence survives various interruption scenarios, test integration with existing task bundle system, and confirm state tracking supports the resume capability requirements
* **Project-Wide Checks:** The Validator Agent must ensure milestone state tracking follows SDD file-based state management conventions, verify that state persistence maintains system performance and doesn't disrupt execution flow, confirm that state tracking provides sufficient information for accurate resume capability, and validate that milestone bundles integrate cleanly with existing bundle system architecture