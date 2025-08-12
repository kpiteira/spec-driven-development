# SDD Process Retrospective Framework

This framework provides structured retrospective analysis across all phases of the Spec-Driven Development methodology. It enables continuous improvement by systematically identifying process issues, persona confusion, requirement inconsistencies, and complexity management opportunities.

## Universal Retrospective Questions (All Phases)

### Persona Effectiveness Analysis
**Human/AI Role Clarity**:
- Were Human Architect and AI agent roles clearly distinguished throughout the phase?
- Did each agent operate within their appropriate domain of expertise?
- Were there instances where roles were confused or responsibilities unclear?
- Did specialists maintain clean context isolation without contamination from other domains?

**Vocabulary Consistency**:
- Did agents use appropriate persona-aware vocabulary throughout the process?
- Were there confusing references to "the system" instead of specific agents?
- Did implementation language emphasize document comprehension over programmatic parsing?
- Were technical terms used appropriately without causing implementation confusion?

### Process Discipline Assessment
**Specialist Usage Patterns**:
- Was the appropriate specialist agent used for each domain of work?
- Were there shortcuts that bypassed specialist expertise for convenience?
- Did specialists receive clean, focused context appropriate for their domain?
- Was the Main Agent + Specialist pattern followed consistently?

**Phase Gate Compliance**:
- Were validation checkpoints completed before proceeding to next phases?
- Was Human Architect approval obtained at all required phase transitions?
- Were quality gates respected or bypassed due to time pressure or convenience?
- Did each phase provide adequate foundation for subsequent phases?

### Requirements Consistency Evaluation
**Reference Accuracy**:
- Were all requirement references verified against actual source documents?
- Were any requirement IDs invented rather than traced to authoritative sources?
- Did cross-references maintain accuracy throughout the specification hierarchy?
- Were requirement descriptions consistent across all document references?

**Scope Boundary Respect**:
- Did the phase deliverables stay within higher-level specification boundaries?
- Were additions properly justified against existing specifications?
- Was feature creep identified and addressed appropriately?
- Did scope expansion receive proper approval and documentation?

### Complexity Management Review
**Simplicity Discipline**:
- Was the simplest viable approach chosen as the starting point?
- Were complexity additions properly justified with clear rationale?
- Did complexity serve actual requirements or represent over-engineering?
- Were simpler alternatives adequately considered before adding complexity?

**Value Delivery Focus**:
- Did complexity additions contribute proportionally to user value delivery?
- Were features implemented that weren't present in higher-level specifications?
- Did the final complexity level align with strategic importance and requirements?
- Were maintenance implications of complexity decisions adequately considered?

## Phase-Specific Retrospective Analysis

### Vision Phase Retrospective
**Strategic Clarity**:
- Does the mission statement clearly communicate the project's core purpose?
- Is the problem definition specific enough to guide requirement decisions?
- Are target user personas well-defined and actionable for development?
- Do strategic goals align with and support the mission statement?

**Foundation Quality**:
- Would the vision enable clear requirements generation by specialists?
- Are there ambiguities that might lead to requirement inconsistencies?
- Does the vision provide sufficient constraint without over-specification?
- Would stakeholders have consistent understanding based on this vision?

### Requirements Phase Retrospective
**Completeness and Consistency**:
- Do functional requirements adequately address the vision goals?
- Are NFRs specific, measurable, and architecturally actionable?
- Is the distinction between essential and enhancement features clear?
- Do all requirements trace clearly back to vision elements?

**Specialist Effectiveness**:
- Did the Requirements Specialist perform adequate domain research?
- Were strategic questions generated appropriately for specification gaps?
- Did the specialist maintain focus on requirements without architectural decisions?
- Was Human Architect input sought appropriately for clarification?

### Architecture Phase Retrospective
**Technical Alignment**:
- Does the architecture adequately address all NFRs from requirements?
- Are technology choices justified by specific requirements rather than preferences?
- Do design patterns serve actual complexity needs rather than theoretical benefits?
- Would the architecture enable clear implementation by development teams?

**Strategic Integration**:
- Does the architecture support the vision and requirements without over-engineering?
- Are architectural constraints clearly communicated for roadmap planning?
- Did the Architecture Specialist balance research depth with decision clarity?
- Were trade-offs between options clearly documented and justified?

### Roadmap Phase Retrospective
**Strategic Sequencing**:
- Do milestones deliver coherent value at each completion point?
- Is the progression logical given architectural dependencies and constraints?
- Are milestone boundaries clear and meaningful to stakeholders?
- Does the roadmap balance risk management with value delivery speed?

**Requirement Integration**:
- Are all essential requirements addressed across the milestone sequence?
- Is the grouping of requirements into milestones logical and coherent?
- Do milestones align with realistic delivery capabilities given the architecture?
- Were enhancement requirements appropriately deferred to later milestones?

### Milestone Planning Phase Retrospective
**Tactical Effectiveness**:
- Do task sequences logically deliver the milestone's stated value?
- Are acceptance criteria clear and measurable for each vertical slice?
- Would the task breakdown enable effective implementation coordination?
- Does the plan balance comprehensiveness with execution simplicity?

**Requirement Traceability**:
- Do all tasks clearly trace to specific requirements and roadmap elements?
- Are task boundaries appropriate for atomic implementation and testing?
- Would task completion collectively deliver the expected milestone value?
- Are integration points between tasks clearly defined and manageable?

### Implementation Phase Retrospective
**Assembly Line Effectiveness**:
- Did the Bundler Specialist provide adequate context for implementation?
- Was the Coder Specialist able to implement based on task blueprints and context?
- Did the Validator Specialist catch quality issues effectively?
- Were handoffs between specialists smooth and information-preserving?

**Quality Achievement**:
- Did the implementation meet the acceptance criteria defined in task blueprints?
- Were architectural constraints and patterns followed consistently?
- Did the validation process catch issues before they reached production?
- Was the final implementation aligned with original vision and requirements?

## Improvement Action Planning

### Issue Categorization
**Process Issues**:
- Specialist usage patterns that need adjustment
- Phase gate compliance problems requiring attention
- Communication patterns between Human Architect and specialists

**Quality Issues**:
- Requirement consistency problems requiring framework updates
- Complexity management failures needing better controls
- Template or standard inadequacies affecting deliverable quality

**Systemic Issues**:
- Vocabulary or persona confusion requiring training or documentation updates
- Tool or framework inadequacies requiring methodology improvements
- Pattern recognition for broader SDD methodology enhancement

### Root Cause Analysis
**Process Root Causes**:
- Training gaps in specialist usage patterns
- Unclear phase gate requirements or validation criteria
- Time pressure leading to shortcuts and quality compromises

**Quality Root Causes**:
- Inadequate templates or standards for specific domains
- Missing validation checkpoints or quality controls
- Insufficient guidance for complexity decision-making

**Communication Root Causes**:
- Unclear persona definitions or vocabulary standards
- Inadequate context isolation between specialist domains
- Missing escalation paths for unclear or complex decisions

### Improvement Recommendation Categories
**Immediate Process Adjustments**:
- Specific process changes that can be implemented immediately
- Training or communication improvements for current team members
- Quick fixes to templates or standards that are causing confusion

**Framework Evolution**:
- Updates to SDD methodology frameworks based on learning
- New quality standards or validation approaches
- Enhanced templates or guidance documents for specific domains

**Strategic Methodology Improvements**:
- Fundamental improvements to the Human Architect + AI Agent collaboration model
- Evolution of specialist agent capabilities or domain boundaries
- Integration improvements between phases or validation approaches

## Continuous Improvement Integration

### Regular Retrospective Schedule
- **Phase Completion Retrospectives**: After each specification phase completion
- **Milestone Retrospectives**: After each milestone delivery using dedicated template
- **Project Retrospectives**: At major project completion points
- **Methodology Retrospectives**: Quarterly review of SDD framework effectiveness

### Learning Capture and Sharing
- **Pattern Documentation**: Capture recurring issues and successful resolution patterns
- **Template Updates**: Evolve templates based on retrospective learning
- **Training Integration**: Incorporate retrospective insights into specialist training
- **Community Sharing**: Contribute methodology improvements to broader SDD community

This framework ensures that the SDD methodology continuously evolves and improves based on systematic reflection and learning from each phase and project experience.