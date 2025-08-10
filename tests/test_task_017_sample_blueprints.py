#!/usr/bin/env python3
"""
Integration test for TASK-017: Create Sample Task Blueprints

This test verifies that all 4 sample task blueprints are created correctly
and follow the exact SDD task blueprint template structure.
"""

import unittest
import os
import re
import json
from pathlib import Path


class TestSampleTaskBlueprints(unittest.TestCase):
    """Test that all sample task blueprints are created and properly formatted"""
    
    def setUp(self):
        """Set up test environment"""
        self.project_dir = Path(__file__).parent.parent
        self.sample_tasks_dir = self.project_dir / "project_sdd_on_claude" / "sample_tasks"
        self.template_path = self.project_dir / "specs" / "templates" / "5_Task_Blueprint_Template.md"
        
        # Expected sample blueprint files based on the 4 behavior categories
        self.expected_samples = {
            "SAMPLE-CLI-001_Create_Help_Command.md": "CLI Command Implementation Sample",
            "SAMPLE-AGENT-001_Create_Formatter_Agent.md": "Agent Development Sample", 
            "SAMPLE-INTEGRATION-001_Add_Logging_Integration.md": "Integration/Workflow Sample",
            "SAMPLE-VALIDATION-001_Add_Performance_Testing.md": "Validation/Enhancement Sample"
        }
        
        # Read template for structure validation
        self.template_content = self.template_path.read_text()
        
    def test_behavior_1_diverse_task_blueprint_coverage(self):
        """Test Behavior 1: Sample blueprints cover new features, bug fixes, refactoring, and integrations"""
        # Given: The need to test various development scenarios
        # When: Sample task blueprints are created
        # Then: They must cover different development patterns
        
        for filename, category in self.expected_samples.items():
            file_path = self.sample_tasks_dir / filename
            self.assertTrue(file_path.exists(), 
                          f"Sample blueprint {filename} does not exist for {category}")
            
            content = file_path.read_text()
            
            # And: Blueprints must follow exact SDD task blueprint template structure
            self.assertIn("## 1. Task Overview & Goal", content)
            self.assertIn("## 2. The Contract: Requirements & Test Cases", content)
            self.assertIn("## 3. Context Bundle (Agent-Populated Sibling Files)", content)
            self.assertIn("## 4. Verification Context", content)
            
            # And: Each blueprint must have realistic Given/When/Then acceptance criteria
            self.assertRegex(content, r'\* \*\*Behavior \d+:.*\*\*')
            self.assertIn("Given:", content)
            self.assertIn("When:", content)
            self.assertIn("Then:", content)
            
            # And: Task scenarios must be appropriate for testing without external dependencies
            self.assertNotIn("external API", content.lower())
            self.assertNotIn("database connection", content.lower())
            self.assertNotIn("network request", content.lower())
    
    def test_behavior_2_blueprint_quality_and_completeness(self):
        """Test Behavior 2: Each sample blueprint has complete YAML frontmatter and clear descriptions"""
        # Given: Each sample task blueprint is created
        # When: Blueprints are validated for completeness
        
        for filename in self.expected_samples.keys():
            file_path = self.sample_tasks_dir / filename
            content = file_path.read_text()
            
            # Extract YAML frontmatter
            yaml_match = re.search(r'^---\n(.*?)\n---', content, re.MULTILINE | re.DOTALL)
            self.assertIsNotNone(yaml_match, f"No YAML frontmatter found in {filename}")
            
            yaml_text = yaml_match.group(1)
            # Simple YAML parsing for basic key-value pairs (sufficient for our frontmatter)
            yaml_content = {}
            for line in yaml_text.strip().split('\n'):
                if ':' in line and not line.strip().startswith('#'):
                    key, value = line.split(':', 1)
                    yaml_content[key.strip()] = value.strip().strip('"\'') if value.strip() else None
            
            # Then: Each must include all required YAML frontmatter fields with appropriate values
            required_fields = ["id", "title", "milestone_id", "requirement_id", "slice", "status", "branch"]
            for field in required_fields:
                self.assertIn(field, yaml_content, f"Missing {field} in {filename} frontmatter")
                self.assertIsNotNone(yaml_content[field], f"Empty {field} in {filename} frontmatter")
            
            # And: Task descriptions must be clear, specific, and implementable
            self.assertIn("**What it is:**", content)
            self.assertIn("**Goal:**", content)
            
            # And: Acceptance criteria must be testable and specific
            behaviors = re.findall(r'\* \*\*Behavior \d+:.*?\*\*', content)
            self.assertGreaterEqual(len(behaviors), 3, f"At least 3 behaviors required in {filename}")
            
            # And: Context bundle requirements must be realistic and achievable
            self.assertIn("bundle_architecture.md", content)
            self.assertIn("bundle_security.md", content)
            self.assertIn("bundle_code_context.md", content)
    
    def test_behavior_3_testing_scenario_representation(self):
        """Test Behavior 3: Sample blueprints test successful workflow and error scenarios"""
        # Given: The need to validate different workflow paths and failure scenarios
        # When: Sample blueprints are designed
        
        all_content = ""
        for filename in self.expected_samples.keys():
            file_path = self.sample_tasks_dir / filename
            content = file_path.read_text()
            all_content += content
        
        # Then: They must include scenarios that test successful workflow execution
        self.assertIn("successful", all_content.lower())
        self.assertIn("valid", all_content.lower())
        
        # And: Some blueprints must test error handling and recovery workflows
        error_keywords = ["error", "invalid", "failure", "exception", "malformed"]
        found_error_scenarios = any(keyword in all_content.lower() for keyword in error_keywords)
        self.assertTrue(found_error_scenarios, "No error handling scenarios found in sample blueprints")
        
        # And: Blueprints must cover different complexity levels
        complexity_indicators = ["simple", "complex", "basic", "advanced", "enhanced"]
        found_complexity_levels = sum(1 for keyword in complexity_indicators if keyword in all_content.lower())
        self.assertGreaterEqual(found_complexity_levels, 2, "Sample blueprints should cover different complexity levels")
        
        # And: Each blueprint must be self-contained without external dependencies
        for filename in self.expected_samples.keys():
            file_path = self.sample_tasks_dir / filename
            content = file_path.read_text()
            
            # Check for external dependency indicators
            external_indicators = ["external service", "third-party API", "database server", "network connection"]
            for indicator in external_indicators:
                self.assertNotIn(indicator, content.lower(), 
                               f"External dependency '{indicator}' found in {filename}")
    
    def test_behavior_4_documentation_and_example_value(self):
        """Test Behavior 4: Blueprints serve as effective learning examples with clear organization"""
        # Given: Sample blueprints will serve as learning examples
        # When: Blueprints are created and organized
        
        # Then: Each must include clear documentation explaining what it demonstrates
        for filename, category in self.expected_samples.items():
            file_path = self.sample_tasks_dir / filename
            content = file_path.read_text()
            
            # Should clearly explain what the sample demonstrates
            self.assertIn("demonstrates", content.lower())
            self.assertIn("example", content.lower())
            
            # Should have educational value
            educational_indicators = ["learn", "understand", "pattern", "approach", "methodology"]
            found_educational = any(indicator in content.lower() for indicator in educational_indicators)
            self.assertTrue(found_educational, f"No educational indicators found in {filename}")
        
        # And: Blueprints must be organized logically for easy discovery
        self.assertTrue(self.sample_tasks_dir.exists(), "Sample tasks directory must exist")
        
        # Check for README file explaining organization
        readme_path = self.sample_tasks_dir / "README.md"
        if readme_path.exists():
            readme_content = readme_path.read_text()
            self.assertIn("sample", readme_content.lower())
            self.assertIn("blueprint", readme_content.lower())
        
        # And: Examples must represent realistic development tasks
        for filename in self.expected_samples.keys():
            file_path = self.sample_tasks_dir / filename
            content = file_path.read_text()
            
            # Should reference actual development activities
            dev_activities = ["create", "implement", "build", "develop", "generate", "add", "enhance"]
            found_activities = sum(1 for activity in dev_activities if activity in content.lower())
            self.assertGreaterEqual(found_activities, 2, f"Insufficient development activities in {filename}")
        
        # And: Blueprint collection must serve as training material
        total_samples = len(list(self.sample_tasks_dir.glob("SAMPLE-*.md")))
        self.assertGreaterEqual(total_samples, 4, "Must have at least 4 sample blueprints for comprehensive training")

    def test_blueprint_template_compliance(self):
        """Verify all sample blueprints strictly follow the template structure"""
        template_sections = [
            "## 1. Task Overview & Goal",
            "## 2. The Contract: Requirements & Test Cases", 
            "## 3. Context Bundle (Agent-Populated Sibling Files)",
            "## 4. Verification Context"
        ]
        
        for filename in self.expected_samples.keys():
            file_path = self.sample_tasks_dir / filename
            if file_path.exists():
                content = file_path.read_text()
                
                for section in template_sections:
                    self.assertIn(section, content, 
                                f"Missing required section '{section}' in {filename}")
    
    def test_frontmatter_format_compliance(self):
        """Verify YAML frontmatter follows exact template requirements"""
        for filename in self.expected_samples.keys():
            file_path = self.sample_tasks_dir / filename
            if file_path.exists():
                content = file_path.read_text()
                
                # Check YAML frontmatter structure
                self.assertTrue(content.startswith("---\n"), f"{filename} must start with YAML frontmatter")
                
                yaml_match = re.search(r'^---\n(.*?)\n---', content, re.MULTILINE | re.DOTALL)
                yaml_text = yaml_match.group(1)
                yaml_content = {}
                for line in yaml_text.strip().split('\n'):
                    if ':' in line and not line.strip().startswith('#'):
                        key, value = line.split(':', 1)
                        yaml_content[key.strip()] = value.strip().strip('"\'') if value.strip() else None
                
                # Verify ID format
                self.assertRegex(yaml_content["id"], r"SAMPLE-[A-Z]+-\d+", 
                               f"Invalid ID format in {filename}")
                
                # Verify branch format
                self.assertRegex(yaml_content["branch"], r"feature/SAMPLE-[A-Z]+-\d+-.+", 
                               f"Invalid branch format in {filename}")
                
                # Verify status
                self.assertEqual(yaml_content["status"], "pending", 
                               f"Status should be 'pending' in {filename}")


if __name__ == "__main__":
    unittest.main(verbosity=2)