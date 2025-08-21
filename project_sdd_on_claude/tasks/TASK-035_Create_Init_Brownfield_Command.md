---
version: "2.0.0"
template_type: "Task Blueprint"
description: "Create foundational /init_brownfield command with Project Structure Analysis integration"
id: TASK-035
title: "Create /init_brownfield command with Project Structure Analysis integration"
milestone_id: "M6"
---

# Task Blueprint: TASK-035 Create /init_brownfield command with Project Structure Analysis integration

## 1. Task Description

**From Milestone Plan:** This task creates the foundational command structure that orchestrates the entire brownfield discovery workflow, integrating Project Structure Analysis sub-agent invocation and user confirmation prompts. The command implements the conversation-first approach with streamlined user interaction.

*Technical Implementation:* Create `/commands/init_brownfield.md` following the established pattern from `/init_greenfield`. The command frontmatter includes description, usage, and model specification. The command includes integrated sub-agent orchestration for Project Structure Analysis with appropriate user confirmation prompts.

*User Interaction Pattern:* The command begins by asking the user a single focused question: "Can you explain the purpose of this project, or point me to a document explaining that?" This allows natural discovery of project context while the structure analysis proceeds. The discovery process naturally identifies project complexity without asking predetermined questions about project type.

*Integration Points:* This task creates the complete orchestration framework including Project Structure Analysis sub-agent invocation. After structure analysis completes, present a summary report to the user including: "Project Type: [assessment]", "Key Technologies: [list]", "Documentation Found: [count and types]", "Source Code Structure: [pattern]", and "Notable Findings: [any unusual patterns]". Ask the user to confirm this assessment is accurate and whether any important components were missed or miscategorized.

**Additional Implementation Details:**

The command frontmatter should specify `claude-opus-4-1-20250805` model for strategic conversation quality (per NFR-PERF-004) and include allowed-tools for Task orchestration, file system access, and user interaction. Error handling should gracefully manage common edge cases including permission denied errors, empty directories, and unreadable file types by noting them in the summary report rather than failing the analysis.

The orchestration sequence follows: 1) Initial user conversation starter, 2) Project Structure Analysis sub-agent invocation, 3) Summary report presentation, 4) User confirmation before proceeding. This ensures the foundation is solid before subsequent slices build upon the structure categorization.

## 2. Implementation Guidance

**Command Structure Pattern:**
- Follow `/init_greenfield` frontmatter format with appropriate tool permissions
- Use Task tool for sub-agent orchestration following established patterns
- Implement conversation-first approach with single focused initial question
- Present structured summary report with specific categories as defined in Integration Points

**Sub-Agent Integration:**
- Invoke Project Structure Analysis sub-agent after initial user context gathering
- Pass current working directory as input to structure analysis
- Receive structured categorization report as output
- Present analysis results to user in readable summary format

**User Confirmation Flow:**
- Present analysis summary with the five required categories (Project Type, Key Technologies, Documentation Found, Source Code Structure, Notable Findings)
- Ask specific confirmation question about accuracy and missed components
- Proceed only after user confirms the foundation assessment is accurate

## 3. Success Criteria

**Given** I am in any existing project directory
**When** I execute `/init_brownfield` 
**Then** the command initializes with clear user conversation starter explaining the discovery process
**And** the command asks the focused question: "Can you explain the purpose of this project, or point me to a document explaining that?"
**And** Project Structure Analysis sub-agent is invoked and comprehensively categorizes ALL files and folders
**And** categories include: docs/specs, source code, configuration, deployment, data, tests, build artifacts, etc.
**And** a summary report is presented including Project Type assessment, Key Technologies list, Documentation Found count and types, Source Code Structure pattern, and Notable Findings
**And** user confirms major project components before proceeding to analysis phases
**And** foundation structure provides clear categorization for subsequent analysis slices (TASK-036 and beyond)

**Given** the Project Structure Analysis encounters edge cases (permission errors, unreadable files, empty directories)
**When** the analysis executes
**Then** edge cases are handled gracefully without failing the overall analysis
**And** issues are noted in the summary report for user awareness
**And** the analysis continues with available information

**Given** the command follows the established orchestration pattern
**When** comparing with `/init_greenfield` command structure
**Then** frontmatter format, sub-agent invocation approach, and user interaction patterns are consistent
**And** Tool permissions and model specification align with SDD architecture requirements
**And** Error handling and graceful degradation follow proven approaches