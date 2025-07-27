# The Specification Hierarchy: From Vision to Task

This document outlines the hierarchy of specifications required for the Spec-Driven Development (SDD) model. The goal is to create a cascading set of documents where each level provides the necessary context for the one below it, ensuring that high-level strategic goals are translated accurately into granular, actionable tasks.

This structure serves as the "single source of truth" for both human architects and AI agents.

---

## 1. The Project Vision (`Project_Vision.md`)

* **Purpose:** The "North Star." This is the highest-level document that answers the question, "Why are we building this?" It's for aligning everyone—from stakeholders to the AI agents—on the core purpose.
* **Contents:**
  * **Mission Statement:** A concise, one-sentence explanation of the project's purpose.
  * **Problem Statement:** A clear description of the pain point or opportunity the project addresses.
  * **Target Audience/User Personas:** Who are we building this for? (e.g., "Enterprise developers," "Small business owners").
  * **High-Level Goals:** What are the ultimate business or strategic outcomes? (e.g., "Capture 10% of the market," "Reduce manual data entry by 90%").

---

## 2. Product Requirements Document (`Product_Requirements.md`)

* **Purpose:** The "What." This document translates the vision into tangible product features and constraints. It defines what the system must do.
* **Contents:**
  * **Functional Requirements:** High-level features and user stories. (e.g., "As a user, I can reset my password.")
  * **Non-Functional Requirements (NFRs):** The critical "ilities" that define system-wide quality attributes. This is a key input for the `Validator` and `Security` agents.
    * *Performance:* "API endpoints must respond in <200ms."
    * *Security:* "The system must be compliant with SOC 2."
    * *Scalability:* "The system must support 10,000 concurrent users."
    * *Usability:* "A new user should be able to complete onboarding in under 5 minutes."
  * **UI/UX Principles:** For products with an interface, this is crucial.
    * **For GUIs:** Links to wireframes, mockups, or a design system. High-level principles like "The interface must be accessible (WCAG 2.1 AA)."
    * **For APIs/CLIs:** Principles for API design (e.g., "We will follow RESTful principles," "All endpoints will be versioned"). This defines the "user experience" for developers.

---

## 3. Architectural Specification (`specs/Architecture.md`)

* **Purpose:** The "How." This document outlines the technical strategy and constraints. It's the master blueprint for all technical decisions and a primary source for the `Bundler Agent`.
* **Contents:**
  * **Guiding Principles:** High-level technical philosophy (e.g., "We will use a microservices architecture," "We favor event-driven communication," "Code will be written in Python 3.11+").
  * **Technology Stack:** The approved list of languages, frameworks, databases, and cloud services.
  * **System Diagram:** A visual representation of the system's components and their interactions (e.g., using the C4 model).
  * **Data Models:** High-level definitions of the core data entities and their relationships.
  * **Key Design Patterns:** Descriptions of mandatory patterns (e.g., "All database access must go through a Repository pattern").

---

## 4. Project Roadmap (`Roadmap.md`)

* **Purpose:** The "When." This document lays out the strategic, phased delivery of the product. It turns the "what" into a high-level timeline.
* **Contents:**
  * **Milestones:** Break the project into large, thematic chunks of work. Each milestone should deliver significant value.
    * **Milestone 1: MVP Launch:** "Deliver the core features necessary to attract early adopters."
    * **Milestone 2: Public API:** "Expose key functionality for third-party integrations."
  * **Feature Sequencing:** A high-level list of the features or epics planned for each milestone.

---

## 5. Milestone Plan (`specs/milestones/M1_MVP_Plan.md`)

* **Purpose:** A detailed, tactical plan for a single milestone from the Roadmap. This is what the `Supervisor Agent` would consume to begin its work.
* **Contents:**
  * **Milestone-Specific Goals:** What does success look like for this specific milestone?
  * **Implementation Plan:** A sequenced, ordered list of the tasks required to complete the milestone's features. This list directly generates the `Task Blueprints`.
  * **Testing Plan:** The specific testing strategy for this milestone. This provides the rules for the `Validator Agent`. (e.g., "All new API endpoints must have >90% unit test coverage," "A full end-to-end test will be run for the user registration flow.").

---

## 6. Task Blueprint (`specs/tasks/TASK-XXX.md`)

* **Purpose:** The "Atomic Unit of Work." This is the final, most granular level, as defined in the `How It Works` document. It's the direct input for the "Assembly Line" and contains everything a single agent needs to perform its function perfectly.

---

## A Living Specification: The Evolution of Artifacts

Specification documents are not static. They must evolve as the project matures and we learn from user feedback. However, this evolution must be structured to prevent chaos. The core principle is **stability at the top, dynamism at the bottom**.

### 1. Project Vision (`Project_Vision.md`)

* **Evolution Speed:** Glacial. This is the bedrock of the project.
* **Lifecycle:** It should be considered **immutable** for most of the project's life.
* **Triggers for Change:** Only a fundamental strategic pivot (e.g., changing target market, company exits a business line). This is a rare, "break glass" event.
* **Process:** Requires a formal re-founding of the project with all key stakeholders. All downstream documents must be reviewed for compliance with the new vision.

### 2. Architectural Specification (`specs/Architecture.md`)

* **Evolution Speed:** Slow and deliberate.
* **Lifecycle:** Evolves incrementally to adapt to new learnings and technologies without altering core principles.
* **Triggers for Change:** A new technology is approved for the stack; a significant technical challenge reveals the need for a new design pattern; a new non-functional requirement is introduced.
* **Process:** Changes are managed via **Architecture Decision Records (ADRs)**. A proposed change is drafted as an ADR, reviewed by the team, and if approved, the main document is updated. This creates a historical log of *why* changes were made.

### 3. Product Requirements Document (`Product_Requirements.md`)

* **Evolution Speed:** Dynamic. This is a living document.
* **Lifecycle:** Changes are driven by the Roadmap Evolution Cycle. It reflects our most current understanding of user needs.
* **Triggers for Change:** A feature's priority changes during a roadmap review; a user story needs to be fleshed out with acceptance criteria as it moves towards implementation; a feature is deprecated.
* **Process:**
  * **Adding:** New ideas are captured as simple user stories and prioritized on the roadmap.
  * **Changing:** Modifications to existing requirements are approved during the roadmap review.
  * **Deprecating:** Do not delete old requirements. Move them to an "Archived" section with a note explaining *why* they were deprecated to preserve project history.

### 4. Project Roadmap (`Roadmap.md`)

* **Evolution Speed:** Rhythmic. It changes at predictable intervals.
* **Lifecycle:** This is the engine of change for the PRD. It evolves via the **"Review, Refine, Re-commit"** cycle.
* **Triggers for Change:** The primary trigger is the **completion of a milestone**. Exceptional triggers include critical user feedback or major market shifts.
* **Process:** The "Human Architect" leads a review after each milestone to analyze feedback, assess the next milestone's priority, and update the `Roadmap.md` accordingly.

### 5. Milestone Plan (`specs/milestones/M1_MVP_Plan.md`)

* **Evolution Speed:** None. It is **immutable** once active.
* **Lifecycle:** A Milestone Plan is a point-in-time artifact. It is **created** at the start of a milestone, **executed** by the `Supervisor Agent`, and **archived** upon completion.
* **Process:** It does not evolve. Its purpose is to be a clear, stable set of instructions for the current block of work. Learnings from a milestone are used to inform the creation of the *next* Milestone Plan, not to alter the one in progress.
