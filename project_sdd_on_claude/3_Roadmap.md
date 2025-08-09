# Project Roadmap: SDD System for Claude Code

This document outlines the strategic, milestone-based plan for developing the SDD System on the Claude Code platform. The roadmap is designed to deliver value incrementally, respecting the logical dependencies of the system's architecture.

## Milestone 1: Project Initialization & Planning

**Goal:** To empower the Human Architect to set up a new project and create a complete, actionable plan for the first milestone. This establishes the foundational workflow.

### Requirements Addressed in this Milestone

- **Commands:**
  - `/init_greenfield`: The starting point. Implements the creation of the `specs/` directory and all its templates.
  - `/plan_milestone`: The core planning tool. Implements the guided process for creating a `Milestone_Plan.md` from the roadmap, including defining vertical slices and task blueprints.
- **User Stories Fulfilled:**
  - "As a Human Architect, I want to initialize a new project..."
  - "As a Human Architect, I want to plan a new milestone..."

## Milestone 2: Core Task Execution

**Goal:** To build the "inner loop" of the assembly line. This milestone makes the plans created in Milestone 1 executable.

### Requirements Addressed in this Milestone

- **Commands:**
  - `/task [task_id]`: Implements the core task execution workflow.
- **Sub-Agents:**
  - `Bundler` (MVP version): Implements the critical logic for analyzing the **local codebase** and creating the context bundle.
- **Hooks & Notifications:**
  - Implement a basic notification for when a `/task` command is complete.
- **User Stories Fulfilled:**
  - "As a Human Architect, I want to initiate a single development task..."

## Milestone 3: Full Validation & Security

**Goal:** To complete the core assembly line by adding the critical quality and security gates, ensuring each individual task is robust and reliable.

### Requirements Addressed in this Milestone

- **Sub-Agents:**
  - `Validator`: Implements the agent that runs tests and performs static analysis.
  - `SecurityConsultant`: Implements the agent that provides proactive security advice.
- **Hooks & Notifications:**
  - Integrate validation results into notifications (pass/fail).

## Milestone 4: Autonomous Milestone Execution

**Goal:** To scale the perfected assembly line by enabling the autonomous execution of an entire milestone.

### Requirements Addressed in this Milestone

- **Commands:**
  - `/milestone [name]`: Implements the orchestrator logic that reads a `Milestone_Plan.md` and executes the `/task` command for each task in sequence.
- **User Stories Fulfilled:**
  - "As a Human Architect, I want to launch the execution of an entire milestone..."

## Milestone 5: Brownfield & Advanced Features

**Goal:** To expand the system's capabilities to handle existing projects and more complex scenarios.

### Requirements Addressed in this Milestone

- **Commands:**
  - `/init_brownfield`: Implements the discovery workflow for existing codebases.
- **Sub-Agents:**
  - `Bundler` (Full version): Extend the Bundler to analyze third-party libraries and external documentation.
- **User Stories Fulfilled:**
  - "As a Human Architect, I want to onboard an existing project..."

## Milestone 6: Intelligent Defaults & Pattern Learning (Future)

**Goal:** To evolve the SDD system from comprehensive questioning to intelligent pattern recognition and preference validation, reducing cognitive load through learned defaults.

### Vision for this Milestone

- **User Preference Storage:** Store cross-project patterns in `~/.sdd/preferences/` (user-level patterns)
- **Pattern Recognition:** Analyze past project choices to suggest intelligent defaults
- **Preference Validation:** Transform "What do you want?" into "Continue using X like last time?"
- **Cross-Project Intelligence:** Learn technology stack patterns, quality approaches, UX patterns

### Example User Experience Evolution

**Before (Current):**
```
SDD: "What package manager do you want for Python?"
SDD: "What testing framework should we use?"
SDD: "How should we handle error messages?"
```

**After (Pattern Learning):**
```
SDD: "I see you've used UV in 3 recent Python projects. Continue with UV? [Y/n]"
SDD: "Use pytest + coverage like your last 2 projects? [Y/n]"  
SDD: "Apply your standard CLI error message patterns? [Y/n]"
```

### Future Considerations

- **Team-Level Patterns:** How to handle shared team preferences vs individual patterns
- **Pattern Evolution:** How preferences change over time and technology trends
- **Pattern Sharing:** Potential for community pattern sharing and best practice propagation

*Note: This milestone represents the evolution from "specification creation" to "specification validation" through learned intelligence.*
