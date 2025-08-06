# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **specification-only repository** for the Spec-Driven Development (SDD) methodology - a framework for AI-assisted software development that uses formal specifications to orchestrate human architects and AI agents. There is no source code to build or test; this repository contains only documentation and templates.

## Core Architecture

The SDD system implements an "Assembly Line" model with specialized AI agents:

- **Human Architect**: Defines strategic vision and requirements
- **Supervisor Agent**: Orchestrates task execution workflows  
- **Bundler Agent**: Performs research and context preparation to prevent hallucination
- **Security Consultant Agent**: Provides proactive security guidance
- **Coder Agent**: Implements code following TDD principles
- **Validator Agent**: Ensures quality through comprehensive testing

## Repository Structure

### System Documentation
- `00_SYSTEM_Vision.md` - Core vision and philosophy of SDD
- `01_SYSTEM_How_It_Works.md` - Detailed assembly line workflow model
- `02_SYSTEM_Specification_Hierarchy.md` - Document hierarchy from vision to tasks
- `03_SYSTEM_Greenfield_Workflow.md` - New project initialization process
- `04_SYSTEM_Brownfield_Workflow.md` - Existing project adoption process

### Main Implementation
- `project_sdd_on_claude/` - Complete example of SDD applied to building the SDD system itself on Claude Code platform
- `0_Project_Vision.md` - Vision for implementing SDD on Claude Code
- `1_Product_Requirements.md` - Functional and non-functional requirements
- `2_Architecture.md` - Technical architecture using Claude Code's native features (slash commands, sub-agents, hooks)
- `3_Roadmap.md` - Phased delivery plan with milestones

### Templates
- `specs/templates/` - Standardized templates for all specification documents
- Templates include Project Vision, Product Requirements, Architecture, Roadmap, Milestone Plans, and Task Blueprints

## Key Concepts

### Specification Hierarchy
1. **Project Vision** - The "why" and strategic goals
2. **Product Requirements** - Functional and non-functional requirements  
3. **Architecture** - Technical strategy and constraints
4. **Roadmap** - Phased delivery timeline
5. **Milestone Plans** - Detailed tactical plans with vertical slices
6. **Task Blueprints** - Atomic units of work with testable contracts

### Task Workflow
Each task follows a strict assembly line process:
1. **Bundle Creation** - Research and context gathering
2. **Security Analysis** - Proactive security guidance
3. **Implementation** - TDD-based code development
4. **Validation** - Comprehensive quality checks
5. **Commit or Halt** - Only validated work is committed

### Claude Code Integration
The architecture leverages Claude Code's native features:
- **Slash Commands** (`/task`, `/milestone`, `/init_greenfield`) for workflow orchestration
- **Sub-agents** for specialized tasks with clean contexts
- **Hooks** for observability and logging (not workflow control)
- **File-based state** with no external dependencies

## Working with This Repository

### Documentation Evolution
- **Vision documents** are nearly immutable (only change for strategic pivots)
- **Architecture** evolves slowly with Architecture Decision Records (ADRs)
- **Requirements** are living documents updated through roadmap reviews
- **Templates** should be updated to reflect methodology improvements

### When Adding Content
- Follow the established document templates in `specs/templates/`
- Maintain the specification hierarchy (changes flow top-down)
- Use Mermaid diagrams for visualizing workflows and architecture
- Include concrete examples rather than abstract descriptions

### File Naming Conventions
- System docs: `NN_SYSTEM_Topic.md`
- Templates: `N_Type_Template.md` 
- Project examples: Match template naming without `_Template` suffix

## No Build/Test Commands

This repository contains no executable code. All "development" work involves:
- Editing Markdown specification documents
- Updating templates based on methodology improvements
- Maintaining consistency across the specification hierarchy
- Ensuring examples demonstrate the methodology effectively