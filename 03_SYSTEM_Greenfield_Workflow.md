# Greenfield Project Initialization Workflow

This document outlines the collaborative process between a Human Architect and the AI Orchestrator for initiating a new "greenfield" project from scratch. The workflow is designed to be a flexible, Socratic dialogue that transforms a high-level idea into a robust set of initial specifications.

The core principle is to move from an informal "brain dump" to formal, structured documents through a guided, interactive process, ensuring clarity and alignment before any development work begins.

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

### Phase 3: Synthesis & First Draft

Once the Socratic dialogue has yielded sufficient clarity, the AI Orchestrator synthesizes the entire conversation—the initial briefing plus the clarifications—into a set of formal specification documents.

-   **AI Orchestrator's Role**: To generate the first drafts of the initial project documents, typically:
    1.  `0_Project_Vision.md`
    2.  `1_Product_Requirements.md`
    The AI will explicitly map statements from the conversation to the sections of these documents, providing traceability.
-   **Human Architect's Role**: To wait for the AI to produce the initial drafts.

### Phase 4: Guided Review & Refinement

The final phase is a collaborative review of the drafted documents. The AI guides the Human Architect through each document, section by section, to ensure it accurately reflects the agreed-upon vision and requirements.

-   **AI Orchestrator's Role**: To present the documents and facilitate the review. It might ask, *"Does this 'Key Features' list accurately capture the core functionality we discussed?"* or *"Is the 'Success Metrics' section aligned with your definition of success?"*
-   **Human Architect's Role**: To review, request changes, and provide final approval on the documents. This is an iterative loop of feedback and refinement until the documents are deemed a solid foundation for the next steps (Architecture and Roadmap).

## Outcome

The successful completion of this workflow results in a set of approved, foundational specification documents (`0_Project_Vision.md` and `1_Product_Requirements.md`) that are deeply aligned with the Human Architect's intent. This robust starting point minimizes ambiguity and provides a clear mandate for the subsequent phases of the Spec-Driven Development process.