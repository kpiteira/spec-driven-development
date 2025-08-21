---
version: "2.0.0"
template_type: "Task Blueprint"
description: "Detailed task specification extending milestone plan descriptions"
id: TASK-036
title: "Create Project Structure Analysis sub-agent that comprehensively categorizes ALL files/folders"
milestone_id: "M6"
---

# Task Blueprint: TASK-036 Create Project Structure Analysis sub-agent that comprehensively categorizes ALL files/folders

## 1. Task Description

**From Milestone Plan:** This task creates a specialized sub-agent that performs comprehensive project structure discovery and categorization. The sub-agent analyzes the tree structure, file names, and directory organization of the project (respecting .gitignore) to categorize them into meaningful architectural buckets that inform subsequent analysis phases. This is structural analysis only - actual file content reading happens in later slices.

*Technical Implementation:* Create `sub_agents/project_structure_analysis.md` with specialized context for understanding project organization patterns. The AI agent uses tools for tree analysis to examine all directories and files, applying categorization logic based on file types, directory names, and common patterns. Categories are examples that depend on project complexity, language, and type - typical categories include: Documentation/Specs (README.md, docs/, wiki/, *.md files), Source Code (language-specific patterns like src/, lib/, app/), Configuration (package.json, Dockerfile, .env files, config directories), Tests (test/, spec/, **tests** directories), Build Artifacts (dist/, build/, target/, node_modules/), Data (database files, migrations, fixtures), Deployment (CI/CD configs, infrastructure as code), and Other (uncategorized files requiring manual review).

*Specific Inputs and Outputs:* Input is the current working directory. Output is a comprehensive categorization report formatted as structured markdown with sections for each category, file counts, and notable patterns discovered. The report includes a "Project Type Assessment" section that identifies the primary technology stack, architectural patterns, and complexity indicators (monorepo vs single service, frontend/backend/fullstack, etc.).

*Edge Case Handling:* The sub-agent handles edge cases including: empty directories, symlinks, very large files (logs, binaries), hidden files and directories, non-standard project structures, and mixed-language codebases. For ambiguous files, the sub-agent marks them for manual review rather than making incorrect assumptions.

**Additional Implementation Details:**

The sub-agent file should be created at `.claude/agents/project_structure_analysis.md` (correcting the path from milestone plan to match actual project structure). The sub-agent must be designed to work with Claude Code's native file system tools (LS, Glob, Grep) and provide comprehensive analysis that enables both Documentation Analysis and Code Analysis sub-agents in subsequent slices to work effectively.

The categorization logic should be intelligence-driven rather than rule-based, using pattern recognition to understand project organization approaches. The sub-agent should handle both simple projects (like TypeScript plugins) and complex multi-service architectures (like Python + TypeScript + Docker combinations) with appropriate depth of analysis for each.

## 2. Implementation Guidance

**Sub-agent Architecture:**
- Create specialized prompt context for understanding diverse project organization patterns
- Include clear instructions for the AI agent to analyze structure without reading file contents
- Provide guidance for handling multiple programming languages and framework patterns
- Include intelligence for distinguishing between source code, configuration, documentation, and artifacts

**Categorization Strategy:**
- Use file extensions, directory names, and common patterns for initial categorization
- Apply intelligent inference for ambiguous cases (e.g., recognizing test directories by name patterns)
- Generate project type assessment based on discovered files and structure patterns
- Provide detailed file counts and notable patterns for each category to inform subsequent analysis

**Integration Requirements:**
- Output format must be structured markdown that can be consumed by Documentation Analysis and Code Analysis sub-agents
- Report must include clear project type assessment and complexity indicators
- Edge case handling must mark ambiguous files for manual review rather than incorrect categorization
- Must respect .gitignore patterns and avoid analyzing ignored files

## 3. Success Criteria

**Given** the sub-agent is created at `.claude/agents/project_structure_analysis.md`
**When** the sub-agent is invoked by the `/init_brownfield` command in any project directory
**Then** it comprehensively analyzes the project structure using file system tools
**And** generates a structured markdown categorization report with clear sections for each category
**And** includes accurate file counts and notable patterns for each category
**And** provides intelligent project type assessment (technology stack, architectural patterns, complexity indicators)
**And** handles edge cases gracefully by marking ambiguous files for manual review
**And** respects .gitignore patterns and avoids analyzing ignored files
**And** provides categorization that enables effective Documentation Analysis and Code Analysis in subsequent slices

**Given** the sub-agent encounters complex project structures (monorepo, multi-language, non-standard organization)
**When** it performs categorization analysis
**Then** it applies intelligent pattern recognition to understand the organization approach
**And** generates appropriate depth of analysis for the project complexity level
**And** identifies service boundaries and architectural patterns where evident from structure alone
**And** flags non-standard structures that require special attention in later analysis phases

**Given** the sub-agent encounters simple project structures (single language, standard patterns)
**When** it performs categorization analysis
**Then** it provides concise but complete categorization appropriate to project simplicity
**And** identifies the primary technology stack and architectural approach clearly
**And** prepares clear foundation for focused Documentation and Code Analysis

**Given** the sub-agent output is consumed by Documentation Analysis and Code Analysis sub-agents
**When** subsequent analysis phases execute
**Then** the categorization report provides sufficient information for targeted file analysis
**And** project type assessment enables appropriate depth and focus for each analysis approach
**And** edge case markings prevent incorrect assumptions in subsequent phases
**And** category organization enables efficient analysis workflow execution