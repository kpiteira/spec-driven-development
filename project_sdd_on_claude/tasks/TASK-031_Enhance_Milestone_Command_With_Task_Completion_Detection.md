---
id: TASK-031
title: "Enhance `/milestone` command to detect completed tasks by analyzing `.task_bundles/TASK-XXX/` directories for success indicators"
milestone_id: "M5-Enhanced-Milestone-Features"
requirement_id: "REQ-004"
slice: "Slice 1: Resume Capability Implementation"
status: "pending"
branch: "feature/TASK-031-task-completion-detection"
---

## Implementation Context for Claude Code Agents

**Agent Guidance:** This task will be implemented by Claude Code agents using natural language understanding capabilities. When you read instructions to "parse files" or "extract information," interpret this as reading and understanding documents using your natural language comprehension, not building programmatic parsers or extraction systems.

**Process Flow:** This task will be executed through the SDD assembly line: Bundler Specialist (context research) → Coder Specialist (TDD implementation) → Validator Specialist (comprehensive testing). Each specialist uses document comprehension to understand requirements and context.

**Architecture Compliance:** All implementation must follow the project's architecture specifications as understood through document analysis, not through algorithmic rule enforcement.

---

## 1. Task Overview & Goal

**What it is:** This task enhances the existing `/milestone` command to include task completion detection capability by analyzing the `.task_bundles/TASK-XXX/` directory structure to identify which tasks have been successfully completed.

**Context:** This is the first task in Milestone 5's "Resume Capability Implementation" slice. It builds upon the existing M4 `/milestone` command functionality to add intelligent completion detection. This capability is foundational for enabling milestone resume functionality and preventing redundant task execution when milestones are interrupted and restarted.

**Goal:** Enhance the existing `/milestone` command with logic to detect completed tasks by examining `.task_bundles/TASK-XXX/` directories for success indicators, enabling the system to identify which tasks in a milestone sequence have already been successfully completed.

---

## 2. Integration Context

### Why This Task Exists
This task enables the core completion detection required for REQ-004 enhancement, allowing the milestone command to intelligently identify completed work and avoid redundant task execution.

### Dependencies & Flow
- **Requires**: M4 `/milestone` command functionality, existing `.task_bundles/` directory structure
- **Enables**: TASK-032 (Resume logic implementation), TASK-033 (Progress notifications), TASK-034 (Testing)
- **Parallel OK**: None (foundational task for resume capability)

### Architectural Integration
- **Leverages**: Existing `/milestone` command, `.task_bundles/TASK-XXX/` directory structure, task completion indicators
- **Creates**: Task completion detection logic, task status analysis capability
- **Modifies**: Existing `/milestone` command implementation

### Implementation Guidance
- **Approach**: Enhance existing milestone command with completion analysis logic using directory-based success indicators
- **Key Files**: `.claude/commands/milestone.md`, task bundle directory analysis logic
- **Complexity**: Level 2 (straightforward enhancement to existing command)
- **Time Estimate**: 4 hours (analysis logic + integration + basic testing)

---

## 3. The Contract: Requirements & Test Cases

**What it is:** The specific, testable requirements for task completion detection functionality.

* **Behavior 1: Successful Task Detection**
  * **Given:** A `.task_bundles/TASK-XXX/` directory exists with success indicators
  * **When:** The milestone command analyzes task completion status
  * **Then:** The task must be identified as successfully completed
  * **And:** The completion status must be clearly logged and reported
  * **And:** Task completion detection must not interfere with existing milestone functionality

* **Behavior 2: Incomplete Task Detection**
  * **Given:** A `.task_bundles/TASK-XXX/` directory does not exist or lacks success indicators
  * **When:** The milestone command analyzes task completion status
  * **Then:** The task must be identified as incomplete or not started
  * **And:** The incomplete status must be clearly distinguished from completed tasks
  * **And:** Partially failed tasks must be treated as incomplete

* **Behavior 3: Task Status Analysis Integration**
  * **Given:** A milestone plan with multiple tasks in various completion states
  * **When:** The enhanced milestone command processes the task list
  * **Then:** Each task's completion status must be accurately determined
  * **And:** Completion analysis must occur before any task execution
  * **And:** Status analysis must maintain existing milestone command behavior for incomplete tasks

* **Behavior 4: Robust Error Handling**
  * **Given:** Corrupted or malformed task bundle directories exist
  * **When:** Task completion detection encounters invalid bundle structures
  * **Then:** The system must treat ambiguous cases as incomplete tasks
  * **And:** Error conditions must be logged clearly without stopping milestone execution
  * **And:** Completion detection must fail safely to ensure no tasks are incorrectly skipped

---

## 4. Context Bundle (Agent-Populated Sibling Files)

**What it is:** Context files that will be provided by other agents for this task.

* **`bundle_architecture.md`:** Current `/milestone` command implementation patterns, `.task_bundles/` directory structure and success indicators, task completion validation strategies, file system analysis approaches for Claude Code
* **`bundle_security.md`:** Safe directory traversal practices, protection against malicious bundle directory structures, secure file system access patterns, validation of task bundle integrity
* **`bundle_code_context.md`:** Existing `/milestone` command implementation details, task bundle system interfaces and success indicator patterns, completion detection logic integration points, error handling patterns for file system operations

---

## 5. Verification Context

**What it is:** Guidance for validating this task's completion.

* **Unit Test Scope:** The Validator Agent must test task completion detection logic with various bundle directory states, verify accurate identification of completed vs incomplete tasks, validate error handling for corrupted or missing bundle directories, and confirm integration with existing milestone command functionality
* **Integration Test Scope:** The Validator Agent must test completion detection with real task bundle directories from previous executions, verify behavior across different milestone plans and task sequences, test edge cases with partially completed or failed task bundles, and confirm backward compatibility with existing milestone execution workflows
* **Project-Wide Checks:** The Validator Agent must ensure the enhanced milestone command maintains all existing functionality, verify completion detection follows Claude Code file system access patterns, confirm error handling aligns with SDD failure isolation requirements, and validate that completion detection performance is acceptable for typical milestone sizes