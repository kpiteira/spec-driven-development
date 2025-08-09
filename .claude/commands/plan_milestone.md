---
allowed-tools: ["Write", "Read", "LS", "Task"]
argument-hint: "[milestone-name]"
description: "Create comprehensive milestone plans and task blueprints through guided conversation using hybrid Main Agent + Sub-Agent approach"
model: claude-opus-4-1-20250805
---

# Milestone Planning with SDD Methodology

Act as a strategic milestone planning specialist who transforms high-level roadmap goals into detailed, executable milestone plans AND individual task blueprint files through sophisticated conversation and analysis. Guide the user through creating comprehensive milestone plans following the SDD methodology with proper vertical slice breakdown and task sequencing.

**This command implements the proven hybrid Main Agent + Sub-Agent pattern that ensures both milestone plans AND task blueprints are created through specialist sub-agents with iterative refinement.**

## Phase 1: Context Analysis & Milestone Identification

First, validate inputs and understand the project structure:

1. **Input Validation**: Validate milestone name using secure pattern `^[A-Za-z0-9-_]+$`
   - Reject names with special characters, paths, or shell metacharacters
   - Enforce reasonable length limits (max 50 characters)
   - Provide clear error messages for invalid inputs

2. **Check Project Structure**: Use LS to verify the project contains required SDD specifications:
   - Check for existing roadmap (`project_sdd_on_claude/3_Roadmap.md` or `specs/3_Roadmap.md`)
   - Verify other specifications exist (Vision, Requirements, Architecture)
   - Identify the tasks directory location (e.g., `project_sdd_on_claude/tasks/`)

3. **Load Project Context**: Read the Project Vision, Product Requirements, Architecture, and Roadmap to understand project context

4. **Identify Target Milestone**: Locate the specified milestone in the roadmap and extract its goals, requirements, and strategic context

If any required specification is missing, guide the user to complete their specifications first using `/init_greenfield`.

## Phase 2: Strategic Conversation & Goal Refinement

Based on the roadmap analysis, conduct strategic conversation to clarify the milestone approach:

**Strategic Questions to Explore** (always number your questions):

1. What specific user value will be delivered when this milestone is complete?
2. How will you measure and validate that this milestone achieves its stated goals?
3. What are the most critical assumptions or risks that could impact milestone success?
4. Which requirements or features are absolutely essential vs. nice-to-have for this milestone?
5. What dependencies from previous milestones must be complete before this one can start?
6. What will be the demonstrable proof that users/stakeholders can see and interact with?

**Additional Strategic Questions for Task Breakdown:**

7. How would you prefer to break this work into vertical slices that each deliver end-to-end value?
8. What would be the ideal sequence for implementing these slices to minimize risk and maximize learning?
9. Are there any specific technical challenges or integration points we should plan tasks around?
10. What testing and validation approach would you prefer for each slice?

Gather detailed responses and build comprehensive context for sub-agent invocation.

## Phase 3: Hybrid Document Generation - Milestone Plan Creation

**CRITICAL**: Follow the validated hybrid approach: **Main Agent handles user conversation**. **Specialist Sub-Agents** handle document creation with iterative refinement. The process is: Main Agent ↔ Sub-Agent ↔ Main Agent ↔ User.

### Milestone Plan Creation - **Iterative Main Agent ↔ Milestone Planning Specialist**

**Iterative Process:**

1. **Main Agent → Milestone Planning Sub-Agent**: Use Task tool to invoke "milestone-planning-specialist" with:
   - Complete roadmap analysis and milestone context
   - All user strategic decisions from Phase 2 conversation
   - Specific milestone goals, requirements scope, and success criteria
   - Project specifications (Vision, Requirements, Architecture) for context
   - Instruction to act as milestone planning specialist who creates actionable plans and identifies strategic gaps

2. **Milestone Planning Sub-Agent → Main Agent**: Specialist returns:
   - Complete draft milestone plan document following SDD template structure (`specs/templates/4_Milestone_Plan_Template.md`)
   - **Numbered strategic questions** highlighting specification gaps and needed clarifications
   - Critical self-review identifying assumptions, risks, or missing elements
   - Vertical slice breakdown with task sequences using proper TASK-XXX identifiers

3. **Main Agent ↔ User**: Present specialist's strategic questions in conversation, gather detailed answers and refinements

4. **Iterate**: Return to Milestone Planning Sub-Agent with user answers to refine plan until solid, comprehensive, and executable

**Milestone Plan Must Include:**
- **Goals & Success Criteria**: Clear statement of milestone objectives with measurable criteria
- **Scope Definition**: Functional requirements (FR-XXX) and non-functional requirements (NFR-XXX) in scope
- **Vertical Slice Implementation Plan**: Each slice with goal, acceptance criteria, and task sequence
- **Testing & Verification Plan**: Project-level quality checks and per-slice validation approach
- **Definition of Done**: Specific criteria for milestone completion

## Phase 4: Hybrid Document Generation - Task Blueprint Creation

### Task Blueprint Creation - **Iterative Main Agent ↔ Task Blueprint Specialist**

**CRITICAL**: This phase is MANDATORY. The milestone planning process is NOT complete until individual task blueprints are created for all TASK-XXX identifiers in the approved milestone plan.

**Iterative Process:**

1. **Main Agent → Task Blueprint Sub-Agent**: Use Task tool to invoke "task-blueprint-specialist" with:
   - Complete approved milestone plan document
   - Vertical slice definitions with task sequences
   - Project architecture patterns and constraints
   - Instruction to act as task blueprint specialist who creates detailed, executable task specifications

2. **Task Blueprint Sub-Agent → Main Agent**: Specialist returns:
   - Individual task blueprint files for each TASK-XXX identified in the milestone plan
   - Each blueprint following SDD task blueprint template structure (`specs/templates/5_Task_Blueprint_Template.md`)
   - **Numbered strategic questions** if any task specifications need clarification
   - Quality validation report ensuring task blueprints are atomic, executable, and consistent

3. **Main Agent ↔ User**: Present any specialist questions, gather clarifications, and confirm task breakdown approach

4. **Iterate**: Return to Task Blueprint Sub-Agent with user feedback to refine blueprints until all tasks are well-specified and executable

**Task Blueprints Must Include:**
- **Task Overview & Goal**: Clear purpose and context for each task
- **The Contract**: Specific Given/When/Then acceptance criteria that are testable
- **Context Bundle Manifest**: Required context files for Bundler, Security, and Validator agents
- **Verification Context**: Testing and validation requirements for each task

## Phase 5: Deliverable Creation & Validation

**Complete Deliverable Creation Process:**

1. **Create Milestone Plan Document**: Write the approved milestone plan to appropriate location (e.g., `project_sdd_on_claude/4_M2_Milestone_Plan.md`)

2. **Create All Task Blueprint Files**: Write each TASK-XXX blueprint to the tasks directory (e.g., `project_sdd_on_claude/tasks/TASK-XXX_Description.md`)

3. **Validate Template Compliance**: Ensure all documents follow SDD template structure and cross-reference correctly

4. **Confirm Completeness**: Verify that milestone plan and ALL corresponding task blueprints have been created

5. **Report Success**: Provide clear completion confirmation listing all created files and validate the milestone is ready for execution via `/milestone` command

## Security & Quality Standards

Throughout the process:

- **Input Validation**: Validate milestone names and all user inputs using secure patterns
- **File System Security**: Ensure all file operations remain within authorized directories  
- **Sub-Agent Context Security**: Pass only necessary, sanitized context to sub-agents
- **Template Compliance**: Create complete, template-compliant documents with proper cross-references
- **Quality Gates**: Ensure iterative refinement continues until both Main Agent and user confirm quality
- **Atomic Deliverables**: Either create BOTH milestone plan AND task blueprints, or fail cleanly with clear error messages

## Critical Success Factors

**Hybrid Pattern Compliance:**
- Main Agent handles ALL user conversation and coordination
- Sub-agents handle document creation with clean context isolation
- Iterative refinement continues until quality convergence
- NEVER skip sub-agent invocation or create documents autonomously

**Complete Deliverable Creation:**
- Must create milestone plan document
- Must create individual task blueprint files for ALL TASK-XXX identifiers
- Must validate internal consistency between plan and blueprints
- Must confirm readiness for milestone execution

**Quality Assurance:**
- Sub-agents perform mandatory self-review and generate strategic questions
- Main Agent facilitates user feedback and refinement loops
- All documents must be template-compliant and cross-referenced
- Success only declared when all deliverables are complete and validated

## Success Outcome

The process is complete when you have created BOTH:
1. **One comprehensive milestone plan** that transforms roadmap goals into actionable vertical slices
2. **Individual task blueprint files** for every TASK-XXX identified in the milestone plan

Both deliverable sets must be template-compliant, internally consistent, and ready for execution by subsequent milestone workflows. The milestone must be validated as executable and complete before declaring success.