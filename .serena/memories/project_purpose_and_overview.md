# Project Purpose and Overview

## What is SDD (Spec-Driven Development)?

SDD is a **specification-only repository** for a methodology framework for AI-assisted software development. This repository contains **no source code to build or test** - only documentation, templates, and specification examples.

## Core Purpose
- Create a specification-driven development model to achieve semi-automated coding with LLMs
- Preserve quality and security through formal specifications
- Orchestrate human architects and AI agents in an "Assembly Line" model

## Key Components
- **Human Architect**: Defines strategic vision and requirements
- **Supervisor Agent**: Orchestrates task execution workflows  
- **Bundler Agent**: Performs research and context preparation to prevent hallucination
- **Security Consultant Agent**: Provides proactive security guidance
- **Coder Agent**: Implements code following TDD principles
- **Validator Agent**: Ensures quality through comprehensive testing

## Architecture Integration
The system leverages Claude Code's native features:
- **Templates** (`~/.sdd/templates/`) - Global specification templates
- **Commands** (`~/.claude/commands/`) - SDD slash commands  
- **Agents** (`~/.claude/agents/`) - Specialized sub-agents
- **File-based State** - No external dependencies or APIs

## Key Repository Characteristics
- This is a **specification-only repository** - no executable code
- Main purpose is methodology documentation and template distribution
- Installation scripts deploy templates and Claude Code integrations
- Example project shows SDD applied to building itself on Claude Code platform