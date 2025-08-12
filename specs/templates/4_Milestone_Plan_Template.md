---
version: "1.0.0"
template_type: "Milestone Plan"
description: "Template for detailed milestone execution planning"
---

# Milestone Plan: [Milestone Name, e.g., M1 - Minimum Viable Product]

**Purpose of this document:** This document provides a detailed, tactical plan for executing a single milestone from the Project Roadmap. It enables Claude Code agents to read and understand milestone execution requirements, containing the precise sequence of work and quality gates required for milestone completion. This plan will be implemented by the `/milestone` command using sequential task execution.

**Link to Roadmap:** `[Link to Roadmap.md]`

## Planning Guidelines for Milestone Planning Specialists

**Requirements Validation:** Before creating this milestone plan, verify all requirement references against the actual requirements document (`1_Product_Requirements.md`). Use only existing REQ-XXX, NFR-XXX identifiers - never invent new requirement IDs.

**Scope Boundaries:** This milestone must deliver only the features specified in the roadmap milestone. Any additions must be explicitly justified against higher-level specifications and approved by the Human Architect.

**Simplicity First:** Start with sequential task execution unless parallel execution provides clear value. Focus on the simplest implementation approach that delivers the roadmap value.

**Generic Capability:** Use examples that demonstrate this plan can be executed by the `/milestone [name]` command for any milestone, not just specific milestone names.

---

## 1. Milestone Goals & Success Criteria

**What it is:** A clear statement of what this milestone aims to achieve and how we will measure its success. This section answers the question, "Why are we doing this work?"

**Example:**

* **Goal:** To launch a Minimum Viable Product (MVP) that solves the core problem for our primary user persona ("Sam the Small Business Owner") and validates that we are building something people want.
* **Success Criteria:**
  * Achieve 100 active users within 30 days of launch.
  * At least 20% of users successfully publish a website.
  * The system maintains >99.5% uptime during the initial launch period.

---

## 2. Scope: Features & Requirements

**What it is:** A definitive list of the features and user stories that are included in this milestone. This sets the boundaries for the work to be done.

**Example:**

* **Functional Requirements In Scope:**
  * `REQ-001`: User Signup
  * `REQ-002`: User Login
  * `REQ-004`: Basic Website Editor
  * `REQ-005`: Single-Page Website Publishing

---

## 3. Implementation Plan: Vertical Slices

**What it is:** The core of the plan. The work for this milestone is broken down into a sequence of **Vertical Slices**. Each slice represents a small, demonstrable, and testable piece of end-to-end functionality that delivers user value. The `Supervisor Agent` will execute the slices in this order.

**Best Practices:**

* A slice should be small enough to be completed in a short amount of time but large enough to deliver coherent value.
* Each slice must be independently testable.

---

### **Slice 1: User Signup Flow**

* **Goal:** A new user can create an account in the system.
* **Acceptance Criteria:**
  * **Given** a user provides a valid email and password on the signup page,
  * **When** they submit the form,
  * **Then** a new user record is created in the database,
  * **And** they are redirected to the login page with a success message.
* **Task Sequence:**
    1. **TASK-001:** Create `users` table in the database with `id`, `email`, `password_hash`.
    2. **TASK-002:** Create API endpoint `POST /api/users` for user signup.
    3. **TASK-003:** Build frontend signup page with a form for email and password.
    4. **TASK-004:** Write an end-to-end test that simulates the full signup flow.

---

### **Slice 2: User Login & Session Management**

* **Goal:** An existing user can log in and the system recognizes them.
* **Acceptance Criteria:**
  * **Given** an existing user is on the login page,
  * **When** they submit their correct credentials,
  * **Then** the system returns a session token (e.g., a JWT),
  * **And** they are redirected to their dashboard.
* **Task Sequence:**
    1. **TASK-005:** Create API endpoint `POST /api/sessions` for user login.
    2. **TASK-006:** Build frontend login page and handle session token storage.
    3. **TASK-007:** Create a protected API endpoint that requires a valid session token.
    4. **TASK-008:** Write an end-to-end test for the login flow and accessing a protected resource.

---
> `[...add more slices as needed...]`
---

## 4. Testing & Verification Plan

**What it is:** A set of specific quality gates that the `Validator Agent` will enforce. This now includes checks for each slice and for the milestone as a whole.

**Example:**

* **Project-Level Checks (Always On):**
  * Linter (`eslint --fix .`) must pass.
  * Security Scanner (`snyk test`) must report zero high-severity vulnerabilities.
* **Unit Testing (A Task-Level Concern):**
  * While not specified in this milestone plan, it is an implicit requirement that all new code produced for a task is accompanied by sufficient unit tests. The specific requirements for unit tests are defined within each `Task Blueprint`.
* **Per-Slice Checks (Integration & E2E Tests):**
  * After each slice is completed, the specific end-to-end tests defined in its "Task Sequence" must pass. These tests verify that the components of the slice work together correctly to deliver user value.
* **Final Milestone Acceptance Tests:**
  * After all slices are complete, a full regression test suite is run.
  * A performance test is run on all new public-facing API endpoints.

---

## 5. Common Pitfalls to Avoid

**What it is:** Anti-patterns that lead to over-engineered, unrealistic milestone plans. Use this section to validate your plan follows simplicity principles.

### ❌ Avoid These Patterns

* **Over-Engineering**: Creating complex systems when simple solutions exist
  * Example: Building a "milestone acceptance test parser" instead of having AI agents read test descriptions directly
* **Parsing Obsession**: Building parsers for structured data when AI agents can read documents directly
  * Example: Creating JSON extractors when agents can understand markdown naturally
* **Reinventing Infrastructure**: Creating new systems instead of leveraging existing components
  * Example: Building new validation frameworks instead of using existing test commands
* **Abstract Tasks**: Tasks without concrete deliverables or clear implementation paths
  * Example: "Design the architecture" instead of "Create config file with API endpoints"
* **Big Bang Tasks**: Tasks taking more than 8 hours to complete
  * Example: "Implement complete user management system" instead of breaking into smaller pieces

### ✅ Instead, Prefer These Patterns

* **Simple Prompt Engineering**: Use AI capabilities directly rather than building complex systems
* **Configuration Over Implementation**: Modify config files and prompts rather than writing new code
* **Extension Over Creation**: Enhance existing components rather than building from scratch
* **Concrete Deliverables**: Each task produces specific files, commands, or visible functionality
* **Template Baseline**: Match the complexity level shown in the template examples above

### Complexity Check

**Before finalizing your milestone plan, verify:**
- Average task complexity ≤ Level 2.5 (see complexity scoring in planning command)
- No individual task > Level 3 complexity
- Each task takes 2-8 hours to complete
- You can explain each task in one simple sentence
- Each task leverages existing infrastructure rather than creating new systems
