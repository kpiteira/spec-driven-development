---
version: "2.0.0"
template_type: "Task Blueprint"
description: "Detailed task specification extending milestone plan descriptions"
id: TASK-XXX
title: "[What user capability this enables]"
milestone_id: "[Milestone ID]"
---

# Task Blueprint: [TASK-XXX] [Title]

**Purpose:** This blueprint extends the milestone plan's task description with the additional detail needed for Bundler, Coder, Security, and Validator agents to implement the task correctly with minimal hallucination.

## Implementation Context for Claude Code Agents

**Agent Guidance:** This task will be implemented by Claude Code agents using natural language understanding. When you read instructions to "parse files" or "extract information," interpret this as reading and understanding documents, not building programmatic parsers or extraction systems.

**Process Flow:** This task executes through the SDD assembly line: Bundler Specialist (context research) → Coder Specialist (TDD implementation) → Validator Specialist (comprehensive testing). Each specialist uses document comprehension to understand requirements and context.

**Architecture Compliance:** All implementation must follow the project's architecture specifications as understood through document analysis, not through algorithmic rule enforcement.

**SIMPLICITY PRINCIPLE:** Only fill out template sections if you have specific, valuable information from the human architect or existing documentation. Do NOT invent complexity to complete the template. It's better to leave sections minimal or empty than to hallucinate requirements.

## 1. Expanding the Milestone Description

**From Milestone Plan:** [Copy the full paragraph from the milestone plan here]

**Additional Complexity and Decisions:**

[Expand the milestone description with 2-3 more paragraphs covering:]
- What specific decisions need to be made that aren't obvious?
- What are the most likely ways this could be implemented wrong?
- What integration challenges exist with other parts of the system?
- What edge cases or error scenarios must be handled?
- What performance, security, or scalability considerations matter?

**Example:**
> From milestone: "This task establishes the foundational data model for user management that must handle both immediate signup needs and future authentication features..."
>
> Additional complexity: The biggest decision is the user ID strategy - auto-incrementing integers are simple but expose user count information and complicate distributed systems. UUIDs provide better privacy and scaling but require more storage and careful index design. The schema must also handle the email uniqueness constraint properly - PostgreSQL's unique constraints are case-sensitive by default, but emails should be case-insensitive, requiring either a functional index on LOWER(email) or application-level normalization.
>
> The password hashing strategy directly impacts both security and performance. bcrypt with 12 rounds provides good security for 2024 but will become insufficient over time. The schema should include a hash_algorithm field to enable future migration to Argon2 or newer algorithms without forcing all users to reset passwords.
>
> Database migration strategy matters because user tables cannot be easily rebuilt in production. The initial schema should include commonly needed fields (created_at, updated_at, status) even if not immediately used, to avoid complex migrations later. Consider soft delete patterns (is_deleted boolean) versus hard deletes for compliance requirements.

## 2. Helping the Agents Succeed

**IMPORTANT:** Only fill out sections below if you have specific information that adds value. Empty sections are better than invented complexity.

### For the Bundler Agent
**What context do you need to research to avoid hallucination?** [Only if specific research needs are known]

- **Architecture patterns:** [Only if specific patterns matter for this task]
- **Existing code:** [Only if specific files provide important patterns]
- **Dependencies:** [Only if specific libraries/versions are critical]
- **Project conventions:** [Only if specific conventions affect this task]

### For the Coder Agent  
**Key decisions and implementation guidance:** [Only if specific technical decisions are needed]

**Technology choices:** [Only if architecture specifies particular approaches]
- Use [specific choice] because [documented reason]
- Follow [specific pattern] from [existing file] 
- Avoid [specific approach] because [documented constraint]

**Critical edge cases:** [Only if task has known tricky scenarios]
**Integration points:** [Only if specific integration requirements exist]

### For the Security Agent
**Security considerations:** [Only if task has specific security requirements]

- **Input validation:** [Only if specific validation rules apply]
- **Authentication/Authorization:** [Only if auth requirements differ from defaults]
- **Data protection:** [Only if handling sensitive data]
- **Attack vectors:** [Only if specific risks are known]

### For the Validator Agent
**Testing approach:** [Only if task needs special testing considerations]

**Must verify:** [Only specific behaviors that need explicit testing guidance]
**Integration testing:** [Only if special integration requirements exist]

## 3. Success Criteria (Precise and Testable)

**What exactly must work for this task to be considered complete?**

[Define 3-5 specific behaviors with Given/When/Then format, but make them more detailed than milestone plan level]

**Example:**

**Behavior 1: Successful User Registration with Proper Data Handling**
* **Given:** A POST request to `/api/users` with `{"email": "test@example.com", "password": "SecurePass123!"}`
* **When:** The email doesn't exist in database and password meets strength requirements (8+ chars, uppercase, lowercase, number, symbol)
* **Then:** Response is 201 Created with `{"id": "uuid-here", "email": "test@example.com", "created_at": "2024-01-01T00:00:00Z"}`
* **And:** Database contains new user record with bcrypt-hashed password (cost factor 12)
* **And:** Email is stored in lowercase for case-insensitive lookups
* **And:** Response does NOT include password hash or other sensitive data

**Behavior 2: Duplicate Email Prevention with Clear Error**
* **Given:** A POST request with email that already exists (case-insensitive match)
* **When:** Database lookup finds existing user with same email (regardless of case)
* **Then:** Response is 409 Conflict with `{"error": "Email already registered", "code": "DUPLICATE_EMAIL"}`
* **And:** No new database record is created
* **And:** Original user record remains unchanged
* **And:** Response time is consistent with successful registration (no timing attacks)

**Behavior 3: Input Validation with Helpful Feedback**
* **Given:** A POST request with invalid data (empty email, weak password, etc.)
* **When:** Input validation runs before any database operations
* **Then:** Response is 400 Bad Request with specific error details per field
* **And:** Error messages are helpful: `{"email": ["Must be valid email"], "password": ["Must include uppercase, lowercase, number, symbol"]}`
* **And:** No database queries are executed for invalid inputs
* **And:** Rate limiting still applies to prevent abuse

---

## Template Usage Notes

**Key Principles:**

1. **Extend, don't repeat** - Start with milestone plan paragraph, add the missing details
2. **SIMPLICITY FIRST** - Empty sections are better than invented complexity
3. **Specific, not generic** - Use exact library names, file paths, error codes (when you know them)
4. **Question over invention** - Ask human architect for missing info rather than making it up
5. **Value-focused** - Only add details that help agents avoid real mistakes

**Red flags your blueprint has too much invention:**
- Agent sections filled with generic advice that could apply to any task
- Technology choices specified without architectural basis
- Security requirements that aren't documented anywhere
- Complex edge cases that aren't based on actual project needs
- Success criteria that go far beyond what the milestone plan requires

**Good signs your blueprint adds value:**
- Sections reference specific existing files, libraries, or documented decisions
- Edge cases come from known project constraints or documented issues  
- Technology choices align with documented architecture
- Security requirements reflect actual sensitive data or attack vectors
- Success criteria clarify ambiguities in the milestone plan without adding new requirements
