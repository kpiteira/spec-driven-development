# How It Works: The Spec-Driven Development "Assembly Line" Model

(A checkpoint in our ongoing brainstorming)

## 1. Executive Summary

This document outlines a Spec-Driven Development (SDD) model designed to address the core challenges of working with Large Language Models (LLMs), namely context degradation, loss of focus, and non-adherence to architectural principles. It also aims to enforce development best practices that human developers often forget.

The proposed solution is an **"Assembly Line" model** orchestrated by a **Supervisor Agent**. This system manages a series of specialized, single-purpose sub-agents, each with a fresh, clean context. The Supervisor can execute high-level plans by breaking the work down into individual tasks. A task moves through the assembly line, with each sub-agent performing a specific function (e.g., research, security analysis, coding, validation) based on a rich, dynamically generated **"Task Bundle."** This approach enables a high degree of automation while ensuring that every stage of the development process is performed with maximum focus and strict adherence to the project's quality, security, and architectural specifications.

## 2. The "Assembly Line" Model: A High-Level Overview

The entire workflow is modeled on a manufacturing assembly line, where a product moves from one specialized station to the next. This ensures separation of concerns and prevents context from one stage from "bleeding" into the next.

The key components of this model are:

* **The Human Architect:** The developer who defines the project's strategic plans. Their primary role is to define the **contract** for each piece of work: the "why" (the goal) and the "what" (the testable requirements).
* **The Strategic & Quality Plans:** High-level documents that define goals, the sequence of milestones, and project-wide quality standards.
* **The Task Blueprints:** A collection of Markdown files, each defining the contract for a single, atomic task.
* **The Supervisor Agent (Master Orchestrator):** An autonomous agent that reads a `Milestone Plan` and executes its Vertical Slices in sequence.
* **The Sub-Agents:** These are ephemeral, single-purpose agents, each designed to perform one job perfectly and then terminate. The primary agents are:
  * **The Bundler Agent:** A specialized research agent. Its primary purpose is to prevent context loss and LLM hallucination by providing the `Coder Agent` with a precise, task-specific "ground truth" of all relevant interfaces, APIs, and architectural rules.
  * **The Security Consultant Agent:** The specialist. It analyzes the task's goal and provides proactive security guidance.
  * **The Coder Agent:** The planner and implementer. It receives the enriched bundle, devises its own implementation plan, and then writes the code and unit tests to fulfill the task's contract.
  * **The Validator Agent:** The quality engineer. It assembles a comprehensive test plan from multiple sources and verifies the completed work.
* **The Task Bundle:** A temporary, self-contained **directory** created for a single task. It acts as a clean workspace, containing the original Task Blueprint and all the rich context (in separate files) that an agent needs for its job.

## 3. Detailed Workflow: From a Single Task to an Autonomous Milestone

The system is designed to be triggered at multiple levels of abstraction. The fundamental process is the lifecycle of a single task, which can be initiated manually by a developer. The autonomous execution of a milestone is a higher-level loop that programmatically initiates this same task lifecycle for a sequence of tasks.

### 3.1 The Core Process: The Life of a Single Task

This is the fundamental, repeatable building block of all work done in the system. It describes the journey of one task from `pending` to `done` with a rich, detailed process at each step.

1. **Initiation:** The process is triggered for a single task. The Supervisor Agent creates a temporary directory for the Task Bundle (e.g., `.task_bundles/TASK-123/`) and copies the original `Task_Blueprint.md` into it.

2. **Bundle Creation (The Bundler Agent):** A fresh **Bundler Agent** is spawned with the path to the Task Bundle directory. Its goal is to perform comprehensive research to build a complete, actionable context for the `Coder Agent`.
    * **Architectural Analysis:** It extracts the specific, relevant rules from `specs/Architecture.md` that the `Coder Agent` must follow for this task.
    * **Codebase Intelligence & Interface Extraction:** This is its most critical function. It performs a semantic search to find relevant internal code (functions, classes, API clients). It then extracts the **exact signatures, arguments, and documentation** for this code. This prevents the `Coder Agent` from inventing or "hallucinating" incorrect ways to interact with the existing codebase.
    * **External Knowledge Integration:** It fetches the relevant API documentation, function signatures, and usage examples for any third-party libraries required by the task, ensuring the `Coder Agent` uses them correctly.
    * **Assembly:** It assembles this intelligence into a series of well-structured context files (e.g., `bundle_architecture.md`, `bundle_code_context.md`) within the Task Bundle, providing the `Coder Agent` with a precise, task-specific API reference.

3. **Security Enrichment (The Security Consultant Agent):** A fresh **Security Consultant Agent** is spawned.
    * **Guidance Injection:** It adds a `bundle_security.md` file to the Task Bundle with specific, actionable advice.

4. **Implementation (The Coder Agent):** The **Coder Agent** is engaged with the path to the fully populated Task Bundle directory. It reads the `Task_Blueprint.md` and all `bundle_*.md` files to inform its work.
    * First, it devises its own step-by-step implementation plan.
    * Then, following Test-Driven Development (TDD), it writes failing unit tests that reflect the task's contract.
    * Finally, it writes the code required to make the tests pass, adhering to all guidance.

5. **Verification (The Validator Agent):** Once the implementation is complete, a fresh **Validator Agent** is spawned.
    * **Test Plan Assembly:** It reads the `Verification Context` from the `Task Blueprint`, the integration tests from the `Milestone Plan`, and the project-wide checks from the "Development Tooling and Quality Standards" section of `2_Architecture.md` to build a comprehensive test plan.
    * **Execution:** It runs all relevant checks, including linting, security scanning, unit tests, and integration tests.
    * The Validator reports a single `pass` or `fail` verdict. A failure in *any* of these steps results in an overall `fail`.

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

### Example Task Blueprint (`specs/tasks/TASK-042_...md`)

The example task blueprint in this document is obsolete and inconsistent with the current model. The definitive template is located at `specs/templates/Task_Blueprint_Template.md`.

*(This entire example section should be removed to prevent confusion).*
