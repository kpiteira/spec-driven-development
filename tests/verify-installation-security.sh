#!/bin/bash
# Installation Security Verification Script for SDD System
#
# This script verifies that all security practices are properly implemented
# in the SDD installation system (both local and remote installers).

set -euo pipefail

# Configuration
readonly TESTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_DIR="$(dirname "$TESTS_DIR")"

# Color codes
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

# Test results tracking
declare -i SECURITY_CHECKS_PASSED=0
declare -i SECURITY_CHECKS_FAILED=0
declare -a SECURITY_ISSUES=()

# Logging functions
log_info() { echo -e "${GREEN}[INFO]${NC} $*"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*"; }
log_debug() { echo -e "${BLUE}[DEBUG]${NC} $*"; }

# Security check functions
security_check() {
    local test_name="$1"
    local check_result="${2:-0}"
    
    if [[ $check_result -eq 0 ]]; then
        log_info "✓ $test_name"
        ((SECURITY_CHECKS_PASSED++))
        return 0
    else
        log_error "✗ $test_name"
        SECURITY_ISSUES+=("$test_name")
        ((SECURITY_CHECKS_FAILED++))
        return 1
    fi
}

# Check 1: Remote installation security practices
check_remote_installer_security() {
    log_info "=== Checking Remote Installer Security ==="
    
    local installer="$SCRIPT_DIR/remote-install.sh"
    
    if [[ ! -f "$installer" ]]; then
        security_check "Remote installer file exists" 1
        return 1
    fi
    
    # Check for security warning display
    if grep -q "SECURITY NOTICE" "$installer"; then
        security_check "Security warning displayed to users"
    else
        security_check "Security warning displayed to users" 1
    fi
    
    # Check for user consent mechanism
    if grep -q "Continue with installation" "$installer"; then
        security_check "User consent required for installation"
    else
        security_check "User consent required for installation" 1
    fi
    
    # Check for HTTPS-only URLs (no HTTP references)
    if ! grep -q "http://" "$installer"; then
        security_check "No insecure HTTP URLs in installer"
    else
        security_check "No insecure HTTP URLs in installer" 1
    fi
    
    # Check for checksum verification
    if grep -q -E "(sha256sum|shasum)" "$installer"; then
        security_check "Checksum verification implemented"
    else
        security_check "Checksum verification implemented" 1
    fi
    
    # Check for bash strict mode
    if grep -q "set -euo pipefail" "$installer"; then
        security_check "Bash strict mode enabled in remote installer"
    else
        security_check "Bash strict mode enabled in remote installer" 1
    fi
    
    # Check for temporary file cleanup
    if grep -q -E "(trap.*cleanup|rm.*temp)" "$installer"; then
        security_check "Temporary file cleanup implemented"
    else
        security_check "Temporary file cleanup implemented" 1
    fi
    
    # Check that installer doesn't require sudo
    if ! grep -q "sudo" "$installer"; then
        security_check "No sudo requirements in installer"
    else
        security_check "No sudo requirements in installer" 1
    fi
}

# Check 2: Local installation script security
check_local_installer_security() {
    log_info "=== Checking Local Installer Security ==="
    
    local installer="$SCRIPT_DIR/install.sh"
    
    if [[ ! -f "$installer" ]]; then
        security_check "Local installer file exists" 1
        return 1
    fi
    
    # Check for bash strict mode
    if grep -q "set -euo pipefail" "$installer"; then
        security_check "Bash strict mode enabled in local installer"
    else
        security_check "Bash strict mode enabled in local installer" 1
    fi
    
    # Check for path validation
    if grep -q "validate_path" "$installer"; then
        security_check "Path validation implemented"
    else
        security_check "Path validation implemented" 1
    fi
    
    # Check for version comparison (prevents downgrades)
    if grep -q "version_compare" "$installer"; then
        security_check "Version comparison prevents downgrades"
    else
        security_check "Version comparison prevents downgrades" 1
    fi
    
    # Check for proper file permissions
    if grep -q "chmod.*644" "$installer"; then
        security_check "Secure file permissions set"
    else
        security_check "Secure file permissions set" 1
    fi
    
    # Check for error handling
    if grep -q -E "(trap.*ERR|handle_error)" "$installer"; then
        security_check "Error handling implemented"
    else
        security_check "Error handling implemented" 1
    fi
}

# Check 3: Documentation security guidance
check_documentation_security() {
    log_info "=== Checking Documentation Security ==="
    
    # Check installation documentation in README
    local install_doc="$SCRIPT_DIR/README.md"
    if [[ -f "$install_doc" ]]; then
        if grep -q -i "security" "$install_doc"; then
            security_check "Security considerations in README"
        else
            security_check "Security considerations in README" 1
        fi
        
        if grep -q "Review scripts before execution" "$install_doc"; then
            security_check "Script review guidance provided"
        else
            security_check "Script review guidance provided" 1
        fi
        
        if grep -q -E "(curl.*-o|Review.*contents)" "$install_doc"; then
            security_check "Secure installation method documented"
        else
            security_check "Secure installation method documented" 1
        fi
    else
        security_check "README documentation exists" 1
    fi
    
    # Check troubleshooting documentation
    local trouble_doc="$SCRIPT_DIR/TROUBLESHOOTING.md"
    if [[ -f "$trouble_doc" ]]; then
        if grep -q -i "permission" "$trouble_doc"; then
            security_check "Permission issues documented"
        else
            security_check "Permission issues documented" 1
        fi
        
        if grep -q -E "(sudo.*not|never.*sudo)" "$trouble_doc"; then
            security_check "Sudo avoidance guidance provided"
        else
            security_check "Sudo avoidance guidance provided" 1
        fi
    else
        security_check "Troubleshooting documentation exists" 1
    fi
}

# Check 4: Template and command file security
check_template_security() {
    log_info "=== Checking Template and Command Security ==="
    
    # Check that templates have version information
    local templates_dir="specs/templates"
    if [[ -d "$templates_dir" ]]; then
        local templates_with_versions=0
        local total_templates=0
        
        for template in "$templates_dir"/*.md; do
            if [[ -f "$template" ]]; then
                ((total_templates++))
                if head -10 "$template" | grep -q "version:"; then
                    ((templates_with_versions++))
                fi
            fi
        done
        
        if [[ $templates_with_versions -eq $total_templates ]] && [[ $total_templates -gt 0 ]]; then
            security_check "All templates have version information"
        else
            security_check "All templates have version information ($templates_with_versions/$total_templates)" 1
        fi
    else
        security_check "Templates directory exists" 1
    fi
    
    # Check command files for proper structure
    local commands_dir=".claude/commands"
    if [[ -d "$commands_dir" ]]; then
        local valid_commands=0
        local total_commands=0
        
        for command in "$commands_dir"/*.md; do
            if [[ -f "$command" ]] && [[ ! "$(basename "$command")" =~ _temp\.md$ ]]; then
                ((total_commands++))
                if grep -q "^description:" "$command"; then
                    ((valid_commands++))
                fi
            fi
        done
        
        if [[ $valid_commands -eq $total_commands ]] && [[ $total_commands -gt 0 ]]; then
            security_check "All command files properly structured"
        else
            security_check "All command files properly structured ($valid_commands/$total_commands)" 1
        fi
    else
        security_check "Commands directory exists" 1
    fi
}

# Check 5: File system security practices
check_filesystem_security() {
    log_info "=== Checking File System Security ==="
    
    # Check that installation creates directories with appropriate permissions
    local install_script="$SCRIPT_DIR/install.sh"
    if [[ -f "$install_script" ]]; then
        if grep -q "mkdir.*-m.*755" "$install_script"; then
            security_check "Directories created with secure permissions (755)"
        else
            security_check "Directories created with secure permissions (755)" 1
        fi
        
        # Check for realpath usage (prevents symlink attacks)
        if grep -q "realpath" "$install_script"; then
            security_check "Path canonicalization used"
        else
            security_check "Path canonicalization used" 1
        fi
    fi
    
    # Check that sensitive operations are logged
    if grep -q -E "(log_|tee.*log)" "$install_script"; then
        security_check "Installation operations are logged"
    else
        security_check "Installation operations are logged" 1
    fi
}

# Check 6: Network security practices
check_network_security() {
    log_info "=== Checking Network Security ==="
    
    local remote_installer="$SCRIPT_DIR/remote-install.sh"
    if [[ -f "$remote_installer" ]]; then
        # Check for network timeout settings
        if grep -q -E "(--max-time|--connect-timeout)" "$remote_installer"; then
            security_check "Network timeouts configured"
        else
            security_check "Network timeouts configured" 1
        fi
        
        # Check for retry logic
        if grep -q -E "(--retry|retry_count)" "$remote_installer"; then
            security_check "Network retry logic implemented"
        else
            security_check "Network retry logic implemented" 1
        fi
        
        # Check for user agent identification
        if grep -q -E "(-A|--user-agent)" "$remote_installer"; then
            security_check "User agent identification used"
        else
            security_check "User agent identification used" 1
        fi
        
        # Check for SSL verification (should not be disabled)
        if ! grep -q -E "(\s-k\s|--insecure)" "$remote_installer"; then
            security_check "SSL certificate verification enabled"
        else
            security_check "SSL certificate verification enabled" 1
        fi
    fi
}

# Check 7: Input validation and sanitization
check_input_validation() {
    log_info "=== Checking Input Validation ==="
    
    local install_script="$SCRIPT_DIR/install.sh"
    if [[ -f "$install_script" ]]; then
        # Check for filename validation
        if grep -q -E "(basename|filename.*validation)" "$install_script"; then
            security_check "Filename validation implemented"
        else
            security_check "Filename validation implemented" 1
        fi
        
        # Check for content validation
        if grep -q -E "(validate.*file|check.*content)" "$install_script"; then
            security_check "File content validation implemented"
        else
            security_check "File content validation implemented" 1
        fi
    fi
    
    # Check template validation
    if grep -q "validate_markdown_file" "$install_script"; then
        security_check "Template file validation implemented"
    else
        security_check "Template file validation implemented" 1
    fi
}

# Generate security report
generate_security_report() {
    # Ensure reports directory exists
    mkdir -p "$SCRIPT_DIR/reports"
    local report_file="$SCRIPT_DIR/reports/installation-security-verification.md"
    
    cat > "$report_file" << EOF
# SDD Installation Security Verification Report

**Verification Date:** $(date)
**Checks Passed:** $SECURITY_CHECKS_PASSED
**Checks Failed:** $SECURITY_CHECKS_FAILED
**Total Checks:** $((SECURITY_CHECKS_PASSED + SECURITY_CHECKS_FAILED))

## Security Assessment Summary

### Risk Level: $(if [[ $SECURITY_CHECKS_FAILED -eq 0 ]]; then echo "LOW ✅"; elif [[ $SECURITY_CHECKS_FAILED -le 3 ]]; then echo "MEDIUM ⚠️"; else echo "HIGH ❌"; fi)

### Security Categories Verified

1. **Remote Installation Security**
   - Security warnings and user consent
   - HTTPS-only communications
   - Checksum verification
   - Temporary file cleanup

2. **Local Installation Security**
   - Path validation and traversal protection
   - Version comparison and downgrade prevention
   - Proper file permissions
   - Error handling and recovery

3. **Documentation Security**
   - Security guidance for users
   - Best practices documentation
   - Permission troubleshooting

4. **Template and Command Security**
   - Version information in templates
   - Proper command file structure
   - Content validation

5. **File System Security**
   - Secure directory creation
   - Path canonicalization
   - Operation logging

6. **Network Security**
   - Timeout configuration
   - Retry logic
   - SSL certificate verification
   - User agent identification

7. **Input Validation**
   - Filename sanitization
   - Content validation
   - Template structure verification

EOF

    if [[ $SECURITY_CHECKS_FAILED -gt 0 ]]; then
        echo "## Security Issues Found" >> "$report_file"
        echo >> "$report_file"
        for issue in "${SECURITY_ISSUES[@]}"; do
            echo "- ❌ $issue" >> "$report_file"
        done
        echo >> "$report_file"
    fi
    
    echo "## Recommendations" >> "$report_file"
    echo >> "$report_file"
    
    if [[ $SECURITY_CHECKS_FAILED -eq 0 ]]; then
        echo "✅ **All security checks passed.** The SDD system implements comprehensive security practices." >> "$report_file"
    else
        echo "⚠️ **Address the failed security checks above before production deployment.**" >> "$report_file"
    fi
    
    echo >> "$report_file"
    echo "## Compliance Notes" >> "$report_file"
    echo >> "$report_file"
    echo "This verification confirms compliance with:" >> "$report_file"
    echo "- Secure installation practices" >> "$report_file"
    echo "- Network security requirements" >> "$report_file"
    echo "- File system security guidelines" >> "$report_file"
    echo "- Input validation standards" >> "$report_file"
    echo "- User consent and transparency requirements" >> "$report_file"
    echo >> "$report_file"
    echo "Report generated: $(date)" >> "$report_file"
    
    log_info "Installation security verification report saved to: $report_file"
}

# Display security verification results
show_security_results() {
    echo
    echo "🔒 Security Verification Results"
    echo "==============================="
    echo "  Security checks passed: $SECURITY_CHECKS_PASSED"
    echo "  Security checks failed: $SECURITY_CHECKS_FAILED"
    echo "  Total security checks: $((SECURITY_CHECKS_PASSED + SECURITY_CHECKS_FAILED))"
    echo
    
    if [[ $SECURITY_CHECKS_FAILED -gt 0 ]]; then
        echo "⚠️  Security issues found:"
        for issue in "${SECURITY_ISSUES[@]}"; do
            echo "  - $issue"
        done
        echo
        if [[ $SECURITY_CHECKS_FAILED -le 3 ]]; then
            echo "📊 Risk Level: MEDIUM - Address issues before production deployment"
        else
            echo "🚨 Risk Level: HIGH - Critical security issues must be resolved"
        fi
        echo
        return 1
    else
        echo "✅ All security checks passed!"
        echo "📊 Risk Level: LOW - System ready for secure deployment"
        echo
        return 0
    fi
}

# Main security verification
main() {
    log_info "Starting SDD Installation Security Verification..."
    
    # Run all security checks
    check_remote_installer_security
    check_local_installer_security  
    check_documentation_security
    check_template_security
    check_filesystem_security
    check_network_security
    check_input_validation
    
    # Generate report and display results
    generate_security_report
    
    if show_security_results; then
        log_info "🔒 Installation security verification completed - system is secure for deployment!"
        exit 0
    else
        log_error "🚨 Installation security verification failed - address issues before deployment!"
        exit 1
    fi
}

# Script entry point
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi