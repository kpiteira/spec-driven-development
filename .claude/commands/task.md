---
description: "Initialize task bundle and prepare for SDD assembly line execution"
argument-hint: "TASK-XXX"
allowed-tools: ["Read", "Write", "LS", "Bash", "Task"]
---

# Task Command - SDD Assembly Line Entry Point

Execute the SDD assembly line workflow for a specified task. This command creates task bundles and coordinates the Bundler → Coder → Validator workflow with proper context isolation and state management.

## Task Execution Process

### Phase 1: Input Validation & Bundle Creation

1. **Validate Task ID Format (Security Critical)**
   - Use strict regex validation: `^TASK-[0-9]+$`
   - Reject any task ID with path traversal sequences (../../../etc/passwd)
   - Check that task blueprint exists in `project_sdd_on_claude/tasks/TASK-XXX_*.md`
   - Validate YAML frontmatter structure in task blueprint
   - Exit immediately on validation failure with clear error message

2. **Validate Bundle Directory Boundaries**
   - Ensure bundle path remains within `.task_bundles/` directory
   - Use absolute path validation to prevent directory traversal
   - Verify workspace permissions for bundle directory creation
   - Reject any paths attempting to escape project boundaries

3. **Handle Existing Bundle Conflicts**
   - Check if `.task_bundles/TASK-XXX/` already exists
   - If exists, create timestamp-based backup: `.task_bundles/TASK-XXX-backup-YYYYMMDD-HHMMSS/`
   - Move existing bundle to backup location atomically
   - Report bundle preservation to user with backup location

4. **Create Task Bundle Structure**
   - Create `.task_bundles/TASK-XXX/` directory with appropriate permissions (750)
   - Copy task blueprint to bundle directory as `task_blueprint.md` (permissions 644)
   - Create initial `bundle_status.yaml` with atomic write operation:
     - task_id: TASK-XXX
     - status: "created" 
     - created_at: ISO 8601 UTC timestamp
     - workflow_phase: "initialization"
     - bundle_path: relative path to bundle directory
     - task_blueprint: "task_blueprint.md"
     - context_files: {} (empty, will be populated by Bundler Agent)
     - bundler_agent_completed: false
     - coder_agent_completed: false
     - last_updated: ISO 8601 UTC timestamp

### Phase 2: Bundler Agent Invocation

1. **Update Bundle Status to Bundling**
   - Use Edit tool to update `$bundle_dir/bundle_status.yaml`
   - Change status from "created" to "bundling"
   - Update workflow_phase to "bundler_invocation"
   - Add bundling_started_at timestamp

2. **Invoke Bundler Agent with Task Tool**
   - Use Task tool with subagent_type "bundler-specialist"
   - Provide comprehensive task context in prompt:
     - Task Bundle directory path: $bundle_dir
     - Task Blueprint location: task_blueprint.md
     - Request creation of all 4 context files: bundle_architecture.md, bundle_security.md, bundle_code_context.md, bundle_dependencies.md
     - Emphasize preventing hallucination through comprehensive context analysis
   - Handle Task tool execution errors with detailed logging

3. **Validate Bundle Context Completion**
   - Use Read tool to verify all required context files were created
   - Check that each file is non-empty and contains substantive content
   - Validate bundle directory structure matches expected pattern
   - Required files: bundle_architecture.md, bundle_code_context.md, bundle_security.md, bundle_dependencies.md

4. **Update Status to Ready for Coding**
   - Use Edit tool to update bundle_status.yaml
   - Change status to "ready_for_coding"
   - Update workflow_phase to "bundle_complete"
   - Add bundling_completed_at timestamp
   - Set bundler_agent_completed: true
   - Report successful bundle creation to user

### Phase 3: Coder Agent Invocation

1. **Validate Bundle Ready for Coding**
   - Use Read tool to verify bundle_status.yaml shows status: "ready_for_coding"
   - Confirm bundler_agent_completed: true in bundle status
   - Validate all required context files exist and are non-empty
   - Required files: bundle_architecture.md, bundle_security.md, bundle_code_context.md, bundle_dependencies.md, task_blueprint.md

2. **Update Bundle Status to Coding**
   - Use Edit tool to update `$bundle_dir/bundle_status.yaml`
   - Change status from "ready_for_coding" to "coding"
   - Update workflow_phase to "coder_invocation"
   - Add coding_started_at timestamp (ISO 8601 UTC)
   - Set coder_agent_completed: false

3. **Invoke Coder Agent with Task Tool**
   - Use Task tool with subagent_type "coder-specialist"
   - Specify model: claude-opus-4-1-20250805 (per NFR-PERF-006)
   - Provide comprehensive context in prompt:
     - Task Bundle directory path: $bundle_dir
     - Instruction: "Read task blueprint and all bundle_*.md context files"
     - Request: "Implement TDD workflow following task contract in Section 2"
     - Emphasis: "Generate failing tests first (red phase), then implement code that makes tests pass (green phase)"
     - Security: "Follow all architectural rules and security guidance in bundle context"
     - Output: "Place generated code according to project architectural conventions"
   - Handle Task tool execution errors with detailed logging to coder_error.log

4. **Validate Coder Implementation Results**
   - Use Read tool to verify Coder Agent generated implementation artifacts
   - Confirm TDD workflow: tests exist and are executable
   - Verify initial test failure (red phase) followed by implementation success (green phase)
   - Validate code placement follows architectural conventions from bundle_architecture.md
   - Check security guidance implementation per bundle_security.md requirements

5. **Update Status to Ready for Validation**
   - Use Edit tool to update bundle_status.yaml
   - Change status to "ready_for_validation"
   - Update workflow_phase to "coder_complete"
   - Add coding_completed_at timestamp
   - Set coder_agent_completed: true
   - Report successful code generation to user

### Phase 4: Validator Agent Invocation

1. **Invoke Validator Agent**: Use Task tool with "validator-specialist" subagent
   - Provide bundle path and implementation locations
   - Request comprehensive validation per task blueprint verification requirements
   - Update bundle status to "validating"

2. **Process Results**: Handle validation outcomes
   - **Success**: Update status to "completed", clean up bundle directory
   - **Failure**: Update status to "failed", preserve bundle for debugging

## Security & Quality Standards

**Input Validation:**
- Validate task ID format using secure regex patterns
- Prevent path traversal attacks in all file operations
- Sanitize all user inputs before processing

**Bundle Management:**
- Use atomic operations where possible
- Maintain consistent filesystem state
- Provide clear error messages and recovery guidance

**Agent Coordination:**
- Ensure clean context isolation between agents
- Pass only necessary, sanitized information to sub-agents
- Maintain bundle status throughout workflow

## Success Criteria

The command succeeds when:
1. Task bundle is created with correct structure and status tracking
2. All three agents (Bundler, Coder, Validator) complete successfully
3. Implementation passes all validation requirements
4. Bundle is properly cleaned up (success) or preserved (failure)
5. User receives clear confirmation of completion or actionable error messages

## Error Handling

**Input Validation Failures:**
- **Invalid task ID format** → Validate using regex `^TASK-[0-9]+$`, reject path traversal attempts
- **Missing task blueprint** → Check `project_sdd_on_claude/tasks/TASK-XXX_*.md` exists
- **Bundle directory conflicts** → Preserve existing bundle with timestamp backup before creating new

**Bundler Agent Invocation Failures:**

- **Task tool execution errors** → Log full error details to `$bundle_dir/bundler_error.log`
- **Bundler agent timeout** → Update bundle status to "bundling_failed", preserve bundle for debugging
- **Context creation failures** → Validate each required context file, provide specific missing file details
- **Bundle validation errors** → Update status to "validation_failed", preserve partial bundle

**Coder Agent Invocation Failures:**

- **Task tool execution errors** → Log full error details to `$bundle_dir/coder_error.log`
- **Coder agent timeout** → Update bundle status to "coding_failed", preserve bundle for debugging
- **Code generation failures** → Validate generated artifacts, provide specific missing implementation details
- **TDD workflow violations** → Check test generation and implementation sequence, report specific TDD failures
- **Security validation failures** → Verify security guidance compliance, report specific security violations
- **Architectural compliance failures** → Check code placement and conventions, report specific architectural violations

**Security Error Handling:**
- **Path traversal attempts** → Reject immediately with security error message
- **Bundle directory boundary violations** → Validate all paths remain within `.task_bundles/`
- **Context sanitization failures** → Log security issues, update bundle status to "security_failed"

**Error Recovery Patterns:**
- **Preserve bundle state on all failures** → Never delete failed bundles, add failure timestamp
- **Atomic status updates** → Use temporary files for status updates, move atomically
- **Detailed error logging** → Write error details to bundle directory for troubleshooting
- **Clean error messages** → Sanitize error output to prevent information disclosure
- **Actionable guidance** → Provide specific next steps for each failure mode

**Bundle Status Error States:**
- "bundling_failed" → Bundler agent execution failed
- "coding_failed" → Coder agent execution failed
- "validation_failed" → Context files missing or invalid
- "security_failed" → Security validation errors
- "error_recovery" → General error state for manual inspection