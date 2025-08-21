---
version: "2.0.0"
template_type: "Task Blueprint"
description: "Detailed task specification extending milestone plan descriptions"
id: TASK-039
title: "Code Analysis sub-agent that analyzes codebase architectural skeleton and generates separate second draft of all 4 specification documents"
milestone_id: "M6"
---

# Task Blueprint: TASK-039 Code Analysis sub-agent that analyzes codebase architectural skeleton and generates separate second draft of all 4 specification documents

## 1. Task Description

**From Milestone Plan:** This task creates a specialized sub-agent that analyzes the codebase architectural skeleton to understand implementation reality and immediately generates a completely separate second draft set of all four SDD specification documents. These code-based drafts will be compared with documentation-based drafts in Slice 4 for contradiction resolution.

*Technical Implementation:* Create `sub_agents/code_analysis.md` with specialized context for understanding architectural patterns across multiple programming languages and frameworks. The sub-agent uses the "architectural skeleton" approach, analyzing: **High-Signal Elements:** File structure and organizational patterns, Import/dependency patterns and module boundaries, API interfaces and service boundaries (actual endpoints, not implementation), Configuration patterns (deployment, environment, security), Entry points and main workflows (application startup, routing), Technology stack integration points (databases, external services, frameworks). **Low-Signal Elements Avoided:** Function implementation details and business logic specifics, Variable naming and internal algorithms, Detailed data transformation logic, Most internal helper functions.

*Multi-Service Architecture Handling:* For complex projects like ktrdr with Python backend + TypeScript frontend + Docker + hosted services, the sub-agent identifies service boundaries through configuration analysis (docker-compose.yml, package.json files), API communication patterns (import statements, HTTP client usage), deployment separation (different Dockerfile patterns, environment configurations), and technology stack boundaries (language-specific entry points and configuration).

*Specification Generation:* The sub-agent immediately generates complete second drafts of all four SDD specification documents based on the architectural skeleton analysis. The Vision document reflects what the codebase actually accomplishes based on implemented features. The Requirements document captures functional requirements actually implemented in code. The Architecture document describes the actual technical implementation patterns, technology stack reality, and service boundaries. The Roadmap document identifies technical debt, incomplete features, and areas needing improvement based on code structure analysis.

*Output Generation for Slice 4:* Generated drafts are written to `.brownfield_analysis/slice3_code_draft_[vision|requirements|architecture|roadmap].md` for systematic comparison with Slice 2 documentation-based drafts. The sub-agent generates a detailed contradiction report highlighting the most significant discrepancies between documented intent and code reality, prioritized by impact and user decision requirements.

**Additional Implementation Details:**

**Path Correction:** The sub-agent file should be created at `.claude/agents/code_analysis.md` following the established project structure, not `sub_agents/code_analysis.md` as mentioned in the milestone plan.

**Document Understanding Approach:** The sub-agent should read and analyze any existing SDD specification documents (Vision, Requirements, Architecture, Roadmap) in the `specs/` directory to understand current project patterns, naming conventions, and architectural terminology. This contextual understanding helps generate code-based drafts that use consistent vocabulary and can be meaningfully compared with documentation-based drafts in Slice 4. The agent should understand these documents as human-readable text, not parse them programmatically.

**Template Compliance for Code Analysis:** Generated drafts should follow SDD template structure closely enough to enable systematic comparison with documentation-based drafts, but may contain rough content that will be refined during contradiction resolution. Each draft should include proper frontmatter, section headers, and requirement numbering (FR-XXX, NFR-XXX) based on discovered functionality.

**Code Reality Assessment Strategy:** The agent analyzes both fully implemented functionality and incomplete features/technical debt to provide a complete picture of current reality. Implemented functionality becomes current requirements (FR-IMP-XXX), while incomplete features and technical debt become improvement opportunities for the roadmap. This comprehensive analysis enables thorough contradiction detection in Slice 4.

**Language-Agnostic Analysis Patterns:** The sub-agent uses universal architectural patterns that work across programming languages: entry points (main.py, index.js, App.tsx), configuration files (package.json, requirements.txt, Dockerfile), API definitions (routes, controllers, handlers), service boundaries (separate directories, different tech stacks), and deployment patterns (multiple Dockerfiles, environment configurations).

## 2. Implementation Guidance

**Architectural Skeleton Focus:** The sub-agent prioritizes understanding system structure over implementation details. For web applications, this means analyzing route definitions and API endpoints rather than business logic. For data processing systems, this means understanding pipeline structure and data flow rather than transformation algorithms. For microservices, this means identifying service boundaries and communication patterns rather than individual service implementations.

**File System Analysis Strategy:** Use Glob patterns to discover files by type and extension, LS commands to understand directory organization, and Read commands to analyze configuration files and entry points. Avoid reading large data files, build artifacts, or detailed implementation code. Focus on files that reveal architectural decisions: docker-compose.yml, package.json, requirements.txt, main entry points, API route definitions, and configuration directories.

**Technology Stack Identification:** Identify technology stacks through configuration file analysis rather than deep code reading. Python projects reveal themselves through requirements.txt, setup.py, or pyproject.toml. JavaScript/TypeScript projects through package.json and tsconfig.json. Docker usage through Dockerfile and docker-compose.yml. Database usage through connection configurations and migration directories.

**Service Boundary Detection:** For multi-service architectures, identify boundaries through: separate package.json or requirements.txt files indicating different services, distinct Dockerfile configurations, different environment variable patterns, separate API endpoint namespaces, and technology stack changes (Python backend + React frontend).

**Requirements Discovery from Code:** Transform discovered functionality into requirement statements. API endpoints become functional requirements (FR-API-XXX). Database schemas become data requirements (FR-DATA-XXX). Authentication systems become security requirements (NFR-SEC-XXX). Configuration options become operational requirements (NFR-OPS-XXX).

**Vision Extraction from Implementation:** Infer project vision from implemented features and architectural choices. E-commerce sites with payment processing, user accounts, and product catalogs suggest a "comprehensive online marketplace" vision. Developer tools with CLI interfaces, configuration management, and plugin systems suggest a "extensible development workflow" vision. The agent extracts vision from what the code actually accomplishes, not what developers intended.

**Contradiction Preparation:** Generate the contradiction report by comparing code reality findings with any existing documentation discovered in the project. Flag major discrepancies like documented microservices vs. monolithic implementation, stated technology stacks vs. actual dependencies, claimed features vs. implemented functionality. Prioritize contradictions by impact: architectural differences (high), feature gaps (medium), technology mismatches (medium), documentation outdated (low).

## 3. Success Criteria

**Given** the Project Structure Analysis has categorized all source code files and configuration files
**When** the Code Analysis sub-agent executes
**Then** it analyzes the codebase architectural skeleton without reading implementation details
**And** it identifies all high-signal architectural elements: file organization, dependencies, API boundaries, configuration patterns, entry points, and technology stack integration
**And** it avoids low-signal elements: function implementations, business logic, variable naming, and internal algorithms
**And** it handles multi-service architectures by identifying service boundaries through configuration analysis and technology stack boundaries

**Given** the architectural skeleton analysis is complete
**When** the sub-agent generates specification drafts
**Then** it creates complete second drafts of all four SDD documents: Vision, Requirements, Architecture, and Roadmap
**And** the Vision document reflects what the codebase actually accomplishes based on implemented features
**And** the Requirements document captures functional requirements actually implemented in code with proper FR-XXX numbering
**And** the Architecture document describes actual technical implementation patterns, technology stack reality, and service boundaries
**And** the Roadmap document identifies technical debt, incomplete features, and areas needing improvement based on code structure analysis

**Given** all four specification drafts are generated
**When** preparing output for Slice 4 consumption
**Then** drafts are written to `.brownfield_analysis/slice3_code_draft_[vision|requirements|architecture|roadmap].md` with proper file naming
**And** a detailed contradiction report is generated highlighting discrepancies between documented intent and code reality
**And** contradictions are prioritized by impact and include specific file references and user decision requirements
**And** generated content follows SDD template structure sufficiently for systematic comparison with documentation-based drafts

**Given** the sub-agent encounters complex architectures (like ktrdr with Python + TypeScript + Docker + hosted services)
**When** analyzing multi-language, multi-service codebases
**Then** it correctly identifies service boundaries through configuration analysis (docker-compose.yml, package.json files)
**And** it recognizes API communication patterns through import statements and HTTP client usage
**And** it distinguishes deployment separation through different Dockerfile patterns and environment configurations
**And** it identifies technology stack boundaries through language-specific entry points and configuration files

**Given** the sub-agent has access to existing SDD specification documents in the `specs/` directory
**When** performing code analysis
**Then** it reads and understands existing specifications to maintain consistent vocabulary and architectural terminology
**And** it uses this context to generate code-based drafts that can be meaningfully compared with documentation-based drafts
**And** it identifies contradictions between documented intent and implemented reality using consistent project language