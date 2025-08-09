---
id: TASK-001
title: "Create init_greenfield command with comprehensive conversation prompt"
milestone_id: "M1-Project-Initialization"
requirement_id: "REQ-001, REQ-CMD-001, NFR-PERF-004"
slice: "Slice 1: Greenfield Initialization Command"
status: "pending"
branch: "feature/TASK-001-init-greenfield-command"
---

## 1. Task Overview & Goal

**What it is:** Create the `.claude/commands/init_greenfield.md` file that contains a comprehensive conversation prompt to guide architects through creating complete project specifications (Vision → Requirements → Architecture → Roadmap) in logical sequence.

**Goal:** Build a structured conversation workflow that transforms the SDD methodology into an interactive, AI-assisted document creation process that produces high-quality specification documents.

**Context:** This is the core deliverable of Slice 1 and demonstrates the fundamental SDD principle: AI handles specification creation mechanics while humans focus on strategic intent. The conversation must be sophisticated enough to guide strategic thinking while systematic enough to ensure consistency and completeness.

---

## 2. The Contract: Requirements & Test Cases

**What it is:** The specific, testable requirements for the `/init_greenfield` command file and conversation workflow.

* **Behavior 1: Proper Command Structure**
  * **Given:** The command file is created as `.claude/commands/init_greenfield.md`
  * **When:** Claude Code scans for available commands
  * **Then:** The command must be discoverable and properly formatted
  * **And:** Frontmatter must include `model: claude-opus-4-1-20250805`, clear description, argument-hint, and minimal allowed-tools
  * **And:** The command must comply with `REQ-CMD-001` frontmatter requirements

* **Behavior 2: Sequential Specification Creation**
  * **Given:** A user executes `/init_greenfield` in a new project directory
  * **When:** The conversation workflow runs
  * **Then:** The user must be guided through Vision → Requirements → Architecture → Roadmap creation in logical sequence
  * **And:** Each specification must build on information from previous ones
  * **And:** The conversation must validate consistency across documents
  * **And:** Four separate markdown files must be created in a `specs/` directory

* **Behavior 3: Strategic Conversation Quality**
  * **Given:** The conversation uses `claude-opus-4-1-20250805` model (`NFR-PERF-004`)
  * **When:** The workflow guides specification creation
  * **Then:** Questions must elicit strategic thinking about project purpose and design
  * **And:** The conversation must help architects think through problems, not just collect information
  * **And:** Each specification section must follow SDD methodology and template structure
  * **And:** The conversation must confirm understanding before proceeding to next specification

* **Behavior 4: Template Compliance and Quality**
  * **Given:** The conversation creates specification documents
  * **When:** Each document is generated
  * **Then:** Documents must follow the exact structure defined in SDD templates
  * **And:** All required sections must be present and properly formatted
  * **And:** Cross-references between documents must be correct and consistent
  * **And:** Generated content must be actionable and specific, not generic

---

## 3. Context Bundle (Agent-Populated Sibling Files)

**What it is:** This section serves as a manifest for the context files that will be provided by the Bundler and Security Consultant agents.

* **`bundle_architecture.md`:** Contains SDD methodology principles, specification hierarchy requirements, and Claude Code command best practices from the Architecture specification.
* **`bundle_security.md`:** Contains security guidance for command-line interfaces, input validation patterns, and secure conversation design principles.
* **`bundle_code_context.md`:** Contains implementation details for:
  * **Claude Code Command Format:** Proper frontmatter structure, conversation management patterns, and file creation approaches
  * **SDD Template Structure:** Complete specification templates with required sections, formatting, and cross-reference patterns
  * **Conversation Design:** Best practices for strategic questioning, validation checkpoints, and user guidance techniques

---

## 4. Verification Context

**What it is:** Guidance for the Validator Agent on how to verify this task's completion.

* **Unit Test Scope:** Tests must verify command file structure, frontmatter compliance, and that the command is recognized by Claude Code.
* **Integration Test Scope:** Tests must verify that executing `/init_greenfield` produces four valid specification documents that pass SDD template validation and maintain cross-document consistency.
* **Conversation Quality Test Scope:** Tests must verify that the conversation workflow produces strategic, actionable specifications rather than generic templates, and that generated documents enable effective project planning.
* **Manual Verification:** The Validator must confirm that `/init_greenfield` appears in Claude Code's available commands and executes the conversation workflow correctly.