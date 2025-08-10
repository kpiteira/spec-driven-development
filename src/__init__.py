"""
SDD Validation System Package

Enhanced validation logic for Spec-Driven Development (SDD) tasks.
Implements comprehensive validation including tests, linting, type checking,
and security scanning with automated git commit functionality.
"""

__version__ = "1.0.0"

from .validation_system import (
    ValidationEngine,
    TestExecutor,
    StaticAnalyzer, 
    GitAutomator,
    ValidationError,
    ValidationResult,
    TestResult,
    StaticAnalysisResult,
    GitCommitResult,
    load_quality_config,
    create_validation_summary
)

__all__ = [
    "ValidationEngine",
    "TestExecutor", 
    "StaticAnalyzer",
    "GitAutomator",
    "ValidationError",
    "ValidationResult", 
    "TestResult",
    "StaticAnalysisResult",
    "GitCommitResult",
    "load_quality_config",
    "create_validation_summary"
]