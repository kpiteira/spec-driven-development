---
id: TASK-002
title: "Create plan_milestone command with hybrid Main Agent + Sub-Agent pattern"
milestone_id: "M1-Project-Initialization"
requirement_id: "REQ-003, REQ-CMD-001, NFR-PERF-004"
slice: "Slice 2: Milestone Planning Command"
status: "completed"
branch: "feature/TASK-002-plan-milestone-command"
---

## 1. Task Overview & Goal

**What it is:** Create the `.claude/commands/plan_milestone.md` file that implements the proven hybrid Main Agent + Sub-Agent pattern from `/init_greenfield` to transform roadmap goals into detailed, executable milestone plans AND individual task blueprint files.

**Goal:** Build a structured conversation workflow that follows the successful `/init_greenfield` architecture: Main Agent handles user conversation and coordination, while specialist sub-agents handle document creation (milestone plan + task blueprints) with iterative refinement.

**Context:** This is the critical fix to ensure command instruction compliance. The current `/plan_milestone` command breaks down by abandoning the proven sub-agent pattern. This task implements the hybrid approach that makes `/init_greenfield` successful, ensuring both milestone plans AND task blueprints are created through specialist sub-agents.

---

## 2. The Contract: Requirements & Test Cases

**What it is:** The specific, testable requirements that ensure the `/plan_milestone` command follows the proven hybrid Main Agent + Sub-Agent pattern and creates ALL required deliverables.

* **Behavior 1: Hybrid Architecture Implementation**
  * **Given:** The command file is created as `.claude/commands/plan_milestone.md` with proper frontmatter
  * **When:** The command executes
  * **Then:** Main Agent must handle ALL user conversation and coordination
  * **And:** Main Agent must use Task tool to invoke "milestone-planning-specialist" for milestone plan creation
  * **And:** Main Agent must use Task tool to invoke "task-blueprint-specialist" for individual task blueprint creation
  * **And:** Frontmatter must include `allowed-tools: ["Write", "Read", "LS", "Task"]` to enable sub-agent coordination
  * **And:** Must follow `REQ-CMD-001` frontmatter requirements with `model: claude-opus-4-1-20250805`

* **Behavior 1.5: Required Sub-Agent Creation**
  * **Given:** The hybrid pattern requires specialist sub-agents for document creation
  * **When:** This task is implemented
  * **Then:** Must create `.claude/agents/milestone-planning-specialist.md` sub-agent file
  * **And:** Must create `.claude/agents/task-blueprint-specialist.md` sub-agent file
  * **And:** Each sub-agent must have proper YAML frontmatter with name, description, and appropriate allowed-tools
  * **And:** Sub-agents must be designed to receive context from Main Agent and produce complete, template-compliant documents
  * **And:** Sub-agents must include self-review capabilities and strategic question generation

* **Behavior 2: Strategic Conversation Phase**
  * **Given:** A user executes `/plan_milestone "M2-Core-Execution"` with existing project specifications
  * **When:** Main Agent conducts strategic conversation
  * **Then:** Must analyze existing roadmap to extract milestone goals and requirements
  * **And:** Must ask numbered strategic questions to clarify vertical slice approach and task breakdown
  * **And:** Must gather user decisions on priorities, dependencies, and implementation approach
  * **And:** Must collect sufficient context for sub-agents to create comprehensive documents

* **Behavior 3: Milestone Plan Creation via Sub-Agent**
  * **Given:** Strategic conversation is complete with user decisions captured
  * **When:** Main Agent invokes "milestone-planning-specialist" via Task tool
  * **Then:** Sub-agent must create complete milestone plan document following SDD template structure
  * **And:** Plan must include goals, scope, vertical slices, testing plan, and definition of done
  * **And:** Sub-agent must perform self-review and identify any gaps or needed clarifications
  * **And:** Main Agent must present sub-agent questions to user for refinement if needed

* **Behavior 4: Task Blueprint Creation via Sub-Agent**
  * **Given:** Milestone plan is approved and contains task sequences with TASK-XXX identifiers
  * **When:** Main Agent invokes "task-blueprint-specialist" via Task tool
  * **Then:** Sub-agent must create individual task blueprint files for each TASK-XXX in the milestone
  * **And:** Each blueprint must follow the SDD task blueprint template structure
  * **And:** Blueprints must include goal, contract (Given/When/Then), context bundle manifest, and verification context
  * **And:** All task blueprint files must be written to the appropriate `tasks/` directory
  * **And:** Task blueprints must be internally consistent with the milestone plan

* **Behavior 5: Complete Deliverable Creation**
  * **Given:** The planning process completes
  * **When:** All sub-agents finish their work
  * **Then:** Must create both milestone plan document AND all individual task blueprint files
  * **And:** All documents must be template-compliant and cross-referenced properly
  * **And:** Must provide clear completion confirmation listing all created files
  * **And:** Must validate that the milestone is ready for execution via `/milestone` command

---

## 3. Context Bundle (Agent-Populated Sibling Files)

**What it is:** This section serves as a manifest for the context files that will provide comprehensive guidance for implementing the hybrid Main Agent + Sub-Agent pattern.

* **`bundle_architecture.md`:** Contains the proven hybrid architecture pattern from `/init_greenfield`, including:
  * **Sub-Agent Coordination:** How Main Agent uses Task tool to invoke specialist sub-agents
  * **Iterative Refinement Process:** Main Agent ↔ Sub-Agent ↔ Main Agent ↔ User workflow pattern
  * **SDD Milestone Planning Methodology:** Vertical slice principles and task breakdown patterns
  * **Document Template Structures:** Complete milestone plan and task blueprint template specifications

* **`bundle_security.md`:** Contains security guidance for:
  * **Parameter Validation:** Safe handling of milestone names and user inputs
  * **File System Operations:** Secure creation of milestone plans and task blueprint files
  * **Sub-Agent Invocation Security:** Safe Task tool usage and context passing

* **`bundle_code_context.md`:** Contains implementation details for:
  * **Successful `/init_greenfield` Pattern:** Exact implementation of hybrid Main Agent + Sub-Agent approach
  * **Task Tool Usage:** How to properly invoke sub-agents with appropriate context and instructions
  * **Specialist Sub-Agent Design:** Required capabilities for "milestone-planning-specialist" and "task-blueprint-specialist"
  * **Document Generation Patterns:** How sub-agents create template-compliant documents with self-review
  * **Iterative Refinement Logic:** How to handle sub-agent questions and user feedback loops

---

## Additional Implementation Guidance

**What it is:** Specific guidance for creating the two required specialist sub-agents to ensure they work effectively with the Main Agent.

### Sub-Agent 1: `milestone-planning-specialist`

**Purpose:** Creates comprehensive milestone plan documents following SDD methodology and template structure.

**Required Capabilities:**
- Analyze roadmap context and user strategic decisions to create actionable milestone plans
- Follow SDD milestone plan template structure exactly (`specs/templates/4_Milestone_Plan_Template.md`)
- Break milestone work into logical vertical slices with clear user value and acceptance criteria
- Generate proper task sequences with TASK-XXX identifiers for each vertical slice
- Perform critical self-review to identify gaps, assumptions, or missing elements
- Generate numbered strategic questions when clarification is needed from user
- Create template-compliant documents with proper cross-references and requirement traceability

**Input Context:** Roadmap analysis, user strategic decisions, milestone goals, requirement scope, project specifications

**Output:** Complete milestone plan document + strategic questions for any identified gaps

### Sub-Agent 2: `task-blueprint-specialist`

**Purpose:** Creates individual task blueprint files for each TASK-XXX identified in approved milestone plans.

**Required Capabilities:**
- Transform milestone plan task sequences into detailed, atomic task blueprints
- Follow SDD task blueprint template structure exactly (`specs/templates/5_Task_Blueprint_Template.md`)
- Create specific, testable Given/When/Then acceptance criteria for each task
- Define appropriate context bundle manifests for Bundler, Security, and Validator agents
- Ensure task blueprints are internally consistent with milestone plan goals and scope
- Generate proper task metadata (id, title, milestone_id, requirement_id, slice, status, branch)
- Perform quality validation to ensure task blueprints are executable and atomic

**Input Context:** Approved milestone plan, vertical slice definitions, task sequences, project architecture patterns

**Output:** Individual task blueprint files for each TASK-XXX + validation report on blueprint quality

**Critical Success Factor:** Both sub-agents must work together seamlessly - task blueprints must be perfectly aligned with milestone plan structure and requirements.

---

## 4. Verification Context

**What it is:** Comprehensive guidance for validating that the hybrid Main Agent + Sub-Agent pattern is correctly implemented and produces complete deliverables.

* **Architecture Pattern Compliance:** Tests must verify the command follows the proven `/init_greenfield` hybrid pattern:
  * Main Agent handles conversation and coordination
  * Task tool used to invoke specialist sub-agents
  * Iterative refinement process with user feedback
  * No autonomous document generation by Main Agent

* **Complete Deliverable Creation:** Tests must verify that executing `/plan_milestone "Test-Milestone"` produces:
  * One milestone plan document following SDD template structure
  * Individual task blueprint files for each TASK-XXX identified in the plan
  * All files written to appropriate directories (`milestone_plan.md` and `tasks/TASK-XXX.md`)
  * Template-compliant document structure and cross-references

* **Sub-Agent Integration:** Tests must verify proper sub-agent coordination:
  * "milestone-planning-specialist" successfully creates milestone plans with self-review
  * "task-blueprint-specialist" successfully creates individual task blueprints
  * Sub-agents generate strategic questions when gaps exist
  * Main Agent presents sub-agent questions to user appropriately

* **Instruction Compliance:** Tests must verify the command never abandons the hybrid pattern:
  * No autonomous planning by Main Agent without sub-agents
  * No incomplete deliverables (plan without blueprints)
  * No skipping of strategic conversation phase
  * Proper error handling when sub-agents fail

* **Self-Validation Test:** The corrected command must successfully plan Milestone 2 with both milestone plan and complete set of task blueprints as proof of pattern effectiveness.