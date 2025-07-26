# How It Works: The Spec-Driven Development "Assembly Line" Model

(A checkpoint in our ongoing brainstorming)

## 1. Executive Summary

This document outlines a Spec-Driven Development (SDD) model designed to address the core challenges of working with Large Language Models (LLMs), namely context degradation, loss of focus, and non-adherence to architectural principles. It also aims to enforce development best practices that human developers often forget.

The proposed solution is an **"Assembly Line" model** orchestrated by a **Supervisor Agent**. This system manages a series of specialized, single-purpose sub-agents, each with a fresh, clean context. The Supervisor can execute high-level plans by breaking the work down into individual tasks. A task moves through the assembly line, with each sub-agent performing a specific function (e.g., research, security analysis, coding, validation) based on a rich, dynamically generated **"Task Bundle."** This approach enables a high degree of automation while ensuring that every stage of the development process is performed with maximum focus and strict adherence to the project's quality, security, and architectural specifications.

## 2. The "Assembly Line" Model: A High-Level Overview

The entire workflow is modeled on a manufacturing assembly line, where a product moves from one specialized station to the next. This ensures separation of concerns and prevents context from one stage from "bleeding" into the next.

The key components of this model are:

* **The Human Architect:** The developer who defines the project's strategic plans—the vision, requirements, architecture, and milestones. Their primary role is high-level direction and intervention when required.
* **The Strategic & Quality Plans:** High-level documents that define goals like an MVP, the ordered list of tasks to achieve them, and the project-wide standards for code quality and security.
* **The Task Blueprints:** A collection of Markdown files, each defining a single, discrete unit of work. They contain the "why" (functional goals) and the "what" (acceptance criteria).
* **The Supervisor Agent (Master Orchestrator):** An autonomous agent that reads the Strategic Plans and manages the end-to-end execution of a milestone. It iterates through tasks and spawns the appropriate sub-agents for each one.
* **The Sub-Agents:** These are ephemeral, single-purpose agents, each designed to perform one job perfectly and then terminate. The primary agents are:
  * **The Bundler Agent:** The researcher. It gathers functional and architectural context to build the initial Task Bundle.
  * **The Security Consultant Agent:** The specialist. It analyzes the bundle to identify potential security risks and provides proactive guidance.
  * **The Coder Agent:** The implementer (the interactive session between the developer and their LLM assistant). It uses the enriched bundle to write code and tests.
  * **The Validator Agent:** The quality inspector. It runs a comprehensive suite of tests, linters, and scanners to verify the completed work.
* **The Task Bundle:** A temporary, self-contained collection of files within a git-ignored directory. It contains all the rich context—rules, security advice, existing code snippets, and verification plans—that an agent needs for its specific job.

## 3. Detailed Workflow: From a Single Task to an Autonomous Milestone

The system is designed to be triggered at multiple levels of abstraction. The fundamental process is the lifecycle of a single task, which can be initiated manually by a developer. The autonomous execution of a milestone is a higher-level loop that programmatically initiates this same task lifecycle for a sequence of tasks.

### 3.1 The Core Process: The Life of a Single Task

This is the fundamental, repeatable building block of all work done in the system. It describes the journey of one task from `pending` to `done` with a rich, detailed process at each step.

1. **Initiation:** The process is triggered for a single task. The system first runs any `pre-start` checks from the Verification Plan to ensure the codebase is in a stable state.

2. **Bundle Creation (The Bundler Agent):** A fresh **Bundler Agent** is spawned. It reads the task's blueprint and performs a comprehensive research phase:
    * **Architectural Analysis:** It parses high-level specification files (e.g., `Project.toml`, `specs/architecture.md`) to find and extract the specific architectural rules and constraints relevant to the task at hand.
    * **Codebase Intelligence:** It performs a **semantic search** across the entire codebase using the task's title and description as a query. Its goal is to find existing functions, classes, API clients, or utility methods that the Coder Agent should reuse or be aware of, preventing feature re-implementation.
    * **External Knowledge Integration:** It has the capability to query external information sources. For example, if the task involves a specific third-party library, the Bundler could use a tool (like the `context7` you mentioned) to fetch the relevant API definitions or documentation snippets to include in the bundle.
    * **Assembly:** It assembles all of this gathered intelligence—architectural rules, relevant code snippets, and external documentation—into an initial `task_context.md` file and then terminates.

3. **Security Enrichment (The Security Consultant Agent):** A fresh **Security Consultant Agent** is spawned.
    * **Threat Modeling:** With a security-focused system prompt, it analyzes the initial Task Bundle to identify potential vulnerabilities (e.g., tasks involving user input, database access, or authentication).
    * **Guidance Injection:** It appends a `## Security Considerations` section to the `task_context.md` file, providing specific, actionable advice (e.g., "Ensure all user input is sanitized to prevent XSS"). It then terminates.

4. **Implementation (The Coder Agent):** The **Coder Agent** is engaged with the fully enriched Task Bundle. The development process is expected to follow a Test-Driven Development (TDD) flow:
    * First, write a new, failing test case that reflects the task's acceptance criteria.
    * Then, write the feature code required to make that test pass, while adhering to all architectural and security guidance in the bundle.

5. **Verification (The Validator Agent):** Once the implementation is believed to be complete, a fresh **Validator Agent** is spawned to act as an automated quality gate. It executes a comprehensive, multi-step verification process defined in a project-level quality configuration file:
    * **Code Formatting & Linting:** Runs tools like `Black` or `ESLint` to ensure code style consistency.
    * **Static Analysis:** Runs type checkers like `MyPy` or `TypeScript` to catch type-related errors.
    * **Security Scanning:** Runs automated security scanners like `Bandit` to check for common vulnerabilities.
    * **Automated Testing:** Runs the relevant unit, integration, and feature tests as defined in the `Verification Plan`.
    * The Validator reports a single `pass` or `fail` verdict. A failure in *any* of these steps results in an overall `fail`.

6. **Completion or Halt:**
    * **On Success:** If the Validator reports a `pass`, the work is automatically committed with a standardized message, and the temporary Task Bundle is deleted. The task is now complete.
    * **On Failure:** If the Validator reports a `fail`, the process halts immediately, providing a precise report of which check failed (e.g., linter error, security vulnerability, or failing test). This prevents flawed code from being committed.

### 3.2 The Autonomous Driver: The Life of a Milestone

(This section remains the same, as it invokes the detailed core process above)

## 4. Appendix: Example Artifacts

### Quality & Security Configuration (`quality.toml`)

This project-level file defines the commands for the Validator Agent.

```toml
[quality_checks]
linter = "black --check ."
type_checker = "mypy src/"
security_scanner = "bandit -r src/ -ll"
test_runner = "pytest"
```

### Example Task Blueprint (`specs/tasks/TASK-042_...md`)

````markdown
---
id: TASK-042
title: "Add `last_login` field to User model"
requirement_id: "REQ-007"
status: "pending"
branch: "feature/TASK-042-user-last-login"
relevant_tests:
  - "tests/test_auth.py"
---

## 1. Goal
As an admin, I want to see when a user last logged in so that I can monitor
activity.

## 2. Functional Acceptance Criteria
*   [ ] When a user successfully logs in, their `last_login` time is recorded.
*   [ ] The `last_login` time must be stored in UTC.

## 3. Implementation Plan
1.  Write a failing test for this functionality.
2.  Update the `User` data model.
3.  Create a database migration.
4.  Update the `login` service logic.
5.  Ensure all tests pass.

## 4. Verification Plan
```guardian
[
  {
    "description": "Run relevant tests to ensure a stable baseline.",
    "stage": "pre-start",
    "command": "pytest tests/test_auth.py",
    "expects": "pass"
  },
  {
    "description": "All relevant tests must pass after implementation.",
    "stage": "final-submit",
    "command": "pytest tests/test_auth.py",
    "expects": "pass"
  }
]
```

## 5. Architectural Constraints
*   **Data Models:** All SQLAlchemy models must be defined in `src/models/`.
*   **Database Migrations:** All schema changes must be accompanied by an Alembic
    migration.

## 6. Security Considerations
*   **SQL Injection:** This task involves database queries. Ensure all access is
    through the ORM or parameterized queries. Do not use string formatting to build
    SQL statements.
*   **Data Validation:** The `last_login` field should be a valid datetime. Ensure
    type validation is handled.

## 7. Relevant Existing Code
**`src/models/user.py`:**
```python
class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True)
    email = Column(String, unique=True, index=True)
```
`````
