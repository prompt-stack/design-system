#!/usr/bin/env python3
"""
Context-Aware Function Analyzer for Grammar-Ops

Analyzes function context to determine appropriate naming conventions.
Recognizes patterns like CLI commands, test functions, factories, etc.
"""

import ast
import re
from typing import Optional, Dict, List, Tuple, Set
from pathlib import Path


class FunctionContext:
    """Represents the context of a function."""
    
    def __init__(self, name: str, node: ast.FunctionDef, file_path: Path):
        self.name = name
        self.node = node
        self.file_path = file_path
        self.decorators: List[str] = []
        self.returns_type: Optional[str] = None
        self.docstring: Optional[str] = None
        self.is_method = False
        self.is_async = isinstance(node, ast.AsyncFunctionDef)
        self.parent_class: Optional[str] = None
        self._analyze()
    
    def _analyze(self):
        """Analyze the function node to extract context."""
        # Extract decorators
        for decorator in self.node.decorator_list:
            self.decorators.append(ast.unparse(decorator))
        
        # Extract return type if annotated
        if self.node.returns:
            self.returns_type = ast.unparse(self.node.returns)
        
        # Extract docstring
        if (self.node.body and 
            isinstance(self.node.body[0], ast.Expr) and
            isinstance(self.node.body[0].value, ast.Constant)):
            self.docstring = self.node.body[0].value.value
    
    @property
    def context_type(self) -> str:
        """Determine the function's context type."""
        # Test function
        if self.name.startswith('test_'):
            return 'test_function'
        
        # CLI command
        if any('@cli.command' in d or '@app.command' in d or 
               '@click.command' in d for d in self.decorators):
            return 'cli_command'
        
        # API endpoint
        if any('@app.' in d or '@router.' in d for d in self.decorators):
            return 'api_endpoint'
        
        # Pytest fixture
        if any('@pytest.fixture' in d for d in self.decorators):
            return 'pytest_fixture'
        
        # Property
        if any('@property' in d for d in self.decorators):
            return 'property'
        
        # Response factory
        if (self.name.endswith('_response') and 
            self.returns_type and 'Response' in self.returns_type):
            return 'response_factory'
        
        # Event handler
        if self.name.startswith('on_') or self.name.startswith('handle_'):
            return 'event_handler'
        
        # Validator (Pydantic style)
        if any('@validator' in d or '@field_validator' in d for d in self.decorators):
            return 'validator'
        
        # Boolean check
        if self.name.startswith('is_') or self.name.startswith('has_'):
            return 'boolean_check'
        
        # Getter
        if self.name.startswith('get_'):
            return 'getter'
        
        # Special method
        if self.name.startswith('__') and self.name.endswith('__'):
            return 'special_method'
        
        # Method in test class
        if self.parent_class and 'Test' in self.parent_class:
            return 'test_method'
        
        return 'regular_function'


class ContextAwareFunctionAnalyzer:
    """Analyzes functions with awareness of their context."""
    
    # Naming rules by context
    CONTEXT_RULES = {
        'test_function': {
            'require_verb_prefix': False,
            'pattern': 'test_*',
            'example': 'test_user_can_login',
            'reason': 'Test functions use test_ as their prefix'
        },
        'cli_command': {
            'require_verb_prefix': 'optional',
            'styles': ['rails', 'verb_noun'],
            'rails_example': 'start, stop, build',
            'verb_noun_example': 'start_server, stop_server, build_project',
            'reason': 'CLI commands often follow Rails-style naming'
        },
        'api_endpoint': {
            'require_verb_prefix': True,
            'pattern': 'verb_resource',
            'example': 'get_users, create_user, update_user',
            'reason': 'API endpoints should clearly indicate the action'
        },
        'pytest_fixture': {
            'require_verb_prefix': False,
            'pattern': 'noun',
            'example': 'user, client, database',
            'reason': 'Fixtures represent objects/resources'
        },
        'property': {
            'require_verb_prefix': False,
            'pattern': 'noun or adjective',
            'example': 'name, is_active, total_count',
            'reason': 'Properties are attributes, not actions'
        },
        'response_factory': {
            'require_verb_prefix': 'optional',
            'pattern': 'noun_response or create_noun_response',
            'example': 'success_response, error_response',
            'reason': 'Factory pattern - the function name describes what it creates'
        },
        'event_handler': {
            'require_verb_prefix': True,
            'pattern': 'on_event or handle_event',
            'example': 'on_click, handle_request',
            'reason': 'Event handlers already have action prefixes'
        },
        'validator': {
            'require_verb_prefix': 'optional',
            'pattern': 'validate_field or field_must_be',
            'example': 'validate_email, email_must_be_unique',
            'reason': 'Validators describe constraints'
        },
        'boolean_check': {
            'require_verb_prefix': True,
            'pattern': 'is_* or has_*',
            'example': 'is_valid, has_permission',
            'reason': 'Boolean checks already have verb prefixes'
        },
        'getter': {
            'require_verb_prefix': True,
            'pattern': 'get_*',
            'example': 'get_user, get_config',
            'reason': 'Getters already have verb prefix'
        },
        'special_method': {
            'require_verb_prefix': False,
            'pattern': '__method__',
            'example': '__init__, __str__, __repr__',
            'reason': 'Python special methods have fixed names'
        },
        'regular_function': {
            'require_verb_prefix': True,
            'pattern': 'verb_noun',
            'example': 'process_data, validate_input',
            'reason': 'Regular functions should indicate action'
        }
    }
    
    def __init__(self, framework_detector=None):
        self.framework_detector = framework_detector
        self.issues: List[Dict] = []
        self.stats = {
            'total_functions': 0,
            'by_context': {},
            'violations': 0,
            'exceptions_applied': 0
        }
    
    def analyze_file(self, file_path: Path) -> List[Dict]:
        """Analyze all functions in a file."""
        try:
            content = file_path.read_text(encoding='utf-8')
            tree = ast.parse(content)
            return self._analyze_node(tree, file_path)
        except Exception as e:
            return [{
                'file': str(file_path),
                'error': f'Failed to parse: {str(e)}'
            }]
    
    def _analyze_node(self, node: ast.AST, file_path: Path, 
                     parent_class: Optional[str] = None) -> List[Dict]:
        """Recursively analyze AST nodes."""
        issues = []
        
        for child in ast.walk(node):
            if isinstance(child, (ast.FunctionDef, ast.AsyncFunctionDef)):
                context = FunctionContext(child.name, child, file_path)
                if parent_class:
                    context.parent_class = parent_class
                    context.is_method = True
                
                issue = self._check_function(context)
                if issue:
                    issues.append(issue)
                
                # Update stats
                self.stats['total_functions'] += 1
                ctx_type = context.context_type
                self.stats['by_context'][ctx_type] = self.stats['by_context'].get(ctx_type, 0) + 1
            
            elif isinstance(child, ast.ClassDef):
                # Recursively analyze methods in classes
                class_issues = self._analyze_node(child, file_path, child.name)
                issues.extend(class_issues)
        
        return issues
    
    def _check_function(self, context: FunctionContext) -> Optional[Dict]:
        """Check if a function follows naming conventions for its context."""
        rule = self.CONTEXT_RULES[context.context_type]
        
        # Check if verb prefix is required
        if rule['require_verb_prefix'] is False:
            return None  # No violation
        
        if rule['require_verb_prefix'] is True:
            if context.context_type == 'boolean_check':
                # Already has is_ or has_ prefix
                return None
            elif context.context_type == 'getter':
                # Already has get_ prefix
                return None
            elif not self._has_verb_prefix(context.name):
                return self._create_issue(context, rule)
        
        elif rule['require_verb_prefix'] == 'optional':
            # Check framework preferences
            if context.context_type == 'cli_command':
                cli_style = self._get_cli_style()
                if cli_style == 'rails':
                    # Rails style is OK without verb prefix
                    self.stats['exceptions_applied'] += 1
                    return None
            elif context.context_type == 'response_factory':
                # Factory pattern is OK
                self.stats['exceptions_applied'] += 1
                return None
        
        # Default check
        if not self._has_verb_prefix(context.name) and rule['require_verb_prefix']:
            return self._create_issue(context, rule)
        
        return None
    
    def _has_verb_prefix(self, name: str) -> bool:
        """Check if function name starts with a verb."""
        # Common verb prefixes
        verbs = [
            'get', 'set', 'create', 'update', 'delete', 'remove', 'add',
            'process', 'validate', 'check', 'verify', 'ensure', 'handle',
            'parse', 'format', 'convert', 'transform', 'build', 'generate',
            'load', 'save', 'read', 'write', 'fetch', 'send', 'receive',
            'start', 'stop', 'run', 'execute', 'perform', 'calculate',
            'is', 'has', 'can', 'should', 'will', 'must'
        ]
        
        name_lower = name.lower()
        return any(name_lower.startswith(verb + '_') or name_lower == verb 
                  for verb in verbs)
    
    def _get_cli_style(self) -> str:
        """Get CLI style preference from framework detector."""
        if self.framework_detector:
            return self.framework_detector.get_cli_style()
        return 'verb_noun'  # Default
    
    def _create_issue(self, context: FunctionContext, rule: Dict) -> Dict:
        """Create an issue report for a naming violation."""
        self.stats['violations'] += 1
        
        suggestion = self._suggest_name(context)
        
        return {
            'file': str(context.file_path),
            'line': context.node.lineno,
            'function': context.name,
            'context': context.context_type,
            'issue': 'Missing verb prefix',
            'rule': rule,
            'suggestion': suggestion,
            'decorators': context.decorators,
            'can_auto_fix': suggestion is not None
        }
    
    def _suggest_name(self, context: FunctionContext) -> Optional[str]:
        """Suggest a better name based on context."""
        name = context.name
        
        # Don't suggest for special contexts
        if context.context_type in ['special_method', 'property']:
            return None
        
        # Try to infer action from docstring or return type
        if context.docstring:
            doc_lower = context.docstring.lower()
            if 'return' in doc_lower or 'get' in doc_lower:
                return f'get_{name}'
            elif 'create' in doc_lower:
                return f'create_{name}'
            elif 'check' in doc_lower or 'validate' in doc_lower:
                return f'validate_{name}'
        
        # Default suggestions by context
        if context.context_type == 'regular_function':
            return f'process_{name}'
        elif context.context_type == 'api_endpoint':
            return f'handle_{name}'
        
        return None
    
    def get_report(self) -> str:
        """Generate analysis report."""
        report = ["Context-Aware Function Analysis Report", "=" * 50]
        
        report.append(f"\nTotal functions analyzed: {self.stats['total_functions']}")
        report.append(f"Violations found: {self.stats['violations']}")
        report.append(f"Exceptions applied: {self.stats['exceptions_applied']}")
        
        report.append("\nFunctions by context:")
        for ctx_type, count in sorted(self.stats['by_context'].items()):
            report.append(f"  {ctx_type}: {count}")
        
        if self.issues:
            report.append(f"\nTop issues:")
            for issue in self.issues[:10]:
                report.append(f"\n{issue['file']}:{issue['line']}")
                report.append(f"  Function: {issue['function']}")
                report.append(f"  Context: {issue['context']}")
                report.append(f"  Issue: {issue['issue']}")
                if issue['suggestion']:
                    report.append(f"  Suggestion: {issue['function']} → {issue['suggestion']}")
        
        return "\n".join(report)


if __name__ == "__main__":
    import sys
    from framework_detector import detect_frameworks
    
    if len(sys.argv) < 2:
        print("Usage: context-analyzer.py <project_root>")
        sys.exit(1)
    
    project_root = Path(sys.argv[1])
    
    # Detect frameworks first
    detector = detect_frameworks(project_root)
    print("Detecting frameworks...")
    print(detector.get_report())
    print("\n" + "=" * 50 + "\n")
    
    # Analyze functions with context
    analyzer = ContextAwareFunctionAnalyzer(detector)
    
    # Analyze Python files
    py_files = list(project_root.rglob("*.py"))
    for py_file in py_files:
        if '.git' in py_file.parts or '__pycache__' in py_file.parts:
            continue
        analyzer.analyze_file(py_file)
    
    print(analyzer.get_report())