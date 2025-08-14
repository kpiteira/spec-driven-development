---
id: TASK-034
title: "Add individual task completion notifications during milestone execution for progress tracking"
milestone_id: "M5-Enhanced-Milestone-Features"
requirement_id: "REQ-004"
slice: "Slice 2: Basic Milestone Notifications"
status: "pending"
branch: "feature/TASK-034-task-completion-notifications"
---

## Implementation Context for Claude Code Agents

**Agent Guidance:** This task will be implemented by Claude Code agents using natural language understanding capabilities. When you read instructions to "parse files" or "extract information," interpret this as reading and understanding documents using your natural language comprehension, not building programmatic parsers or extraction systems.

**Process Flow:** This task will be executed through the SDD assembly line: Bundler Specialist (context research) → Coder Specialist (TDD implementation) → Validator Specialist (comprehensive testing). Each specialist uses document comprehension to understand requirements and context.

**Architecture Compliance:** All implementation must follow the project's architecture specifications as understood through document analysis, not through algorithmic rule enforcement.

---

## 1. Task Overview & Goal

**What it is:** This task adds individual task completion notifications during milestone execution to provide granular progress tracking through the existing hook infrastructure, complementing the milestone-level notifications from TASK-033.

**Context:** This is the second task in Milestone 5's "Basic Milestone Notifications" slice. It builds upon TASK-033's milestone-level notifications to provide per-task progress updates during milestone execution. This gives Human Architects detailed visibility into milestone progress and enables them to track execution status at both milestone and individual task levels.

**Goal:** Implement individual task completion notifications that are triggered during milestone execution, providing granular progress tracking by sending notifications through the existing hook infrastructure each time a task completes within a milestone sequence.

---

## 2. Integration Context

### Why This Task Exists
This task completes the notification enhancement for REQ-004, providing comprehensive progress visibility that includes both milestone-level and task-level execution status.

### Dependencies & Flow
- **Requires**: TASK-033 (milestone-level notifications), existing hook infrastructure, task execution completion detection
- **Enables**: Complete M5 notification capability, comprehensive milestone progress tracking
- **Parallel OK**: TASK-032 resume capability testing (both finalize M5 functionality)

### Architectural Integration
- **Leverages**: TASK-033 notification patterns, existing hook infrastructure, task completion detection from milestone execution workflow
- **Creates**: Individual task completion notification integration, granular progress reporting capability
- **Modifies**: Milestone command task execution loop to include per-task notification hooks

### Implementation Guidance
- **Approach**: Integrate per-task notification hooks into milestone command's task execution sequence
- **Key Files**: `.claude/commands/milestone.md`, task completion notification integration points
- **Complexity**: Level 2 (extending existing notification patterns to task level)
- **Time Estimate**: 4 hours (per-task hook integration + notification content + testing)

---

## 3. The Contract: Requirements & Test Cases

**What it is:** The specific, testable requirements for individual task completion notification functionality.

* **Behavior 1: Task Completion Notification During Milestone Execution**
  * **Given:** A milestone is executing and individual tasks are completing
  * **When:** Each task within the milestone sequence finishes execution
  * **Then:** An individual task completion notification must be sent through the existing hook system
  * **And:** The notification must include task ID, milestone context, and completion status
  * **And:** Task notifications must be sent for both successful and failed task completions

* **Behavior 2: Progress Context in Task Notifications**
  * **Given:** A milestone is executing with multiple tasks
  * **When:** Individual task completion notifications are generated
  * **Then:** Each notification must include progress context (e.g., "Task 3 of 7 completed")
  * **And:** Progress information must be accurate relative to the total task count in the milestone
  * **And:** Task notifications must distinguish between normal execution and resumed execution

* **Behavior 3: Integration with Resume Capability**
  * **Given:** A milestone is resumed and skips completed tasks
  * **When:** Task completion notifications are processed during resume
  * **Then:** Notifications must only be sent for tasks that are actually executed, not skipped
  * **And:** Progress context must account for skipped tasks in the total count
  * **And:** Resumed execution must maintain consistent notification patterns

* **Behavior 4: Notification Consistency and Performance**
  * **Given:** Multiple task completion notifications are sent during milestone execution
  * **When:** Notification content is generated and sent
  * **Then:** All task notifications must follow consistent format and content patterns
  * **And:** Notification sending must not introduce significant delays to task execution
  * **And:** Task notifications must be clearly distinguishable from milestone-level notifications

---

## 4. Context Bundle (Agent-Populated Sibling Files)

**What it is:** Context files that will be provided by other agents for this task.

* **`bundle_architecture.md`:** TASK-033 notification implementation patterns, milestone command task execution workflow, per-task hook integration strategies, notification consistency requirements across milestone and task levels
* **`bundle_security.md`:** Safe per-task notification practices, protection against notification flooding, validation of task completion status before notification, secure integration with milestone execution flow
* **`bundle_code_context.md`:** TASK-033 notification implementation details, milestone command task execution loop structure, existing hook system usage patterns, task completion detection interfaces, notification formatting standards

---

## 5. Verification Context

**What it is:** Guidance for validating this task's completion.

* **Unit Test Scope:** The Validator Agent must test individual task completion notification triggering, verify progress context accuracy in notifications, validate integration with milestone execution flow without performance impact, and confirm notification consistency across different execution scenarios
* **Integration Test Scope:** The Validator Agent must test task notifications during complete milestone executions, verify behavior with resumed milestone executions (skipped vs executed tasks), test notification patterns across different milestone sizes and structures, and confirm compatibility with TASK-033 milestone-level notifications
* **Project-Wide Checks:** The Validator Agent must ensure task completion notifications follow established hook system patterns, verify notification content provides useful progress information for Human Architects, confirm integration maintains milestone execution performance per NFR-PERF-005, and validate that combined notification system (milestone + task level) delivers coherent progress tracking experience