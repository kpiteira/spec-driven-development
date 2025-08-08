# Brownfield Project Onboarding Workflow

This document outlines the validated hybrid process for integrating an existing "brownfield" project into the Spec-Driven Development (SDD) methodology. The workflow combines Main Agent codebase analysis and conversational guidance with specialized Sub-Agent research-driven specification generation. The primary goal is to analyze the current state of the codebase, synthesize a set of "as-is" specifications, and then collaborate with the Human Architect to define the future direction using the same hybrid approach proven successful for greenfield projects.

## The Four Phases of Onboarding

### Phase 1: Codebase Discovery

The process begins with the AI Orchestrator performing a comprehensive, automated analysis of the existing codebase.

-   **Human Architect's Role**: To provide the AI with access to the project repository and identify the primary branch for analysis.
-   **AI Orchestrator's Role**: To ingest and analyze the codebase, focusing on:
    -   **Structure & Dependencies**: Mapping the file structure, identifying key modules, and analyzing dependency manifests (`package.json`, `pom.xml`, etc.).
    -   **Code Analysis**: Identifying languages, frameworks, common patterns, and code quality metrics (e.g., complexity, duplication).
    -   **Test Coverage**: Analyzing existing test suites to gauge coverage and identify untested areas.
    -   **Documentation**: Parsing any existing `README` files, wikis, or other documentation.

### Phase 2: Synthesis & "As-Is" Report

The AI synthesizes its findings into a concise report that serves as a snapshot of the project's current state. This report is the foundation for the clarification dialogue.

-   **AI Orchestrator's Role**: To generate a summary report containing its initial findings on architecture, dependencies, and potential areas of interest or concern.
-   **Human Architect's Role**: To review the "As-Is" report to confirm its high-level accuracy and prepare for the clarification phase.

### Phase 3: Socratic Clarification

This is the key collaborative phase. Using the "As-Is" Report as context, the AI engages the Human Architect in a Socratic dialogue to bridge the gap between what the code *is* and what the business *requires*. The questions are targeted to uncover implicit knowledge and strategic goals.

-   **AI Orchestrator's Role**: To ask targeted questions based on its analysis. The questions fall into several categories:

    **1. To Understand Business Purpose & Domain Logic:**
    *   *"Based on my analysis, the application seems to be an e-commerce platform. Is that correct? What are the core business goals?"*
    *   *"I see modules for `invoicing`, `shipping`, and `inventory`. Can you walk me through a typical user journey that involves these three modules?"*
    *   *"Who are the primary users of this system? Are there different user roles with different permissions?"*

    **2. To Validate Architectural Assumptions:**
    *   *"I've detected a REST API and a GraphQL endpoint. Are both actively used? Is there a preferred pattern for new features?"*
    *   *"The system connects to a PostgreSQL database and a Redis cache. What is the caching strategy? What kind of data is stored in Redis?"*
    *   *"Configuration appears to be handled by environment variables. Are there any other sources of configuration I should be aware of?"*

    **3. To Identify Pain Points & Technical Debt:**
    *   *"The test coverage for the `payment_processing` module is lower than other areas. Is this a known concern, and is improving it a priority?"*
    *   *"I've noticed several large, complex classes in the `legacy` directory. Are there plans to refactor these, or should they be treated as a black box?"*
    *   *"The build and deployment process seems to involve several manual steps. Is automating this part of our current scope?"*

    **4. To Define Future Goals & Scope:**
    *   *"What is the primary objective for this next phase of work? (e.g., build a new feature, improve performance, migrate to a new framework)."*
    *   *"What does success for this project look like in the next quarter?"*
    *   *"Are we aiming to create a full set of specifications from scratch, or to evolve the existing (or non-existent) ones based on our conversation?"*

-   **Human Architect's Role**: To answer the AI's questions, providing the essential context that isn't present in the code itself.

### Phase 4: Hybrid Specification Generation

Armed with both the code analysis and the human's strategic input, the workflow uses the validated hybrid approach combining Main Agent conversation with specialized Sub-Agent research and generation.

-   **Main AI Agent's Role**: 
    1.  **Vision Generation**: Generate `0_Project_Vision.md` directly through continued conversation with the Human Architect, using the accumulated context from codebase analysis and strategic discussions. The existing codebase provides concrete context for vision refinement.
    
-   **Sub-Agent Coordination**: After vision completion, coordinate specialized sub-agents with clean contexts:
    2.  **Requirements Sub-Agent**: Invoked with clean context containing approved vision, existing codebase analysis, SDD requirements methodology, templates, and web research capabilities to generate `1_Product_Requirements.md` plus numbered strategic questions for specification gaps.
    3.  **Architecture Sub-Agent**: Invoked with clean context containing vision, requirements, existing codebase architecture patterns, SDD architecture methodology, templates, and web research capabilities to generate updated `2_Architecture.md` plus numbered strategic questions.
    4.  **Roadmap Sub-Agent**: Invoked with clean context containing all prior specifications, existing codebase state, SDD roadmap methodology, templates, and web research capabilities to generate `3_Roadmap.md` plus numbered strategic questions.
    
    Each sub-agent leverages the existing codebase analysis while performing additional research, ensuring research-driven specifications that build on current system understanding.
    
-   **Human Architect's Role**: To engage with the Main Agent for vision creation, then review sub-agent outputs and answer their strategic questions, ensuring specifications align the existing codebase with new business goals.

## Outcome

The result of this workflow is a shared, deep understanding of the project, captured in a set of clear, actionable specification documents generated through the validated hybrid approach. The Main Agent's conversational guidance ensures context preservation from codebase analysis, while specialized Sub-Agents provide research-driven, high-quality specifications with clean contexts. This process transforms an existing codebase from a static artifact into a living project aligned with the SDD methodology, ready for structured, predictable development with comprehensive specifications that bridge current system understanding and future strategic direction.