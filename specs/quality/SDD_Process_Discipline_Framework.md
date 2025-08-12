# SDD Process Discipline Framework

This framework establishes consistent process discipline across all phases of the Spec-Driven Development methodology. It ensures proper specialist agent usage, validates phase transitions, and maintains quality gates throughout the specification hierarchy.

## Core Process Principles

### Main Agent + Specialist Pattern (Universal)
The SDD methodology uses a consistent pattern across all phases:

- **Main Agent Role**: User conversation facilitation and coordination ONLY
- **Specialist Agent Role**: Domain expertise, research, and document creation
- **Never**: Main Agent creates documents directly (except Vision via conversation)
- **Never**: Quick edits instead of specialist revision
- **Always**: Use the appropriate specialist for each domain of work

### Phase Gate Requirements (All Phases)
Every transition between specification levels requires validation and approval:

- **Vision → Requirements**: Human Architect approval of vision completeness
- **Requirements → Architecture**: Requirements validation against vision + Human Architect approval
- **Architecture → Roadmap**: Architecture validation against requirements + Human Architect approval  
- **Roadmap → Milestone Plan**: Roadmap scope validation + Human Architect approval
- **Milestone Plan → Task Blueprints**: Milestone plan approval + validation of task sequences
- **Task Blueprint → Implementation**: Blueprint validation + Human Architect approval

### Universal Validation Checkpoints (All Phases)
Before any specialist invocation and at every phase gate:

1. **Requirements Consistency**: All references verified against source documents
2. **Scope Verification**: All additions justified against higher-level specifications
3. **Complexity Check**: Simplest approach that delivers specification value
4. **Persona Consistency**: All language follows SDD persona vocabulary guide
5. **Human Review Gate**: Explicit approval before proceeding to next phase

## Phase-Specific Process Applications

### `/init_greenfield` Process Discipline
**Phase Sequence**:
1. Main Agent conversation for Vision development only
2. Requirements Specialist for requirements generation (clean context with vision)
3. Architecture Specialist for architecture generation (clean context with vision + requirements)
4. Roadmap Specialist for roadmap generation (clean context with all prior specifications)
5. Human Architect approval at each phase gate before proceeding

**Quality Gates**:
- Vision completeness validation before Requirements Specialist invocation
- Requirements consistency validation before Architecture Specialist invocation
- Architecture feasibility validation before Roadmap Specialist invocation
- Final roadmap approval before project initialization completion

### `/plan_milestone` Process Discipline
**Pre-Specialist Validation** (Mandatory):
1. Requirements document analysis to identify actual REQ-XXX, NFR-XXX formats
2. Roadmap scope verification to confirm milestone features are in scope
3. Complexity check to start with simplest implementation approach
4. Generic example requirement verification for general-purpose capability

**Specialist Sequence**:
1. Milestone Planning Specialist for comprehensive milestone plan generation
2. Task Blueprint Specialist for individual task blueprint creation
3. Human Architect approval before blueprint creation begins

**Quality Gates**:
- Milestone plan validation against roadmap scope
- Task blueprint consistency validation against milestone plan
- Human Architect approval before any implementation begins

### `/task` Process Discipline
**Assembly Line Sequence** (No shortcuts allowed):
1. Bundler Specialist for context creation through codebase analysis
2. Coder Specialist for TDD-based implementation using context bundles
3. Validator Specialist for comprehensive quality verification
4. Human Architect decision-making on validation failures

**Quality Gates**:
- Context bundle completeness before Coder Specialist invocation
- Implementation validation before commit/merge operations
- Quality verification results review with Human Architect involvement for failures

## Universal Process Standards

### Specialist Invocation Rules
- **Main Agent**: Never bypass specialist for their domain of expertise
- **Context Isolation**: Each specialist receives only relevant, clean context
- **Research Integration**: Specialists perform web research when creating strategic documents
- **Strategic Questions**: Specialists generate numbered questions for specification gaps
- **Quality Validation**: Specialists perform self-review and identify assumptions

### Human Architect Interaction Points
- **Strategic Decision Making**: All high-level decisions require Human Architect input
- **Approval Gates**: Explicit approval required before phase transitions
- **Clarification Points**: Human Architect provides clarification on specialist questions
- **Final Authority**: Human Architect has final authority on all specification decisions

### Validation and Quality Control
- **No Feature Creep**: All additions must be justified against higher-level specifications
- **No Invented Requirements**: All requirement IDs must trace to actual source documents
- **No Generic References**: Specify which agent or persona performs each action
- **No Assumption-Making**: When unclear, agents ask for clarification rather than assume

## Error Prevention Patterns

### Common Process Failures to Avoid
1. **Main Agent Document Creation**: Never create documents without appropriate specialist
2. **Phase Gate Skipping**: Never proceed without explicit Human Architect approval
3. **Quick Edit Shortcuts**: Always use specialist revision instead of direct edits
4. **Context Pollution**: Maintain clean, focused contexts for each specialist
5. **Requirement Invention**: Always validate against actual source documents

### Quality Assurance Integration
- **Template Compliance**: All documents must follow established SDD templates
- **Cross-Reference Validation**: All references must trace correctly through hierarchy
- **Persona Consistency**: All language must follow vocabulary guide standards
- **Complexity Justification**: All complexity beyond simplest approach must be justified

## Success Indicators

### Process Quality Metrics
- Consistent specialist usage across all domains
- Proper phase gate validation and approval
- Reduced requirement reference errors
- Higher specification consistency across phases

### Outcome Quality Metrics
- Specifications that enable clear implementation
- Reduced Human Architect correction time
- More accurate and contextual specialist outputs
- Improved cross-phase consistency and traceability

This framework ensures that the SDD methodology maintains high standards of process discipline while leveraging the full capabilities of the Human Architect + AI Agent collaboration model.