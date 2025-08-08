# Project Roadmap: [Project Name]

**Purpose of this document:** The Project Roadmap provides a strategic, high-level view of the project's development sequence, organized by value-driven milestones. It is not a timeline. Instead, it communicates the ordered path of development, ensuring all stakeholders and team members understand what is being built now, what's next, and what is planned for the future.

**Link to Requirements:** `[Link to Product_Requirements.md]`

---

## 1. Guiding Principles

**What it is:** A few core principles that guide how this roadmap should be interpreted.

**Best Practices:**

* Emphasize flexibility and outcomes over rigid schedules.
* Set the expectation that this roadmap is a living document that evolves as we learn.

**Example:**

* **Focus on Outcomes, Not Output:** We prioritize work that delivers the most value to our users and achieves the goals outlined in the Project Vision.
* **Sequential, Not Timed:** This roadmap represents the *order* of development, not a commitment to dates. We complete one milestone before moving to the next.
* **A Living Document:** This roadmap is designed to evolve. The process for its evolution is defined in the [Specification Hierarchy Guide](link-to-your-guide).
* **Embrace Learning:** The "Later" section is subject to change based on feedback from previous milestones and shifting strategic priorities.

---

## 2. Milestone Overview

**What it is:** A high-level, ordered list of the major milestones for the project. Each milestone should represent a significant and coherent package of value delivered through vertical slices.

**Best Practices:**

* Give each milestone a clear, descriptive name and a primary goal.
* The sequence should tell a logical story of the product's evolution.
* **Vertical Slice Approach:** Each milestone should be broken down into vertical slices that deliver end-to-end functionality across all layers of the system (UI, business logic, data). This ensures each slice provides tangible user value and can be independently tested and deployed.

**Example:**

* **Milestone 1: Minimum Viable Product (MVP)**
  * *Goal:* Solve the single most important problem for our primary user persona to validate that we are building something people want.
* **Milestone 2: Public API & Core Integrations**
  * *Goal:* Enable programmatic access and connect our product to other key systems, expanding its utility.
* **Milestone 3: "Pro" User Features**
  * *Goal:* Introduce a set of advanced features to provide more value for our power users and create a premium offering.
* **Milestone 4: Enterprise Readiness**
  * *Goal:* Add features like Single Sign-On (SSO) and advanced security controls to make the product viable for large organizations.

---

## 3. Roadmap: Now, Next, Later

**What it is:** A simple, powerful way to visualize priorities based on the milestone sequence.

**Best Practices:**

* **Now:** The milestone the team is actively working on. This section should be the most detailed.
* **Next:** The milestone that will be worked on immediately after the current one is complete. This should be well-defined.
* **Later:** All subsequent milestones from the overview. These are less defined and subject to refinement.

**Example:**

### Now

* **Milestone:** **Minimum Viable Product (MVP)**
  * **Features:** User Account Creation & Login (`REQ-001`, `REQ-002`), Basic Website Builder, Single-Page Deployment.
  * **Confidence:** High

### Next

* **Milestone:** **Public API & Core Integrations**
  * **Features:** Public API for programmatic site management, Zapier Integration, Admin Dashboard V1.
  * **Confidence:** Medium (scope may be adjusted based on MVP feedback)

### Later

* **Milestone:** **"Pro" User Features**
  * **Features:** Custom Domain Support, Advanced Analytics, Collaboration Tools.
  * **Confidence:** Low (subject to change based on strategic direction and user requests)
* **Milestone:** **Enterprise Readiness**
  * **Features:** SSO, Role-Based Access Control, Audit Logs.
  * **Confidence:** Low

---

## 4. Out of Scope (for now)

**What it is:** A list of features or ideas that have been explicitly de-prioritized and do not fit into the current milestone sequence. This helps manage stakeholder expectations.

**Best Practices:**

* Briefly explain the rationale for de-prioritizing.
* This is not a "never" list, but a "not in the foreseeable future" list.

**Example:**

* **E-commerce functionality:** De-prioritized to focus on the core content creation experience first.
* **Multi-language support:** Will be considered after we have validated the product in the primary market.
* **Native Mobile App:** Our initial focus is on the desktop web experience.
