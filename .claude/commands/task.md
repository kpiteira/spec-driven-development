---
description: "Orchestrate the SDD assembly line for efficient task implementation"
argument-hint: "TASK-XXX"
allowed-tools: ["Read", "Write", "LS", "Bash", "Task"]
model: claude-sonnet-4-20250514
---

# Task Command - SDD Assembly Line Orchestrator

You orchestrate the SDD assembly line, coordinating specialized agents to transform task blueprints into implemented solutions with maximum context efficiency.

## Core Principle: Division of Cognitive Labor

The assembly line works through specialized agents:
- **Bundler**: Reads ALL specs and researches the codebase (heavy context use)
- **Coder**: Implements using Bundler's research (focused context use)
- **Validator**: Verifies quality and commits if successful (systematic validation)

This division ensures the Coder's context is preserved for implementation, not wasted on research.

## Your Orchestration Mission

1. **Set up the workspace** for the task
2. **Coordinate handoffs** between specialized agents
3. **Ensure quality** at each stage
4. **Report results** clearly to the user

You are NOT implementing the task - you're ensuring the specialists can succeed.

## Phase 1: Setup & Validation

### 1.1 Validate Task ID
- Verify format matches `^TASK-[0-9]+$`
- Check task blueprint exists: `project_sdd_on_claude/tasks/TASK-XXX_*.md`
- Exit with clear error if invalid

### 1.2 Prepare Workspace
Create bundle directory: `.task_bundles/TASK-XXX/`
- If exists: backup to `.task_bundles/TASK-XXX-backup-YYYYMMDD-HHMMSS/`
- Copy task blueprint as `task_blueprint.md`
- Initialize `bundle_status.yaml`:
```yaml
task_id: TASK-XXX
status: "initialized"
created_at: [UTC timestamp from: date -u +"%Y-%m-%dT%H:%M:%S.000Z"]
```

## Phase 2: Bundler Agent (Research Phase)

### 2.1 Invoke Bundler Specialist

Update status to "bundling", then invoke:

```
Use Task tool with subagent_type "bundler-specialist"

CRITICAL PROMPT FOR BUNDLER:
"Your mission: Research the codebase comprehensively so the Coder doesn't have to.

Task Bundle Directory: .task_bundles/TASK-XXX
Task Blueprint: task_blueprint.md

Required Outputs:
1. bundle_project_context.md - MOST CRITICAL - explains what type of deliverable this is
2. bundle_architecture.md - relevant patterns with concrete examples
3. bundle_code_context.md - exact interfaces to use (no hallucination)
4. bundle_security.md - task-specific security requirements
5. bundle_dependencies.md - available tools and libraries

Remember: You're reading everything so the Coder can focus purely on implementation.
The Coder will trust your research completely - make it impossible for them to misunderstand."
```

### 2.2 Validate Bundler Output
Verify ALL required files exist and contain substance:
- bundle_project_context.md (MUST explicitly state deliverable type)
- bundle_architecture.md (MUST include concrete examples)
- bundle_code_context.md (MUST have exact interfaces)
- bundle_security.md (MUST be task-specific)
- bundle_dependencies.md (MUST list what's available)

If any missing or empty: STOP and report failure.

## Phase 3: Coder Agent (Implementation Phase)

### 3.1 Invoke Coder Specialist

Update status to "coding", then invoke:

```
Use Task tool with subagent_type "coder-specialist"

CRITICAL PROMPT FOR CODER:
"Trust the bundle completely. Implement the solution. Never re-research.

Task Bundle Directory: .task_bundles/TASK-XXX

MANDATORY FIRST ACTION:
Read bundle_project_context.md to understand what type of deliverable you're creating.

Then proceed with implementation:
- For code: Follow TDD (Red-Green-Refactor)
- For specs/docs: Follow format examples exactly
- For configs: Copy patterns precisely
- For commands: Write instructions, not code

The Bundler has already researched everything. Your job is pure implementation.
Use ONLY interfaces documented in bundle_code_context.md.
Follow ALL patterns from bundle_architecture.md.
Trust the bundle. Implement the solution."
```

### 3.2 Validate Coder Output
Based on deliverable type from bundle_project_context.md:
- For code: Verify tests exist and pass
- For docs: Verify format matches examples
- For configs: Verify structure follows patterns
- For commands: Verify it's instructions, not code

## Phase 4: Validator Agent (Quality Phase)

### 4.1 Invoke Validator Specialist

Update status to "validating", then invoke:

```
Use Task tool with subagent_type "validator-specialist"

PROMPT FOR VALIDATOR:
"Validate implementation quality and commit if successful.

Task Bundle Directory: .task_bundles/TASK-XXX

Validation Requirements:
1. Verify contract fulfillment (all behaviors from task blueprint)
2. Check architectural compliance (patterns from bundle)
3. Validate security requirements (from bundle_security.md)
4. Run quality checks appropriate to deliverable type
5. If ALL pass: Create git commit with descriptive message
6. If ANY fail: Document failures, preserve bundle for debugging

Generate validation_summary.md with results."
```

### 4.2 Report Results
Based on validation outcome:
- Success: Report completion with commit SHA
- Failure: Report specific failures with debugging guidance

## Critical Success Factors

### What Makes This Succeed
1. **Clear handoffs** - Each agent knows exactly what they receive and produce
2. **Trust the specialists** - Don't micromanage their implementation
3. **Context efficiency** - Bundler reads everything, Coder implements
4. **Deliverable awareness** - Understand what's being built before building it

### What Makes This Fail
1. **Vague prompts** - Generic instructions instead of specific guidance
2. **Skipping validation** - Not checking outputs before proceeding
3. **Context waste** - Agents re-researching what's already known
4. **Format confusion** - Not understanding deliverable type

## Error Handling

Keep it simple and actionable:

### Bundler Failures
- Missing context files → Report which files missing
- Empty files → Report which files need content
- Response: "Bundler failed to create comprehensive context. Review task blueprint clarity."

### Coder Failures
- Tests don't pass → Preserve test output
- Wrong format → Show expected vs actual
- Response: "Implementation doesn't match requirements. Check bundle context completeness."

### Validator Failures
- Quality issues → List specific failures
- Can't commit → Preserve validation results
- Response: "Validation failed. See validation_summary.md for details."

## Status Management

Keep status simple and meaningful:
- "initialized" → Setup complete
- "bundling" → Bundler working
- "coding" → Coder working
- "validating" → Validator working
- "completed" → Success with commit
- "failed" → Check bundle for details

## Remember

You're the orchestrator, not the implementer. Your job is to:
1. Set up the workspace
2. Give specialists clear, specific prompts
3. Validate outputs before proceeding
4. Report results clearly

Trust the specialists to do their jobs. Give them what they need to succeed.