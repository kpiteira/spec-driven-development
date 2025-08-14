---
id: TASK-032
title: "Implement resume logic that skips completed tasks and continues from first uncompleted task with clear progress reporting"
milestone_id: "M5-Enhanced-Milestone-Features"
requirement_id: "REQ-004"
slice: "Slice 1: Resume Capability Implementation"
status: "pending"
branch: "feature/TASK-032-resume-capability"
---

## Implementation Context for Claude Code Agents

**Agent Guidance:** This task will be implemented by Claude Code agents using natural language understanding capabilities. When you read instructions to "parse files" or "extract information," interpret this as reading and understanding documents using your natural language comprehension, not building programmatic parsers or extraction systems.

**Process Flow:** This task will be executed through the SDD assembly line: Bundler Specialist (context research) → Coder Specialist (TDD implementation) → Validator Specialist (comprehensive testing). Each specialist uses document comprehension to understand requirements and context.

**Architecture Compliance:** All implementation must follow the project's architecture specifications as understood through document analysis, not through algorithmic rule enforcement.

---

## 1. Task Overview & Goal

**What it is:** This task implements the resume capability for the `/milestone` command by adding logic to skip completed tasks and continue execution from the first uncompleted task, with clear progress reporting throughout the process.

**Context:** This is the second task in Milestone 5's "Resume Capability Implementation" slice. It builds directly upon TASK-031's completion detection capability to create the intelligent resume workflow. This represents the core user-facing functionality that enables interrupted milestone executions to be safely restarted without losing progress.

**Goal:** Implement the resume logic that leverages task completion detection to skip completed tasks, continue execution from the first uncompleted task, and provide clear progress reporting about which tasks are being skipped and where execution is resuming.

---

## 2. Integration Context

### Why This Task Exists
This task delivers the core user value of REQ-004 enhancement, enabling milestone executions to be safely interrupted and resumed without redundant work or manual tracking.

### Dependencies & Flow
- **Requires**: TASK-031 (Task completion detection logic)
- **Enables**: TASK-033 (Progress notifications), TASK-034 (Comprehensive testing)
- **Parallel OK**: None (depends on completion detection from TASK-031)

### Architectural Integration
- **Leverages**: TASK-031 completion detection logic, existing `/milestone` command infrastructure, task execution sequencing patterns
- **Creates**: Resume workflow logic, progress reporting for skipped tasks, checkpoint-based execution continuation
- **Modifies**: Milestone command execution flow, task sequencing logic

### Implementation Guidance
- **Approach**: Enhance milestone command with resume logic using completion detection to implement skip-and-continue workflow
- **Key Files**: `.claude/commands/milestone.md`, resume logic integration with existing task sequencing
- **Complexity**: Level 3 (workflow orchestration with state management)
- **Time Estimate**: 6 hours (resume logic + progress reporting + integration testing)

---

## 3. The Contract: Requirements & Test Cases

**What it is:** The specific, testable requirements for the resume capability implementation.

* **Behavior 1: Skip Completed Tasks with Clear Reporting**
  * **Given:** A milestone execution is resumed after interruption with some tasks completed
  * **When:** The enhanced milestone command processes the task sequence
  * **Then:** Completed tasks must be skipped without execution
  * **And:** Clear status messages must be displayed for each skipped task (e.g., "TASK-001 already completed, skipping...")
  * **And:** Skipped task reporting must include task ID and brief confirmation of completion status

* **Behavior 2: Resume from First Uncompleted Task**
  * **Given:** Task completion analysis identifies the first uncompleted task in the sequence
  * **When:** Resume logic determines where to continue execution
  * **Then:** Execution must begin with the first uncompleted task in the milestone sequence
  * **And:** The resume point must be clearly communicated (e.g., "Resuming from TASK-005...")
  * **And:** All subsequent tasks must execute normally using existing task execution infrastructure

* **Behavior 3: Progress Reporting During Resume**
  * **Given:** A milestone is being resumed with mixed completion states
  * **When:** The resume process analyzes and skips completed tasks
  * **Then:** Progress updates must clearly distinguish between skipped and executed tasks
  * **And:** Overall progress must be accurately reported (e.g., "Skipping 3 completed tasks, executing 4 remaining tasks")
  * **And:** Progress reporting must maintain existing milestone progress format for executed tasks

* **Behavior 4: Handle Partially Failed Tasks**
  * **Given:** A task bundle directory exists but indicates partial or failed completion
  * **When:** Resume logic encounters tasks with ambiguous completion status
  * **Then:** Partially failed tasks must be treated as incomplete and restarted from the beginning
  * **And:** Clear messaging must indicate when tasks are being restarted due to incomplete status
  * **And:** Restart behavior must follow existing task execution patterns

---

## 4. Context Bundle (Agent-Populated Sibling Files)

**What it is:** Context files that will be provided by other agents for this task.

* **`bundle_architecture.md`:** TASK-031 completion detection implementation, existing milestone command workflow patterns, task sequencing and execution flow, progress reporting strategies for Claude Code
* **`bundle_security.md`:** Safe resume workflow practices, validation of task sequence integrity during resume, protection against manipulation of completion status, secure handling of partially failed task states
* **`bundle_code_context.md`:** TASK-031 completion detection interfaces, existing milestone command implementation, task execution workflow patterns, progress reporting implementation examples, error handling patterns for resume scenarios

---

## 5. Verification Context

**What it is:** Guidance for validating this task's completion.

* **Unit Test Scope:** The Validator Agent must test resume logic with various task completion scenarios, verify accurate skipping of completed tasks, validate progress reporting accuracy for skipped vs executed tasks, and confirm proper handling of partially failed tasks
* **Integration Test Scope:** The Validator Agent must test complete resume workflows with real milestone plans at various interruption points, verify integration with existing task execution infrastructure, test edge cases including all-completed and no-completed scenarios, and confirm backward compatibility with non-resumed milestone executions
* **Project-Wide Checks:** The Validator Agent must ensure resume capability maintains existing milestone command functionality, verify progress reporting aligns with SDD user experience requirements, confirm error handling follows NFR-REL-002 failure isolation patterns, and validate that resume performance is acceptable for typical milestone sizes