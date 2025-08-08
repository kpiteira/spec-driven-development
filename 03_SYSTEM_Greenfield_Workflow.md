# Greenfield Project Initialization Workflow

This document outlines the validated hybrid process between a Human Architect, the Main AI Agent, and specialized Sub-Agents for initiating a new "greenfield" project from scratch. The workflow combines conversational guidance (Main Agent) with research-intensive specification generation (Sub-Agents) to transform a high-level idea into a robust set of initial specifications.

The core principle is to move from an informal "brain dump" to formal, structured documents through a guided, interactive process that leverages both conversational context-building and clean-context research-driven generation, ensuring clarity and alignment before any development work begins.

## The Four Phases of Initialization

The workflow is divided into four distinct, sequential phases.

### Phase 1: Open-Ended Briefing

The process begins with the Human Architect providing an open-ended, free-form description of the project. This can be anything from a single sentence to a multi-page document.

-   **Human Architect's Role**: To articulate the initial vision, goals, target users, and any known constraints or requirements. The focus is on conveying the core idea without worrying about structure or completeness.
-   **AI Orchestrator's Role**: To listen and parse the initial input, identifying key concepts, potential ambiguities, and areas that require deeper exploration.

### Phase 2: Socratic Clarification

This is the most critical phase. Instead of immediately generating documents, the AI Orchestrator engages the Human Architect in a Socratic dialogue. It asks probing, open-ended questions to challenge assumptions, uncover hidden requirements, and refine the project's scope.

-   **AI Orchestrator's Role**: To act as a thinking partner. It will ask questions like:
    -   *"You mentioned a 'user-friendly interface.' What does 'user-friendly' mean in the context of your target audience (e.g., novices, power users)?"*
    -   *"What is the single most important problem this project solves for its users?"*
    -   *"How will we measure the success of this project once it's launched?"*
    -   *"Are there any specific technologies we must use or avoid? Why?"*
-   **Human Architect's Role**: To engage with the questions, think critically about the project, and provide clearer, more detailed answers. This dialogue enriches the shared understanding of the project.

### Phase 3: Hybrid Document Generation

Once the Socratic dialogue has yielded sufficient clarity, the workflow uses a validated hybrid approach combining Main Agent conversation with specialized Sub-Agent research and generation.

-   **Main AI Agent's Role**: 
    1.  **Vision Generation**: Generate `0_Project_Vision.md` directly through continued conversation with the Human Architect, using the accumulated context and SDD vision methodology. No sub-agent needed as this is conversational work that provides essential context for subsequent sub-agents.
    
-   **Sub-Agent Coordination**: After vision completion, coordinate specialized sub-agents with clean contexts:
    2.  **Requirements Sub-Agent**: Invoked with clean context containing approved vision, SDD requirements methodology, templates, and web research capabilities to generate `1_Product_Requirements.md` plus numbered strategic questions for specification gaps.
    3.  **Architecture Sub-Agent**: Invoked with clean context containing vision, requirements, SDD architecture methodology, templates, and web research capabilities to generate `2_Architecture.md` plus numbered strategic questions.
    4.  **Roadmap Sub-Agent**: Invoked with clean context containing all prior specifications, SDD roadmap methodology, templates, and web research capabilities to generate `3_Roadmap.md` plus numbered strategic questions.
    
    Each sub-agent performs extensive research and receives only the specifications needed for their work, preventing context pollution while ensuring research-driven, high-quality outputs.
    
-   **Human Architect's Role**: To engage with the Main Agent for vision creation, then review sub-agent outputs and answer their strategic questions.

### Phase 4: Guided Review & Sub-Agent Refinement

The final phase is a collaborative review of the sub-agent generated documents. The AI Orchestrator facilitates review while leveraging sub-agents for refinements when needed.

-   **AI Orchestrator's Role**: To present the sub-agent generated documents and facilitate the review. For each document, it presents both the content and the sub-agent's self-review findings. When refinements are needed, it re-invokes the appropriate specialist sub-agent with updated context and specific feedback to generate improved versions. The orchestrator asks strategic questions like *"Does this 'Key Features' list accurately capture the core functionality we discussed?"* or *"Is the 'Success Metrics' section aligned with your definition of success?"*
-   **Human Architect's Role**: To review, request changes, and provide final approval on the documents. This is an iterative loop of feedback and refinement, with the AI Orchestrator coordinating specialized sub-agents for any needed revisions until the documents are deemed a solid foundation for development.

## Outcome

The successful completion of this workflow results in a complete set of approved, foundational specification documents (`0_Project_Vision.md`, `1_Product_Requirements.md`, `2_Architecture.md`, and `3_Roadmap.md`) that are deeply aligned with the Human Architect's intent. These documents are generated by specialized sub-agents working with clean, focused contexts, ensuring high quality and consistency while preventing context pollution. This robust starting point minimizes ambiguity and provides a comprehensive mandate for the subsequent implementation phases of the Spec-Driven Development process.