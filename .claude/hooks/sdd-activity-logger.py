#!/usr/bin/env python3
"""
SDD Activity Logger Hook - PostToolUse Event Handler
Implementation for TASK-014: Enhanced Notification System

This hook processes PostToolUse events from Claude Code and provides:
- Tool usage tracking and monitoring
- File activity observability
- Workflow progress detection

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
        process_post_tool_use_hook,
        secure_error_logging,
        get_bundle_status,
        monitor_status_changes,
        play_notification_sound_async
    )
    
    # Read hook data from stdin
    hook_data = json.load(sys.stdin)
    
    # Validate and process the tool use event
    validated_data = validate_hook_data(hook_data)
    
    # Process the post tool use hook
    process_post_tool_use_hook(validated_data)
    
    # Check for workflow status changes if this is a file operation
    tool_name = validated_data.get("tool_name", "")
    workspace_dir = Path(os.environ.get("CLAUDE_PROJECT_DIR", "."))
    
    # Monitor bundle status changes for significant file operations
    if tool_name in ["create_file", "replace_string_in_file", "run_in_terminal"]:
        try:
            # Look for active task bundles
            task_bundles_dir = workspace_dir / ".task_bundles"
            if task_bundles_dir.exists():
                for bundle_dir in task_bundles_dir.iterdir():
                    if bundle_dir.is_dir() and (bundle_dir / "bundle_status.yaml").exists():
                        status = get_bundle_status(bundle_dir)
                        
                        # Trigger progress notification for active tasks
                        if status.get("status") in ["bundling", "coding", "validating"]:
                            play_notification_sound_async("progress")
                            break
        except Exception as e:
            # Don't fail the hook for monitoring errors
            print(f"Bundle monitoring error: {e}", file=sys.stderr)
    
    # Log successful processing
    print(f"Tool activity logged: {tool_name} for session {validated_data['session_id']}", file=sys.stderr)
    
except json.JSONDecodeError as e:
    # Handle malformed JSON gracefully
    error_log = secure_error_logging(e, "activity_logger_json_decode")
    print(f"JSON decode error in activity logger: {error_log['message']}", file=sys.stderr)
    
except ValueError as e:
    # Handle validation errors
    error_log = secure_error_logging(e, "activity_logger_validation")
    print(f"Validation error in activity logger: {error_log['message']}", file=sys.stderr)
    
except Exception as e:
    # Handle any other errors gracefully
    error_log = secure_error_logging(e, "activity_logger_general")
    print(f"Error in activity logger: {error_log['message']}", file=sys.stderr)

# Always exit 0 - hooks are for observability, not control
sys.exit(0)