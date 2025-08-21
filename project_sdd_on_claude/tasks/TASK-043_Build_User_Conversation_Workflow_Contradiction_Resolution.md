---
version: "2.0.0"
template_type: "Task Blueprint"
description: "Detailed task specification extending milestone plan descriptions"
id: TASK-043
title: "Build user conversation workflow for resolving contradictions through hypothesis validation and roadmap enhancement"
milestone_id: "M6"
---

# Task Blueprint: TASK-043 Build user conversation workflow for resolving contradictions through hypothesis validation and roadmap enhancement

## 1. Task Description

**From Milestone Plan:** This task creates the structured user conversation workflow that will present contradictions through living documents and guide collaborative resolution through hypothesis validation, iterative refinement, and roadmap enhancement when gaps require code improvements.

*Technical Implementation:* Build conversation workflow that will present contradictions systematically using the living documents from TASK-042. Start with highest-impact discrepancies (those affecting project vision and major architectural decisions) and proceed to tactical details. The conversation presents 2-3 resolution proposals per contradiction with pros/cons analysis, allowing users to choose or propose alternatives. The workflow maintains conversation state to track resolution decisions and updates living documents in real-time.

*Structured Question Approach:* For each contradiction, present structured questions following this pattern: "**Contradiction [N]:** [Description]. **Documentation says:** [excerpt]. **Code shows:** [pattern]. **Hypothesis A:** [option with pros/cons]. **Hypothesis B:** [option with pros/cons]. **Hypothesis C:** [option with pros/cons]. **What's your preference?** [1/2/3/other]. **Additional context needed?** [Y/n]". Use numbered questions for easy user response and clear progress tracking through contradiction resolution.

*Roadmap Enhancement Logic:* When contradiction resolution reveals that code reality is behind documented intent (e.g., documentation describes microservices but code is monolithic), automatically generate improvement tasks for the roadmap. Task granularity depends on gap size: **Major gaps become milestones** (e.g., "M-ARCH: Migrate from monolithic to microservices architecture"), **Medium gaps become task groups** (e.g., "Implement missing API authentication described in architecture docs"), **Small gaps become individual tasks** (e.g., "Add missing error handling for user registration endpoint"). Each generated improvement includes: specific description referencing the contradiction, acceptance criteria based on documented intent, estimated complexity (high/medium/low), and priority recommendation.

*Iterative Refinement Process:* After each contradiction resolution, update the living documents and present updated sections to user for confirmation. Continue iterative refinement until user explicitly confirms satisfaction with all four specification documents. The conversation tracks: resolved contradictions count, remaining contradictions, user satisfaction score per document, and readiness to proceed to final generation.

*User Satisfaction Validation:* After each major contradiction resolution, ask: "How satisfied are you with the [Vision/Requirements/Architecture/Roadmap] resolution? [1-5 scale]" and "Any areas that still feel unclear or incorrect? [Y/n]". Only proceed to final generation when user rates satisfaction as 4+ for all documents and confirms no remaining concerns.

*Conversation Structure:* The conversation follows a pattern: "I found [number] contradictions between your documentation and code. Let's resolve the most critical ones first." Each contradiction is presented as: "CONTRADICTION [X]: [brief description]", "DOCUMENTATION SAYS: [relevant excerpt]", "CODE REALITY: [relevant finding]", "HYPOTHESIS: [proposed resolution]", "QUESTION [X]: [specific validation question]". Questions are designed to be answerable with specific choices rather than open-ended responses.

*Improvement Task Integration:* When contradiction resolution identifies areas where code reality should evolve toward documentation intent, the conversation explicitly asks whether to add improvement tasks to the roadmap. For example: "Your documentation describes microservices architecture, but code implements a monolith. Should I add 'Refactor to microservices architecture' as a roadmap milestone?" This ensures contradiction resolution actively improves project planning.

*Iterative Refinement:* After initial contradiction resolution, present updated specifications to the user for validation. Continue iteration until the user confirms that specifications accurately reflect both current reality and intended direction. Track resolution decisions to ensure consistency across all specification documents.

**Additional Implementation Details:**

The user conversation workflow must implement systematic contradiction resolution that guides users through structured decision-making while maintaining conversation state and updating living documents in real-time. The workflow operates on the principle that clear user choices lead to better resolution outcomes.

### Conversation Flow Architecture

The conversation workflow implements a structured progression through contradiction resolution:

1. **Initial Presentation**: Summary of contradictions found with impact prioritization
2. **Sequential Resolution**: Work through contradictions in order of impact (strategic → functional → architectural → tactical)
3. **Decision Capture**: Record user choices and rationale for each resolution
4. **Document Updates**: Real-time updates to living documents based on user decisions
5. **Satisfaction Validation**: Confirmation checks after each major resolution phase
6. **Roadmap Enhancement**: Generation of improvement tasks when gaps are identified

### Structured Question Framework

The conversation uses consistent question patterns for clarity and efficient resolution:

- **Context Setup**: Present contradiction with clear documentation vs code comparison
- **Hypothesis Presentation**: 2-3 specific resolution options with pros/cons analysis
- **Decision Request**: Numbered choices with open option for user alternatives
- **Confirmation Check**: Validation that user understands implications of their choice
- **Next Steps**: Clear transition to next contradiction or completion

### State Management System

The workflow maintains comprehensive conversation state to ensure consistent progress:

- **Resolution Tracking**: Record of which contradictions have been resolved and how
- **Document Versions**: Track updates to living documents through resolution process
- **User Preferences**: Pattern recognition for user decision-making style and priorities
- **Progress Metrics**: Completion percentage and remaining contradiction count
- **Satisfaction Scores**: User satisfaction ratings for each specification document

### Roadmap Enhancement Engine

When contradiction resolution reveals implementation gaps, the system generates appropriate improvement tasks:

1. **Gap Classification**: Determine size and scope of discrepancy between documentation and code
2. **Task Granularity**: Generate milestones for major gaps, task groups for medium gaps, individual tasks for small gaps
3. **Priority Assessment**: Recommend priority based on strategic importance and technical complexity
4. **Integration Logic**: Add generated tasks to existing roadmap with proper sequencing and dependencies

### Real-Time Document Updates

Living documents are updated immediately as contradictions are resolved:

- **Inline Edits**: Update specific sections based on user resolution choices
- **Consistency Checks**: Ensure updates maintain coherence across all specification documents
- **Version Control**: Track changes with clear attribution to resolution decisions
- **Preview Mode**: Show users updated sections before finalizing changes

### User Satisfaction Measurement

The workflow implements systematic satisfaction validation:

- **Quantitative Metrics**: 1-5 scale ratings for each specification document
- **Qualitative Feedback**: Open-ended questions about remaining concerns or unclear areas
- **Threshold Management**: Only proceed when satisfaction scores meet minimum thresholds (4+ for all documents)
- **Iterative Improvement**: Continue refinement until user explicitly confirms readiness to proceed

### Error Handling and Edge Cases

The conversation workflow handles various real-world scenarios:

- **Incomplete User Responses**: Graceful handling of unclear or incomplete user choices
- **Contradictory Decisions**: Detection and resolution of user choices that create new contradictions
- **Conversation Interruption**: State preservation and resumption capabilities for interrupted sessions
- **Complex Contradictions**: Escalation paths for contradictions requiring extensive user input or external research

## 2. Implementation Guidance

### Conversation Flow Integration

The user conversation workflow extends the `/init_brownfield` command by adding interactive resolution logic that loads living documents from TASK-042 outputs and guides users through systematic contradiction resolution. The workflow must handle both simple contradictions requiring single decisions and complex contradictions requiring multi-step resolution.

### Question Pattern Implementation

The structured question approach implements consistent formatting and response handling:

1. **Contradiction Presentation**: Clear setup with specific documentation vs code comparison
2. **Hypothesis Framework**: 2-3 concrete resolution options with structured pros/cons analysis
3. **Decision Interface**: Numbered choices with validation for user selection and alternative input handling
4. **Progress Tracking**: Clear indication of current question number and total contradiction count

### State Persistence Strategy

The conversation workflow implements robust state management to handle session continuity:

- **File-Based State**: Store conversation state in `.brownfield_analysis/slice4_conversation_state.json`
- **Resume Capability**: Allow users to resume contradiction resolution sessions
- **Rollback Support**: Enable users to revisit and change previous resolution decisions
- **Progress Indicators**: Maintain clear progress metrics throughout resolution process

### Document Update Mechanism

Real-time living document updates follow systematic patterns:

1. **Resolution Mapping**: Map user choices to specific document section updates
2. **Consistency Validation**: Ensure updates maintain coherence across all specification documents
3. **Change Tracking**: Record all updates with clear attribution to user decisions
4. **Preview System**: Show users proposed changes before applying them permanently

### Roadmap Integration Logic

The roadmap enhancement system integrates seamlessly with existing roadmap structures:

- **Task Generation**: Create appropriately-scoped improvement tasks based on gap analysis
- **Priority Integration**: Insert new tasks into existing roadmap with proper priority ordering
- **Dependency Analysis**: Ensure new tasks respect existing project dependencies and constraints
- **User Approval**: Confirm roadmap additions with user before finalizing changes

### Satisfaction Validation Framework

User satisfaction measurement implements structured feedback collection:

- **Rating Interface**: Clear 1-5 scale presentation with description of each rating level
- **Concern Collection**: Systematic gathering of remaining user concerns or unclear areas
- **Threshold Enforcement**: Prevent progression until satisfaction requirements are met
- **Iterative Refinement**: Support multiple rounds of refinement based on user feedback

## 3. Success Criteria

### Given: Living documents with identified contradictions exist from TASK-042 analysis
### When: User conversation workflow is initiated within `/init_brownfield` command
### Then: Conversation presents contradictions in priority order (strategic, functional, architectural, tactical)
### And: Each contradiction follows structured question pattern with clear documentation vs code comparison
### And: User is presented with 2-3 specific resolution hypotheses with pros/cons analysis
### And: Conversation state is maintained throughout resolution process with progress tracking

### Given: User makes resolution choices for contradictions during conversation workflow
### When: Choices are captured and processed
### Then: Living documents are updated in real-time to reflect user decisions
### And: Updates maintain consistency across all specification documents (Vision, Requirements, Architecture, Roadmap)
### And: User is shown updated document sections for confirmation before finalizing changes
### And: Resolution decisions are tracked with clear attribution and rationale

### Given: Contradiction resolution reveals gaps where code reality is behind documented intent
### When: Gap analysis determines improvement tasks are needed
### Then: Appropriate improvement tasks are generated based on gap size (milestones for major gaps, task groups for medium gaps, individual tasks for small gaps)
### And: Generated tasks include specific descriptions referencing the contradiction, acceptance criteria based on documented intent, and complexity estimates
### And: User is asked explicitly whether to add improvement tasks to the roadmap
### And: Roadmap integration maintains proper priority ordering and dependency relationships

### Given: User has resolved multiple contradictions through the conversation workflow
### When: Satisfaction validation is performed for each specification document
### Then: User is asked for 1-5 scale satisfaction rating for each document (Vision, Requirements, Architecture, Roadmap)
### And: User is asked about remaining concerns or unclear areas with Y/n response format
### And: Workflow only proceeds to final generation when user rates satisfaction as 4+ for all documents
### And: Iterative refinement continues until user explicitly confirms readiness to proceed

### Given: Complex project with numerous contradictions requiring extensive user interaction
### When: Conversation workflow processes all contradictions systematically
### Then: State persistence enables session resumption if conversation is interrupted
### And: Progress indicators keep user informed of current position in resolution process
### And: Rollback capability allows users to revisit and change previous resolution decisions
### And: Error handling manages incomplete responses and contradictory user choices gracefully

### Given: Project with minimal contradictions and high documentation-code alignment
### When: Conversation workflow processes the limited contradictions
### Then: Workflow completes efficiently with minimal user interaction required
### And: User satisfaction validation confirms high satisfaction scores across all documents
### And: Final generation readiness is achieved quickly with clear user confirmation
### And: Living documents accurately reflect resolved state with minimal changes from original analysis

### Given: User conversation workflow completes successfully with all contradictions resolved
### When: Preparing for final specification generation
### Then: All living documents are updated with user resolution decisions and internally consistent
### And: Roadmap includes any improvement tasks generated through contradiction resolution
### And: User satisfaction scores meet threshold requirements (4+ for all documents)
### And: Conversation state indicates readiness to proceed to final specification generation
### And: Clear summary is provided of all resolution decisions made during the workflow