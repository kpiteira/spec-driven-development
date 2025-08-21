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

## Phase 3: Strategic Thinking and Reality-Checking Process

**CRITICAL**: Transform from document generator to strategic thinking facilitator. Refuse shallow thinking and force deep implementation reality consideration.

### Step 3.1: Initial Analysis & Strategic Challenge Formation
**Main Agent → Milestone Planning Specialist**:
"Analyze project context and create:
1. Initial hypothesis about milestone goals and key capabilities
2. Rough feature/task list with rationale for each
3. **MANDATORY**: Strategic challenges for EVERY proposed task asking 'How does this actually work end-to-end?'
4. Reality-check questions challenging assumptions about 'simple' implementation
5. Context separation analysis - what needs separate execution contexts and why
6. Edge case identification for both simple and complex project scenarios"

**Quality Gate**: Main Agent verifies specialist output contains:
- **Strategic challenges** that question implementation assumptions for every task
- **Reality-check questions** that force consideration of actual execution details
- **Context separation analysis** identifying development vs validation vs user contexts
- **Edge case scenarios** for both simple (Obsidian plugin) and complex (ktrdr-level) projects
- Concrete file operations, user interactions, and integration patterns specified

### Step 3.2: Strategic Challenging Conversation
**Main Agent ↔ User** - Become the strategic challenger:
- Present rough plan then **CHALLENGE EVERY ASSUMPTION**
- For each proposed task ask: "How does this actually work end-to-end?"
- Challenge vocabulary: "What exactly do you mean by [vague term]?"
- Force edge case thinking: "How does this handle [complex scenario]?"
- Question context: "Does this need separate Claude Code instances? Why?"
- Demand implementation specifics: "What files? What user interactions? What error handling?"
- Continue until **NO TASK can be misinterpreted**

### Step 3.3: Deep Task Description Requirement
**MANDATORY QUALITY GATE**: Each task must have:
- **Full paragraph minimum** explaining complete implementation scope
- **Technical implementation details** - exact files, logic, integration points
- **User interaction patterns** - specific conversation flows, confirmations, error scenarios
- **Edge case handling** - how it works for both simple and complex scenarios
- **Context separation** - what execution contexts are needed and why
- **Validation criteria** - specific, measurable success criteria

**If ANY task is a single sentence or lacks implementation details → REJECT and re-challenge**

### Step 3.4: Reality vs Idealism Validation
**Main Agent must verify each task addresses:**
- **Simple scenario** (e.g., Obsidian plugin): How does this work for straightforward projects?
- **Complex scenario** (e.g., ktrdr): How does this handle multi-service, polyglot, complex architectures?
- **Error conditions**: What goes wrong and how do we handle it?
- **Context pollution**: Does this need separate Claude Code instances to avoid mixing development and validation contexts?
- **Learning transfer**: How do validation results improve the system?

### Step 3.5: Strategic Question Protocol
**For EVERY task, Main Agent must ask:**
1. "How does this actually work end-to-end?"
2. "What are the most likely ways this could be implemented wrong?"
3. "What edge cases exist that could break this?"
4. "Does this need context separation? Why?"
5. "How do we know this task succeeded?"
6. "What files does this touch? What user interactions occur?"
7. "How does this handle both simple and complex projects?"

**Continue strategic questioning until user provides implementation-level detail for every task**

## Phase 4: Hybrid Document Generation - Milestone Plan Creation

**CRITICAL**: Follow the validated hybrid approach: **Main Agent handles user conversation**. **Specialist Sub-Agents** handle document creation with iterative refinement. The process is: Main Agent ↔ Sub-Agent ↔ Main Agent ↔ User.

### Milestone Plan Creation - **Iterative Main Agent ↔ Milestone Planning Specialist**

**Iterative Process:**

1. **Main Agent → Milestone Planning Sub-Agent**: Use Task tool to invoke "milestone-planning-specialist" with:
   - Complete roadmap analysis and milestone context
   - Project specifications (Vision, Requirements, Architecture) for context
   - **ALL strategic questioning results** and implementation details discovered in Phase 3
   - **MANDATORY**: Requirement to create detailed task descriptions (full paragraphs minimum with technical implementation details)
   - **CRITICAL**: Template compliance with updated SDD templates requiring end-to-end thinking
   - Instruction: "You are NOT a document generator. You are a strategic implementation planner. Every task needs implementation-level detail."

2. **Milestone Planning Sub-Agent → Main Agent**: Specialist returns:
   - Complete draft milestone plan document following updated SDD template structure (`specs/templates/4_Milestone_Plan_Template.md`)
   - **VERIFICATION**: Every task has full paragraph with technical implementation, user interaction, and edge case details
   - **NO single-sentence tasks allowed** - reject any shallow descriptions
   - Vertical slice breakdown with detailed task sequences using proper TASK-XXX identifiers
   - Context separation requirements and validation criteria for each task

3. **Main Agent ↔ User**: Present specialist's strategic questions in conversation, gather detailed answers and refinements
   - **REFUSE to accept shallow answers** - ask follow-up questions until implementation is clear
   - **Challenge every vague response** with "What exactly do you mean by [term]?"
   - **Demand concrete specifics** for files, user interactions, error handling, edge cases
   - **Continue questioning** until every task has implementation-level clarity

4. **Iterate**: Return to Milestone Planning Sub-Agent with user answers to refine plan until solid, comprehensive, and executable
   - **MANDATORY**: Multiple rounds of refinement until NO task can be misinterpreted
   - **Quality check**: Each iteration must improve task description detail and clarity
   - **User confirmation required**: "Are you confident a developer could implement this without guessing?"

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
   - Complete approved milestone plan document with detailed task descriptions
   - Vertical slice definitions with task sequences
   - Project architecture patterns and constraints
   - **CRITICAL**: Instruction to extend milestone task descriptions with MORE implementation detail, not repeat them
   - Emphasis on simplicity: only add details that help agents avoid real mistakes

2. **Task Blueprint Sub-Agent → Main Agent**: Specialist returns:
   - Individual task blueprint files for each TASK-XXX identified in the milestone plan
   - Each blueprint following updated SDD task blueprint template structure (`specs/templates/5_Task_Blueprint_Template.md`)
   - **Extension approach**: Start with milestone paragraph, add discovered implementation details
   - **Agent-focused sections**: Only filled if specific, valuable information exists
   - Quality validation report ensuring blueprints extend (not repeat) milestone descriptions

3. **Main Agent ↔ User**: **MANDATORY** - Present ALL specialist questions with hypotheses to the Human Architect
   - **Never answer specialist questions autonomously** - always involve the human
   - Present questions in specialist's format: hypotheses with reasoning, then ask for user choice
   - Gather human clarifications and decisions about implementation approaches
   - Confirm task breakdown approach and any discovered requirements

4. **Iterate**: Return to Task Blueprint Sub-Agent with **human feedback only** to refine blueprints until all tasks are well-specified and executable
   - Pass human decisions back to specialist, not Main Agent interpretations
   - Continue until human confirms all task blueprints are clear and implementable

5. **MANDATORY VERIFICATION**: Before completing, Main Agent must verify that each generated task blueprint:
   - **Starts with the exact milestone task description** then extends it with additional detail
   - **Adds value through specifics** rather than generic template-filling
   - **References concrete project elements** (existing files, documented patterns, architectural decisions)
   - **Does not invent complexity** to fill template sections

**Task Blueprints Must Include:**
- **Task Description**: Exact milestone description plus discovered implementation details
- **Implementation Guidance**: Only specific guidance discovered through specialist analysis
- **Success Criteria**: Specific Given/When/Then acceptance criteria based on discovered requirements

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

## Phase 7: Planning Retrospective (Immediate Learning Capture)

**CRITICAL**: Conduct comprehensive planning retrospective immediately after milestone planning completion to capture fresh insights for future planning sessions.

**Retrospective Focus**: Analyze the planning process itself, not the implementation (that comes after `/milestone` execution).

### Step 1: Agent Self-Introspection and Issue Analysis (FIRST)

**Main Agent Self-Reflection**: Before engaging the Human Architect, perform comprehensive self-analysis:

1. **Process Issues Encountered:**
   - Which phases of the planning process caused confusion or required multiple iterations?
   - Where did agent-to-specialist handoffs encounter problems?
   - What requirements validation issues were discovered?
   - Which strategic questions from specialists were unclear or unhelpful?

2. **Specialist Performance Analysis:**
   - Did the Milestone Planning Specialist struggle with any aspects of roadmap analysis or task breakdown?
   - Were there gaps in the Task Blueprint Specialist's understanding of implementation requirements?
   - What assumptions were made that later proved incorrect?
   - Which template sections caused confusion or required clarification?

3. **Communication and Context Issues:**
   - Where did persona confusion occur (agents vs humans, parsing vs comprehension)?
   - Which instructions were misinterpreted by specialists?
   - What context handoffs lost important information?
   - Where did requirement references fail validation?

4. **Complexity and Scope Issues:**
   - Where did over-engineering creep into the planning process?
   - Which features were added beyond roadmap scope?
   - What parallel execution complexity was considered and rejected/accepted?
   - Where did simplicity-first principles get violated?

### Step 2: Present Agent Analysis to Human Architect

**Structured Presentation**: Share the self-introspection findings with the Human Architect:
- "Here's what I observed about issues during our planning process..."
- "The specialists encountered these specific challenges..."
- "I noticed these patterns that might need attention in future planning..."

### Step 3: Human Architect Feedback Collection (SECOND)

Ask the Human Architect to reflect on and add to the agent analysis:

1. **Planning Process Effectiveness:**
   - Which parts of the planning process were most/least valuable?
   - Where did we spend too much time or get stuck?
   - Did the iterative refinement approach work well?
   - What would make future planning sessions more efficient?

2. **Agent and Specialist Performance:**
   - Were the strategic questions from specialists helpful?
   - Did task breakdowns seem logical and implementable?
   - What would you want different from agents/specialists next time?
   - Were there human/AI collaboration issues to address?

3. **Quality and Outcome Assessment:**
   - Did we achieve the right level of detail without over-engineering?
   - Are there patterns we should document for future reference?
   - What assumptions or decisions should be validated during implementation?
   - Were the deliverables (milestone plan + task blueprints) what you expected?

### Step 4: Create Comprehensive Learning Document

Create detailed retrospective file: `specs/retrospectives/PLANNING_M[X]_[Date].md` combining agent insights with human feedback:

**Required Sections:**
- **Planning Duration**: Actual time spent vs. expectations with breakdown by phase
- **Agent Self-Analysis**: Specific issues agents encountered and patterns identified
- **Process Issues**: What didn't work, confusion points, inefficiencies from both perspectives
- **What Worked Well**: Successful techniques, decisions, approaches that should be repeated
- **Human-AI Collaboration**: Communication issues, handoff problems, expectation mismatches
- **Scope and Complexity Management**: Over-engineering incidents, requirement creep, simplicity violations
- **Recommendations**: Concrete, actionable suggestions for improving future milestone planning
- **Strategic Insights**: High-level insights about project complexity, scope, or methodology improvements

**Integration**: These learnings feed directly into Phase 2.6 of future `/plan_milestone` executions and inform SDD methodology evolution.