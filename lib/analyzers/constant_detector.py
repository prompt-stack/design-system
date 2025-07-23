#!/usr/bin/env python3
"""
Smart Constant vs Instance Detector for Grammar-Ops

Distinguishes between true constants (should be UPPER_CASE) and
singleton instances, TypeVar declarations, and other valid lowercase patterns.
"""

import ast
import re
from typing import Optional, Dict, List, Tuple, Set
from pathlib import Path


class AssignmentContext:
    """Context for an assignment statement."""
    
    def __init__(self, target: str, value_node: ast.AST, node: ast.AST, file_path: Path):
        self.target = target
        self.value_node = value_node
        self.node = node
        self.file_path = file_path
        self.value_str = ast.unparse(value_node) if value_node else ""
        self.is_module_level = True  # Will be set by analyzer
        self.assignment_type = self._determine_type()
    
    def _determine_type(self) -> str:
        """Determine what type of assignment this is."""
        # TypeVar and related typing constructs
        if self._is_typevar():
            return 'typevar'
        
        # Singleton instance (framework objects)
        if self._is_singleton_instance():
            return 'singleton'
        
        # Logger instance
        if self._is_logger():
            return 'logger'
        
        # Configuration object
        if self._is_config_object():
            return 'config'
        
        # Compiled regex
        if self._is_compiled_regex():
            return 'regex'
        
        # Environment variable
        if self._is_env_var():
            return 'env_var'
        
        # Simple literal constant
        if self._is_literal_constant():
            return 'constant'
        
        # Collection constant
        if self._is_collection_constant():
            return 'collection_constant'
        
        # Default/unknown
        return 'unknown'
    
    def _is_typevar(self) -> bool:
        """Check if this is a TypeVar or similar typing construct."""
        patterns = [
            r'TypeVar\s*\(',
            r'ParamSpec\s*\(',
            r'TypeVarTuple\s*\(',
            r'NewType\s*\(',
            r'TypeAlias\s*=',
            r'type\s*\[',  # Python 3.12+ type syntax
        ]
        return any(re.search(pattern, self.value_str) for pattern in patterns)
    
    def _is_singleton_instance(self) -> bool:
        """Check if this is a singleton instance creation."""
        # Common framework singleton patterns
        singleton_patterns = [
            r'FastAPI\s*\(',
            r'Flask\s*\(',
            r'Typer\s*\(',
            r'APIRouter\s*\(',
            r'Blueprint\s*\(',
            r'Celery\s*\(',
            r'Redis\s*\(',
            r'create_app\s*\(',
            r'get_app\s*\(',
            r'declarative_base\s*\(',
            r'sessionmaker\s*\(',
            r'create_engine\s*\(',
        ]
        
        if isinstance(self.value_node, ast.Call):
            # It's a function/class call
            return any(re.search(pattern, self.value_str) for pattern in singleton_patterns)
        
        return False
    
    def _is_logger(self) -> bool:
        """Check if this is a logger instance."""
        logger_patterns = [
            r'logging\.getLogger',
            r'get_logger\s*\(',
            r'Logger\s*\(',
            r'getLogger\s*\(',
        ]
        return any(re.search(pattern, self.value_str) for pattern in logger_patterns)
    
    def _is_config_object(self) -> bool:
        """Check if this is a configuration object."""
        # Check if it's a dict/list with specific patterns
        if isinstance(self.value_node, (ast.Dict, ast.List)):
            # Common config names
            config_names = [
                'config', 'settings', 'options', 'params', 'defaults',
                'models', 'endpoints', 'routes', 'urls', 'paths'
            ]
            target_lower = self.target.lower()
            return any(name in target_lower for name in config_names)
        
        # Config class instantiation
        if 'Config(' in self.value_str or 'Settings(' in self.value_str:
            return True
        
        return False
    
    def _is_compiled_regex(self) -> bool:
        """Check if this is a compiled regular expression."""
        return 're.compile' in self.value_str or 'regex.compile' in self.value_str
    
    def _is_env_var(self) -> bool:
        """Check if this is reading an environment variable."""
        env_patterns = [
            r'os\.environ',
            r'os\.getenv',
            r'env\s*\[',
            r'getenv\s*\(',
        ]
        return any(re.search(pattern, self.value_str) for pattern in env_patterns)
    
    def _is_literal_constant(self) -> bool:
        """Check if this is a simple literal constant."""
        return isinstance(self.value_node, (ast.Constant, ast.Num, ast.Str))
    
    def _is_collection_constant(self) -> bool:
        """Check if this is a collection of constants."""
        if isinstance(self.value_node, (ast.List, ast.Tuple, ast.Set)):
            # Check if all elements are constants
            return all(isinstance(elt, (ast.Constant, ast.Num, ast.Str)) 
                      for elt in self.value_node.elts)
        elif isinstance(self.value_node, ast.Dict):
            # Check if all keys and values are constants
            return all(isinstance(k, (ast.Constant, ast.Num, ast.Str)) and
                      isinstance(v, (ast.Constant, ast.Num, ast.Str))
                      for k, v in zip(self.value_node.keys, self.value_node.values))
        return False


class SmartConstantAnalyzer:
    """Analyzes module-level assignments to distinguish constants from instances."""
    
    # Naming rules by assignment type
    TYPE_RULES = {
        'typevar': {
            'style': 'single_letter_or_pascal',
            'examples': ['T', 'K', 'V', 'TUser', 'TResponse'],
            'reason': 'TypeVar follows Python typing conventions'
        },
        'singleton': {
            'style': 'lowercase',
            'examples': ['app', 'router', 'db', 'cache'],
            'reason': 'Singleton instances use lowercase like any variable'
        },
        'logger': {
            'style': 'lowercase',
            'examples': ['logger', 'log', 'audit_logger'],
            'reason': 'Logger instances are variables, not constants'
        },
        'config': {
            'style': 'flexible',  # Can be UPPER or lower depending on mutability
            'examples': ['SETTINGS', 'config', 'DEFAULT_OPTIONS'],
            'reason': 'Config can be constant or mutable'
        },
        'regex': {
            'style': 'uppercase',
            'examples': ['EMAIL_PATTERN', 'URL_REGEX'],
            'reason': 'Compiled regexes are typically constants'
        },
        'env_var': {
            'style': 'flexible',  # Depends on usage
            'examples': ['DEBUG', 'api_key', 'DATABASE_URL'],
            'reason': 'Environment variables vary by convention'
        },
        'constant': {
            'style': 'uppercase',
            'examples': ['MAX_RETRIES', 'DEFAULT_TIMEOUT', 'PI'],
            'reason': 'True constants should be UPPER_CASE'
        },
        'collection_constant': {
            'style': 'uppercase',
            'examples': ['ALLOWED_METHODS', 'VALID_STATES'],
            'reason': 'Constant collections should be UPPER_CASE'
        }
    }
    
    def __init__(self, framework_detector=None):
        self.framework_detector = framework_detector
        self.issues: List[Dict] = []
        self.stats = {
            'total_assignments': 0,
            'by_type': {},
            'violations': 0,
            'auto_classified': 0
        }
    
    def analyze_file(self, file_path: Path) -> List[Dict]:
        """Analyze all module-level assignments in a file."""
        try:
            content = file_path.read_text(encoding='utf-8')
            tree = ast.parse(content)
            return self._analyze_module(tree, file_path)
        except Exception as e:
            return [{
                'file': str(file_path),
                'error': f'Failed to parse: {str(e)}'
            }]
    
    def _analyze_module(self, tree: ast.Module, file_path: Path) -> List[Dict]:
        """Analyze module-level assignments."""
        issues = []
        
        for node in tree.body:
            if isinstance(node, ast.Assign):
                # Simple assignment
                for target in node.targets:
                    if isinstance(target, ast.Name):
                        context = AssignmentContext(
                            target.id, node.value, node, file_path
                        )
                        issue = self._check_assignment(context)
                        if issue:
                            issues.append(issue)
                        
                        # Update stats
                        self.stats['total_assignments'] += 1
                        assignment_type = context.assignment_type
                        self.stats['by_type'][assignment_type] = \
                            self.stats['by_type'].get(assignment_type, 0) + 1
            
            elif isinstance(node, ast.AnnAssign) and isinstance(node.target, ast.Name):
                # Annotated assignment
                if node.value:  # Has a value
                    context = AssignmentContext(
                        node.target.id, node.value, node, file_path
                    )
                    issue = self._check_assignment(context)
                    if issue:
                        issues.append(issue)
        
        return issues
    
    def _check_assignment(self, context: AssignmentContext) -> Optional[Dict]:
        """Check if an assignment follows naming conventions."""
        name = context.target
        assignment_type = context.assignment_type
        
        # Unknown types need manual review
        if assignment_type == 'unknown':
            return None
        
        rule = self.TYPE_RULES[assignment_type]
        
        # Check naming style
        if rule['style'] == 'uppercase':
            if not self._is_uppercase(name):
                return self._create_issue(context, rule, 'should be UPPER_CASE')
        
        elif rule['style'] == 'lowercase':
            if not self._is_lowercase(name):
                self.stats['auto_classified'] += 1
                return self._create_issue(context, rule, 'should be lowercase')
        
        elif rule['style'] == 'single_letter_or_pascal':
            if not (len(name) == 1 and name.isupper()) and not self._is_pascal_case(name):
                return self._create_issue(context, rule, 'should be single letter or PascalCase')
        
        elif rule['style'] == 'flexible':
            # No strict rule, but track for stats
            self.stats['auto_classified'] += 1
            return None
        
        return None
    
    def _is_uppercase(self, name: str) -> bool:
        """Check if name is UPPER_CASE style."""
        return name.isupper() and '_' in name or (name.isupper() and len(name) > 1)
    
    def _is_lowercase(self, name: str) -> bool:
        """Check if name is lowercase style."""
        return name.islower() or '_' in name and name.replace('_', '').islower()
    
    def _is_pascal_case(self, name: str) -> bool:
        """Check if name is PascalCase."""
        return name[0].isupper() and not '_' in name and not name.isupper()
    
    def _create_issue(self, context: AssignmentContext, rule: Dict, message: str) -> Dict:
        """Create an issue report."""
        self.stats['violations'] += 1
        
        return {
            'file': str(context.file_path),
            'line': context.node.lineno,
            'name': context.target,
            'current_value': context.value_str[:50] + '...' if len(context.value_str) > 50 else context.value_str,
            'type': context.assignment_type,
            'issue': message,
            'rule': rule,
            'auto_fixable': self._can_auto_fix(context)
        }
    
    def _can_auto_fix(self, context: AssignmentContext) -> bool:
        """Check if this can be automatically fixed."""
        # TypeVars and singletons should not be auto-fixed
        if context.assignment_type in ['typevar', 'singleton', 'logger']:
            return False
        
        # Simple constants can be auto-fixed
        if context.assignment_type in ['constant', 'collection_constant', 'regex']:
            return True
        
        return False
    
    def get_report(self) -> str:
        """Generate analysis report."""
        report = ["Smart Constant Analysis Report", "=" * 50]
        
        report.append(f"\nTotal module-level assignments: {self.stats['total_assignments']}")
        report.append(f"Violations found: {self.stats['violations']}")
        report.append(f"Auto-classified: {self.stats['auto_classified']}")
        
        report.append("\nAssignments by type:")
        for assign_type, count in sorted(self.stats['by_type'].items()):
            percentage = (count / self.stats['total_assignments'] * 100) if self.stats['total_assignments'] > 0 else 0
            report.append(f"  {assign_type}: {count} ({percentage:.1f}%)")
        
        if self.issues:
            report.append(f"\nTop issues:")
            for issue in self.issues[:10]:
                report.append(f"\n{issue['file']}:{issue['line']}")
                report.append(f"  Name: {issue['name']}")
                report.append(f"  Type: {issue['type']}")
                report.append(f"  Issue: {issue['issue']}")
                report.append(f"  Value: {issue['current_value']}")
                if issue['auto_fixable']:
                    report.append(f"  Auto-fixable: Yes")
        
        return "\n".join(report)
    
    def generate_exceptions(self) -> Dict[str, List[str]]:
        """Generate exception patterns for valid lowercase assignments."""
        exceptions = {
            'singletons': [],
            'loggers': [],
            'typevars': []
        }
        
        for issue in self.issues:
            if issue['type'] == 'singleton':
                exceptions['singletons'].append(f"{issue['name']} = {issue['current_value']}")
            elif issue['type'] == 'logger':
                exceptions['loggers'].append(issue['name'])
            elif issue['type'] == 'typevar':
                exceptions['typevars'].append(f"{issue['name']} = TypeVar(")
        
        return exceptions


if __name__ == "__main__":
    import sys
    from framework_detector import detect_frameworks
    
    if len(sys.argv) < 2:
        print("Usage: constant-detector.py <project_root>")
        sys.exit(1)
    
    project_root = Path(sys.argv[1])
    
    # Detect frameworks first
    detector = detect_frameworks(project_root)
    
    # Analyze constants
    analyzer = SmartConstantAnalyzer(detector)
    
    # Analyze Python files
    py_files = list(project_root.rglob("*.py"))
    for py_file in py_files[:50]:  # Limit for demo
        if '.git' in py_file.parts or '__pycache__' in py_file.parts:
            continue
        analyzer.analyze_file(py_file)
    
    print(analyzer.get_report())
    
    # Generate exceptions
    print("\n" + "=" * 50)
    print("Suggested exceptions for .grammarops.exceptions.json:")
    exceptions = analyzer.generate_exceptions()
    for category, items in exceptions.items():
        if items:
            print(f"\n{category}:")
            for item in items[:5]:  # Show first 5
                print(f"  - {item}")