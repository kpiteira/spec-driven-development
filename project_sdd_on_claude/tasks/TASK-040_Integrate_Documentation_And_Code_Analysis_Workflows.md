---
version: "2.0.0"
template_type: "Task Blueprint"
description: "Detailed task specification extending milestone plan descriptions"
id: TASK-040
title: "Integrate Documentation AND Code Analysis workflows into /init_brownfield command"
milestone_id: "M6"
---

# Task Blueprint: TASK-040 Integrate Documentation AND Code Analysis workflows into /init_brownfield command

## 1. Task Description

**From Milestone Plan:** This task integrates both Documentation Analysis and Code Analysis workflows into the main `/init_brownfield` command, orchestrating both analysis approaches to execute and generate their respective specification drafts. The integration includes user interaction patterns and progress coordination for both analysis phases.

*Technical Implementation:* Extend `/commands/init_brownfield.md` to include both Documentation Analysis and Code Analysis sub-agent invocations after Project Structure Analysis completes. The command orchestrates both the documentation reading/analysis and codebase architectural skeleton analysis as coordinated workflows. The integration includes error handling for projects with no documentation or unreadable documentation formats, as well as complex codebases with multiple languages and architectures.

*Parallel Execution Design:* The integration coordinates both analysis approaches which are objective analyses that don't depend on each other. After structure analysis and user confirmation, the command launches both documentation and code analysis. Both analyses generate their respective specification drafts independently, with results properly stored for Slice 4 comparison and contradiction resolution.

*User Interaction Pattern:* After structure analysis, the command presents: "Beginning documentation and code analysis. Found [X] documentation files and [Y] source files. This will read actual file contents to understand both documented project intent and implementation reality, generating two complete sets of specification drafts. Proceed? [Y/n]". After analyses complete: "Analysis complete. Generated first draft specifications based on documented intent and second draft specifications based on code reality. Key findings: Documentation - [summary]. Code Reality - [summary]. Ready for contradiction analysis."

*Coordination and Orchestration:* The task ensures both Documentation Analysis and Code Analysis outputs (draft specifications and analysis reports) are properly stored with clear naming conventions (`.brownfield_analysis/slice2_docs_draft_*` and `.brownfield_analysis/slice2_code_draft_*`) for systematic comparison in Slice 4. The integration coordinates progress reporting and user feedback for both analysis phases.

*Error Handling:* The integration handles edge cases including: no documentation found (code analysis becomes primary source), documentation in unsupported formats (notes for manual review), complex multi-language codebases (architectural skeleton approach), and analysis failures (graceful degradation with manual fallback options).

*Integration Points:* This task establishes the complete handoff to Slice 4 by ensuring both analysis approaches have executed successfully and generated complete specification draft sets. The workflow prepares all necessary inputs for contradiction analysis and resolution in subsequent slices.

**Additional Implementation Details:**

The integration must orchestrate both Documentation Analysis and Code Analysis sub-agents as coordinated workflows that execute in parallel to generate two complete sets of specification drafts. The agents analyze documents and code through natural language understanding and architectural pattern recognition, not through parsing or extraction algorithms.

### Human Architect Decisions:
1. **Parallel execution approach confirmed** - Both analyses execute simultaneously since they are objective analyses that don't depend on each other
2. **Error handling strategy** - Problems should be reported clearly to user rather than graceful degradation or halting execution
3. **File preservation** - All analysis files must be preserved in `.brownfield_analysis/` directory for complete transparency and traceability

### Sub-agent Orchestration Pattern

The command extends the established pattern from Project Structure Analysis to coordinate both Documentation Analysis and Code Analysis sub-agents:

1. **Sequential Setup**: Project Structure Analysis completes first, providing categorization input for both subsequent analyses
2. **Parallel Execution**: Documentation and Code analyses launch simultaneously with structure analysis results as input
3. **Independent Processing**: Each analysis generates its own complete set of specification drafts without cross-dependencies
4. **Coordinated Output**: Results are stored with consistent naming conventions for Slice 4 consumption

### User Interaction Flow

The integration maintains clear user communication throughout the analysis process:

1. **Pre-Analysis Confirmation**: Present analysis scope and request user confirmation before launching intensive analysis
2. **Progress Coordination**: Provide updates on both analysis approaches as they execute
3. **Results Summary**: Present findings from both documentation and code reality analyses with key highlights
4. **Readiness Confirmation**: Confirm user readiness to proceed to contradiction analysis phase

### Error Handling Strategy

The integration implements comprehensive error handling for real-world project complexity:

- **Missing Documentation**: When no documentation exists, code analysis becomes primary source with user notification
- **Unreadable Documentation**: Corrupted or unsupported file formats are logged for manual review
- **Complex Codebases**: Multi-language, multi-service architectures are handled through architectural skeleton approach
- **Analysis Failures**: Graceful degradation with manual fallback options and clear user guidance

### File Management and Storage

All analysis outputs are systematically organized for Slice 4 consumption:
- `.brownfield_analysis/slice2_docs_draft_vision.md`
- `.brownfield_analysis/slice2_docs_draft_requirements.md`
- `.brownfield_analysis/slice2_docs_draft_architecture.md`
- `.brownfield_analysis/slice2_docs_draft_roadmap.md`
- `.brownfield_analysis/slice2_code_draft_vision.md`
- `.brownfield_analysis/slice2_code_draft_requirements.md`
- `.brownfield_analysis/slice2_code_draft_architecture.md`
- `.brownfield_analysis/slice2_code_draft_roadmap.md`

## 2. Implementation Guidance

### Command Structure Extension

The `/init_brownfield` command must be extended to include sub-agent orchestration for both Documentation Analysis and Code Analysis after Project Structure Analysis completes. The command follows the established pattern from Task 035 but adds coordinated dual-analysis workflow.

### Sub-agent Context Preparation

Both sub-agents receive the Project Structure Analysis categorization report as input context, but process different aspects:
- **Documentation Analysis**: Focuses on categorized documentation files for intent understanding
- **Code Analysis**: Focuses on categorized source code and configuration files for implementation reality

### Progress Coordination

The integration coordinates progress reporting to provide clear user feedback:
1. **Analysis Initiation**: "Launching documentation analysis on [X] files and code analysis on [Y] files..."
2. **Completion Status**: "Documentation analysis complete. Code analysis complete."
3. **Results Summary**: "Generated [N] specification drafts from documentation intent and [N] drafts from code reality."

### Error Recovery Patterns

The integration implements specific error recovery for common scenarios:
- **Partial Documentation**: Proceed with available documentation and note gaps for user awareness
- **Analysis Timeout**: Implement reasonable timeouts with user notification and retry options
- **Sub-agent Failures**: Graceful degradation with clear error reporting and manual fallback guidance

## 3. Success Criteria

### Given: Project Structure Analysis has completed successfully and user has confirmed categorization accuracy
### When: Both Documentation Analysis and Code Analysis sub-agents are orchestrated by the `/init_brownfield` command
### Then: Both analyses execute in parallel without blocking each other
### And: Documentation Analysis reads all discovered documentation files and generates first complete set of specification drafts
### And: Code Analysis analyzes codebase architectural skeleton and generates second complete set of specification drafts
### And: Both sets of drafts are stored with proper naming conventions in `.brownfield_analysis/` directory
### And: User receives clear progress updates and completion confirmations for both analysis phases

### Given: A project with extensive documentation and complex multi-language codebase (like ktrdr)
### When: The integrated analysis workflow executes
### Then: Documentation Analysis processes multiple documentation sources systematically
### And: Code Analysis identifies service boundaries and technology stack complexity appropriately
### And: Both analyses generate complete specification drafts that handle project complexity
### And: Results are properly coordinated for systematic comparison in Slice 4

### Given: A project with minimal documentation (like simple plugin with only README)
### When: The integrated analysis workflow executes
### Then: Documentation Analysis handles sparse documentation gracefully without failing
### And: Code Analysis becomes primary source for specification generation
### And: User is clearly informed about documentation limitations and reliance on code analysis
### And: Integration proceeds successfully with appropriate fallback behavior

### Given: Analysis failures or errors occur during sub-agent execution
### When: Error handling logic activates
### Then: Specific error information is reported clearly to user
### And: Manual fallback options are provided with clear guidance
### And: Partial results are preserved when possible for user review
### And: Integration maintains system stability without crashing or hanging

### Given: Both analysis phases complete successfully
### When: Preparing handoff to Slice 4 contradiction analysis
### Then: All specification draft files exist with proper naming and structure
### And: User receives comprehensive summary of what was analyzed and generated
### And: System confirms readiness to proceed with contradiction analysis
### And: All necessary inputs for Slice 4 are properly prepared and accessible