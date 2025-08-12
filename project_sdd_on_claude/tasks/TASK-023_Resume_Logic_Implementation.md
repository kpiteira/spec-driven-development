---
id: TASK-023
title: "Enable Claude Code agent to implement resume logic by analyzing task bundle status and continuing from correct checkpoint"
milestone_id: "M4-Sequential-Milestone-Execution"
requirement_id: "REQ-004"
slice: "Slice 3: Resume Capability and State Management"
status: "pending"
branch: "feature/TASK-023-resume-logic"
---

## Implementation Context for Claude Code Agents

**Agent Guidance:** This task will be implemented by Claude Code agents using natural language understanding capabilities. When you read instructions to "parse files" or "extract information," interpret this as reading and understanding documents using your natural language comprehension, not building programmatic parsers or extraction systems.

**Process Flow:** This task will be executed through the SDD assembly line: Bundler Specialist (context research) → Coder Specialist (TDD implementation) → Validator Specialist (comprehensive testing). Each specialist uses document comprehension to understand requirements and context.

**Architecture Compliance:** All implementation must follow the project's architecture specifications as understood through document analysis, not through algorithmic rule enforcement.

---

## 1. Task Overview & Goal

**What it is:** This task implements intelligent resume logic that analyzes existing task bundle and milestone state to automatically continue milestone execution from the correct checkpoint after interruptions.

**Context:** This is the second task in Slice 3, building upon TASK-022's state tracking to add intelligent resume capability. This transforms milestone execution from a restart-from-beginning process to a smart continuation system that preserves progress across interruptions.

**Goal:** Implement resume logic that analyzes existing `.task_bundles/` and `.milestone_bundles/` directories to understand which tasks are completed, automatically resumes from the first uncompleted task, and provides clear status about which tasks are being skipped during resume.

---

## 2. Integration Context

### Why This Task Exists
This task enables efficient milestone execution by preserving progress across interruptions, allowing Human Architects to continue milestone execution without losing completed work or requiring manual tracking of progress.

### Dependencies & Flow
- **Requires**: TASK-022 (Milestone state tracking), existing task bundle system from M2
- **Enables**: TASK-024 (State cleanup), seamless milestone execution workflow
- **Parallel OK**: None (resume logic depends on state tracking foundation)

### Architectural Integration
- **Leverages**: TASK-022 milestone state tracking, existing task bundle analysis patterns, Claude Code agent file system analysis capabilities
- **Creates**: Resume logic system, task completion analysis, checkpoint continuation workflow
- **Modifies**: Milestone command to include resume capability, enhances execution flow with state analysis

### Implementation Guidance
- **Approach**: Implement intelligent state analysis using natural language understanding of file system state, create resume workflow that integrates seamlessly with existing execution
- **Key Files**: `.claude/commands/milestone.md` (enhance existing), resume logic utilities, state analysis functions
- **Complexity**: Level 4 (requires sophisticated state analysis and resume orchestration)
- **Time Estimate**: 7 hours (state analysis logic + resume workflow + checkpoint handling + edge cases + testing)

---

## 3. The Contract: Requirements & Test Cases

**What it is:** The specific, testable requirements for intelligent resume logic.

* **Behavior 1: Task Completion Analysis and Status Detection**
  * **Given:** A milestone execution was interrupted after completing some tasks
  * **When:** `/milestone [name]` is re-executed
  * **Then:** The system must analyze existing `.task_bundles/` directories to understand which tasks are completed
  * **And:** The system must cross-reference task bundle status with milestone state tracking
  * **And:** Task completion analysis must distinguish between successfully completed tasks and partially completed/failed tasks
  * **And:** The system must identify the correct checkpoint for resume (first uncompleted task)

* **Behavior 2: Automatic Resume from Correct Checkpoint**
  * **Given:** Task completion analysis has identified completed and uncompleted tasks
  * **When:** Resume logic determines the continuation point
  * **Then:** The system must automatically resume from the first uncompleted task without requiring user confirmation
  * **And:** Resume must continue execution seamlessly using the existing milestone execution workflow
  * **And:** The resumed execution must maintain all existing error handling and progress reporting capabilities
  * **And:** Resume must handle edge cases like all tasks completed or no tasks completed

* **Behavior 3: Clear Skip Status Reporting During Resume**
  * **Given:** Resume logic is continuing from a checkpoint with previously completed tasks
  * **When:** The milestone execution resumes
  * **Then:** The system must display clear status about which tasks are being skipped (e.g., "TASK-001 already completed, skipping...")
  * **And:** Skip status must include completion timestamps and success indicators for skipped tasks
  * **And:** The resume process must provide a summary of completed work before starting new execution
  * **And:** Skip reporting must clearly distinguish between completed tasks and the resumption point

* **Behavior 4: Partially Completed Task Handling**
  * **Given:** A task was interrupted during execution (partial task bundle exists)
  * **When:** Resume logic analyzes the task completion status
  * **Then:** The system must handle partially completed tasks by restarting them from the beginning
  * **And:** Partial task bundles must be cleaned up before restarting the interrupted task
  * **And:** The system must clearly report when a task is being restarted rather than skipped
  * **And:** Partially completed task handling must not interfere with completed task detection

---

## 4. Context Bundle (Agent-Populated Sibling Files)

**What it is:** Context files that will be provided by other agents for this task.

* **`bundle_architecture.md`:** Resume logic patterns for multi-task workflows, state analysis strategies for file-based systems, checkpoint continuation patterns, integration with existing milestone execution workflows
* **`bundle_security.md`:** Secure state analysis practices, protection against resume logic manipulation, validation of task completion status, safe handling of partial state during resume
* **`bundle_code_context.md`:** Task bundle system structure and completion indicators, milestone state tracking interfaces from TASK-022, existing milestone execution workflow patterns, file system analysis utilities

---

## 5. Verification Context

**What it is:** Guidance for validating this task's completion.

* **Unit Test Scope:** The Validator Agent must test task completion analysis accuracy and edge cases, verify resume logic correctly identifies continuation points, validate skip status reporting and partial task handling, and confirm resume workflow integration with existing execution
* **Integration Test Scope:** The Validator Agent must test resume functionality across various interruption scenarios (task failure, process interruption, partial completion), verify resume logic works with different milestone sizes and structures, test complete resume workflow from interruption through successful continuation, and confirm resume capability maintains all existing milestone execution features
* **Project-Wide Checks:** The Validator Agent must ensure resume logic follows SDD patterns for state analysis and workflow continuation, verify that resume functionality maintains system integrity and doesn't introduce state corruption, confirm that resume capability supports the autonomous execution requirements, and validate that resume logic provides clear visibility and control for Human Architects