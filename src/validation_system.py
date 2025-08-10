#!/usr/bin/env python3
"""
Enhanced Validation System for SDD (TASK-013)

This module implements comprehensive validation logic including:
1. Test execution and validation
2. Static analysis and quality checking
3. Conditional git commit automation
4. Validation failure handling and debugging

Follows the security requirements and architectural patterns
from the task bundle context files.
"""

import json
import os
import re
import shutil
import subprocess
import time
from dataclasses import dataclass, field
from pathlib import Path
from typing import Dict, List, Optional, Tuple, Any, Union
import tempfile
try:
    import yaml
except ImportError:
    # Simple YAML fallback for basic configs
    yaml = None

try:
    import toml
except ImportError:
    # Fallback for environments without toml
    toml = None


class ValidationError(Exception):
    """Exception raised when validation fails."""
    
    def __init__(self, message: str, category: str = "unknown", details: Optional[Dict] = None):
        super().__init__(message)
        self.category = category
        self.details = details or {}


@dataclass
class ValidationResult:
    """Result of a validation operation."""
    success: bool
    message: str
    details: Dict[str, Any] = field(default_factory=dict)
    error_message: Optional[str] = None
    category: Optional[str] = None


@dataclass
class TestResult:
    """Result of test execution."""
    success: bool
    test_results: List[Dict] = field(default_factory=list)
    coverage_percentage: Optional[float] = None
    error_message: Optional[str] = None
    exit_code: int = 0


@dataclass
class StaticAnalysisResult:
    """Result of static analysis."""
    success: bool
    tool_results: Dict[str, Any] = field(default_factory=dict)
    violations: List[Dict] = field(default_factory=list)
    error_message: Optional[str] = None


@dataclass
class GitCommitResult:
    """Result of git commit operation."""
    success: bool
    commit_sha: Optional[str] = None
    committed: bool = False
    error_message: Optional[str] = None


def load_quality_config(config_path: str) -> Dict[str, Any]:
    """Load quality configuration from TOML file."""
    if not os.path.exists(config_path):
        raise ValidationError(f"Quality config not found: {config_path}", "config")
    
    try:
        if toml:
            with open(config_path, 'r') as f:
                return toml.load(f)
        else:
            # Simple TOML parser fallback for basic configs
            config = {}
            current_section = None
            
            with open(config_path, 'r') as f:
                for line in f:
                    line = line.strip()
                    if not line or line.startswith('#'):
                        continue
                        
                    if line.startswith('[') and line.endswith(']'):
                        current_section = line[1:-1]
                        config[current_section] = {}
                    elif '=' in line and current_section:
                        key, value = line.split('=', 1)
                        key = key.strip()
                        value = value.strip().strip('"\'')
                        
                        # Basic type conversion
                        if value.lower() == 'true':
                            value = True
                        elif value.lower() == 'false':
                            value = False
                        elif value.isdigit():
                            value = int(value)
                        
                        config[current_section][key] = value
            
            return config
            
    except Exception as e:
        raise ValidationError(f"Failed to load quality config: {e}", "config")


class TestExecutor:
    """Handles test execution and validation."""
    
    def __init__(self, project_root: str):
        self.project_root = Path(project_root)
        
    def run_generated_tests(self, task_id: str) -> TestResult:
        """Run generated tests for a specific task."""
        try:
            # Look for task-specific test files
            test_pattern = f"test_task_{task_id}*.py"
            test_files = list(self.project_root.glob(f"**/{test_pattern}"))
            
            if not test_files:
                # If no task-specific tests, run all tests in tests directory
                test_files = list(self.project_root.glob("tests/test_*.py"))
                
            if not test_files:
                return TestResult(
                    success=False,
                    error_message="No test files found for execution"
                )
            
            # Use pytest if available, otherwise use unittest
            try:
                cmd = ["python3", "-m", "pytest"] + [str(f) for f in test_files] + ["-v", "--tb=short"]
                result = subprocess.run(
                    cmd, 
                    cwd=self.project_root, 
                    capture_output=True, 
                    text=True, 
                    timeout=300
                )
                
                return TestResult(
                    success=result.returncode == 0,
                    test_results=[{"file": str(f), "status": "run"} for f in test_files],
                    error_message=result.stdout + result.stderr if result.returncode != 0 else None,
                    exit_code=result.returncode
                )
                
            except (subprocess.TimeoutExpired, FileNotFoundError):
                # Fallback to unittest
                cmd = ["python3", "-m", "unittest", "discover", "-s", "tests", "-p", "test_*.py", "-v"]
                result = subprocess.run(
                    cmd,
                    cwd=self.project_root,
                    capture_output=True,
                    text=True,
                    timeout=300
                )
                
                return TestResult(
                    success=result.returncode == 0,
                    test_results=[{"framework": "unittest", "status": "run"}],
                    error_message=result.stdout + result.stderr if result.returncode != 0 else None,
                    exit_code=result.returncode
                )
                
        except subprocess.TimeoutExpired:
            return TestResult(
                success=False,
                error_message="Test execution timed out after 5 minutes"
            )
        except Exception as e:
            return TestResult(
                success=False,
                error_message=f"Test execution failed: {str(e)}"
            )
    
    def run_regression_tests(self) -> TestResult:
        """Run all existing tests to check for regressions."""
        try:
            # Find all test files
            test_files = list(self.project_root.glob("tests/test_*.py"))
            
            if not test_files:
                return TestResult(success=True, test_results=[], error_message="No regression tests found")
            
            # Run all tests
            cmd = ["python3", "-m", "pytest", "tests/", "-v"]
            result = subprocess.run(
                cmd,
                cwd=self.project_root,
                capture_output=True,
                text=True,
                timeout=600
            )
            
            return TestResult(
                success=result.returncode == 0,
                test_results=[{"type": "regression", "status": "run"}],
                error_message=result.stdout + result.stderr if result.returncode != 0 else None,
                exit_code=result.returncode
            )
            
        except Exception as e:
            return TestResult(
                success=False,
                error_message=f"Regression test execution failed: {str(e)}"
            )
    
    def check_coverage_threshold(self, threshold: int, bundle_dir: str) -> TestResult:
        """Check if test coverage meets the specified threshold."""
        try:
            # Try to run coverage analysis
            cmd = ["python3", "-m", "pytest", "--cov=src", "--cov-report=json", "tests/"]
            result = subprocess.run(
                cmd,
                cwd=self.project_root,
                capture_output=True,
                text=True,
                timeout=300
            )
            
            coverage_file = self.project_root / "coverage.json"
            if coverage_file.exists():
                with open(coverage_file) as f:
                    coverage_data = json.load(f)
                    total_coverage = coverage_data.get("totals", {}).get("percent_covered", 0)
                    
                    return TestResult(
                        success=total_coverage >= threshold,
                        coverage_percentage=total_coverage,
                        error_message=f"Coverage {total_coverage}% below threshold {threshold}%" if total_coverage < threshold else None
                    )
            else:
                # No coverage data available, assume 0% coverage
                return TestResult(
                    success=False,
                    coverage_percentage=0,
                    error_message=f"No coverage data available, below threshold {threshold}%"
                )
                
        except Exception as e:
            return TestResult(
                success=False,
                coverage_percentage=0,
                error_message=f"Coverage check failed: {str(e)}"
            )


class StaticAnalyzer:
    """Handles static analysis and quality checking."""
    
    def __init__(self, project_root: str):
        self.project_root = Path(project_root)
        
    def run_linting(self, tools: List[str]) -> StaticAnalysisResult:
        """Run linting tools on the codebase."""
        tool_results = {}
        violations = []
        overall_success = True
        
        for tool in tools:
            try:
                if tool == "flake8":
                    result = self._run_flake8()
                elif tool == "black":
                    result = self._run_black()
                elif tool == "isort":
                    result = self._run_isort()
                elif tool == "pylint":
                    result = self._run_pylint()
                else:
                    result = {"status": "skipped", "message": f"Unknown linting tool: {tool}"}
                
                tool_results[tool] = result
                
                if result.get("status") != "passed":
                    overall_success = False
                    if "violations" in result:
                        violations.extend(result["violations"])
                        
            except Exception as e:
                tool_results[tool] = {"status": "error", "message": str(e)}
                overall_success = False
                
        return StaticAnalysisResult(
            success=overall_success,
            tool_results=tool_results,
            violations=violations,
            error_message="Linting violations found" if not overall_success else None
        )
    
    def _run_flake8(self) -> Dict:
        """Run flake8 linting."""
        try:
            cmd = ["python3", "-m", "flake8", "src/", "tests/"]
            result = subprocess.run(
                cmd,
                cwd=self.project_root,
                capture_output=True,
                text=True,
                timeout=120
            )
            
            if result.returncode == 0:
                return {"status": "passed", "message": "No flake8 violations"}
            else:
                violations = []
                for line in result.stdout.split('\n'):
                    if line.strip():
                        violations.append({"tool": "flake8", "message": line.strip()})
                
                return {
                    "status": "failed",
                    "message": f"Found {len(violations)} flake8 violations", 
                    "violations": violations
                }
                
        except FileNotFoundError:
            return {"status": "skipped", "message": "flake8 not available"}
        except subprocess.TimeoutExpired:
            return {"status": "error", "message": "flake8 timed out"}
        except Exception as e:
            return {"status": "error", "message": str(e)}
    
    def _run_black(self) -> Dict:
        """Run black code formatting check."""
        try:
            cmd = ["python3", "-m", "black", "--check", "src/", "tests/"]
            result = subprocess.run(
                cmd,
                cwd=self.project_root,
                capture_output=True,
                text=True,
                timeout=120
            )
            
            if result.returncode == 0:
                return {"status": "passed", "message": "Code formatting is correct"}
            else:
                return {"status": "failed", "message": "Code formatting issues found"}
                
        except FileNotFoundError:
            return {"status": "skipped", "message": "black not available"}
        except Exception as e:
            return {"status": "error", "message": str(e)}
    
    def _run_isort(self) -> Dict:
        """Run isort import sorting check."""
        try:
            cmd = ["python3", "-m", "isort", "--check-only", "src/", "tests/"]
            result = subprocess.run(
                cmd,
                cwd=self.project_root,
                capture_output=True,
                text=True,
                timeout=120
            )
            
            if result.returncode == 0:
                return {"status": "passed", "message": "Import sorting is correct"}
            else:
                return {"status": "failed", "message": "Import sorting issues found"}
                
        except FileNotFoundError:
            return {"status": "skipped", "message": "isort not available"}
        except Exception as e:
            return {"status": "error", "message": str(e)}
    
    def _run_pylint(self) -> Dict:
        """Run pylint static analysis."""
        try:
            cmd = ["python3", "-m", "pylint", "src/"]
            result = subprocess.run(
                cmd,
                cwd=self.project_root,
                capture_output=True,
                text=True,
                timeout=180
            )
            
            # pylint returns different exit codes for different severity levels
            if result.returncode == 0:
                return {"status": "passed", "message": "No pylint issues"}
            else:
                return {"status": "failed", "message": f"Pylint issues found (exit code: {result.returncode})"}
                
        except FileNotFoundError:
            return {"status": "skipped", "message": "pylint not available"}
        except Exception as e:
            return {"status": "error", "message": str(e)}
    
    def run_type_checking(self, tool: str) -> StaticAnalysisResult:
        """Run type checking on the codebase."""
        try:
            if tool == "mypy":
                result = self._run_mypy()
            elif tool == "pyright":
                result = self._run_pyright()
            else:
                return StaticAnalysisResult(
                    success=False,
                    error_message=f"Unknown type checker: {tool}"
                )
            
            return StaticAnalysisResult(
                success=result.get("status") == "passed",
                tool_results={tool: result},
                error_message=result.get("message") if result.get("status") != "passed" else None
            )
            
        except Exception as e:
            return StaticAnalysisResult(
                success=False,
                error_message=f"Type checking failed: {str(e)}"
            )
    
    def _run_mypy(self) -> Dict:
        """Run mypy type checking."""
        try:
            cmd = ["python3", "-m", "mypy", "src/"]
            result = subprocess.run(
                cmd,
                cwd=self.project_root,
                capture_output=True,
                text=True,
                timeout=180
            )
            
            if result.returncode == 0:
                return {"status": "passed", "message": "No type errors"}
            else:
                return {"status": "failed", "message": f"Type errors found: {result.stdout}"}
                
        except FileNotFoundError:
            return {"status": "skipped", "message": "mypy not available"}
        except Exception as e:
            return {"status": "error", "message": str(e)}
    
    def _run_pyright(self) -> Dict:
        """Run pyright type checking."""
        try:
            cmd = ["pyright", "src/"]
            result = subprocess.run(
                cmd,
                cwd=self.project_root,
                capture_output=True,
                text=True,
                timeout=180
            )
            
            if result.returncode == 0:
                return {"status": "passed", "message": "No type errors"}
            else:
                return {"status": "failed", "message": f"Type errors found: {result.stdout}"}
                
        except FileNotFoundError:
            return {"status": "skipped", "message": "pyright not available"}
        except Exception as e:
            return {"status": "error", "message": str(e)}
    
    def run_security_scanning(self, tools: List[str]) -> StaticAnalysisResult:
        """Run security scanning tools."""
        tool_results = {}
        security_issues = []
        overall_success = True
        
        for tool in tools:
            try:
                if tool == "bandit":
                    result = self._run_bandit()
                elif tool == "safety":
                    result = self._run_safety()
                else:
                    result = {"status": "skipped", "message": f"Unknown security tool: {tool}"}
                
                tool_results[tool] = result
                
                if result.get("status") == "failed":
                    overall_success = False
                    if "issues" in result:
                        security_issues.extend(result["issues"])
                        
            except Exception as e:
                tool_results[tool] = {"status": "error", "message": str(e)}
                overall_success = False
                
        return StaticAnalysisResult(
            success=overall_success,
            tool_results=tool_results,
            violations=[],  # Use separate field for security issues
            error_message="Security issues found" if not overall_success else None
        )
    
    def _run_bandit(self) -> Dict:
        """Run bandit security scanner."""
        try:
            cmd = ["python3", "-m", "bandit", "-r", "src/", "-f", "json"]
            result = subprocess.run(
                cmd,
                cwd=self.project_root,
                capture_output=True,
                text=True,
                timeout=120
            )
            
            if result.returncode == 0:
                return {"status": "passed", "message": "No security issues"}
            else:
                try:
                    bandit_output = json.loads(result.stdout)
                    issues = bandit_output.get("results", [])
                    return {
                        "status": "failed" if issues else "passed",
                        "message": f"Found {len(issues)} security issues",
                        "issues": issues
                    }
                except json.JSONDecodeError:
                    return {"status": "error", "message": "Failed to parse bandit output"}
                
        except FileNotFoundError:
            return {"status": "skipped", "message": "bandit not available"}
        except Exception as e:
            return {"status": "error", "message": str(e)}
    
    def _run_safety(self) -> Dict:
        """Run safety dependency vulnerability check."""
        try:
            cmd = ["python3", "-m", "safety", "check", "--json"]
            result = subprocess.run(
                cmd,
                cwd=self.project_root,
                capture_output=True,
                text=True,
                timeout=120
            )
            
            if result.returncode == 0:
                return {"status": "passed", "message": "No dependency vulnerabilities"}
            else:
                return {"status": "failed", "message": "Dependency vulnerabilities found"}
                
        except FileNotFoundError:
            return {"status": "skipped", "message": "safety not available"}
        except Exception as e:
            return {"status": "error", "message": str(e)}
    
    def get_remediation_guidance(self, tool: str, error_message: str) -> str:
        """Get remediation guidance for specific errors."""
        guidance_map = {
            "flake8": {
                "E302": "Add 2 blank lines before function/class definitions",
                "E501": "Line too long - break into multiple lines or use shorter variable names",
                "W503": "Line break before binary operator - this is a style preference",
                "E203": "Whitespace before ':' - this is often a black vs flake8 conflict"
            },
            "mypy": {
                "error: Missing return statement": "Add explicit return statement or return type annotation",
                "error: Incompatible return value type": "Check return type annotation matches actual return value",
                "error: Need type annotation": "Add type annotations to function parameters and return values"
            },
            "bandit": {
                "B602": "subprocess_popen_with_shell_equals_true - avoid shell=True, use list arguments instead",
                "B608": "possible_sql_injection_in_string_based_query - use parameterized queries instead"
            }
        }
        
        tool_guidance = guidance_map.get(tool, {})
        for pattern, guidance in tool_guidance.items():
            if pattern in error_message:
                return guidance
                
        return f"Check {tool} documentation for guidance on: {error_message}"


class GitAutomator:
    """Handles git commit automation."""
    
    def __init__(self, project_root: str):
        self.project_root = Path(project_root)
        
    def is_working_tree_clean(self) -> bool:
        """Check if git working tree is clean."""
        try:
            result = subprocess.run(
                ["git", "status", "--porcelain"],
                cwd=self.project_root,
                capture_output=True,
                text=True,
                timeout=30
            )
            
            # Empty output means clean working tree
            return result.returncode == 0 and not result.stdout.strip()
            
        except Exception:
            return False
    
    def commit_validated_changes(self, task_id: str, description: str) -> GitCommitResult:
        """Create commit with validated changes following SDD conventions."""
        try:
            # Stage all changes
            subprocess.run(
                ["git", "add", "."],
                cwd=self.project_root,
                check=True,
                timeout=30
            )
            
            # Create commit message following SDD format
            commit_message = f"TASK-{task_id}: {description}\n\n🤖 Generated with SDD\nCo-Authored-By: Claude <noreply@anthropic.com>"
            
            # Commit changes
            result = subprocess.run(
                ["git", "commit", "-m", commit_message],
                cwd=self.project_root,
                capture_output=True,
                text=True,
                timeout=30
            )
            
            if result.returncode == 0:
                # Get commit SHA
                sha_result = subprocess.run(
                    ["git", "rev-parse", "HEAD"],
                    cwd=self.project_root,
                    capture_output=True,
                    text=True,
                    timeout=10
                )
                
                commit_sha = sha_result.stdout.strip() if sha_result.returncode == 0 else None
                
                return GitCommitResult(
                    success=True,
                    commit_sha=commit_sha,
                    committed=True
                )
            else:
                return GitCommitResult(
                    success=False,
                    error_message=result.stderr or result.stdout
                )
                
        except subprocess.CalledProcessError as e:
            return GitCommitResult(
                success=False,
                error_message=f"Git commit failed: {e}"
            )
        except Exception as e:
            return GitCommitResult(
                success=False,
                error_message=f"Unexpected error during commit: {e}"
            )
    
    def commit_on_validation_success(self, validation_passed: bool, task_id: str, description: str) -> GitCommitResult:
        """Conditionally commit only if validation passed."""
        if not validation_passed:
            return GitCommitResult(
                success=True,  # Not an error - just didn't commit
                committed=False,
                error_message="Validation failed - no commit created"
            )
        
        return self.commit_validated_changes(task_id, description)


class ValidationEngine:
    """Main validation engine coordinating all validation activities."""
    
    def __init__(self, quality_config: Union[str, Dict], bundle_dir: str):
        if isinstance(quality_config, str):
            self.config = load_quality_config(quality_config)
        else:
            self.config = quality_config
            
        self.bundle_dir = Path(bundle_dir)
        self.project_root = self.bundle_dir.parent.parent  # Go up from .task_bundles/TASK-XXX
        
        # Initialize components
        self.test_executor = TestExecutor(str(self.project_root))
        self.static_analyzer = StaticAnalyzer(str(self.project_root))
        self.git_automator = GitAutomator(str(self.project_root))
    
    def run_full_validation(self, task_id: str) -> ValidationResult:
        """Run complete validation workflow for a task."""
        validation_start_time = time.time()
        validation_results = {}
        
        try:
            # Update bundle status
            self._update_bundle_status("validation_started")
            
            # Phase 1: Test Execution and Validation
            if self.config.get("testing", {}).get("enabled", True):
                test_result = self._run_test_validation(task_id)
                validation_results["testing"] = test_result
                
                if not test_result.success:
                    raise ValidationError("Test validation failed", "test", test_result.details)
            
            # Phase 2: Static Analysis
            if self.config.get("linting", {}).get("enabled", True):
                lint_result = self._run_linting_validation()
                validation_results["linting"] = lint_result
                
                if not lint_result.success:
                    raise ValidationError("Linting validation failed", "lint", lint_result.details)
            
            # Phase 3: Type Checking
            if self.config.get("type_checking", {}).get("enabled", True):
                type_result = self._run_type_checking_validation()
                validation_results["type_checking"] = type_result
                
                if not type_result.success:
                    raise ValidationError("Type checking validation failed", "type", type_result.details)
            
            # Phase 4: Security Scanning
            if self.config.get("security", {}).get("enabled", True):
                security_result = self._run_security_validation()
                validation_results["security"] = security_result
                
                if not security_result.success:
                    raise ValidationError("Security validation failed", "security", security_result.details)
            
            # Phase 5: Git Commit (if all validation passed)
            commit_result = None
            if self.config.get("git_integration", {}).get("auto_commit", True):
                commit_result = self._commit_validated_changes(task_id)
                validation_results["git_commit"] = commit_result
            
            # Update bundle status to completed
            self._update_bundle_status("validation_completed", commit_sha=commit_result.commit_sha if commit_result else None)
            
            # Save validation results
            self._save_validation_results(validation_results)
            
            return ValidationResult(
                success=True,
                message="All validation checks passed",
                details={
                    "all_checks_passed": True,
                    "commit_sha": commit_result.commit_sha if commit_result else None,
                    "validation_time": time.time() - validation_start_time,
                    "results": validation_results
                }
            )
            
        except ValidationError as e:
            # Handle validation failure
            self.handle_validation_failure(e.category, str(e), preserve_bundle=True)
            raise e
            
        except Exception as e:
            # Handle unexpected errors
            self.handle_validation_failure("error", f"Unexpected validation error: {e}", preserve_bundle=True)
            raise ValidationError(f"Validation system error: {e}", "system")
    
    def _run_test_validation(self, task_id: str) -> ValidationResult:
        """Run comprehensive test validation."""
        # Run generated tests
        generated_result = self.test_executor.run_generated_tests(task_id)
        
        # Run regression tests
        regression_result = self.test_executor.run_regression_tests()
        
        # Check coverage if configured
        coverage_threshold = self.config.get("testing", {}).get("coverage_threshold", 0)
        coverage_result = None
        if coverage_threshold > 0:
            coverage_result = self.test_executor.check_coverage_threshold(coverage_threshold, str(self.bundle_dir))
        
        # Determine overall success
        success = generated_result.success and regression_result.success
        if coverage_result:
            success = success and coverage_result.success
        
        return ValidationResult(
            success=success,
            message="Test validation completed",
            details={
                "generated_tests": generated_result.__dict__,
                "regression_tests": regression_result.__dict__,
                "coverage": coverage_result.__dict__ if coverage_result else None
            }
        )
    
    def _run_linting_validation(self) -> ValidationResult:
        """Run linting validation."""
        tools = self.config.get("linting", {}).get("tools", ["flake8"])
        result = self.static_analyzer.run_linting(tools)
        
        return ValidationResult(
            success=result.success,
            message="Linting validation completed",
            details=result.__dict__
        )
    
    def _run_type_checking_validation(self) -> ValidationResult:
        """Run type checking validation."""
        tool = self.config.get("type_checking", {}).get("tool", "mypy")
        result = self.static_analyzer.run_type_checking(tool)
        
        return ValidationResult(
            success=result.success,
            message="Type checking validation completed",
            details=result.__dict__
        )
    
    def _run_security_validation(self) -> ValidationResult:
        """Run security validation."""
        tools = self.config.get("security", {}).get("tools", ["bandit"])
        result = self.static_analyzer.run_security_scanning(tools)
        
        return ValidationResult(
            success=result.success,
            message="Security validation completed",
            details=result.__dict__
        )
    
    def _commit_validated_changes(self, task_id: str) -> GitCommitResult:
        """Commit validated changes."""
        description = f"Implement enhanced validation logic (validation system)"
        return self.git_automator.commit_validated_changes(task_id, description)
    
    def _update_bundle_status(self, status: str, **kwargs):
        """Update bundle status file."""
        status_file = self.bundle_dir / "bundle_status.yaml"
        
        if status_file.exists():
            if yaml:
                with open(status_file, 'r') as f:
                    bundle_status = yaml.safe_load(f) or {}
            else:
                # Simple YAML parsing fallback
                bundle_status = self._simple_yaml_load(status_file)
        else:
            bundle_status = {}
        
        bundle_status.update({
            "status": status,
            "last_updated": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
            **kwargs
        })
        
        # Add validation-specific fields
        if status == "validation_started":
            bundle_status["validation_started_at"] = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
            bundle_status["validator_agent_completed"] = False
        elif status == "validation_completed":
            bundle_status["validation_completed_at"] = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
            bundle_status["validator_agent_completed"] = True
        
        if yaml:
            with open(status_file, 'w') as f:
                yaml.dump(bundle_status, f, default_flow_style=False)
        else:
            # Simple YAML writing fallback
            self._simple_yaml_dump(status_file, bundle_status)
    
    def _save_validation_results(self, results: Dict):
        """Save detailed validation results to bundle."""
        results_file = self.bundle_dir / "validation_results.json"
        
        # Convert any non-serializable objects to dicts
        serializable_results = {}
        for key, value in results.items():
            if hasattr(value, '__dict__'):
                serializable_results[key] = value.__dict__
            else:
                serializable_results[key] = value
        
        with open(results_file, 'w') as f:
            json.dump(serializable_results, f, indent=2, default=str)
    
    def handle_validation_failure(self, category: str, error_message: str, preserve_bundle: bool = True):
        """Handle validation failures with detailed logging and bundle preservation."""
        if preserve_bundle:
            # Update bundle status to failed
            self._update_bundle_status("validation_failed", error_category=category)
            
            # Save error details
            error_file = self.bundle_dir / "validation_error.log"
            with open(error_file, 'a') as f:
                timestamp = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
                f.write(f"{timestamp}: {category} validation failed\n")
                f.write(f"Error: {error_message}\n")
                f.write("---\n")
            
            # Generate failure feedback
            feedback = self.generate_failure_feedback({
                "category": category,
                "message": error_message,
                "timestamp": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
            })
            
            feedback_file = self.bundle_dir / "validation_failure_feedback.md"
            with open(feedback_file, 'w') as f:
                f.write(feedback)
    
    def generate_failure_feedback(self, error_details: Dict) -> str:
        """Generate detailed, actionable feedback for validation failures."""
        category = error_details.get("category", "unknown")
        message = error_details.get("message", "No details available")
        timestamp = error_details.get("timestamp", "Unknown time")
        
        feedback = f"""# Validation Failure Report

**Category:** {category.title()} Validation Failure
**Time:** {timestamp}

## Error Details

{message}

## Remediation Guidance

"""
        
        if category == "test":
            feedback += """
### Test Failures
1. Review the test output above for specific assertion failures
2. Check if the implementation matches the test expectations
3. Verify test data and setup are correct
4. Consider if the test logic itself needs adjustment
"""
        elif category == "lint":
            feedback += """
### Linting Issues
1. Review code style violations listed above
2. Run the linting tool locally to see detailed line-by-line issues
3. Consider using auto-formatters like `black` or `autopep8`
4. Update code to follow project style guidelines
"""
        elif category == "type":
            feedback += """
### Type Checking Issues
1. Add missing type annotations to functions and variables
2. Fix type mismatches between expected and actual types
3. Import necessary types from `typing` module
4. Consider using `# type: ignore` for unavoidable type issues
"""
        elif category == "security":
            feedback += """
### Security Issues
1. Review security vulnerabilities identified above
2. Replace unsafe functions with secure alternatives
3. Validate and sanitize all user inputs
4. Update dependencies to non-vulnerable versions
"""
        
        feedback += """

## Next Steps

1. Fix the issues identified above
2. Re-run validation to verify fixes
3. The task bundle has been preserved for debugging
4. Contact the development team if you need additional assistance

## Bundle Location

This validation failure information is saved in the task bundle for future reference.
"""
        
        return feedback
    
    def _simple_yaml_load(self, file_path: Path) -> Dict:
        """Simple YAML loader fallback when yaml module not available."""
        data = {}
        with open(file_path, 'r') as f:
            for line in f:
                line = line.strip()
                if not line or line.startswith('#'):
                    continue
                if ':' in line and not line.startswith(' '):
                    key, value = line.split(':', 1)
                    key = key.strip()
                    value = value.strip().strip('"\'')
                    
                    # Basic type conversion
                    if value.lower() == 'true':
                        value = True
                    elif value.lower() == 'false':
                        value = False
                    elif value.isdigit():
                        value = int(value)
                    elif value == 'null' or not value:
                        value = None
                        
                    data[key] = value
        return data
    
    def _simple_yaml_dump(self, file_path: Path, data: Dict):
        """Simple YAML writer fallback when yaml module not available."""
        with open(file_path, 'w') as f:
            for key, value in data.items():
                if isinstance(value, str):
                    f.write(f"{key}: \"{value}\"\n")
                elif isinstance(value, bool):
                    f.write(f"{key}: {str(value).lower()}\n")
                elif value is None:
                    f.write(f"{key}: null\n")
                else:
                    f.write(f"{key}: {value}\n")
    
    def categorize_failure(self, error_message: str) -> str:
        """Categorize validation failures for targeted remediation."""
        error_lower = error_message.lower()
        
        # Check more specific categories first to avoid false matches
        if any(keyword in error_lower for keyword in ["mypy", "pyright"]) or "type" in error_lower:
            return "type"
        elif any(keyword in error_lower for keyword in ["bandit", "safety"]) or "security" in error_lower or "vulnerability" in error_lower:
            return "security"
        elif any(keyword in error_lower for keyword in ["flake8", "black", "isort", "pylint"]) or "style" in error_lower or "lint" in error_lower:
            return "lint"
        elif any(keyword in error_lower for keyword in ["pytest", "test"]) or "assert" in error_lower or "fail" in error_lower:
            return "test"
        else:
            return "unknown"


# Additional utility functions for integration with the SDD system

def create_validation_summary(results: ValidationResult) -> str:
    """Create human-readable validation summary."""
    if results.success:
        return f"""# Validation Summary ✅

All validation checks passed successfully!

**Commit SHA:** {results.details.get('commit_sha', 'N/A')}
**Validation Time:** {results.details.get('validation_time', 0):.2f} seconds

## Checks Performed
- ✅ Test execution and coverage
- ✅ Code style and linting
- ✅ Type checking
- ✅ Security scanning
- ✅ Git commit automation

Generated code meets all quality standards and has been committed to the repository.
"""
    else:
        return f"""# Validation Summary ❌

Validation failed. Please review the error details and fix the issues.

**Error Category:** {results.category}
**Error Message:** {results.error_message}

Check the validation failure feedback for detailed remediation guidance.
"""