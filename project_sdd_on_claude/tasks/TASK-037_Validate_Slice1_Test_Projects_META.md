---
version: "2.0.0"
template_type: "Task Blueprint"
description: "Detailed task specification extending milestone plan descriptions"
id: TASK-037
title: "Validate Slice 1 on test projects with META self-improvement"
milestone_id: "M6"
---

# Task Blueprint: TASK-037 Validate Slice 1 on test projects with META self-improvement

## 1. Task Description

**From Milestone Plan:** This task implements comprehensive validation of Slice 1 functionality using real test projects, with META instructions for self-improvement when validation criteria are not met.

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

**Additional Implementation Details:**

This validation task serves as a critical quality gate before proceeding to Slices 2-4. The implementation must create a systematic validation protocol that ensures the foundational project structure analysis capabilities are robust across different project types and complexities. The validation approach explicitly separates development context from usage context to simulate realistic end-user conditions and prevent context pollution that could mask implementation flaws.

## 2. Implementation Guidance

**Validation Protocol Implementation:**
- Create user prompts that clearly explain the context separation requirement
- Provide step-by-step instructions for opening separate Claude Code sessions
- Include specific directory navigation instructions for test projects
- Generate template validation report structures for consistent data collection

**META Analysis Integration:**
- Implement failure pattern analysis that examines validation criteria systematically
- Create improvement recommendation logic that maps failed criteria to specific sub-agent enhancements
- Design iterative improvement workflow that enables rapid testing-improvement cycles
- Ensure META instructions are clearly marked for production removal

**Quality Assurance Focus:**
- Validate that Project Structure Analysis sub-agent (TASK-036) correctly categorizes files across different project architectures
- Confirm that `/init_brownfield` command (TASK-035) orchestrates structure analysis with appropriate user interaction
- Test edge cases including minimal documentation, complex multi-service architectures, and unusual project structures
- Ensure validation criteria distinguish between minor categorization differences and fundamental analysis failures

## 3. Success Criteria

**Given** TASK-035 and TASK-036 have been completed with `/init_brownfield` command and Project Structure Analysis sub-agent implemented
**When** validation testing is executed on both Obsidian Importer and ktrdr projects in separate Claude Code sessions
**Then** the Obsidian Importer validation session correctly identifies TypeScript/Node.js plugin structure, recognizes Obsidian-specific patterns, and receives positive human confirmation on project understanding
**And** the ktrdr validation session correctly identifies multi-service polyglot architecture, distinguishes between dockerized and hosted components, and receives positive human confirmation on architectural complexity understanding
**And** validation reports are successfully transferred back to development context through structured documentation
**And** if any validation criteria fail, META analysis produces specific, actionable improvement recommendations for TASK-035 and TASK-036 implementations
**And** the validation protocol itself demonstrates clear context separation without development context pollution
**And** both test projects receive 100% file and directory identification with appropriate categorization accuracy
**And** user confirmation questions receive affirmative responses indicating correct project analysis understanding