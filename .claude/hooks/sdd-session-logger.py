#!/usr/bin/env python3
"""
SDD Session Logger Hook - SessionStart Event Handler
Implementation for TASK-014: Enhanced Notification System

This hook processes SessionStart events from Claude Code and provides:
- Session initialization logging
- Project context setup
- Observability event tracking

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
        process_session_start_hook,
        secure_error_logging
    )
    
    # Read hook data from stdin
    hook_data = json.load(sys.stdin)
    
    # Validate and process the session start event
    validated_data = validate_hook_data(hook_data)
    
    # Process the session start hook
    process_session_start_hook(validated_data)
    
    # Log successful processing
    print(f"Session start logged: {validated_data['session_id']}", file=sys.stderr)
    
except json.JSONDecodeError as e:
    # Handle malformed JSON gracefully
    error_log = secure_error_logging(e, "session_logger_json_decode")
    print(f"JSON decode error in session logger: {error_log['message']}", file=sys.stderr)
    
except ValueError as e:
    # Handle validation errors
    error_log = secure_error_logging(e, "session_logger_validation")
    print(f"Validation error in session logger: {error_log['message']}", file=sys.stderr)
    
except Exception as e:
    # Handle any other errors gracefully
    error_log = secure_error_logging(e, "session_logger_general")
    print(f"Error in session logger: {error_log['message']}", file=sys.stderr)

# Always exit 0 - hooks are for observability, not control
sys.exit(0)