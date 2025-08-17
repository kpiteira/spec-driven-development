# Milestone Plan: M6 - Brownfield Project Support

**Purpose of this document:** This document provides a detailed, tactical plan for implementing the `/init_brownfield` command that enables SDD onboarding of existing projects. The command follows the proven pattern from `/init_greenfield`: discovery-analysis-conversation-generation workflow to create exactly four SDD specification documents (Vision, Requirements, Architecture, Roadmap) that enable immediate use of SDD workflows on existing codebases.

**Link to Roadmap:** [`3_Roadmap.md`](../3_Roadmap.md) - Lines 69-84

---

## 1. Milestone Goals & Success Criteria

**Goal:** Create the `/init_brownfield` command that onboards existing projects to SDD methodology by generating exactly four specification documents (Vision, Requirements, Architecture, Roadmap) through discovery-analysis-conversation workflow.

**Success Criteria:**

* Human Architects can execute `/init_brownfield` in any existing project directory
* Command discovers and analyzes ALL existing documentation and project specifications
* Command comprehensively analyzes actual codebase structure and architectural elements
* Command identifies contradictions between documentation intent and code reality
* Command engages conversation-based discovery to resolve contradictions with user validation
* Generated specifications distinguish between current reality and intended direction
* Results in exactly four SDD specification documents: Vision, Requirements, Architecture, Roadmap
* Generated specifications enable milestone planning workflow (like init_greenfield)

---

## 2. Scope: Features & Requirements

**Functional Requirements In Scope:**

* `REQ-002`: `/init_brownfield` command implementation with conversation-based discovery
* `REQ-CMD-001`: Command frontmatter requirements for `/init_brownfield`
* Project Structure Analysis sub-agent for comprehensive file/folder categorization
* Documentation Analysis sub-agent for existing documentation discovery and analysis
* Code Analysis sub-agent for codebase reality comprehension
* Contradiction resolution workflow with hypothesis formulation
* Final specification generation conversation with iterative refinement
* Exactly four specification documents as output: Vision, Requirements, Architecture, Roadmap

**Non-Functional Requirements In Scope:**

* `NFR-PERF-004`: Strategic conversation quality using `claude-opus-4-1-20250805` model
* `NFR-INT-001`: Claude Code platform integration without external dependencies
* `NFR-REL-001`: Deterministic workflow execution

**Explicitly Out of Scope:**

* `/task` and `/milestone` execution readiness (beyond generating specifications)
* Multiple project types or technology stack specialization
* Performance optimization for large codebases
* Advanced architectural pattern detection
* Legacy code refactoring suggestions

---

## 3. Implementation Plan: Vertical Slices

### **Slice 1: Foundation - Project Structure Discovery**

**Goal:** Establish foundation command structure and comprehensive project structure analysis that both documentation and code analysis slices can build upon.

**Acceptance Criteria:**

* **Given** I am in any existing project directory
* **When** I execute `/init_brownfield`
* **Then** the command initializes with clear user conversation starter explaining the discovery process
* **And** Project Structure Analysis sub-agent comprehensively categorizes ALL files and folders
* **And** categories include: docs/specs, source code, configuration, deployment, data, tests, build artifacts, etc.
* **And** user confirms major project components before proceeding to analysis phases
* **And** foundation structure provides clear categorization for subsequent analysis slices

**Task Sequence:**

**TASK-035: Create `/init_brownfield` command with Project Structure Analysis integration**

This task creates the foundational command structure that orchestrates the entire brownfield discovery workflow, integrating Project Structure Analysis sub-agent invocation and user confirmation prompts. The command implements the conversation-first approach with streamlined user interaction.

*Technical Implementation:* Create `/commands/init_brownfield.md` following the established pattern from `/init_greenfield`. The command frontmatter includes description, usage, and model specification. The command includes integrated sub-agent orchestration for Project Structure Analysis with appropriate user confirmation prompts.

*User Interaction Pattern:* The command begins by asking the user a single focused question: "Can you explain the purpose of this project, or point me to a document explaining that?" This allows natural discovery of project context while the structure analysis proceeds. The discovery process naturally identifies project complexity without asking predetermined questions about project type.

*Integration Points:* This task creates the complete orchestration framework including Project Structure Analysis sub-agent invocation. After structure analysis completes, present a summary report to the user including: "Project Type: [assessment]", "Key Technologies: [list]", "Documentation Found: [count and types]", "Source Code Structure: [pattern]", and "Notable Findings: [any unusual patterns]". Ask the user to confirm this assessment is accurate and whether any important components were missed or miscategorized.

**TASK-036: Create Project Structure Analysis sub-agent that comprehensively categorizes ALL files/folders**

This task creates a specialized sub-agent that performs comprehensive project structure discovery and categorization. The sub-agent analyzes the tree structure, file names, and directory organization of the project (respecting .gitignore) to categorize them into meaningful architectural buckets that inform subsequent analysis phases. This is structural analysis only - actual file content reading happens in later slices.

*Technical Implementation:* Create `sub_agents/project_structure_analysis.md` with specialized context for understanding project organization patterns. The AI agent uses tools for tree analysis to examine all directories and files, applying categorization logic based on file types, directory names, and common patterns. Categories are examples that depend on project complexity, language, and type - typical categories include: Documentation/Specs (README.md, docs/, wiki/, *.md files), Source Code (language-specific patterns like src/, lib/, app/), Configuration (package.json, Dockerfile, .env files, config directories), Tests (test/, spec/, **tests** directories), Build Artifacts (dist/, build/, target/, node_modules/), Data (database files, migrations, fixtures), Deployment (CI/CD configs, infrastructure as code), and Other (uncategorized files requiring manual review).

*Specific Inputs and Outputs:* Input is the current working directory. Output is a comprehensive categorization report formatted as structured markdown with sections for each category, file counts, and notable patterns discovered. The report includes a "Project Type Assessment" section that identifies the primary technology stack, architectural patterns, and complexity indicators (monorepo vs single service, frontend/backend/fullstack, etc.).

*Edge Case Handling:* The sub-agent handles edge cases including: empty directories, symlinks, very large files (logs, binaries), hidden files and directories, non-standard project structures, and mixed-language codebases. For ambiguous files, the sub-agent marks them for manual review rather than making incorrect assumptions.

**TASK-037: Validate Slice 1 on test projects with META self-improvement**

This task implements comprehensive validation of Slice 1 functionality using real test projects, with META instructions for self-improvement when validation criteria are not met.

*Validation Test Projects:* Test using two representative projects: (1) Obsidian Importer (simple TypeScript plugin project) and (2) ktrdr (complex multi-service polyglot architecture). Each test validates both automated AI analysis and human confirmation aspects.

*Test Execution Approach:* After Tasks 35-36 are complete, validation requires separate Claude Code instances to avoid context pollution. The Human Architect:

**Separate Validation Context (Different Claude Code Sessions):**
The following must be run by the user, prompted by the task:

1. Open new Claude Code session in Obsidian Importer project directory
2. Execute `/init_brownfield` as end-user (fresh context, no development knowledge)
3. Command runs Slice 1 functionality, generates structure analysis report
4. Document results and validate against success criteria
5. Repeat in separate Claude Code session for ktrdr project
6. Compare validation results against specified criteria

**Context Separation Rationale:** Development context (building the command) must be completely separate from validation context (using the command). Mixing these contexts would pollute the M6 implementation work with test project analysis and prevent realistic end-user simulation.

**Learning Transfer Mechanism:** Validation outcomes transfer back to development context through structured validation documents:

1. Task 37 implementation prompts: "Please complete validation testing in separate Claude Code sessions (Obsidian Importer and ktrdr projects), then return here and confirm when validation reports are ready for analysis"
2. Each test session creates validation reports (`.brownfield_analysis/validation_report_obsidian.md`, `.brownfield_analysis/validation_report_ktrdr.md`)
3. Human Architect copies these reports back to SDD project validation folder (`M6_validation/slice1_results/`)
4. Human confirms validation completion, development context reads validation reports
5. If validation fails, META instructions analyze failure patterns and propose specific command/sub-agent improvements
6. Development context iterates on Tasks 35-36 until success criteria are met

This validates only Slice 1 functionality in clean, isolated contexts before proceeding to implement Slices 2-4.

*Obsidian Importer Validation Criteria:*
**AI Validation (Automated):**

* Identifies 100% of root-level files and directories
* Correctly identifies as TypeScript/Node.js plugin project
* Finds core categories: Source code, configuration, documentation, build artifacts
* Recognizes Obsidian plugin structure (manifest.json, main.ts patterns)
* Identifies Obsidian API dependencies and dev dependencies

**Human Validation (User Confirmation):**

* "Does the analysis correctly understand this is an Obsidian plugin?"
* "Are there any important files or architectural decisions the analysis missed?"
* "Is the TypeScript/Node.js identification correct and complete?"

*ktrdr Validation Criteria:*
**AI Validation (Automated):**

* Identifies Python backend, TypeScript frontend, and separate hosted services
* Correctly identifies Docker usage, multiple programming languages, API layers
* Distinguishes between dockerized backend, non-docker services, frontend, CLI components
* Recognizes multi-tier, polyglot architecture
* Identifies Docker configurations, hosted service indicators, build processes

**Human Validation (User Confirmation):**

* "Does the analysis correctly understand the multi-service architecture?"
* "Are the connections between Python backend, TypeScript frontend, and APIs understood?"
* "Is the Docker vs hosted services distinction accurate?"
* "What architectural complexities did the analysis miss or misunderstand?"

*META Instructions for Self-Improvement:*
When validation fails, the command should:

* Analyze which specific validation criteria were not met
* Propose specific improvements to the command logic or sub-agent prompts
* Suggest additional context gathering or analysis techniques
* Provide actionable recommendations for passing validation on similar projects

**NOTE:** META instructions are development-time improvement mechanisms and should be clearly delineated for removal in production versions. These instructions enable iterative improvement of the analysis quality based on real project validation results.

---

### **Slice 2: Documentation AND Code Analysis**

**Goal:** Both Documentation Analysis and Code Analysis sub-agents execute to understand project intent from documentation and implementation reality from codebase, generating complete first and second drafts of all 4 specification documents, plus integration of both analysis workflows into the main command.

**Acceptance Criteria:**

* **Given** Project Structure Analysis has identified all documentation files and source code structure
* **When** both Documentation Analysis and Code Analysis sub-agents execute
* **Then** all discovered documentation is read and analyzed for project intent
* **And** codebase architectural skeleton is analyzed for implementation reality
* **And** Documentation Analysis generates complete first draft of Vision, Requirements, Architecture, Roadmap documents based on documented intent
* **And** Code Analysis generates complete second draft of Vision, Requirements, Architecture, Roadmap documents based on code reality
* **And** both analysis workflows are integrated into main command with proper orchestration and user interaction
* **And** analysis handles projects with minimal documentation and complex architectures appropriately
* **And** both draft sets are prepared for systematic comparison in Slice 4

**Task Sequence:**

**TASK-038: Create Documentation Analysis sub-agent that reads all discovered documentation, analyzes project intent, and generates first draft of all 4 specification documents**

This task creates a specialized sub-agent focused on understanding project intent through comprehensive documentation analysis and immediately generating the first complete draft set of all four SDD specification documents. The sub-agent reads all documentation identified in Slice 1, extracts strategic information, and produces documentation-based drafts while flagging inconsistencies for later resolution.

*Technical Implementation:* Create `.claude/agents/documentation_analist.md` with specialized context for understanding various documentation formats (README files, API documentation, architecture decision records, changelogs, wiki pages, inline code comments). The sub-agent reads actual file contents (not just metadata) to extract key information including: stated project purpose and goals, target users and use cases, functional requirements and features, architectural decisions and constraints, technology choices and rationale, deployment and operational considerations, and known issues or limitations. The sub-agent uses intelligent prioritization for large documentation sets, focusing on README, architecture docs, and API documentation first.

*Contradiction Detection Logic:* The sub-agent specifically looks for contradictions between different documentation sources (e.g., README says Python but API docs mention Node.js, architecture diagram shows microservices but deployment guide assumes monolith). When contradictions are found, they are flagged with specific location references and severity assessment (minor inconsistency vs major architectural conflict). This is extremely valuable information for users during contradiction resolution.

*User Interaction Pattern:* After analysis completes, present summary to user: "Documentation Analysis Complete. Found: [X] documents analyzed, [Y] architectural decisions identified, [Z] contradictions flagged for your review. Key findings: [summary]". Ask user to confirm major findings and whether any critical documentation was missed.

*Context Requirements:* The sub-agent receives the Project Structure Analysis categorization report to know which files to analyze. It also receives project type assessment (simple vs complex) to adjust its analysis depth appropriately. For complex projects like ktrdr, it handles multiple documentation sources systematically.

*Output Format:* The sub-agent produces a "Documentation Intent Analysis" report with sections for: Project Purpose and Vision, Functional Requirements Discovered, Architectural Intentions, Technology Stack Rationale, Deployment and Operations Intent, Documentation Quality Assessment (completeness, clarity, consistency), **Contradictions and Gaps Identified** (with specific references and severity), and **Questions for User Resolution** (structured for Slice 4 conversation).

**TASK-039: Create Code Analysis sub-agent that analyzes codebase architectural skeleton and generates separate second draft of all 4 specification documents**

This task creates a specialized sub-agent that analyzes the codebase architectural skeleton to understand implementation reality and immediately generates a completely separate second draft set of all four SDD specification documents. These code-based drafts will be compared with documentation-based drafts in Slice 4 for contradiction resolution.

*Technical Implementation:* Create `sub_agents/code_analysis.md` with specialized context for understanding architectural patterns across multiple programming languages and frameworks. The sub-agent uses the "architectural skeleton" approach, analyzing: **High-Signal Elements:** File structure and organizational patterns, Import/dependency patterns and module boundaries, API interfaces and service boundaries (actual endpoints, not implementation), Configuration patterns (deployment, environment, security), Entry points and main workflows (application startup, routing), Technology stack integration points (databases, external services, frameworks). **Low-Signal Elements Avoided:** Function implementation details and business logic specifics, Variable naming and internal algorithms, Detailed data transformation logic, Most internal helper functions.

*Multi-Service Architecture Handling:* For complex projects like ktrdr with Python backend + TypeScript frontend + Docker + hosted services, the sub-agent identifies service boundaries through configuration analysis (docker-compose.yml, package.json files), API communication patterns (import statements, HTTP client usage), deployment separation (different Dockerfile patterns, environment configurations), and technology stack boundaries (language-specific entry points and configuration).

*Specification Generation:* The sub-agent immediately generates complete second drafts of all four SDD specification documents based on the architectural skeleton analysis. The Vision document reflects what the codebase actually accomplishes based on implemented features. The Requirements document captures functional requirements actually implemented in code. The Architecture document describes the actual technical implementation patterns, technology stack reality, and service boundaries. The Roadmap document identifies technical debt, incomplete features, and areas needing improvement based on code structure analysis.

*Output Generation for Slice 4:* Generated drafts are written to `.brownfield_analysis/slice3_code_draft_[vision|requirements|architecture|roadmap].md` for systematic comparison with Slice 2 documentation-based drafts. The sub-agent generates a detailed contradiction report highlighting the most significant discrepancies between documented intent and code reality, prioritized by impact and user decision requirements.

**TASK-040: Integrate both Documentation AND Code Analysis workflows into `/init_brownfield` command**

This task integrates both Documentation Analysis and Code Analysis workflows into the main `/init_brownfield` command, orchestrating both analysis approaches to execute and generate their respective specification drafts. The integration includes user interaction patterns and progress coordination for both analysis phases.

*Technical Implementation:* Extend `/commands/init_brownfield.md` to include both Documentation Analysis and Code Analysis sub-agent invocations after Project Structure Analysis completes. The command orchestrates both the documentation reading/analysis and codebase architectural skeleton analysis as coordinated workflows. The integration includes error handling for projects with no documentation or unreadable documentation formats, as well as complex codebases with multiple languages and architectures.

*Parallel Execution Design:* The integration coordinates both analysis approaches which are objective analyses that don't depend on each other. After structure analysis and user confirmation, the command launches both documentation and code analysis. Both analyses generate their respective specification drafts independently, with results properly stored for Slice 4 comparison and contradiction resolution.

*User Interaction Pattern:* After structure analysis, the command presents: "Beginning documentation and code analysis. Found [X] documentation files and [Y] source files. This will read actual file contents to understand both documented project intent and implementation reality, generating two complete sets of specification drafts. Proceed? [Y/n]". After analyses complete: "Analysis complete. Generated first draft specifications based on documented intent and second draft specifications based on code reality. Key findings: Documentation - [summary]. Code Reality - [summary]. Ready for contradiction analysis."

*Coordination and Orchestration:* The task ensures both Documentation Analysis and Code Analysis outputs (draft specifications and analysis reports) are properly stored with clear naming conventions (`.brownfield_analysis/slice2_docs_draft_*` and `.brownfield_analysis/slice2_code_draft_*`) for systematic comparison in Slice 4. The integration coordinates progress reporting and user feedback for both analysis phases.

*Error Handling:* The integration handles edge cases including: no documentation found (code analysis becomes primary source), documentation in unsupported formats (notes for manual review), complex multi-language codebases (architectural skeleton approach), and analysis failures (graceful degradation with manual fallback options).

*Integration Points:* This task establishes the complete handoff to Slice 4 by ensuring both analysis approaches have executed successfully and generated complete specification draft sets. The workflow prepares all necessary inputs for contradiction analysis and resolution in subsequent slices.

---

### **Slice 3: Comprehensive Validation**

**Goal:** Validate the complete discovery and analysis capabilities (Project Structure Analysis, Documentation Analysis, and Code Analysis) on real test projects using context separation to ensure quality and effectiveness before proceeding to contradiction resolution.

**Acceptance Criteria:**

* **Given** Slices 1-2 functionality is complete with Project Structure Analysis, Documentation Analysis, and Code Analysis capabilities
* **When** comprehensive validation executes on both simple and complex test projects
* **Then** Project Structure Analysis correctly categorizes all files and folders for both project types
* **And** Documentation Analysis discovers and analyzes all existing documentation appropriately
* **And** Code Analysis comprehensively analyzes codebase architectural skeleton for implementation reality
* **And** both analysis approaches generate complete specification drafts with proper template compliance
* **And** validation uses context separation (separate Claude Code sessions) to avoid development context pollution
* **And** META self-improvement instructions identify and propose fixes for any validation failures

**Task Sequence:**

**TASK-041: Comprehensive validation of Slices 1-2 functionality on test projects with META self-improvement**

This task implements comprehensive validation of the complete discovery and analysis workflow (Project Structure Analysis from Slice 1, plus Documentation Analysis and Code Analysis from Slice 2) using real test projects, with META instructions for self-improvement when validation criteria are not met.

*Test Execution Approach:* After Tasks 038-040 are complete, validation requires separate Claude Code instances to avoid context pollution. The Human Architect:

**Separate Validation Context (Different Claude Code Sessions):**
The following must be run by the user, prompted by the task:

1. Open new Claude Code session in Obsidian Importer project directory
2. Execute `/init_brownfield` as end-user (fresh context, no development knowledge)
3. Command runs Slices 1-3 functionality, generates both documentation and code analysis reports
4. Document results and validate against success criteria for both documentation and code analysis
5. Repeat in separate Claude Code session for ktrdr project
6. Compare validation results against specified criteria for both analysis approaches

**Learning Transfer Mechanism:** Validation outcomes transfer back to development context through structured validation documents:

1. Task 041 implementation prompts: "Please complete validation testing in separate Claude Code sessions (Obsidian Importer and ktrdr projects), then return here and confirm when validation reports are ready for analysis"
2. Each test session creates validation reports for both documentation and code analysis (`.brownfield_analysis/validation_report_obsidian_slices2-3.md`, `.brownfield_analysis/validation_report_ktrdr_slices2-3.md`)
3. Human Architect copies these reports back to SDD project validation folder (`M6_validation/slices2-3_results/`)
4. Human confirms validation completion, development context reads validation reports
5. If validation fails, META instructions analyze failure patterns and propose specific improvements to documentation or code analysis sub-agents
6. Development context iterates on Tasks 038-040 until success criteria are met

*Combined Validation Criteria:*

**Obsidian Importer (Simple Project):**

* Documentation Analysis: Correctly identifies plugin purpose from README, handles minimal documentation gracefully
* Code Analysis: Identifies TypeScript plugin structure, Obsidian API dependencies, simple architecture
* Draft Quality: Both documentation and code-based drafts are complete, separate, and template-compliant

**ktrdr (Complex Project):**

* Documentation Analysis: Synthesizes information across multiple documentation sources, identifies contradictions
* Code Analysis: Identifies multi-service architecture (Python + TypeScript + Docker), service boundaries
* Draft Quality: Both draft sets handle complex architecture appropriately as completely separate specification sets

---

### **Slice 4: Contradiction Resolution & Final Generation**

**Goal:** Build the contradiction analysis and resolution capabilities that will compare documentation-based and code-based drafts, create user conversation workflows for resolving contradictions through hypothesis validation, and generate final specification documents with clear reality vs intent distinctions.

**Acceptance Criteria:**

* **Given** both documentation-based and code-based drafts of all 4 specification documents exist
* **When** the built contradiction analysis and resolution capability executes during `/init_brownfield` command usage
* **Then** the system creates combined drafts showing contradictions between documentation intent and code reality
* **And** specific hypotheses are formulated about which represents current state vs intended direction
* **And** user is presented with structured questions to validate hypotheses and resolve contradictions
* **And** contradiction resolution includes adding improvement tasks to roadmap when appropriate
* **And** final four specification documents clearly distinguish between current reality and intended direction
* **And** generated specifications enable milestone planning workflow (following init_greenfield pattern)

**Task Sequence:**

**TASK-042: Build contradiction analysis capability that compares documentation and code drafts and generates living documents with hypotheses**

This task creates the contradiction analysis capability that will systematically compare documentation-based and code-based specification drafts to identify specific discrepancies and formulate hypotheses about resolution approaches. Based on research, this builds a hybrid approach with annotated living documents + structured recommendations.

*Technical Implementation:* Build contradiction analysis logic within the main `/init_brownfield` command that will perform section-by-section comparison of the two draft sets. The analysis identifies contradictions at multiple levels: strategic (project vision and goals), functional (what features exist vs what's documented), architectural (intended vs actual technical implementation), and tactical (roadmap priorities vs technical debt reality). The analysis logic loads both draft sets from `.brownfield_analysis/slice2_docs_draft_*` and `.brownfield_analysis/slice3_code_draft_*` files.

*Contradiction Identification Strategy:* The analysis systematically compares corresponding sections of each specification document type. For Vision documents, it compares stated purpose with actual functionality discovered in code. For Requirements documents, it compares documented features with implemented capabilities (APIs, modules, integrations). For Architecture documents, it compares intended patterns with actual implementation architecture. For Roadmap documents, it compares planned directions with technical debt and implementation gaps discovered through code analysis.

*Hypothesis Formulation Logic:* For each identified contradiction, the system formulates 2-3 specific resolution hypotheses with pros/cons analysis. Common hypothesis patterns include: "Documentation reflects original intent, code represents evolution" (pro: honors project history, con: may not reflect current needs), "Code reflects current reality, documentation represents outdated aspiration" (pro: matches implementation, con: may lack strategic vision), "Both sources contain partial truth requiring synthesis" (pro: comprehensive solution, con: requires more user decision-making), and "Contradiction suggests architectural decision point requiring strategic input" (pro: enables informed choice, con: may delay completion).

*Research-Informed Output Format:* Generate "Living Documents" for each specification type using the hybrid approach: **Annotated Living Documents** with side-by-side presentation of documentation vs code reality, **Gap Analysis sections** with specific recommendations for resolving contradictions, **Decision Matrices** with pros/cons for each resolution hypothesis, and **Structured Recommendations** that help users make informed choices. Each contradiction includes: the specific discrepancy with line references, context from both drafts, 2-3 formulated hypotheses with pros/cons, confidence level in each hypothesis, and impact assessment (high/medium/low).

*User Interaction Pattern:* After analysis completes, present summary: "Contradiction analysis complete. Found [X] strategic contradictions, [Y] functional discrepancies, [Z] architectural differences. Most critical: [summary of top 3]. Ready to review and resolve these with you."

**TASK-043: Build user conversation workflow for resolving contradictions through hypothesis validation and roadmap enhancement**

This task creates the structured user conversation workflow that will present contradictions through living documents and guide collaborative resolution through hypothesis validation, iterative refinement, and roadmap enhancement when gaps require code improvements.

*Technical Implementation:* Build conversation workflow that will present contradictions systematically using the living documents from TASK-042. Start with highest-impact discrepancies (those affecting project vision and major architectural decisions) and proceed to tactical details. The conversation presents 2-3 resolution proposals per contradiction with pros/cons analysis, allowing users to choose or propose alternatives. The workflow maintains conversation state to track resolution decisions and updates living documents in real-time.

*Structured Question Approach:* For each contradiction, present structured questions following this pattern: "**Contradiction [N]:** [Description]. **Documentation says:** [excerpt]. **Code shows:** [pattern]. **Hypothesis A:** [option with pros/cons]. **Hypothesis B:** [option with pros/cons]. **Hypothesis C:** [option with pros/cons]. **What's your preference?** [1/2/3/other]. **Additional context needed?** [Y/n]". Use numbered questions for easy user response and clear progress tracking through contradiction resolution.

*Roadmap Enhancement Logic:* When contradiction resolution reveals that code reality is behind documented intent (e.g., documentation describes microservices but code is monolithic), automatically generate improvement tasks for the roadmap. Task granularity depends on gap size: **Major gaps become milestones** (e.g., "M-ARCH: Migrate from monolithic to microservices architecture"), **Medium gaps become task groups** (e.g., "Implement missing API authentication described in architecture docs"), **Small gaps become individual tasks** (e.g., "Add missing error handling for user registration endpoint"). Each generated improvement includes: specific description referencing the contradiction, acceptance criteria based on documented intent, estimated complexity (high/medium/low), and priority recommendation.

*Iterative Refinement Process:* After each contradiction resolution, update the living documents and present updated sections to user for confirmation. Continue iterative refinement until user explicitly confirms satisfaction with all four specification documents. The conversation tracks: resolved contradictions count, remaining contradictions, user satisfaction score per document, and readiness to proceed to final generation.

*User Satisfaction Validation:* After each major contradiction resolution, ask: "How satisfied are you with the [Vision/Requirements/Architecture/Roadmap] resolution? [1-5 scale]" and "Any areas that still feel unclear or incorrect? [Y/n]". Only proceed to final generation when user rates satisfaction as 4+ for all documents and confirms no remaining concerns.

*Conversation Structure:* The conversation follows a pattern: "I found [number] contradictions between your documentation and code. Let's resolve the most critical ones first." Each contradiction is presented as: "CONTRADICTION [X]: [brief description]", "DOCUMENTATION SAYS: [relevant excerpt]", "CODE REALITY: [relevant finding]", "HYPOTHESIS: [proposed resolution]", "QUESTION [X]: [specific validation question]". Questions are designed to be answerable with specific choices rather than open-ended responses.

*Improvement Task Integration:* When contradiction resolution identifies areas where code reality should evolve toward documentation intent, the conversation explicitly asks whether to add improvement tasks to the roadmap. For example: "Your documentation describes microservices architecture, but code implements a monolith. Should I add 'Refactor to microservices architecture' as a roadmap milestone?" This ensures contradiction resolution actively improves project planning.

*Iterative Refinement:* After initial contradiction resolution, present updated specifications to the user for validation. Continue iteration until the user confirms that specifications accurately reflect both current reality and intended direction. Track resolution decisions to ensure consistency across all specification documents.

**TASK-044: Build final specification generation with user roadmap input and SDD workflow compatibility**

This task creates the final specification generation capability that will incorporate all contradiction resolutions, gather additional user roadmap input beyond what was discovered in the repository, and generate final documents that clearly distinguish between current reality and intended direction, enabling milestone planning workflow (following init_greenfield pattern).

*Technical Implementation:* Build final specification generation logic that will synthesize contradiction resolution decisions into complete, consistent specification documents. The final documents follow SDD templates exactly and include special sections that clearly distinguish between "Current State" and "Target State" where relevant. The generation logic processes the living documents with user resolution decisions and creates clean, final versions in `specs/` directory following init_greenfield output pattern.

*Reality vs Intent Distinctions:* Each specification document includes clear markers for areas where current reality differs from intended direction. The Vision document includes "Current State Assessment" and "Strategic Direction" subsections. The Requirements document distinguishes between "Implemented Capabilities" (FR-IMP-XXX) and "Planned Features" (FR-PLN-XXX). The Architecture document separates "Current Implementation Architecture" from "Target Architecture" with explicit migration considerations. The Roadmap document includes specific improvement tasks generated from contradiction resolution with proper task sequencing.

*SDD Workflow Compatibility:* Ensure final specifications enable milestone planning workflow by including proper requirement numbering (FR-XXX, NFR-XXX), clear acceptance criteria, and actionable descriptions. Generate improvement tasks that can be included in future milestone plans. The output exactly matches init_greenfield format: `specs/0_Project_Vision.md`, `specs/1_Product_Requirements.md`, `specs/2_Architecture.md`, `specs/3_Roadmap.md`.

*Quality Validation:* Perform final validation that all four documents follow SDD template structure exactly, maintain consistent cross-references, include all required sections, and provide actionable guidance for milestone planning. Ensure that specifications acknowledge architectural complexity and messy reality rather than creating idealized versions. Validate that improvement tasks in roadmap are specific, measurable, and executable.

*User Roadmap Input Collection:* Before generating final roadmap, prompt user for additional roadmap items beyond what was discovered in the repository: "Based on analysis, I've identified [X] improvement areas from contradictions and technical debt. Are there additional strategic initiatives, features, or improvements you want to include in the roadmap that weren't mentioned in existing docs or inferred from code? [list any additional milestones, technical initiatives, business requirements, etc.]". This ensures the final roadmap reflects both discovered gaps and strategic user input.

*User Confirmation and Handoff:* Present final documents to user for approval: "Final specifications generated. **Vision:** [key points]. **Requirements:** [FR count] implemented, [FR count] planned. **Architecture:** Current [pattern] targeting [pattern]. **Roadmap:** [milestone count] with [improvement task count] plus [user-added count] strategic initiatives. Ready to proceed with milestone planning using these specifications? [Y/n]". Include summary report explaining what was generated and how the specifications reflect both current reality and intended direction.

*Integration Points:* Ensure clean handoff to standard SDD workflow. Final specifications should be immediately usable with `/plan_milestone` command. Include completion confirmation that brownfield discovery and specification generation is complete, and development can proceed following standard SDD methodology.

---

## 4. Testing & Verification Plan

**Project-Level Checks (Always On):**

* All generated specifications must pass SDD template validation
* `/init_brownfield` command must be discoverable in Claude Code command list
* Generated specifications must enable immediate use of SDD workflows
* Command follows proven `/init_greenfield` pattern with sub-agent orchestration
* Project Structure Analysis correctly categorizes files in both simple and complex projects
* Sub-agent workflows complete successfully without token limit issues

**Per-Slice Validation:**

* **Slice 1:** Project Structure Analysis correctly categorizes all files/folders; streamlined user interaction with focused purpose question; validation testing on Obsidian Importer and ktrdr projects; META self-improvement when validation criteria not met
* **Slice 2:** Documentation Analysis discovers all documentation files; generates complete first drafts that reflect documented intent; handles projects with minimal documentation gracefully
* **Slice 3:** Code Analysis comprehensively analyzes codebase structure; generates complete second drafts that reflect implementation reality; identifies architectural patterns and technical debt
* **Slice 4:** Contradiction analysis identifies real discrepancies between drafts; hypothesis formulation produces actionable questions; user conversation resolves contradictions and generates improvement tasks; final specifications distinguish reality from intent

**End-to-End Validation:**

* **Simple Project Test (Obsidian Plugin):** Complete workflow from `/init_brownfield` execution through final specification generation; validate handling of minimal documentation and straightforward codebase
* **Complex Project Test (ktrdr):** Complete workflow with multi-language, multi-service architecture; validate handling of extensive documentation, complex dependencies, and architectural contradictions
* Generated specifications enable successful execution of subsequent SDD commands (`/task`, `/milestone`)
* Reality vs intent distinctions are clear and actionable throughout all documents
* Improvement tasks added to roadmap are specific and executable

**Success Validation Methods:**

* Task blueprint validation for each TASK-035 through TASK-046
* Template compliance verification for all generated specification documents
* User conversation quality assessment (clear questions, actionable hypotheses)
* Integration testing with existing SDD workflow commands
* Cross-reference validation between generated documents

---

## 5. Risk Mitigation

**Risk: Token Consumption from Large Files**

* **Mitigation:** Project Structure Analysis implements intelligent file filtering by type and size before detailed analysis
* **Mitigation:** Use file metadata, directory structure, and configuration files to infer architecture without reading large data files or build artifacts
* **Mitigation:** Focus detailed analysis on configuration, documentation, key source files, and architectural entry points
* **Mitigation:** Sub-agents report file counts and sizes to avoid token limit surprises

**Risk: No Existing Documentation**

* **Mitigation:** Documentation Analysis sub-agent gracefully handles projects with minimal or no documentation
* **Mitigation:** First draft specifications acknowledge documentation limitations and focus on code reality
* **Mitigation:** Contradiction analysis focuses more heavily on codebase reality when documentation is sparse or missing
* **Mitigation:** User conversation explicitly addresses gaps and helps formulate intended direction

**Risk: Complex Legacy Architecture**

* **Mitigation:** Code Analysis sub-agent discovers ALL architectural elements without forcing predefined categories or oversimplifying complex patterns
* **Mitigation:** Generated specifications acknowledge architectural complexity and technical debt rather than creating idealized versions
* **Mitigation:** Reality vs intent distinction provides clear migration path from complex current state toward cleaner architecture
* **Mitigation:** Improvement tasks capture specific technical debt items that can be addressed systematically

**Risk: Unclear User Intent During Contradiction Resolution**

* **Mitigation:** Conversation-based discovery uses numbered, specific questions rather than open-ended prompts
* **Mitigation:** Hypothesis formulation provides concrete resolution options that help users articulate intended direction
* **Mitigation:** Iterative refinement continues until user explicitly confirms satisfaction with specifications
* **Mitigation:** User can request re-analysis of specific areas if initial resolution seems incorrect

**Risk: Sub-agent Integration Complexity**

* **Mitigation:** Follow proven `/init_greenfield` pattern for sub-agent orchestration and state management
* **Mitigation:** Each sub-agent has clearly defined inputs, outputs, and responsibilities with minimal overlap
* **Mitigation:** User confirmation prompts between phases allow validation of sub-agent outputs before proceeding
* **Mitigation:** Error handling and graceful degradation when sub-agents encounter unexpected project structures

---

## 6. Dependencies

**Completed Prerequisites:**

* M1: Project initialization framework (foundation for specification creation)
* SDD specification templates and structure (Vision, Requirements, Architecture, Roadmap)
* `/init_greenfield` command pattern for sub-agent orchestration and conversation flow
* Sub-agent development patterns and integration approaches

**Platform Dependencies:**

* Claude Code Task tool: Sub-agent orchestration following established patterns
* File system access: Documentation discovery, codebase analysis, and structure categorization
* Claude Opus model: Strategic conversation quality for contradiction resolution
* SDD specification templates from `/specs/templates/` directory

**Internal Dependencies:**

* Command structure patterns from `/init_greenfield` implementation
* Sub-agent specialization patterns proven in greenfield workflow
* Conversation-based discovery methodology and user interaction patterns
* Specification generation and validation processes
* Template compliance validation logic

**External Context Dependencies:**

* Access to project files and directories in working directory
* Ability to read various file types (.md, source code, configuration files)
* User availability for multi-phase conversation and validation process

---

## 7. Definition of Done

**Functional Completion:**

* `/init_brownfield` command exists and follows `/init_greenfield` orchestration pattern
* Project Structure Analysis sub-agent comprehensively categorizes all files and folders
* Documentation Analysis sub-agent discovers and analyzes all existing documentation, generating first specification drafts
* Code Analysis sub-agent comprehensively analyzes codebase structure and reality, generating second specification drafts
* Contradiction analysis identifies discrepancies between documentation intent and code reality
* User conversation workflow resolves contradictions through hypothesis validation and iterative refinement
* Final specification generation produces exactly four SDD documents: Vision, Requirements, Architecture, Roadmap
* Generated documents clearly distinguish between current reality and intended direction

**Quality Gates:**

* All 12 task blueprints (TASK-035 through TASK-046) pass individual validation
* Generated specifications clearly distinguish between current reality and intended direction throughout all documents
* Specifications enable immediate use of SDD workflows (`/task`, `/milestone`) with proper requirement numbering
* Command follows proven sub-agent orchestration pattern with appropriate error handling
* User conversation produces actionable improvement tasks added to roadmap when contradictions require code evolution
* Template compliance validation passes for all generated specification documents

**Integration Validation:**

* Existing SDD workflows remain unaffected by brownfield command addition
* Generated specifications pass SDD template validation and maintain consistent cross-references
* End-to-end workflow from `/init_brownfield` execution to final specification generation works reliably for both simple and complex projects
* Reality vs intent distinctions provide clear, actionable migration path for project improvement
* Sub-agent integration follows established patterns and maintains clean separation of concerns

**Documentation & Handoff:**

* All specification documents follow SDD template structure exactly with proper frontmatter and section organization
* Task blueprints have clear, non-overlapping responsibilities with explicit inputs, outputs, and integration points
* Generated specifications acknowledge both messy reality and clean intent without oversimplifying complex situations
* User receives clear summary of what was generated and how to proceed with SDD development workflows
* Milestone completion enables immediate transition to SDD development workflow with generated specifications

---
