---
allowed-tools: ["Write", "Read", "LS", "Task"]
argument-hint: "[milestone-name]"
description: "Create comprehensive milestone plans and task blueprints through guided conversation using hybrid Main Agent + Sub-Agent approach"
model: claude-opus-4-1-20250805
---

# Milestone Planning with SDD Methodology

**MAIN AGENT ROLE**: Context coordinator and user conversation facilitator ONLY. You do NOT conduct strategic analysis, milestone breakdown, or document creation - that's the specialist's responsibility.

Your job is to quickly validate context and immediately hand off to specialist sub-agents who handle all strategic analysis and document creation.

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

## Phase 2: Quick Context Preparation & Immediate Handoff

**Main Agent Responsibility**: Quickly gather context and immediately delegate to specialists. Do NOT conduct lengthy strategic conversations - that's the specialist's job.

**Quick Context Gathering** (minimize questions):
1. Confirm the target milestone is correct and appropriate for current project phase
2. Only ask critical questions if information is genuinely missing from existing documents

**Immediate Handoff**: After basic context validation, immediately proceed to Phase 3 specialist invocation. The milestone-planning-specialist will identify strategic gaps and generate appropriate questions.

## Phase 2.5: Mandatory Simplicity Principles

**CRITICAL**: Before any specialist invocation, establish these universal constraints that apply to ALL projects:

### Simplicity Principles (Project-Agnostic)

1. **Study Existing Patterns**: Review previous milestones if they exist - identify what made them successful
2. **Leverage Over Create**: Extend existing components rather than building new infrastructure
3. **Atomic Tasks**: Each task must be completable in 2-8 hours
4. **Concrete Over Abstract**: Specify actual files, commands, and outputs - no abstract architectural discussions
5. **Template Baseline**: Match the complexity level shown in template examples

### Complexity Scoring System

**Task Complexity Levels**:
- **Level 1**: Configuration/prompt changes, file modifications
- **Level 2**: Simple integrations with existing systems
- **Level 3**: New components with clear, defined boundaries
- **Level 4**: Multi-component systems requiring coordination
- **Level 5**: Architectural changes affecting multiple systems

**Mandatory Limits**:
- Average milestone complexity ≤ 2.5
- No individual task > Level 3
- If any task seems Level 4+, break it down or simplify approach

### Anti-Pattern Detection

**Immediately reject specialist proposals containing**:
- Complex parsing systems (AI agents read documents directly)
- "Intelligent analysis engines" or "smart processors"
- Reinventing existing infrastructure
- Abstract tasks without concrete deliverables
- "Big bang" tasks taking more than 8 hours

**Pass these constraints to the specialist with every invocation.**

## Phase 2.6: Learn from History

**Before beginning milestone planning, integrate learnings from previous experience:**

1. **Read Previous Retrospectives**: Check for retrospective files in `specs/retrospectives/*.md`
   - Extract patterns that worked well
   - Note complexities to plan for
   - Identify specific recommendations to apply

2. **Pass Historical Context to Specialist**: Include retrospective insights in specialist instructions:
   - "Apply these successful patterns: [list from retrospectives]"
   - "Avoid these identified pitfalls: [list from retrospectives]"
   - "Account for these discovered complexities: [specific factors from experience]"

## Phase 3: Iterative Discovery Process

**CRITICAL**: Use multi-phase discovery conversation to prevent over-engineering and ensure concrete, implementable plans.

### Step 3.1: Initial Analysis & Hypothesis Formation
**Main Agent → Milestone Planning Specialist**:
"Analyze project context and create:
1. Initial hypothesis about milestone goals and key capabilities
2. Rough feature/task list with rationale for each
3. Strategic questions needing user input for concrete specification  
4. Complexity assessment using simplicity principles and template examples"

**Quality Gate**: Main Agent verifies specialist output contains:
- Questions that are specific and actionable (not abstract)
- Rough plan follows simplicity principles from Phase 2.5
- Features clearly leverage existing infrastructure where possible
- 5-10 strategic questions for user clarification

### Step 3.2: User Discovery Conversation
**Main Agent ↔ User**:
- Present rough plan and strategic questions conversationally
- Explore each feature in detail - get specific about files, commands, integration points
- Challenge complexity: "Could we use existing X instead of building Y?"
- Document specific implementation decisions and approaches
- Continue until concrete implementation approaches are clear

### Step 3.3: Iteration Decision Point
**Specialist Assessment**: "Do I have enough concrete detail to create atomic tasks?"
- **If NO**: Generate more targeted questions focusing on implementation specifics
- **If YES**: Proceed to detailed milestone plan creation with discovered constraints

### Step 3.4: Detailed Plan Creation with Discovered Constraints
**Main Agent → Specialist**: Create detailed milestone plan using:
- All discovered implementation specifics as requirements (not suggestions)
- Simplicity principles and anti-pattern constraints from Phase 2.5
- Historical learnings from Phase 2.6
- Concrete integration approaches from discovery conversation

## Phase 4: Hybrid Document Generation - Milestone Plan Creation

**CRITICAL**: Follow the validated hybrid approach: **Main Agent handles user conversation**. **Specialist Sub-Agents** handle document creation with iterative refinement. The process is: Main Agent ↔ Sub-Agent ↔ Main Agent ↔ User.

### Milestone Plan Creation - **Iterative Main Agent ↔ Milestone Planning Specialist**

**Iterative Process:**

1. **Main Agent → Milestone Planning Sub-Agent**: Use Task tool to invoke "milestone-planning-specialist" with:
   - Complete roadmap analysis and milestone context
   - Project specifications (Vision, Requirements, Architecture) for context
   - Target milestone identification and basic context validation from Phase 2
   - **CRITICAL**: Let the specialist analyze documents, identify gaps, and generate strategic questions
   - Instruction to act as milestone planning specialist who analyzes existing documents first, then creates actionable plans and identifies strategic gaps

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

## Phase 5: Hybrid Document Generation - Task Blueprint Creation

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

5. **MANDATORY VERIFICATION**: Before completing, Main Agent must verify that each generated task blueprint:
   - **Exactly matches** the corresponding TASK-XXX description from the approved milestone plan
   - **Aligns with** the specified task sequence and slice goals
   - **References correct** architectural patterns and requirements from milestone context
   - **Does not hallucinate** requirements not present in the milestone plan

**Task Blueprints Must Include:**
- **Task Overview & Goal**: Clear purpose and context for each task
- **The Contract**: Specific Given/When/Then acceptance criteria that are testable
- **Context Bundle Manifest**: Required context files for Bundler, Security, and Validator agents
- **Verification Context**: Testing and validation requirements for each task

## Phase 6: Deliverable Creation & Validation

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
- Main Agent handles ALL user conversation and coordination ONLY
- **Main Agent NEVER conducts strategic analysis** - that's the specialist's job  
- **Main Agent NEVER breaks down milestones** - that's the specialist's job
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