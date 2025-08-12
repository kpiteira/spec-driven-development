---
id: TASK-029
title: "Create agent-driven retrospective analysis that identifies process issues, confusion points, and improvement opportunities"
milestone_id: "M4-Sequential-Milestone-Execution"
requirement_id: "REQ-004"
slice: "Slice 5: Comprehensive Retrospective and Learning Integration"
status: "pending"
branch: "feature/TASK-029-retrospective-analysis"
---

## Implementation Context for Claude Code Agents

**Agent Guidance:** This task will be implemented by Claude Code agents using natural language understanding capabilities. When you read instructions to "parse files" or "extract information," interpret this as reading and understanding documents using your natural language comprehension, not building programmatic parsers or extraction systems.

**Process Flow:** This task will be executed through the SDD assembly line: Bundler Specialist (context research) → Coder Specialist (TDD implementation) → Validator Specialist (comprehensive testing). Each specialist uses document comprehension to understand requirements and context.

**Architecture Compliance:** All implementation must follow the project's architecture specifications as understood through document analysis, not through algorithmic rule enforcement.

---

## 1. Task Overview & Goal

**What it is:** This task implements agent-driven retrospective analysis that processes self-introspection data to identify systematic process issues, confusion points, and improvement opportunities, generating comprehensive retrospective insights before collecting Human Architect feedback.

**Context:** This is the second task in Slice 5, building upon TASK-028's self-introspection capability to create sophisticated retrospective analysis. This enables Claude Code agents to perform the primary retrospective analysis, presenting structured insights to Human Architects for feedback and enhancement.

**Goal:** Implement comprehensive retrospective analysis that processes agent self-introspection data to identify process issues, analyze confusion points and inefficiencies, and generate structured retrospective insights that provide the foundation for Human Architect feedback and process improvement.

---

## 2. Integration Context

### Why This Task Exists
This task enables systematic process improvement by allowing Claude Code agents to perform comprehensive retrospective analysis first, providing structured insights that enhance Human Architect feedback and create more effective learning outcomes.

### Dependencies & Flow
- **Requires**: TASK-028 (Agent self-introspection), complete milestone execution experience data
- **Enables**: TASK-030 (Learning integration), comprehensive retrospective workflow
- **Parallel OK**: None (retrospective analysis must process introspection data before human feedback integration)

### Architectural Integration
- **Leverages**: TASK-028 self-introspection data, milestone execution completion data, pattern analysis capabilities
- **Creates**: Agent-driven retrospective analysis system, process issue identification, improvement opportunity analysis
- **Modifies**: Retrospective workflow to begin with agent analysis before human feedback collection

### Implementation Guidance
- **Approach**: Implement sophisticated analysis that processes introspection data to identify systematic patterns and generate structured retrospective insights
- **Key Files**: Retrospective analysis utilities, process issue identification tools, improvement opportunity analysis systems
- **Complexity**: Level 5 (requires sophisticated pattern analysis and retrospective insight generation)
- **Time Estimate**: 9 hours (retrospective analysis system + pattern processing + insight generation + structuring + testing)

---

## 3. The Contract: Requirements & Test Cases

**What it is:** The specific, testable requirements for agent-driven retrospective analysis.

* **Behavior 1: Systematic Process Issue Identification**
  * **Given:** Agent self-introspection data is available from milestone planning and execution processes
  * **When:** Retrospective analysis processes the introspection data
  * **Then:** The system must identify systematic process issues that affected agent performance across multiple instances
  * **And:** Issue identification must distinguish between systematic problems (requiring process changes) and isolated incidents (one-time circumstances)
  * **And:** Process issues must be categorized by type, severity, and impact on overall milestone execution effectiveness
  * **And:** Systematic analysis must provide specific evidence and examples for each identified issue

* **Behavior 2: Confusion Point and Inefficiency Analysis**
  * **Given:** Self-introspection data contains records of agent confusion and inefficiencies
  * **When:** Confusion point analysis is performed
  * **Then:** The system must analyze patterns of confusion to identify specific process elements that consistently caused agent uncertainty
  * **And:** Inefficiency analysis must identify workflow elements that consistently slowed agent performance or required excessive effort
  * **And:** Confusion analysis must provide specific recommendations about process clarifications or improvements needed
  * **And:** Analysis must quantify the impact of confusion points and inefficiencies on overall execution effectiveness

* **Behavior 3: Improvement Opportunity Generation and Prioritization**
  * **Given:** Process issues and confusion points have been identified and analyzed
  * **When:** Improvement opportunity generation is performed
  * **Then:** The system must generate specific, actionable improvement opportunities based on the retrospective analysis
  * **And:** Improvement opportunities must be prioritized by potential impact, implementation difficulty, and frequency of occurrence
  * **And:** Each opportunity must include specific recommendations, expected benefits, and implementation considerations
  * **And:** Opportunity generation must focus on changes that would meaningfully improve future milestone planning and execution

* **Behavior 4: Structured Retrospective Insight Presentation**
  * **Given:** Comprehensive retrospective analysis has been completed
  * **When:** Retrospective insights are prepared for Human Architect review
  * **Then:** The system must present structured retrospective insights that clearly organize findings, issues, and opportunities
  * **And:** Insight presentation must provide executive summary, detailed findings, and specific recommendations
  * **And:** Structured presentation must enable effective Human Architect feedback and decision-making
  * **And:** Retrospective insights must be formatted to support the learning integration requirements for TASK-030

---

## 4. Context Bundle (Agent-Populated Sibling Files)

**What it is:** Context files that will be provided by other agents for this task.

* **`bundle_architecture.md`:** Retrospective analysis patterns for AI-driven process improvement, systematic issue identification strategies, improvement opportunity analysis approaches, structured insight presentation methods
* **`bundle_security.md`:** Secure retrospective data processing, protection against bias in retrospective analysis, validation of improvement recommendations, safe handling of process improvement insights
* **`bundle_code_context.md`:** TASK-028 self-introspection data interfaces, pattern analysis and insight generation utilities, retrospective analysis tools, structured presentation and documentation systems

---

## 5. Verification Context

**What it is:** Guidance for validating this task's completion.

* **Unit Test Scope:** The Validator Agent must test systematic process issue identification accuracy and comprehensiveness, verify confusion point and inefficiency analysis provides actionable insights, validate improvement opportunity generation and prioritization logic, and confirm structured retrospective insight presentation supports effective review
* **Integration Test Scope:** The Validator Agent must test complete retrospective analysis workflow using real self-introspection data from milestone execution scenarios, verify retrospective analysis generates valuable and actionable insights for process improvement, test retrospective analysis integration with self-introspection data collection, and confirm structured insights support effective Human Architect feedback collection
* **Project-Wide Checks:** The Validator Agent must ensure retrospective analysis follows SDD principles for continuous learning and process improvement, verify that agent-driven analysis provides genuine value for identifying process improvements, confirm that retrospective insights support effective integration with Human Architect feedback, and validate that retrospective analysis contributes meaningfully to the overall learning and improvement system