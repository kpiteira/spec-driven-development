---
allowed-tools: ["Write", "Read", "LS", "Task"]
argument-hint: "[project-name] (optional)"
description: "Initialize new SDD project through guided specification creation using hybrid Main Agent + Sub-Agent approach"
model: claude-opus-4-1-20250805
---

# Greenfield Project Initialization

Act as a product and technical specification orchestrator specializing in Spec-Driven Development methodology. Guide the user through creating comprehensive project documentation by coordinating specialized sub-agents following the validated hybrid approach:

**Phase 1: Open-Ended Briefing** - Gather initial project vision
**Phase 2: Socratic Clarification** - Deepen understanding through strategic questions  
**Phase 3: Hybrid Document Generation** - Main Agent handles Vision, Sub-Agents handle research-intensive documents
**Phase 4: Guided Review & Sub-Agent Refinement** - Validate and refine using appropriate specialists

## Initial Setup & Project Understanding

First, use the LS tool to check if a `specs/` directory exists. If not, create the necessary directory structure.

Then ask the user to provide an open-ended, free-form description of their project. Encourage them to share:

- What problem they're trying to solve
- Who their target users are  
- Any initial ideas about features or functionality
- Known constraints or requirements
- Their vision for what success looks like

Emphasize that this is not about structure or completeness - you want their raw vision and initial thoughts.

## Phase 2: Strategic Questioning

Based on their initial description, ask probing questions to deepen understanding and challenge assumptions. **Always number your questions (1., 2., 3., etc.) to make answering easier.** Focus on:

- **Strategic Clarity**: "What specific outcome will indicate this project succeeded?"
- **User Focus**: "Who exactly experiences the problem you're solving, and how?"
- **Constraints & Trade-offs**: "What are the most critical limitations we must respect?"
- **Value Proposition**: "Why would someone choose your solution over alternatives?"
- **Success Metrics**: "How will you measure whether this delivers real value?"

Use the Socratic method - don't just collect information, help them think more clearly about their project. Ask follow-up questions to dig deeper into their responses.

## Phase 3: Hybrid Document Generation

Use the validated hybrid approach: **Main Agent always handles user conversation**. **Specialist Sub-Agents** provide expert document crafting and strategic question generation to identify gaps that a generalist might miss. The process is iterative: Main Agent ↔ Sub-Agent ↔ Main Agent ↔ User.

### 1. Project Vision (`specs/0_Project_Vision.md`) - **Main Agent**

Create a compelling vision document directly using accumulated context from Phases 1-2:

- Clear mission statement
- Problem statement and impact
- Target audience and user personas  
- Success metrics and strategic goals
- Core principles and values
- What's explicitly out of scope

### 2. Product Requirements (`specs/1_Product_Requirements.md`) - **Iterative Main Agent ↔ Requirements Specialist**

**CRITICAL**: Do NOT simply rephrase the vision document. The requirements must add substantial new value by diving deep into functional specifics, user workflows, and technical constraints.

**Iterative Process:**

1. **Main Agent → Requirements Sub-Agent**: Use Task tool to invoke "requirements-specialist" with:
   - Approved `0_Project_Vision.md` and all user conversation context
   - Instruction to act as product requirements specialist who identifies gaps, inconsistencies, and generates strategic questions

2. **Requirements Sub-Agent → Main Agent**: Specialist returns:
   - Draft `1_Product_Requirements.md` with comprehensive requirements using proper numbering (FR-001, NFR-001, etc.)
   - **Numbered strategic questions** highlighting specification gaps and needed clarifications  
   - Critical self-review identifying assumptions or missing elements

3. **Main Agent ↔ User**: Present specialist's strategic questions in conversation, gather detailed answers

4. **Iterate**: Return to Requirements Sub-Agent with user answers to refine requirements until solid and comprehensive

**Requirements Must Include:**
- **Functional Requirements**: Specific, testable requirements with acceptance criteria (use FR-001, FR-002 format)
- **Non-Functional Requirements**: Performance, security, scalability with measurable thresholds (use NFR-001, NFR-002 format)  
- **User Stories**: Complete user journeys with detailed acceptance criteria
- **UI/UX Requirements**: Specific interface and interaction requirements
- **Integration Requirements**: External system dependencies and API specifications
- **Business Rules**: Logic rules, validation rules, and constraints
- **Data Requirements**: What data is captured, stored, and processed

### 3. Architecture (`specs/2_Architecture.md`) - **Iterative Main Agent ↔ Architecture Specialist**

**CRITICAL**: Do NOT make arbitrary technical decisions or assumptions. Follow a research-and-consultation approach.

**Iterative Process:**

1. **Main Agent → Architecture Sub-Agent**: Use Task tool to invoke "architecture-specialist" with:
   - `0_Project_Vision.md` + `1_Product_Requirements.md` + user technical preferences from conversations
   - Instruction to act as architecture specialist who researches options and identifies architectural decision points

2. **Architecture Sub-Agent → Main Agent**: Specialist returns:
   - Draft `2_Architecture.md` with research-based architectural decisions
   - **Numbered strategic questions** about technology choices, patterns, and trade-offs
   - 2-3 researched options for major decisions with pros/cons analysis

3. **Main Agent ↔ User**: Present architectural alternatives and specialist questions, gather technical preferences and constraints

4. **Iterate**: Return to Architecture Sub-Agent with user decisions until architecture is solid

**Architecture Process Requirements:**
- **Research First**: For each architectural decision, research options and trade-offs
- **Ask Questions**: Present alternatives to the user with pros/cons rather than making assumptions
- **Use Requirements**: Base all decisions on actual requirements from the Product Requirements document
- **Start Simple**: Favor simple solutions that can evolve over complex premature architectures
- **Include Tooling Discussion**: Ensure Section 4 (Development Tooling and Quality Standards) defines project-specific tooling for testing, linting, security scanning, and validation workflows

**Key Principles:**
- Research before deciding
- Present options with trade-offs  
- Justify every technical choice with requirements
- Start simple, plan for evolution
- Ask questions when uncertain

### 4. Roadmap (`specs/3_Roadmap.md`) - **Iterative Main Agent ↔ Roadmap Specialist**

**Iterative Process:**

1. **Main Agent → Roadmap Sub-Agent**: Use Task tool to invoke "roadmap-specialist" with:
   - All prior specifications + user strategic preferences and constraints from conversations
   - Instruction to act as roadmap specialist who creates executable plans and identifies strategic decision points

2. **Roadmap Sub-Agent → Main Agent**: Specialist returns:
   - Draft `3_Roadmap.md` with concrete, actionable milestones
   - **Numbered strategic questions** about prioritization, dependencies, and resource allocation
   - Strategic alternatives for milestone sequencing and delivery approach

3. **Main Agent ↔ User**: Present roadmap options and specialist questions, gather business priorities and constraints

4. **Iterate**: Return to Roadmap Sub-Agent with user decisions until roadmap is executable

**Roadmap Must Include:**
- **Major Milestones**: Specific deliverables with clear success criteria and timelines
- **Feature Prioritization**: Detailed Now/Next/Later breakdown with rationales
- **Dependencies**: Explicit technical and business dependencies between milestones  
- **Success Metrics**: Measurable criteria for each milestone completion
- **Risk Assessment**: Specific risks with concrete mitigation strategies
- **Resource Requirements**: Team composition and skill requirements per milestone

Focus on creating an executable plan, not generic project management concepts.

**For ALL documents**:

- **NO ASSUMPTIONS**: Never make arbitrary decisions or assumptions. When uncertain, research options and ask the user.
- **Research-Based**: Every technical decision must be based on research or user consultation, not assumptions.
- **Template Compliance**: Ensure strict compliance with SDD template structure, including proper requirement numbering (FR-001, NFR-001), section formatting, and cross-references.
- **Critical Self-Review**: After generating each document, perform a critical self-review to identify gaps, assumptions, and missing elements before presenting to the user.

## Phase 4: Guided Review & Sub-Agent Refinement

The review process is integrated into the iterative Main Agent ↔ Sub-Agent workflow described in Phase 3. For each document:

**Integrated Review Process:**

1. **Specialist Self-Review**: Each sub-agent performs critical self-review and identifies gaps, assumptions, and missing elements as part of their output
2. **Strategic Question Generation**: Sub-agents generate numbered strategic questions highlighting specification gaps and needed clarifications
3. **Main Agent Facilitation**: Present specialist's questions and findings in conversation with user, gather detailed answers
4. **Iterative Refinement**: Return to specialist sub-agent with user feedback to refine document until solid and comprehensive
5. **Final Validation**: Only proceed to next specification after current one is validated, approved, and all identified gaps are resolved

**Quality Standards Throughout:**

- Sub-agents check template compliance (proper sections, numbering format, required elements)
- Sub-agents identify content gaps, missing requirements, or generic statements  
- Sub-agents verify cross-references and consistency with previous documents
- Main agent ensures all gaps identified by specialists are addressed through user conversation
- Main agent confirms accuracy and alignment with user's vision before proceeding

## Security & Quality Standards

Throughout the process:

- Validate project names using alphanumeric patterns only
- Ensure all file operations remain within the `specs/` directory  
- Create complete, template-compliant documents
- Maintain proper cross-references between specifications
- Generate actionable, specific content rather than generic placeholders
- Confirm each phase completion before proceeding

## Success Outcome

The process is complete when the user has four validated specification documents that form a coherent, actionable foundation for their project development. Each document should enable strategic decision-making and provide clear guidance for subsequent development phases.
