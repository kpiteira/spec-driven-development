---
id: TASK-027
title: "Enable Claude Code agent to perform milestone completion validation and reporting"
milestone_id: "M4-Sequential-Milestone-Execution"
requirement_id: "REQ-004"
slice: "Slice 4: Autonomous Execution and Hook Integration"
status: "pending"
branch: "feature/TASK-027-completion-validation"
---

## Implementation Context for Claude Code Agents

**Agent Guidance:** This task will be implemented by Claude Code agents using natural language understanding capabilities. When you read instructions to "parse files" or "extract information," interpret this as reading and understanding documents using your natural language comprehension, not building programmatic parsers or extraction systems.

**Process Flow:** This task will be executed through the SDD assembly line: Bundler Specialist (context research) → Coder Specialist (TDD implementation) → Validator Specialist (comprehensive testing). Each specialist uses document comprehension to understand requirements and context.

**Architecture Compliance:** All implementation must follow the project's architecture specifications as understood through document analysis, not through algorithmic rule enforcement.

---

## 1. Task Overview & Goal

**What it is:** This task implements comprehensive milestone completion validation and reporting that verifies milestone success criteria are met and generates detailed execution summaries for Human Architects.

**Context:** This is the third and final task in Slice 4, building upon TASK-025's autonomous execution and TASK-026's hook integration to complete the autonomous milestone execution workflow with proper completion validation and reporting.

**Goal:** Implement comprehensive milestone completion validation that verifies all milestone success criteria are met, generates detailed execution summaries including task completion status and milestone achievements, and provides Human Architects with clear confirmation of milestone completion.

---

## 2. Integration Context

### Why This Task Exists
This task ensures that autonomous milestone execution concludes with proper validation and reporting, providing Human Architects with confidence that milestone goals have been achieved and comprehensive documentation of the execution results.

### Dependencies & Flow
- **Requires**: TASK-025 (Autonomous execution), TASK-026 (Hook integration), complete Slice 3 state management
- **Enables**: Complete autonomous milestone execution workflow, foundation for Slice 5 retrospectives
- **Parallel OK**: None (completion validation is the final step in the execution workflow)

### Architectural Integration
- **Leverages**: Complete milestone execution infrastructure, autonomous execution logic, hook system integration, state management from Slice 3
- **Creates**: Milestone completion validation system, execution summary generation, completion reporting workflow
- **Modifies**: Milestone execution workflow to include comprehensive completion validation and reporting

### Implementation Guidance
- **Approach**: Implement validation logic that verifies milestone success criteria against actual execution results, generate comprehensive reports using natural language understanding
- **Key Files**: `.claude/commands/milestone.md` (enhance existing), completion validation utilities, reporting generation logic
- **Complexity**: Level 4 (requires comprehensive validation logic and sophisticated reporting generation)
- **Time Estimate**: 7 hours (validation logic + success criteria verification + report generation + integration + testing)

---

## 3. The Contract: Requirements & Test Cases

**What it is:** The specific, testable requirements for milestone completion validation and reporting.

* **Behavior 1: Comprehensive Milestone Success Criteria Validation**
  * **Given:** A milestone execution has completed all tasks
  * **When:** Completion validation is triggered
  * **Then:** The system must verify that all milestone success criteria from the milestone plan have been met
  * **And:** Validation must check that all tasks completed successfully with no outstanding failures
  * **And:** Success criteria validation must include verification of milestone goals and acceptance criteria
  * **And:** Validation must provide clear results indicating whether the milestone is genuinely complete or if issues remain

* **Behavior 2: Detailed Execution Summary Generation**
  * **Given:** Milestone completion validation has been performed
  * **When:** Execution summary generation is triggered
  * **Then:** The system must generate a comprehensive execution summary including task completion status, execution timeline, and milestone achievements
  * **And:** Execution summary must include details about each task's completion status, duration, and any significant events
  * **And:** Summary must highlight milestone-level accomplishments and how they relate to project goals
  * **And:** Execution summary must be formatted for Human Architect review and project documentation

* **Behavior 3: Completion Confirmation and Reporting Delivery**
  * **Given:** Milestone validation and summary generation are complete
  * **When:** Completion reporting is delivered
  * **Then:** The system must provide clear confirmation to the Human Architect that the milestone has completed successfully
  * **And:** Completion confirmation must include the detailed execution summary and validation results
  * **And:** Reporting must integrate with hook system notifications for immediate Human Architect awareness
  * **And:** Completion reporting must preserve execution history for future reference and retrospectives

* **Behavior 4: Failure and Partial Completion Handling**
  * **Given:** Milestone validation detects incomplete or failed elements
  * **When:** Completion validation processes the milestone status
  * **Then:** The system must provide clear reporting about what succeeded, what failed, and what remains incomplete
  * **And:** Partial completion reporting must include guidance about next steps for completing the milestone
  * **And:** Failure handling must preserve all context needed for debugging and resolution
  * **And:** Incomplete milestone reporting must distinguish between partial success and complete failure scenarios

---

## 4. Context Bundle (Agent-Populated Sibling Files)

**What it is:** Context files that will be provided by other agents for this task.

* **`bundle_architecture.md`:** Completion validation patterns for milestone workflows, execution summary generation strategies, reporting and documentation approaches, integration with autonomous execution and hook systems
* **`bundle_security.md`:** Secure validation and reporting practices, protection against false completion reporting, validation of success criteria verification, safe handling of execution summaries and milestone documentation
* **`bundle_code_context.md`:** Milestone execution state and completion detection interfaces, success criteria validation utilities, reporting generation patterns, integration with hook system and autonomous execution infrastructure

---

## 5. Verification Context

**What it is:** Guidance for validating this task's completion.

* **Unit Test Scope:** The Validator Agent must test milestone success criteria validation logic and accuracy, verify execution summary generation includes all required information and formatting, validate completion confirmation and reporting delivery mechanisms, and confirm failure and partial completion handling provides appropriate guidance
* **Integration Test Scope:** The Validator Agent must test complete milestone execution workflow including final completion validation and reporting, verify completion validation works correctly across different milestone types and sizes, test integration with autonomous execution, hook system, and state management infrastructure, and confirm completion reporting provides valuable documentation and confirmation for Human Architects
* **Project-Wide Checks:** The Validator Agent must ensure completion validation follows SDD patterns for milestone success verification, verify that completion reporting provides comprehensive documentation suitable for project records, confirm that completion validation integrates seamlessly with the complete autonomous milestone execution workflow, and validate that completion reporting supports the retrospective analysis requirements for Slice 5