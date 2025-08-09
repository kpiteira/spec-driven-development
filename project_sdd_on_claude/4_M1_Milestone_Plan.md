# Milestone Plan: M1 - Project Initialization & Planning

**Purpose of this document:** This document provides a detailed, tactical plan for executing Milestone 1 of the SDD System on Claude Code. It is the primary input for the `Supervisor Agent`, containing the precise sequence of work and the quality gates required to consider the milestone complete.

**Link to Roadmap:** [`3_Roadmap.md`](3_Roadmap.md)

---

## 1. Milestone Goals & Success Criteria

**What it is:** This milestone implements the core SDD initialization and planning workflows as interactive, AI-assisted document creation processes using Claude Code's native features.

**Goal:** To create the `/init_greenfield` and `/plan_milestone` commands that guide Human Architects through interactive specification creation, transforming strategic intent into well-structured, actionable project documents.

**Success Criteria:**

* `/init_greenfield` command successfully guides users through creating complete project specifications (Vision, Requirements, Architecture, Roadmap)
* `/plan_milestone` command interactively helps architects create comprehensive milestone plans from their roadmap
* Global template system provides guidance without polluting project repositories
* All generated specifications follow SDD hierarchy and methodology
* Claude Code recognizes and executes all SDD commands correctly
* System enables strategic focus by automating specification document creation

---

## 2. Scope: Features & Requirements

**What it is:** This milestone focuses on interactive document creation workflows that transform the SDD methodology into practical, conversational commands.

**Functional Requirements In Scope:**

* `REQ-001`: `/init_greenfield` - Interactive specification creation workflow (Vision → Requirements → Architecture → Roadmap)
* `REQ-003`: `/plan_milestone` - Interactive milestone planning workflow with vertical slice breakdown
* `REQ-CMD-001`: Command frontmatter requirements (model, description, argument-hint, allowed-tools)
* `NFR-PERF-004`: Strategic conversation quality using `claude-opus-4-1-20250805` model
* Global template storage system (not project-specific)
* AI-assisted document creation using templates as guidance
* Specification hierarchy validation and consistency checking

**User Stories Fulfilled:**

* "As a Human Architect, I want to initialize a new project so that I can set up the required specification structure"
* "As a Human Architect, I want to plan a new milestone so that I can define goals and sequence of tasks"

**Key Insight:** These commands are **conversation workflows**, not file copying operations. They use AI to guide architects through thoughtful specification creation based on SDD methodology.

**Explicitly Out of Scope for M1:**

* Task execution workflows (`/task`, `/milestone` commands)
* Sub-agents (Bundler, SecurityConsultant, Validator)
* Brownfield project onboarding (`/init_brownfield`) 
* Hook-based notifications and observability

---

## 3. Implementation Plan: Vertical Slices

**What it is:** The work is organized into 3 focused slices that deliver the core SDD functionality: two conversation-driven commands and an installation system that enables easy adoption.

---

### **Slice 1: Greenfield Initialization Command**

* **Goal:** Create the `/init_greenfield` command that guides architects through creating complete project specifications via structured conversation.
* **Acceptance Criteria:**
  * **Given** I am in a new project directory
  * **When** I execute `/init_greenfield`
  * **Then** Claude Code guides me through creating Vision → Requirements → Architecture → Roadmap in logical sequence
  * **And** each specification builds on the previous ones with consistency validation
  * **And** a complete `specs/` directory with all foundational documents is created
  * **And** all documents follow SDD methodology and template structure
* **Task Sequence:**
    1. **TASK-001:** Create `.claude/commands/init_greenfield.md` with comprehensive conversation prompt

---

### **Slice 2: Milestone Planning Command**

* **Goal:** Create the `/plan_milestone` command that transforms roadmap goals into detailed, executable milestone plans through guided conversation.
* **Acceptance Criteria:**
  * **Given** I have a complete project roadmap
  * **When** I execute `/plan_milestone "M1-Planning"`
  * **Then** Claude Code guides me through defining milestone goals and success criteria
  * **And** I am helped to break work into logical vertical slices with clear acceptance criteria
  * **And** task sequences are developed for each vertical slice
  * **And** a complete, actionable `Milestone_Plan.md` is created following SDD template
* **Task Sequence:**
    1. **TASK-002:** Create `.claude/commands/plan_milestone.md` with comprehensive conversation prompt

---

### **Slice 3: Installation and Distribution System**

* **Goal:** Create a simple installation process that sets up both global templates and Claude Code commands, enabling easy SDD system adoption.
* **Acceptance Criteria:**
  * **Given** a developer wants to use the SDD system
  * **When** they run the installation process
  * **Then** templates are installed to `~/.sdd/templates/` for global access
  * **And** SDD commands are installed to `.claude/commands/` and recognized by Claude Code
  * **And** installation can be done via both git clone and curl approaches
  * **And** clear documentation guides setup and first usage
* **Task Sequence:**
    1. **TASK-003:** Create installation script that copies templates to `~/.sdd/templates/` and commands to `.claude/commands/`
    2. **TASK-004:** Create curl-based installation option and comprehensive setup documentation

---

## 4. Testing & Verification Plan

**What it is:** Quality gates that ensure each interactive workflow creates high-quality specifications and integrates properly with Claude Code.

**Project-Level Checks (Always On):**

* All generated specification documents must follow SDD template structure and methodology
* Claude Code command syntax validation ensures all `.claude/commands/*.md` files are well-formed
* Cross-document consistency validation ensures specifications maintain logical hierarchy
* Conversation quality assessment ensures workflows guide architects effectively

**Per-Slice Checks (Manual Verification):**

* **Slice 1:** Verify `/init_greenfield` command is recognized by Claude Code and successfully guides creation of complete specification sets
* **Slice 2:** Verify `/plan_milestone` command transforms roadmaps into actionable milestone plans with proper vertical slice breakdowns
* **Slice 3:** Verify installation process correctly sets up templates and commands, making SDD system immediately usable

**Final Milestone Acceptance Tests:**

* **Complete SDD Workflow:** Installation → Greenfield initialization → Milestone planning end-to-end manual test
* **Claude Code Integration:** Verify all SDD commands appear in `/help` and execute correctly
* **Self-Validation Test:** Use `/plan_milestone` to successfully plan M2, M3, M4, and M5 for the SDD project itself
* **User Experience:** Confirm new users can install and use the system successfully following documentation

---

## 5. Definition of Done

**Milestone 1 is complete when:**

* All 4 tasks are implemented successfully
* `/init_greenfield` creates complete, high-quality specification sets through interactive conversations
* `/plan_milestone` transforms roadmaps into actionable milestone plans with proper vertical slice breakdowns
* Global template system provides guidance without polluting project repositories
* Installation process reliably enables developers to use SDD commands in Claude Code
* Generated specifications follow SDD methodology and enable effective Milestone 2 development
* Documentation and conversation quality enable architects to focus on strategy rather than document structure
* The system demonstrates the SDD vision: AI handles specification creation mechanics while humans focus on strategic intent