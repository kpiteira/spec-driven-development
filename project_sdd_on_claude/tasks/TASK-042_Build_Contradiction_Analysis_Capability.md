---
version: "2.0.0"
template_type: "Task Blueprint"
description: "Detailed task specification extending milestone plan descriptions"
id: TASK-042
title: "Build contradiction analysis capability that compares documentation and code drafts and generates living documents with hypotheses"
milestone_id: "M6"
---

# Task Blueprint: TASK-042 Build contradiction analysis capability that compares documentation and code drafts and generates living documents with hypotheses

## 1. Task Description

**From Milestone Plan:** This task creates the contradiction analysis capability that will systematically compare documentation-based and code-based specification drafts to identify specific discrepancies and formulate hypotheses about resolution approaches. Based on research, this builds a hybrid approach with annotated living documents + structured recommendations.

*Technical Implementation:* Build contradiction analysis logic within the main `/init_brownfield` command that will perform section-by-section comparison of the two draft sets. The analysis identifies contradictions at multiple levels: strategic (project vision and goals), functional (what features exist vs what's documented), architectural (intended vs actual technical implementation), and tactical (roadmap priorities vs technical debt reality). The analysis logic loads both draft sets from `.brownfield_analysis/slice2_docs_draft_*` and `.brownfield_analysis/slice3_code_draft_*` files.

*Contradiction Identification Strategy:* The analysis systematically compares corresponding sections of each specification document type. For Vision documents, it compares stated purpose with actual functionality discovered in code. For Requirements documents, it compares documented features with implemented capabilities (APIs, modules, integrations). For Architecture documents, it compares intended patterns with actual implementation architecture. For Roadmap documents, it compares planned directions with technical debt and implementation gaps discovered through code analysis.

*Hypothesis Formulation Logic:* For each identified contradiction, the system formulates 2-3 specific resolution hypotheses with pros/cons analysis. Common hypothesis patterns include: "Documentation reflects original intent, code represents evolution" (pro: honors project history, con: may not reflect current needs), "Code reflects current reality, documentation represents outdated aspiration" (pro: matches implementation, con: may lack strategic vision), "Both sources contain partial truth requiring synthesis" (pro: comprehensive solution, con: requires more user decision-making), and "Contradiction suggests architectural decision point requiring strategic input" (pro: enables informed choice, con: may delay completion).

*Research-Informed Output Format:* Generate "Living Documents" for each specification type using the hybrid approach: **Annotated Living Documents** with side-by-side presentation of documentation vs code reality, **Gap Analysis sections** with specific recommendations for resolving contradictions, **Decision Matrices** with pros/cons for each resolution hypothesis, and **Structured Recommendations** that help users make informed choices. Each contradiction includes: the specific discrepancy with line references, context from both drafts, 2-3 formulated hypotheses with pros/cons, confidence level in each hypothesis, and impact assessment (high/medium/low).

*User Interaction Pattern:* After analysis completes, present summary: "Contradiction analysis complete. Found [X] strategic contradictions, [Y] functional discrepancies, [Z] architectural differences. Most critical: [summary of top 3]. Ready to review and resolve these with you."

**Additional Implementation Details:**

The contradiction analysis capability must implement systematic comparison logic that processes both draft sets through natural language understanding to identify specific discrepancies across all levels of the specification hierarchy. The analysis operates on the principle that agents read and analyze documents rather than parsing them programmatically.

### Contradiction Analysis Architecture

The analysis logic implements a layered comparison approach:

1. **Document-Level Comparison**: Each specification type (Vision, Requirements, Architecture, Roadmap) is compared between documentation-based and code-based drafts
2. **Section-Level Analysis**: Within each document, corresponding sections are systematically compared to identify specific discrepancies
3. **Content-Level Assessment**: Individual statements, requirements, and architectural decisions are analyzed for contradictions
4. **Impact Classification**: Each contradiction is classified by impact level (strategic, functional, architectural, tactical) and priority (high/medium/low)

### Hypothesis Generation Framework

The system formulates resolution hypotheses following established patterns:

- **Historical Perspective**: "Documentation reflects original intent, code represents evolution"
- **Current Reality**: "Code reflects current reality, documentation represents outdated aspiration"  
- **Synthesis Approach**: "Both sources contain partial truth requiring synthesis"
- **Strategic Decision**: "Contradiction suggests architectural decision point requiring strategic input"

Each hypothesis includes structured pros/cons analysis and confidence assessment to guide user decision-making.

### Living Documents Structure

The hybrid output format creates systematic presentation of contradictions:

- **Side-by-Side Comparison**: Documentation intent vs code reality with specific line references
- **Contradiction Catalog**: Numbered list of discrepancies with impact classification
- **Resolution Matrix**: Decision framework with hypothesis options and trade-off analysis
- **Recommendation Summary**: Structured guidance for user decision-making

### File Organization and Naming

All contradiction analysis outputs follow systematic naming conventions:

- `.brownfield_analysis/slice4_living_vision.md`
- `.brownfield_analysis/slice4_living_requirements.md`  
- `.brownfield_analysis/slice4_living_architecture.md`
- `.brownfield_analysis/slice4_living_roadmap.md`
- `.brownfield_analysis/slice4_contradiction_summary.md`

## 2. Implementation Guidance

### Analysis Logic Integration

The contradiction analysis capability extends the `/init_brownfield` command by adding analysis logic that loads both documentation and code draft sets and performs systematic comparison. The logic must handle edge cases where draft sets are incomplete or inconsistent.

### Comparison Algorithm Structure

The comparison algorithm implements structured analysis across multiple dimensions:

1. **Strategic Level**: Project purpose, vision statements, core value propositions
2. **Functional Level**: Feature descriptions, API capabilities, user-facing functionality
3. **Architectural Level**: Technical patterns, service boundaries, technology choices
4. **Tactical Level**: Implementation priorities, technical debt, roadmap sequencing

### Hypothesis Formulation Process

For each identified contradiction, the system generates multiple resolution hypotheses using natural language analysis to understand context and implications. The formulation process considers project history, current constraints, and strategic objectives.

### User Interface Design

The contradiction presentation follows structured patterns that enable clear user understanding and decision-making:

- **Impact-Ordered Presentation**: Start with highest-impact contradictions affecting project vision and architecture
- **Systematic Formatting**: Consistent presentation format for all contradictions with clear hypothesis options
- **Decision Tracking**: Maintain state for user resolution decisions across conversation flow

### Error Handling Strategy

The analysis capability implements robust error handling for real-world scenarios:

- **Missing Draft Files**: Graceful degradation when either documentation or code drafts are incomplete
- **Analysis Failures**: Clear error reporting with fallback options for manual review
- **Inconsistent Formats**: Handling of varied document structures and incomplete information

## 3. Success Criteria

### Given: Both documentation-based and code-based specification drafts exist in `.brownfield_analysis/` directory from previous slices
### When: Contradiction analysis capability is executed within `/init_brownfield` command
### Then: Analysis logic systematically compares all four specification document types (Vision, Requirements, Architecture, Roadmap)
### And: Contradictions are identified at strategic, functional, architectural, and tactical levels with specific line references
### And: Each contradiction generates 2-3 resolution hypotheses with structured pros/cons analysis
### And: Impact assessment and confidence levels are assigned to each hypothesis
### And: Living documents are generated with side-by-side presentation format

### Given: Project with significant discrepancies between documentation intent and code implementation (like documented microservices vs monolithic code)
### When: Contradiction analysis processes the draft sets
### Then: Strategic and architectural contradictions are identified with high impact classification
### And: Hypothesis formulation addresses evolution vs intent patterns appropriately
### And: Resolution options consider both historical context and current constraints
### And: Living documents clearly present the scope and implications of major contradictions

### Given: Project with minimal contradictions (documentation and code largely aligned)
### When: Contradiction analysis executes
### Then: Analysis completes successfully with low contradiction count
### And: Minor discrepancies are properly classified with appropriate impact levels
### And: Living documents reflect accurate assessment of project consistency
### And: User receives clear summary indicating high alignment between documentation and code

### Given: Incomplete or missing draft files from previous analysis slices
### When: Contradiction analysis attempts to load draft sets
### Then: Error handling provides clear guidance about missing inputs
### And: Partial analysis proceeds with available drafts when possible
### And: User is informed about limitations and manual review requirements
### And: System maintains stability without crashing or corrupting existing analysis files

### Given: Complex project with multiple languages, services, and architectural patterns
### When: Contradiction analysis processes extensive draft sets
### Then: Analysis handles complexity systematically without overwhelming user
### And: Contradictions are properly categorized by service boundary and technology domain
### And: Hypothesis formulation considers architectural migration patterns and constraints
### And: Living documents organize contradictions logically for systematic resolution

### Given: Contradiction analysis completes successfully
### When: Preparing output for Slice 4 user conversation workflow
### Then: Living documents are properly formatted with consistent structure across all specification types
### And: Contradiction summary provides clear overview of findings with impact prioritization
### And: User receives completion notification with readiness confirmation for resolution workflow
### And: All analysis outputs are stored with proper naming conventions for subsequent slice consumption