#!/usr/bin/env python3
"""
SDD Session Summary Hook - Stop Event Handler
Implementation for TASK-014: Enhanced Notification System

This hook processes Stop events from Claude Code and provides:
- Session completion summary
- Final workflow status reporting  
- Session cleanup and finalization

Security Features:
- Input validation and sanitization
- Secure file operations
- Error handling with graceful degradation
"""

import json
import os
import sys
from pathlib import Path
from datetime import datetime

# Add hooks lib to path
hooks_lib = Path(__file__).parent / "lib"
if hooks_lib.exists():
    sys.path.insert(0, str(hooks_lib))

try:
    from notification_system import (
        validate_hook_data,
        process_stop_hook,
        secure_error_logging,
        get_bundle_status,
        generate_progress_report,
        play_notification_sound_async,
        safe_write_log
    )
    
    # Read hook data from stdin
    hook_data = json.load(sys.stdin)
    
    # Validate and process the session stop event
    validated_data = validate_hook_data(hook_data)
    
    # Process the session stop hook
    process_stop_hook(validated_data)
    
    # Generate session summary
    session_id = validated_data['session_id']
    workspace_dir = Path(os.environ.get("CLAUDE_PROJECT_DIR", "."))
    
    summary = {
        "session_id": session_id,
        "end_time": datetime.now().isoformat(),
        "workspace": workspace_dir.name,
        "active_tasks": [],
        "completed_tasks": [],
        "failed_tasks": []
    }
    
    try:
        # Check all task bundles for status
        task_bundles_dir = workspace_dir / ".task_bundles"
        if task_bundles_dir.exists():
            for bundle_dir in task_bundles_dir.iterdir():
                if bundle_dir.is_dir() and (bundle_dir / "bundle_status.yaml").exists():
                    status = get_bundle_status(bundle_dir)
                    task_info = {
                        "task_id": status.get("task_id", bundle_dir.name),
                        "status": status.get("status", "unknown"),
                        "workflow_phase": status.get("workflow_phase", "unknown"),
                        "last_updated": status.get("last_updated", "unknown")
                    }
                    
                    if status.get("status") == "completed":
                        summary["completed_tasks"].append(task_info)
                    elif status.get("status") == "failed":
                        summary["failed_tasks"].append(task_info)
                    elif status.get("status") in ["bundling", "coding", "validating"]:
                        summary["active_tasks"].append(task_info)
        
        # Play appropriate session end notification
        if summary["failed_tasks"]:
            play_notification_sound_async("error")
            print(f"Session ended with {len(summary['failed_tasks'])} failed tasks", file=sys.stderr)
        elif summary["completed_tasks"]:
            play_notification_sound_async("success")
            print(f"Session ended with {len(summary['completed_tasks'])} completed tasks", file=sys.stderr)
        else:
            play_notification_sound_async("progress")
            print(f"Session ended with {len(summary['active_tasks'])} active tasks", file=sys.stderr)
        
        # Write session summary to log
        log_dir = workspace_dir / ".claude" / "logs"
        safe_write_log(log_dir, f"session_summary_{session_id}.json", summary)
        
        # Print summary for observability
        print(f"Session Summary:", file=sys.stderr)
        print(f"  - Completed: {len(summary['completed_tasks'])} tasks", file=sys.stderr)
        print(f"  - Failed: {len(summary['failed_tasks'])} tasks", file=sys.stderr) 
        print(f"  - Active: {len(summary['active_tasks'])} tasks", file=sys.stderr)
        
    except Exception as e:
        # Don't fail the hook for summary generation errors
        print(f"Session summary generation error: {e}", file=sys.stderr)
    
    # Log successful processing
    print(f"Session summary completed for session {session_id}", file=sys.stderr)
    
except json.JSONDecodeError as e:
    # Handle malformed JSON gracefully
    error_log = secure_error_logging(e, "session_summary_json_decode")
    print(f"JSON decode error in session summary: {error_log['message']}", file=sys.stderr)
    
except ValueError as e:
    # Handle validation errors
    error_log = secure_error_logging(e, "session_summary_validation")
    print(f"Validation error in session summary: {error_log['message']}", file=sys.stderr)
    
except Exception as e:
    # Handle any other errors gracefully
    error_log = secure_error_logging(e, "session_summary_general")
    print(f"Error in session summary: {error_log['message']}", file=sys.stderr)

# Always exit 0 - hooks are for observability, not control
sys.exit(0)