---
version: "2.0.0"
template_type: "Task Blueprint"
description: "Detailed task specification extending milestone plan descriptions"
id: TASK-038
title: "Documentation Analysis sub-agent that generates first SDD specification drafts"
milestone_id: "M6"
---

# Task Blueprint: TASK-038 Documentation Analysis sub-agent that generates first SDD specification drafts

## 1. Task Description

**From Milestone Plan:** Create Documentation Analysis sub-agent that reads all discovered documentation, analyzes project intent, and generates first draft of all 4 specification documents

This task creates a specialized sub-agent focused on understanding project intent through comprehensive documentation analysis and immediately generating the first complete draft set of all four SDD specification documents. The sub-agent reads all documentation identified in Slice 1, extracts strategic information, and produces documentation-based drafts while flagging inconsistencies for later resolution.

*Technical Implementation:* Create `.claude/agents/documentation_analyst.md` with specialized context for understanding various documentation formats (README files, API documentation, architecture decision records, changelogs, wiki pages, inline code comments). The sub-agent reads actual file contents (not just metadata) to extract key information including: stated project purpose and goals, target users and use cases, functional requirements and features, architectural decisions and constraints, technology choices and rationale, deployment and operational considerations, and known issues or limitations. The sub-agent uses intelligent prioritization for large documentation sets, focusing on README, architecture docs, and API documentation first.

*Contradiction Detection Logic:* The sub-agent specifically looks for contradictions between different documentation sources (e.g., README says Python but API docs mention Node.js, architecture diagram shows microservices but deployment guide assumes monolith). When contradictions are found, they are flagged with specific location references and severity assessment (minor inconsistency vs major architectural conflict). This is extremely valuable information for users during contradiction resolution.

*User Interaction Pattern:* After analysis completes, present summary to user: "Documentation Analysis Complete. Found: [X] documents analyzed, [Y] architectural decisions identified, [Z] contradictions flagged for your review. Key findings: [summary]". Ask user to confirm major findings and whether any critical documentation was missed.

*Context Requirements:* The sub-agent receives the Project Structure Analysis categorization report to know which files to analyze. It also receives project type assessment (simple vs complex) to adjust its analysis depth appropriately. For complex projects like ktrdr, it handles multiple documentation sources systematically.

*Output Format:* The sub-agent produces a "Documentation Intent Analysis" report with sections for: Project Purpose and Vision, Functional Requirements Discovered, Architectural Intentions, Technology Stack Rationale, Deployment and Operations Intent, Documentation Quality Assessment (completeness, clarity, consistency), **Contradictions and Gaps Identified** (with specific references and severity), and **Questions for User Resolution** (structured for Slice 4 conversation).

**Additional Implementation Details:**

The Documentation Analysis sub-agent must understand and analyze documents as content-rich sources of project intent, not as data to be parsed programmatically. The agent reads documentation to comprehend meaning, identify patterns, and extract strategic insights through natural language understanding rather than building extraction algorithms.

### Document Prioritization Strategy

For projects with extensive documentation, the sub-agent implements intelligent prioritization:
1. **Primary Sources**: README.md, PROJECT.md, main documentation files in root directory
2. **Architectural Sources**: Architecture docs, ADRs, design documents, system diagrams
3. **API Sources**: API documentation, OpenAPI specs, interface descriptions
4. **Operational Sources**: Deployment guides, configuration documentation, operational runbooks
5. **Secondary Sources**: Changelogs, release notes, contributor guides, wiki pages

### Content Analysis Approach

The sub-agent analyzes each document to extract:
- **Strategic Intent**: Project vision, goals, and intended user value
- **Functional Scope**: Features, capabilities, and user requirements described
- **Technical Intent**: Architectural patterns, technology choices, and design rationale
- **Operational Intent**: Deployment, scaling, and operational considerations
- **Quality Intent**: Testing strategies, performance requirements, and reliability goals

### Specification Generation Process

After analyzing all documentation, the sub-agent generates complete first drafts of all four SDD specification documents:

1. **Vision Document**: Synthesizes project purpose, user value, and strategic goals from documentation
2. **Requirements Document**: Extracts functional and non-functional requirements with proper SDD numbering (FR-DOC-XXX, NFR-DOC-XXX)
3. **Architecture Document**: Captures intended architectural patterns, technology stack, and design constraints
4. **Roadmap Document**: Identifies planned features, improvement areas, and strategic initiatives mentioned in documentation

### Output File Structure

The sub-agent creates documentation-based drafts in `.brownfield_analysis/` directory:
- `slice2_docs_draft_vision.md`
- `slice2_docs_draft_requirements.md`  
- `slice2_docs_draft_architecture.md`
- `slice2_docs_draft_roadmap.md`

Each draft follows SDD template structure exactly, with frontmatter and proper section organization, enabling direct comparison with code-based drafts in Slice 4.

## 2. Implementation Guidance

### Sub-agent Context Structure

The documentation analyst agent receives structured input context:
- Project Structure Analysis categorization report
- List of discovered documentation files with prioritization weights
- Project complexity assessment (simple/complex)
- Technology stack indicators from file structure

### Documentation Reading Strategy

The agent must read actual file contents comprehensively, not just extract metadata. For each document:
1. **Full Content Analysis**: Read complete document content to understand context and relationships
2. **Cross-Reference Detection**: Identify references between documents and track consistency
3. **Intent Extraction**: Focus on understanding what the project is intended to accomplish
4. **Gap Identification**: Note areas where documentation is incomplete or vague

### Contradiction Detection Logic

The sub-agent implements systematic contradiction detection:
- **Technology Stack Contradictions**: Different documents mentioning conflicting technologies
- **Architectural Contradictions**: Inconsistent descriptions of system design
- **Feature Contradictions**: Conflicting descriptions of functionality
- **Deployment Contradictions**: Inconsistent operational requirements

Each contradiction is logged with:
- Source documents and specific locations
- Severity assessment (minor/major/critical)
- Impact analysis on specification generation
- Recommended resolution approach

### Error Handling

The sub-agent gracefully handles:
- **No Documentation**: Creates minimal drafts based on limited information
- **Corrupted Files**: Skips unreadable files with appropriate logging
- **Large Files**: Implements intelligent sampling for extremely large documentation
- **Foreign Languages**: Notes language barriers and focuses on universal elements

## 3. Success Criteria

### Given: Project Structure Analysis has categorized all project files and identified documentation sources
### When: Documentation Analysis sub-agent executes with the categorization report
### Then: All discovered documentation files are systematically read and analyzed for project intent
### And: Complete first drafts of all four SDD specification documents are generated based on documented intent
### And: Documentation Intent Analysis report is created with structured findings
### And: Any contradictions between documentation sources are identified and flagged with specific references
### And: Generated specification drafts follow SDD template structure exactly
### And: User receives clear summary of analysis results and confirmation prompts for major findings
### And: All outputs are properly stored in `.brownfield_analysis/` directory for Slice 4 consumption

### Given: A project with minimal documentation (like a simple plugin with only README)
### When: Documentation Analysis executes
### Then: Agent handles sparse documentation gracefully without failing
### And: Generated drafts acknowledge documentation limitations
### And: User is informed about documentation gaps for potential manual input

### Given: A complex project with extensive documentation (like ktrdr with multiple documentation sources)
### When: Documentation Analysis executes
### Then: Agent processes multiple documentation sources systematically
### And: Cross-references between documents are identified and validated
### And: Contradictions between different documentation sources are flagged
### And: Generated drafts synthesize information from all sources coherently

### Given: Documentation contains contradictory information about technology stack or architecture
### When: Contradiction detection logic executes
### Then: Specific contradictions are identified with source file references
### And: Severity assessment is provided for each contradiction
### And: Contradictions are structured for efficient resolution in Slice 4

### Given: Generated specification drafts are created
### When: Template compliance validation occurs
### Then: All drafts follow SDD template structure with proper frontmatter
### And: Cross-references between documents are consistent
### And: Requirements are properly numbered with FR-DOC-XXX and NFR-DOC-XXX format
### And: Drafts are ready for comparison with code-based drafts in Slice 4