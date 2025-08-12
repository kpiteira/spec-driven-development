# How It Works: The Spec-Driven Development "Assembly Line" Model

(A checkpoint in our ongoing brainstorming)

## 1. Executive Summary

This document outlines a Spec-Driven Development (SDD) model designed to address the core challenges of working with Large Language Models (LLMs), namely context degradation, loss of focus, and non-adherence to architectural principles. It also aims to enforce development best practices that human developers often forget.

The proposed solution is an **"Assembly Line" model** that coordinates specialized AI agents with the Human Architect. The Main Agent orchestrates a series of specialist agents, each with clean context isolation and domain expertise. The Human Architect provides strategic guidance while specialist agents handle document creation and analysis through natural language understanding. Tasks move through the assembly line, with each specialist agent performing specific functions (research, security analysis, coding, validation) based on comprehensive context bundles. This approach enables high automation while ensuring every stage maintains focus and strict adherence to project specifications.

## 2. The "Assembly Line" Model: A High-Level Overview

The entire workflow is modeled on a manufacturing assembly line, where a product moves from one specialized station to the next. This ensures separation of concerns and prevents context from one stage from "bleeding" into the next.

The key components of this model are:

* **The Human Architect:** The developer who defines the project's strategic plans. Their primary role is to define the **contract** for each piece of work: the "why" (the goal) and the "what" (the testable requirements).
* **The Strategic & Quality Plans:** High-level documents that define goals, the sequence of milestones, and project-wide quality standards.
* **The Task Blueprints:** A collection of Markdown files, each defining the contract for a single, atomic task.
* **The Supervisor Agent (Master Orchestrator):** An autonomous agent that reads a `Milestone Plan` and executes its Vertical Slices in sequence.
* **The Specialist Agents:** Domain experts with clean contexts who create documents and provide analysis using natural language understanding. The specialist agents include:
  * **Requirements Specialist:** Analyzes vision documents and researches domain patterns to create comprehensive product requirements
  * **Architecture Specialist:** Transforms requirements into technical architecture through research-driven decision making
  * **Roadmap Specialist:** Creates strategic delivery plans with milestone sequencing and vertical slice methodology  
  * **Milestone Planning Specialist:** Converts roadmap milestones into detailed tactical plans with task breakdowns
  * **Task Blueprint Specialist:** Creates atomic, executable task specifications with clear contracts
  * **Bundler Specialist:** Research specialist that gathers context through semantic codebase analysis and document comprehension
  * **Coder Specialist:** Implementation specialist using TDD principles and document understanding to generate compliant code
  * **Validator Specialist:** Quality assurance specialist using comprehensive testing and validation approaches
* **The Task Bundle:** A temporary, self-contained **directory** created for a single task. It acts as a clean workspace, containing the original Task Blueprint and all the rich context (in separate files) that an agent needs for its job.

## 3. Detailed Workflow: From a Single Task to an Autonomous Milestone

The system is designed to be triggered at multiple levels of abstraction. The fundamental process is the lifecycle of a single task, which can be initiated manually by a developer. The autonomous execution of a milestone is a higher-level loop that programmatically initiates this same task lifecycle for a sequence of tasks.

### 3.1 The Core Process: The Life of a Single Task

This is the fundamental, repeatable building block of all work done in the system. It describes the journey of one task from `pending` to `done` with a rich, detailed process at each step.

1. **Initiation:** The process is triggered for a single task. The Main Agent creates a temporary directory for the Task Bundle (e.g., `.task_bundles/TASK-123/`) and copies the original `Task_Blueprint.md` into it.

2. **Context Preparation (Bundler Specialist):** The **Bundler Specialist** analyzes the task blueprint and performs comprehensive research to build complete, actionable context for implementation.
    * **Architectural Analysis:** Reads and understands the specific, relevant rules from `specs/Architecture.md` that must be followed for this task.
    * **Codebase Intelligence & Interface Analysis:** Performs semantic analysis to identify relevant internal code (functions, classes, API clients). Uses natural language understanding to comprehend exact signatures, arguments, and documentation for existing code, preventing implementation confusion about existing codebase interfaces.
    * **External Knowledge Integration:** Researches relevant API documentation, function signatures, and usage examples for third-party libraries required by the task, ensuring correct implementation approaches.
    * **Context Assembly:** Creates well-structured context files (e.g., `bundle_architecture.md`, `bundle_code_context.md`) within the Task Bundle, providing comprehensive, task-specific guidance.

3. **Implementation (Coder Specialist):** The **Coder Specialist** reads and comprehends the Task Blueprint and all context bundle files to inform implementation.
    * First, analyzes requirements and devises a step-by-step implementation plan.
    * Then, following Test-Driven Development (TDD), writes failing unit tests that reflect the task's contract.
    * Finally, implements code required to make the tests pass, adhering to architectural guidance.

4. **Verification (Validator Specialist):** Once implementation is complete, the **Validator Specialist** performs comprehensive quality verification.
    * **Test Plan Assembly:** Reads and understands the `Verification Context` from the Task Blueprint, integration tests from the Milestone Plan, and project-wide checks from the Architecture document to build a comprehensive validation approach.
    * **Quality Verification:** Runs all relevant checks, including linting, security scanning, unit tests, and integration tests using established project tooling.
    * Reports a single `pass` or `fail` verdict. A failure in *any* verification step results in an overall `fail`.

6. **Completion or Halt:**
    * **On Success:** If the Validator reports a `pass`, the work is automatically committed with a standardized message, and the temporary Task Bundle is deleted. The task is now complete.
    * **On Failure:** If the Validator reports a `fail`, the process halts immediately, providing a precise report of which check failed (e.g., linter error, security vulnerability, or failing test). This prevents flawed code from being committed.

### 3.2 The Autonomous Driver: The Life of a Milestone

(This section remains the same, as it invokes the detailed core process above)

## 4. Appendix: Example Artifacts

### Quality & Security Configuration (Architecture-Based)

Project-level tooling standards are now defined in Section 4 ("Development Tooling and Quality Standards") of the `2_Architecture.md` file. This architecture-based approach allows for flexible, project-specific tooling configuration instead of hard-coded tool assumptions.

**Example Architecture Section:**
```markdown
### Development Tooling by Component
#### Backend (Python)
* **Package Management**: uv (not pip or poetry) for faster dependency resolution  
* **Testing**: pytest with coverage reporting, appropriate test discovery and options
* **Linting**: ruff for both linting and formatting (replaces flake8, black, isort)
* **Type Checking**: mypy with strict configuration for production code quality
```

## 5. Human Architect + AI Agent Collaboration Model

The SDD methodology relies on clear persona distinctions and vocabulary standards to ensure effective collaboration between Human Architects and AI specialist agents.

### Persona-Aware Design

**Human Architect Role**: Provides strategic vision, makes final decisions on specifications, and approves phase transitions. The Human Architect focuses on the "what" and "why" while delegating the "how" to appropriate specialist agents.

**Main Agent Role**: Facilitates conversation with the Human Architect and coordinates specialist agent invocation. The Main Agent does NOT create documents except through conversational vision development.

**Specialist Agent Role**: Domain experts who read and understand documents using natural language comprehension, perform research, and create comprehensive specifications within their area of expertise.

### Communication Standards

All SDD documentation maintains clear persona distinctions:
- Specify which persona (Human Architect or specific specialist) performs each action
- Use document comprehension language for AI agents rather than programmatic parsing language  
- Distinguish between strategic work (Human Architect) and implementation work (specialists)
- Maintain clean context isolation between specialist domains

### Implementation Guidance

When specialist agents encounter instructions to "parse documents" or "extract information," they should interpret this as reading and understanding documents using natural language comprehension, not building programmatic parsers or extraction systems. The SDD methodology leverages AI agents' natural language understanding capabilities rather than traditional software approaches.
