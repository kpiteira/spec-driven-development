---
version: "1.0.0"
template_type: "Task Blueprint"
description: "Template for atomic task definition with testable contracts"
id: TASK-XXX
title: "[A clear, descriptive title for the task]"
milestone_id: "M1-MVP"
requirement_id: "REQ-001"
slice: "Slice 1: User Signup Flow"
status: "pending"
branch: "feature/TASK-XXX-[short-description]"
---

## 1. Task Overview & Goal

**What it is:** A clear, narrative description of the task's purpose, its place within the larger feature slice, and why it's important. This provides the essential "why" for the agents.
**Source:** Defined by the Human Architect.

**Example:**
> **Goal:** This task is to create a secure API endpoint for registering a new user in the system.
>
> **Context:** This is the first and most critical step in the "User Signup Flow" slice. Without this endpoint, no user can create an account. This endpoint must be robust and secure, as it's a public-facing entry point into our system. It will receive user credentials, validate them, and create a new record in the `users` database table.

---

## 2. The Contract: Requirements & Test Cases

**What it is:** The specific, testable requirements for this single component. This section is the **contract** that the `Coder Agent` must fulfill. It defines what "done" looks like and serves as the primary input for writing unit tests.
**Source:** Defined by the Human Architect.

**Example:**

* **Behavior 1: Successful Registration**
  * **Given:** A request is made with a unique email and a valid, strong password.
  * **When:** The endpoint is called.
  * **Then:** It should return a `201 Created` status code.
  * **And:** The response body should contain the new user's `id` and `email`.
  * **And:** A new user record must be created in the database with a properly hashed password.

* **Behavior 2: Duplicate Email**
  * **Given:** A request is made with an email that already exists in the database.
  * **When:** The endpoint is called.
  * **Then:** It should return a `409 Conflict` status code.

* **Behavior 3: Invalid Input**
  * **Given:** A request is made with an invalid email address or a weak password.
  * **When:** The endpoint is called.
  * **Then:** It should return a `400 Bad Request` status code with a clear error message.

---
---

## 3. Context Bundle (Agent-Populated Sibling Files)

**What it is:** This section serves as a manifest, reminding the `Coder Agent` that its full context is provided in separate files within the Task Bundle directory. These files are dynamically created by the `Bundler` and `Security Consultant` agents.

* **`bundle_architecture.md`:** Contains relevant rules from `specs/Architecture.md`. The `Coder Agent` **MUST** adhere to these rules.
* **`bundle_security.md`:** Contains specific, actionable security advice. The `Coder Agent` **MUST** implement these recommendations.
* **`bundle_code_context.md`:** Contains the ground-truth interfaces, signatures, and documentation for all code relevant to this task. Its purpose is to provide a precise API reference to prevent the `Coder Agent` from hallucinating method calls or arguments. It includes:
  * **Internal Code:** Exact signatures and documentation for existing functions, classes, or API clients within this codebase that the `Coder Agent` must use.
  * **External Libraries:** The specific API documentation, function signatures, and usage examples for the versions of third-party libraries that the task requires.
    The `Coder Agent` **MUST** adhere to the interfaces defined in this file.
* *(Other files as needed, e.g., `bundle_api_schema.json`)*

---

## 4. Verification Context

**What it is:** High-level pointers for the `Validator Agent`. This is not a list of commands, but a guide to where the verification requirements are defined.
**Source:** Defined by the Human Architect.

**Example:**

* **Unit Test Scope:** The `Validator Agent` must find and run the unit tests associated with the code changed in this task. These tests must cover all behaviors defined in Section 2.
* **Integration Test Scope:** This task is part of the "User Signup Flow" slice. The `Validator Agent` must run the relevant end-to-end tests for this slice as defined in the `Milestone Plan`.
* **Project-Wide Checks:** The `Validator Agent` must run all standard project-wide quality checks (e.g., linting, security scanning) as defined in `quality.toml`.
