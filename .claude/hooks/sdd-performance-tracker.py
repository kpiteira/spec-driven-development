#!/usr/bin/env python3
"""
SDD Performance Tracker Hook - SubagentStop Event Handler  
Implementation for TASK-014: Enhanced Notification System

This hook processes SubagentStop events from Claude Code and provides:
- Sub-agent performance monitoring
- Workflow health tracking
- Agent completion notifications

Security Features:
- Input validation and sanitization
- Secure file operations
- Error handling with graceful degradation
"""

import json
import os
import sys
from pathlib import Path

# Add hooks lib to path
hooks_lib = Path(__file__).parent / "lib"
if hooks_lib.exists():
    sys.path.insert(0, str(hooks_lib))

try:
    from notification_system import (
        validate_hook_data,
        process_subagent_stop_hook,
        secure_error_logging,
        get_bundle_status,
        play_notification_sound_async,
        handle_workflow_failure,
        generate_debugging_guidance
    )
    
    # Read hook data from stdin
    hook_data = json.load(sys.stdin)
    
    # Validate and process the subagent stop event
    validated_data = validate_hook_data(hook_data)
    
    # Process the subagent stop hook
    process_subagent_stop_hook(validated_data)
    
    # Check for agent completion and trigger appropriate notifications
    subagent_name = validated_data.get("subagent_name", "")
    workspace_dir = Path(os.environ.get("CLAUDE_PROJECT_DIR", "."))
    
    try:
        # Look for active task bundles to update status
        task_bundles_dir = workspace_dir / ".task_bundles"
        if task_bundles_dir.exists():
            for bundle_dir in task_bundles_dir.iterdir():
                if bundle_dir.is_dir() and (bundle_dir / "bundle_status.yaml").exists():
                    status = get_bundle_status(bundle_dir)
                    
                    # Check if this subagent completion should trigger notification
                    if subagent_name:
                        if "bundler" in subagent_name.lower():
                            if status.get("workflow_phase") == "bundler_invocation":
                                if status.get("bundler_agent_completed"):
                                    play_notification_sound_async("success")
                                    print(f"Bundler agent completed for {bundle_dir.name}", file=sys.stderr)
                                else:
                                    # Possible failure - check for error conditions
                                    if status.get("status") == "failed":
                                        play_notification_sound_async("error")
                                        print(f"Bundler agent failed for {bundle_dir.name}", file=sys.stderr)
                                    
                        elif "coder" in subagent_name.lower():
                            if status.get("workflow_phase") == "coder_invocation":
                                if status.get("coder_agent_completed"):
                                    play_notification_sound_async("success")
                                    print(f"Coder agent completed for {bundle_dir.name}", file=sys.stderr)
                                else:
                                    # Possible failure - check for error conditions
                                    if status.get("status") == "failed":
                                        play_notification_sound_async("error")
                                        print(f"Coder agent failed for {bundle_dir.name}", file=sys.stderr)
                                        
                        elif "validator" in subagent_name.lower():
                            if status.get("workflow_phase") == "validator_invocation":
                                if status.get("status") == "completed":
                                    play_notification_sound_async("success")
                                    print(f"Validation completed for {bundle_dir.name}", file=sys.stderr)
                                elif status.get("status") == "failed":
                                    play_notification_sound_async("error")
                                    print(f"Validation failed for {bundle_dir.name}", file=sys.stderr)
                    
                    break  # Only process first active bundle
                    
    except Exception as e:
        # Don't fail the hook for status checking errors
        print(f"Status monitoring error: {e}", file=sys.stderr)
    
    # Log successful processing
    print(f"Subagent performance tracked: {subagent_name} for session {validated_data['session_id']}", file=sys.stderr)
    
except json.JSONDecodeError as e:
    # Handle malformed JSON gracefully
    error_log = secure_error_logging(e, "performance_tracker_json_decode")
    print(f"JSON decode error in performance tracker: {error_log['message']}", file=sys.stderr)
    
except ValueError as e:
    # Handle validation errors
    error_log = secure_error_logging(e, "performance_tracker_validation")
    print(f"Validation error in performance tracker: {error_log['message']}", file=sys.stderr)
    
except Exception as e:
    # Handle any other errors gracefully
    error_log = secure_error_logging(e, "performance_tracker_general")
    print(f"Error in performance tracker: {error_log['message']}", file=sys.stderr)

# Always exit 0 - hooks are for observability, not control
sys.exit(0)