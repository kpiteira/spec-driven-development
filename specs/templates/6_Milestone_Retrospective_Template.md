---
version: "1.0.0"
template_type: "Milestone Retrospective"
description: "Learning capture from completed milestones to improve future planning"
---

# Milestone Retrospective: [Milestone Name]

**Date Completed**: [YYYY-MM-DD]
**Actual Duration vs. Estimate**: [X days actual vs Y days estimated]
**Milestone Goal**: [Brief restatement of the milestone's primary objective]

---

## 1. What Worked Well

**Patterns and approaches that succeeded:**

- [Specific technique or decision that helped]
- [Tool, framework, or methodology that proved valuable]
- [Architectural decision that paid off]
- [Process improvement that worked]

**Example:**
- Using existing authentication middleware saved 2 days vs building from scratch
- Breaking user management into 4 small tasks made progress tracking much clearer
- The TDD approach caught 3 integration issues early

---

## 2. What Was Harder Than Expected

**Tasks, decisions, or challenges that took longer than planned:**

- [Task that exceeded time estimate and why]
- [Hidden complexity that was discovered]
- [Integration challenge or dependency issue]
- [Technical decision that required more research]

**Example:**
- TASK-005 took 12 hours instead of 4 due to database migration complexity
- Integration with existing user service required understanding legacy authentication patterns
- Testing required setting up additional test data that wasn't anticipated

---

## 3. Discovered Patterns & Solutions

**Reusable solutions and insights found during implementation:**

- [Better approach learned through experience]
- [Simplification opportunity identified]
- [Library, tool, or technique discovered]
- [Architecture pattern that emerged]

**Example:**
- Using middleware factories instead of individual route handlers reduces duplication
- The existing error handling patterns can be extended for new API endpoints
- Database migrations work better when split into schema and data changes

---

## 4. Complexity Analysis

**Comparison of estimated vs actual complexity and time:**

| Task ID | Description | Est. Hours | Actual Hours | Est. Complexity | Actual Complexity | Why Different? |
|---------|-------------|------------|--------------|-----------------|-------------------|----------------|
| TASK-001 | Create user model | 4 | 6 | Level 2 | Level 2 | Validation rules more complex |
| TASK-002 | User registration API | 3 | 3 | Level 2 | Level 2 | As expected |
| TASK-003 | Authentication middleware | 6 | 12 | Level 3 | Level 4 | Legacy integration required |

**Key Insights:**
- Tasks involving legacy system integration consistently take 2x longer
- New feature development matches estimates well when following existing patterns
- Testing setup often adds 25% to implementation time

---

## 5. Recommendations for Future Milestones

**Specific advice for improving future planning and execution:**

### Planning Improvements
1. [Specific change to milestone planning process]
2. [Pattern to repeat in similar situations]
3. [Pitfall to watch for and avoid]

### Technical Recommendations
1. [Architectural decision to continue]
2. [Tool or approach to adopt more widely]
3. [Integration pattern that worked well]

### Process Recommendations
1. [Development workflow improvement]
2. [Testing approach that proved valuable]
3. [Communication or coordination improvement]

**Example:**
- Always budget extra time for tasks that integrate with legacy systems (1.5x multiplier)
- The middleware factory pattern should be used for all new API endpoints
- Breaking large features into 2-4 hour tasks improves progress visibility significantly

---

## 6. Questions for Next Planning Session

**Strategic questions or architectural considerations surfaced by this milestone:**

- [Technical architecture question that emerged]
- [Process or methodology question]
- [Tool or technology evaluation needed]
- [Organizational or team workflow consideration]

**Example:**
- Should we standardize on the middleware factory pattern across all services?
- Is the current database migration strategy scalable for larger schema changes?
- Would API versioning help with future legacy integration challenges?

---

## 7. Overall Assessment

**Milestone Success Rating**: [1-5] where 5 = exceeded expectations, 3 = met goals, 1 = major issues

**Key Success Factors**:
- [Primary reason the milestone succeeded or struggled]
- [Most important lesson learned]
- [Biggest contributor to efficiency or delay]

**Would Do Differently**:
- [Major change you'd make if repeating this milestone]
- [Different approach you'd try]
- [Earlier decision or investment that would have helped]

**Example:**
**Rating**: 4/5
**Success Factors**: Clear task breakdown, good use of existing patterns, early testing caught issues
**Would Do Differently**: Spend more time analyzing legacy integration points during planning phase