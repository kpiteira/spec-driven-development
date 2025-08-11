# Milestone Planning Quality Checklist

**Purpose**: Systematic validation that milestone plans follow SDD principles and avoid common pitfalls.

**When to Use**: After creating a milestone plan but before beginning implementation.

---

## Phase 1: Discovery Process Validation

### Discovery Conversation Quality
- [ ] Did we have multiple rounds of discovery conversation with the user?
- [ ] Did we challenge each proposed feature for simplification opportunities?
- [ ] Did we identify which existing infrastructure components to leverage?
- [ ] Did we get specific about implementation approaches (files, commands, patterns)?
- [ ] Did the specialist ask 5-10 strategic questions before creating the plan?

### Specification Completeness
- [ ] Are all implementation approaches concrete rather than abstract?
- [ ] Do we have clear decisions on technology choices and integration points?
- [ ] Are user requirements translated into specific system capabilities?
- [ ] Did we resolve ambiguities through conversation rather than assumptions?

---

## Phase 2: Simplicity & Complexity Validation

### Overall Complexity Assessment
- [ ] Average task complexity ≤ Level 2.5 (using the 1-5 complexity scale)?
- [ ] No individual task > Level 3 complexity?
- [ ] Each task completable in 2-8 hours?
- [ ] Can each task be explained to a junior developer in one sentence?

### Task Atomicity Check
- [ ] Is each task focused on a single, clear deliverable?
- [ ] Are tasks neither too small (< 1 hour) nor too large (> 8 hours)?
- [ ] Does each task produce testable, verifiable output?
- [ ] Are task boundaries clean (minimal interdependencies)?

### Simplicity Principles Adherence
- [ ] Does the plan leverage existing infrastructure rather than reinventing?
- [ ] Are we extending/configuring rather than building from scratch?
- [ ] Do tasks follow patterns from successful previous milestones?
- [ ] Are we using simple prompt engineering over complex code where appropriate?

---

## Phase 3: Integration & Architecture Validation

### Task Integration Context
- [ ] Does each task explain WHY it exists in the milestone context?
- [ ] Are dependencies between tasks clearly mapped and minimal?
- [ ] Is it clear which existing components each task leverages?
- [ ] Are implementation hints concrete (specific files, commands, patterns)?

### Architecture Alignment
- [ ] Do tasks follow established architectural patterns from the project?
- [ ] Are integration points with existing systems clearly defined?
- [ ] Does the plan respect the project's technology stack and constraints?
- [ ] Are new components designed to fit cleanly into existing structure?

### Milestone Coherence
- [ ] Do the vertical slices build logically toward the milestone goal?
- [ ] Does each slice deliver independent user value?
- [ ] Are slice boundaries clean and testable?
- [ ] Is the milestone goal achievable with the defined tasks?

---

## Phase 4: Learning Integration Validation

### Retrospective Application
- [ ] Did we review retrospectives from previous milestones?
- [ ] Are we repeating successful patterns identified in retrospectives?
- [ ] Are we avoiding pitfalls and anti-patterns from past experience?
- [ ] Did we account for complexity factors discovered in previous work?

### Pattern Recognition
- [ ] Are we following proven approaches from successful milestones?
- [ ] Do we leverage solutions that worked well before?
- [ ] Are estimates informed by historical actuals for similar tasks?
- [ ] Did we apply specific recommendations from retrospectives?

---

## Phase 5: Anti-Pattern Detection

### Over-Engineering Check
- [ ] No complex parsing systems for AI-native operations?
- [ ] No "intelligent analysis engines" or "smart processors"?
- [ ] No reinventing of existing infrastructure or capabilities?
- [ ] No abstract architectural tasks without concrete deliverables?

### Big Bang Prevention
- [ ] No tasks taking more than 8 hours to complete?
- [ ] No "implement entire system" type tasks?
- [ ] No tasks requiring multiple major architectural decisions?
- [ ] No tasks with unclear or multiple success criteria?

### AI-Native Validation
- [ ] Are we using AI agent capabilities (document reading, conversation) appropriately?
- [ ] Do tasks avoid building parsers when agents can understand directly?
- [ ] Are validation approaches using agent intelligence rather than rigid automation?
- [ ] Do we prefer prompt engineering over complex code where appropriate?

---

## Phase 6: Quality Gates

### Template Compliance
- [ ] Does the milestone plan follow the SDD template structure exactly?
- [ ] Are all required sections completed with appropriate detail?
- [ ] Do task blueprints include the new Integration Context section?
- [ ] Are Given/When/Then acceptance criteria concrete and testable?

### Success Criteria Validation
- [ ] Are milestone success criteria specific and measurable?
- [ ] Can we verify milestone completion objectively?
- [ ] Are individual task acceptance criteria testable?
- [ ] Do success criteria align with user value delivery?

### Risk Assessment
- [ ] Have we identified the highest-risk tasks and planned appropriately?
- [ ] Are there clear fallback plans for complex integration tasks?
- [ ] Do we have sufficient buffer for learning/discovery during implementation?
- [ ] Are external dependencies identified and managed?

---

## Scoring & Decision

### Overall Quality Score
Rate each phase 1-5 (5 = excellent, 3 = acceptable, 1 = needs work):

- Discovery Process: ___/5
- Simplicity & Complexity: ___/5  
- Integration & Architecture: ___/5
- Learning Integration: ___/5
- Anti-Pattern Prevention: ___/5
- Quality Gates: ___/5

**Total: ___/30**

### Decision Criteria
- **25-30**: Excellent plan, ready for implementation
- **20-24**: Good plan, minor adjustments recommended
- **15-19**: Needs improvement, address major gaps
- **Below 15**: Significant rework required

### Action Required
- [ ] Plan approved as-is
- [ ] Plan approved with minor adjustments (list below)
- [ ] Plan needs revision in specific areas (list below)
- [ ] Plan requires complete rework

**Specific Actions Needed:**
1. [Action item if any]
2. [Action item if any]
3. [Action item if any]

---

**Completed By**: [Name]
**Date**: [YYYY-MM-DD]
**Milestone**: [Milestone Name]