#!/usr/bin/env python3
"""
Grammar-Ops Learning Tool

Learns naming patterns from existing codebases to generate smart configurations
and exception rules. This helps adopt grammar-ops without massive refactoring.
"""

import ast
import json
import re
import sys
from pathlib import Path
from typing import Dict, List, Set, Tuple, Optional
from collections import defaultdict, Counter
import argparse

# Add parent directory to path for imports
sys.path.insert(0, str(Path(__file__).parent.parent))

from lib.core import FrameworkDetector
from lib.analyzers import FunctionContext, AssignmentContext


class PatternLearner:
    """Learns naming patterns from existing code."""
    
    def __init__(self, project_root: Path):
        self.project_root = Path(project_root)
        self.framework_detector = FrameworkDetector(project_root)
        
        # Pattern collections
        self.function_patterns = defaultdict(list)
        self.constant_patterns = defaultdict(list)
        self.class_patterns = []
        self.module_patterns = []
        
        # Statistics
        self.stats = {
            'files_analyzed': 0,
            'functions': 0,
            'constants': 0,
            'classes': 0,
            'modules': 0
        }
        
        # Learned patterns
        self.learned_exceptions = {
            'functions': set(),
            'constants': set(),
            'patterns': {
                'cli_commands': set(),
                'response_factories': set(),
                'singletons': set(),
                'typevars': set()
            }
        }
    
    def learn_from_project(self):
        """Learn patterns from the entire project."""
        print(f"Learning patterns from {self.project_root}...")
        
        # Analyze Python files
        py_files = list(self.project_root.rglob("*.py"))
        for py_file in py_files:
            if self._should_skip_file(py_file):
                continue
            
            self._analyze_file(py_file)
            self.stats['files_analyzed'] += 1
        
        # Analyze module structure
        self._learn_module_patterns()
        
        # Process learned patterns
        self._process_patterns()
    
    def _should_skip_file(self, file_path: Path) -> bool:
        """Check if file should be skipped."""
        skip_dirs = {'.git', '__pycache__', 'node_modules', 'venv', '.env', 'migrations'}
        return any(skip_dir in file_path.parts for skip_dir in skip_dirs)
    
    def _analyze_file(self, file_path: Path):
        """Analyze a single file for patterns."""
        try:
            content = file_path.read_text(encoding='utf-8')
            tree = ast.parse(content)
            
            # Learn from different node types
            for node in ast.walk(tree):
                if isinstance(node, (ast.FunctionDef, ast.AsyncFunctionDef)):
                    self._learn_function_pattern(node, file_path)
                    self.stats['functions'] += 1
                
                elif isinstance(node, ast.ClassDef):
                    self._learn_class_pattern(node)
                    self.stats['classes'] += 1
                
                elif isinstance(node, ast.Assign):
                    self._learn_constant_pattern(node, file_path)
                    self.stats['constants'] += 1
        
        except Exception as e:
            print(f"Error analyzing {file_path}: {e}")
    
    def _learn_function_pattern(self, node: ast.FunctionDef, file_path: Path):
        """Learn from function naming patterns."""
        context = FunctionContext(node.name, node, file_path)
        
        # Categorize by context
        if context.context_type == 'cli_command':
            self.learned_exceptions['patterns']['cli_commands'].add(node.name)
        
        elif context.context_type == 'response_factory':
            self.learned_exceptions['patterns']['response_factories'].add(node.name)
        
        elif context.context_type == 'regular_function':
            # Check if it follows verb_noun pattern
            if not self._has_verb_prefix(node.name):
                self.learned_exceptions['functions'].add(node.name)
        
        # Store pattern
        self.function_patterns[context.context_type].append({
            'name': node.name,
            'decorators': context.decorators,
            'file': str(file_path.relative_to(self.project_root))
        })
    
    def _learn_constant_pattern(self, node: ast.Assign, file_path: Path):
        """Learn from constant naming patterns."""
        for target in node.targets:
            if isinstance(target, ast.Name):
                context = AssignmentContext(target.id, node.value, node, file_path)
                
                # Learn specific patterns
                if context.assignment_type == 'singleton':
                    self.learned_exceptions['patterns']['singletons'].add(
                        f"{target.id} = {context.value_str[:30]}"
                    )
                
                elif context.assignment_type == 'typevar':
                    self.learned_exceptions['patterns']['typevars'].add(target.id)
                
                elif context.assignment_type == 'constant':
                    # Check if it follows UPPER_CASE
                    if not target.id.isupper():
                        self.learned_exceptions['constants'].add(target.id)
                
                # Store pattern
                self.constant_patterns[context.assignment_type].append({
                    'name': target.id,
                    'type': context.assignment_type,
                    'value_preview': context.value_str[:50]
                })
    
    def _learn_class_pattern(self, node: ast.ClassDef):
        """Learn from class naming patterns."""
        self.class_patterns.append({
            'name': node.name,
            'bases': [ast.unparse(base) for base in node.bases],
            'is_exception': node.name.endswith('Exception') or node.name.endswith('Error')
        })
    
    def _learn_module_patterns(self):
        """Learn from module/package naming patterns."""
        py_files = list(self.project_root.rglob("*.py"))
        
        for py_file in py_files:
            if self._should_skip_file(py_file):
                continue
            
            module_name = py_file.stem
            if module_name != '__init__':
                self.module_patterns.append(module_name)
                self.stats['modules'] += 1
    
    def _has_verb_prefix(self, name: str) -> bool:
        """Check if name has a verb prefix."""
        verbs = ['get', 'set', 'create', 'update', 'delete', 'process', 
                'validate', 'check', 'handle', 'parse', 'build', 'load', 'save']
        return any(name.startswith(verb) for verb in verbs)
    
    def _process_patterns(self):
        """Process learned patterns to identify conventions."""
        # Identify CLI style
        cli_commands = self.learned_exceptions['patterns']['cli_commands']
        if cli_commands:
            # Check if Rails-style (single word) or verb-noun
            rails_style = sum(1 for cmd in cli_commands if '_' not in cmd)
            verb_noun_style = len(cli_commands) - rails_style
            
            if rails_style > verb_noun_style:
                self.cli_style = 'rails_style'
            else:
                self.cli_style = 'verb_noun'
    
    def generate_config(self) -> Dict:
        """Generate grammar-ops configuration based on learned patterns."""
        config = {
            "version": "2.0.0",
            "project": {
                "name": self.project_root.name,
                "type": "fullstack" if self.framework_detector.detected_frameworks else "library",
                "language": "python"  # Could be extended to detect mixed
            },
            "frameworks": {
                "auto_detect": True,
                "detected": list(self.framework_detector.detected_frameworks)
            },
            "rules": {
                "python": {
                    "functions": {
                        "require_verb_prefix": {
                            "enabled": True,
                            "exceptions": {
                                "cli_commands": getattr(self, 'cli_style', 'verb_noun'),
                                "test_functions": "test_prefix_only",
                                "response_factories": "noun_response_pattern" 
                                    if self.learned_exceptions['patterns']['response_factories'] 
                                    else "create_pattern"
                            }
                        }
                    },
                    "constants": {
                        "style": "UPPER_CASE",
                        "detect_singletons": True,
                        "allow_typevar": bool(self.learned_exceptions['patterns']['typevars'])
                    }
                }
            },
            "exceptions": {
                "functions": sorted(list(self.learned_exceptions['functions']))[:20],
                "constants": sorted(list(self.learned_exceptions['constants']))[:20],
                "patterns": {
                    "allow": self._generate_allow_patterns()
                }
            },
            "enforcement": {
                "level": "warning",
                "new_files_only": False,
                "gradual_adoption": {
                    "enabled": True,
                    "start_date": "2025-02-01"
                }
            }
        }
        
        return config
    
    def _generate_allow_patterns(self) -> List[str]:
        """Generate regex patterns for exceptions."""
        patterns = []
        
        # TypeVar patterns
        if self.learned_exceptions['patterns']['typevars']:
            patterns.append("^[A-Z] = TypeVar\\(")
        
        # Logger patterns
        if any('logger' in s for s in self.learned_exceptions['patterns']['singletons']):
            patterns.append("^logger = logging\\.getLogger")
        
        # Add framework-specific patterns
        for framework in self.framework_detector.detected_frameworks:
            if framework == 'fastapi':
                patterns.append("^app = FastAPI\\(")
                patterns.append("^router = APIRouter\\(")
            elif framework == 'flask':
                patterns.append("^app = Flask\\(")
        
        return patterns
    
    def generate_report(self) -> str:
        """Generate a learning report."""
        report = ["Pattern Learning Report", "=" * 50]
        
        report.append(f"\nProject: {self.project_root}")
        report.append(f"Files analyzed: {self.stats['files_analyzed']}")
        report.append(f"Functions: {self.stats['functions']}")
        report.append(f"Constants: {self.stats['constants']}")
        report.append(f"Classes: {self.stats['classes']}")
        report.append(f"Modules: {self.stats['modules']}")
        
        # Detected frameworks
        report.append(f"\nDetected Frameworks: {', '.join(self.framework_detector.detected_frameworks)}")
        
        # Function patterns
        report.append("\nFunction Patterns:")
        for context_type, patterns in self.function_patterns.items():
            if patterns:
                report.append(f"  {context_type}: {len(patterns)} functions")
                # Show examples
                for pattern in patterns[:3]:
                    report.append(f"    - {pattern['name']} ({pattern['file']})")
        
        # Constant patterns
        report.append("\nConstant Patterns:")
        for assign_type, patterns in self.constant_patterns.items():
            if patterns:
                report.append(f"  {assign_type}: {len(patterns)} assignments")
        
        # Learned exceptions
        report.append("\nLearned Exceptions:")
        report.append(f"  Functions without verb prefix: {len(self.learned_exceptions['functions'])}")
        report.append(f"  Constants not UPPER_CASE: {len(self.learned_exceptions['constants'])}")
        report.append(f"  CLI commands: {len(self.learned_exceptions['patterns']['cli_commands'])}")
        report.append(f"  Singletons: {len(self.learned_exceptions['patterns']['singletons'])}")
        
        # Recommendations
        report.append("\nRecommendations:")
        if hasattr(self, 'cli_style'):
            report.append(f"  - Use {self.cli_style} for CLI commands")
        
        if self.learned_exceptions['patterns']['typevars']:
            report.append("  - Allow TypeVar naming conventions")
        
        if len(self.learned_exceptions['functions']) > 50:
            report.append("  - Consider gradual adoption for function naming")
        
        return "\n".join(report)


def main():
    parser = argparse.ArgumentParser(
        description="Learn naming patterns from existing code"
    )
    parser.add_argument(
        "project_root",
        help="Path to project root directory"
    )
    parser.add_argument(
        "--output",
        "-o",
        default=".grammarops.learned.json",
        help="Output configuration file (default: .grammarops.learned.json)"
    )
    parser.add_argument(
        "--report",
        "-r",
        action="store_true",
        help="Generate detailed report"
    )
    
    args = parser.parse_args()
    
    # Learn from project
    learner = PatternLearner(Path(args.project_root))
    learner.learn_from_project()
    
    # Generate configuration
    config = learner.generate_config()
    
    # Save configuration
    output_path = Path(args.output)
    with open(output_path, 'w') as f:
        json.dump(config, f, indent=2)
    
    print(f"\nConfiguration saved to: {output_path}")
    
    # Generate report if requested
    if args.report:
        print("\n" + learner.generate_report())
    
    # Show summary
    print("\nSummary:")
    print(f"  Frameworks detected: {', '.join(config['frameworks']['detected'])}")
    print(f"  Function exceptions: {len(config['exceptions']['functions'])}")
    print(f"  Constant exceptions: {len(config['exceptions']['constants'])}")
    print(f"  Pattern rules: {len(config['exceptions']['patterns']['allow'])}")
    print("\nNext steps:")
    print("  1. Review the generated configuration")
    print("  2. Rename to .grammarops.config.json to use")
    print("  3. Run grammar-ops audit to see results")


if __name__ == "__main__":
    main()