#!/usr/bin/env python3
"""
Enhanced Error Reporter for Grammar-Ops

Provides context-aware, helpful error messages with actionable suggestions.
"""

import json
from pathlib import Path
from typing import Dict, List, Optional, Tuple
from datetime import datetime
import textwrap


class EnhancedReporter:
    """Generate enhanced error reports with context and suggestions."""
    
    # ANSI color codes for terminal output
    COLORS = {
        'reset': '\033[0m',
        'bold': '\033[1m',
        'red': '\033[91m',
        'green': '\033[92m',
        'yellow': '\033[93m',
        'blue': '\033[94m',
        'magenta': '\033[95m',
        'cyan': '\033[96m',
        'gray': '\033[90m'
    }
    
    # Emoji indicators
    EMOJI = {
        'error': '❌',
        'warning': '⚠️',
        'info': 'ℹ️',
        'success': '✅',
        'suggestion': '💡',
        'context': '📍',
        'file': '📄',
        'function': '🔧',
        'constant': '📌',
        'question': '❓'
    }
    
    def __init__(self, config: Optional[Dict] = None, use_color: bool = True):
        self.config = config or {}
        self.use_color = use_color
    
    def format_function_issue(self, issue: Dict) -> str:
        """Format a function naming issue with context."""
        lines = []
        
        # Header with file location
        file_path = Path(issue['file'])
        relative_path = file_path.name  # Could make relative to project root
        
        lines.append(f"\n{self._emoji('file')} {self._bold(relative_path)}:{issue['line']}")
        lines.append(f"{self._emoji('function')} Function: {self._code(issue['function'])}")
        
        # Context information
        context_info = self._get_context_info(issue['context'])
        lines.append(f"{self._emoji('context')} Context: {self._info(context_info['description'])}")
        
        # Issue description
        lines.append(f"{self._emoji('error')} Issue: {self._error(issue['issue'])}")
        
        # Detailed explanation based on context
        if issue['context'] == 'cli_command':
            lines.append(self._format_cli_command_explanation(issue))
        elif issue['context'] == 'test_function':
            lines.append(self._format_test_function_explanation(issue))
        elif issue['context'] == 'response_factory':
            lines.append(self._format_factory_explanation(issue))
        else:
            lines.append(self._format_regular_function_explanation(issue))
        
        # Suggestion if available
        if issue.get('suggestion'):
            lines.append(f"\n{self._emoji('suggestion')} Suggestion:")
            lines.append(f"  Rename to: {self._success(issue['suggestion'])}")
        
        # Show decorators if relevant
        if issue.get('decorators'):
            lines.append(f"\n  Decorators: {', '.join(self._code(d) for d in issue['decorators'])}")
        
        # Quick fix options
        lines.append(f"\n  {self._emoji('question')} Options:")
        lines.extend(self._format_fix_options(issue))
        
        return '\n'.join(lines)
    
    def format_constant_issue(self, issue: Dict) -> str:
        """Format a constant naming issue with context."""
        lines = []
        
        # Header
        file_path = Path(issue['file'])
        lines.append(f"\n{self._emoji('file')} {self._bold(file_path.name)}:{issue['line']}")
        lines.append(f"{self._emoji('constant')} Constant: {self._code(issue['name'])}")
        
        # Type and value preview
        lines.append(f"{self._emoji('context')} Type: {self._info(issue['type'])}")
        lines.append(f"  Value: {self._gray(issue['current_value'])}")
        
        # Issue
        lines.append(f"{self._emoji('error')} Issue: {self._error(issue['issue'])}")
        
        # Context-specific explanation
        if issue['type'] == 'singleton':
            lines.append(self._format_singleton_explanation(issue))
        elif issue['type'] == 'typevar':
            lines.append(self._format_typevar_explanation(issue))
        elif issue['type'] == 'logger':
            lines.append(self._format_logger_explanation(issue))
        else:
            lines.append(self._format_constant_explanation(issue))
        
        # Options
        lines.append(f"\n  {self._emoji('question')} Options:")
        lines.extend(self._format_constant_fix_options(issue))
        
        return '\n'.join(lines)
    
    def _get_context_info(self, context: str) -> Dict:
        """Get human-friendly context information."""
        contexts = {
            'cli_command': {
                'description': 'CLI Command',
                'explanation': 'Command-line interface commands often use Rails-style naming'
            },
            'test_function': {
                'description': 'Test Function',
                'explanation': 'Test functions already have test_ prefix'
            },
            'response_factory': {
                'description': 'Response Factory',
                'explanation': 'Factory functions that create response objects'
            },
            'api_endpoint': {
                'description': 'API Endpoint Handler',
                'explanation': 'HTTP endpoint handlers should indicate the action'
            },
            'pytest_fixture': {
                'description': 'Pytest Fixture',
                'explanation': 'Fixtures represent resources, not actions'
            },
            'event_handler': {
                'description': 'Event Handler',
                'explanation': 'Event handlers already have action prefixes'
            },
            'property': {
                'description': 'Property',
                'explanation': 'Properties are attributes, not actions'
            },
            'regular_function': {
                'description': 'Regular Function',
                'explanation': 'Standard functions should indicate what action they perform'
            }
        }
        
        return contexts.get(context, {
            'description': context,
            'explanation': 'Function context not recognized'
        })
    
    def _format_cli_command_explanation(self, issue: Dict) -> str:
        """Format explanation for CLI command issues."""
        return textwrap.dedent(f"""
        {self._gray('CLI commands traditionally use one of two styles:')}
        {self._gray('  1. Rails-style:')} {self._code('start')}, {self._code('stop')}, {self._code('build')}
        {self._gray('  2. Verb-noun style:')} {self._code('start_server')}, {self._code('stop_server')}
        
        {self._gray('Your project appears to use Rails-style based on detected patterns.')}
        """).strip()
    
    def _format_test_function_explanation(self, issue: Dict) -> str:
        """Format explanation for test function issues."""
        return textwrap.dedent(f"""
        {self._gray('Test functions already have')} {self._code('test_')} {self._gray('as their verb prefix.')}
        {self._gray('The current name')} {self._code(issue['function'])} {self._gray('follows testing conventions.')}
        """).strip()
    
    def _format_factory_explanation(self, issue: Dict) -> str:
        """Format explanation for factory function issues."""
        return textwrap.dedent(f"""
        {self._gray('Response factory functions follow constructor naming patterns:')}
        {self._gray('  • Pattern:')} {self._code('noun_response()')} {self._gray('returns a Response object')}
        {self._gray('  • Reads naturally:')} {self._code('return success_response(data)')}
        """).strip()
    
    def _format_regular_function_explanation(self, issue: Dict) -> str:
        """Format explanation for regular function issues."""
        name = issue['function']
        return textwrap.dedent(f"""
        {self._gray('Function')} {self._code(name)} {self._gray('should start with a verb to indicate its action.')}
        {self._gray('This makes code more readable and self-documenting.')}
        """).strip()
    
    def _format_singleton_explanation(self, issue: Dict) -> str:
        """Format explanation for singleton issues."""
        return textwrap.dedent(f"""
        {self._gray('This is a singleton instance, not a constant.')}
        {self._gray('Framework objects like')} {self._code('app = FastAPI()')} {self._gray('use lowercase by convention.')}
        """).strip()
    
    def _format_typevar_explanation(self, issue: Dict) -> str:
        """Format explanation for TypeVar issues."""
        return textwrap.dedent(f"""
        {self._gray('TypeVar follows Python typing conventions:')}
        {self._gray('  • Single letter:')} {self._code('T = TypeVar("T")')}
        {self._gray('  • Descriptive:')} {self._code('TUser = TypeVar("TUser")')}
        """).strip()
    
    def _format_logger_explanation(self, issue: Dict) -> str:
        """Format explanation for logger issues."""
        return textwrap.dedent(f"""
        {self._gray('Logger instances are variables, not constants.')}
        {self._gray('Standard pattern:')} {self._code('logger = logging.getLogger(__name__)')}
        """).strip()
    
    def _format_constant_explanation(self, issue: Dict) -> str:
        """Format explanation for regular constant issues."""
        return textwrap.dedent(f"""
        {self._gray('Constants should use UPPER_CASE naming convention.')}
        {self._gray('This clearly distinguishes them from variables.')}
        """).strip()
    
    def _format_fix_options(self, issue: Dict) -> List[str]:
        """Format fix options for function issues."""
        options = []
        
        if issue.get('suggestion'):
            options.append(f"    1. {self._success('Accept suggestion')}: Rename to {self._code(issue['suggestion'])}")
        
        options.append(f"    2. {self._info('Add exception')}: Add {self._code(issue['function'])} to .grammarops.exceptions.json")
        
        if issue['context'] == 'cli_command':
            options.append(f"    3. {self._info('Change style')}: Configure CLI style in .grammarops.config.json")
        
        options.append(f"    4. {self._gray('Skip')}: Leave as-is for now")
        
        return options
    
    def _format_constant_fix_options(self, issue: Dict) -> List[str]:
        """Format fix options for constant issues."""
        options = []
        
        if issue['type'] in ['singleton', 'logger', 'typevar']:
            options.append(f"    1. {self._info('Add exception')}: This is a valid {issue['type']}")
            exception_pattern = self._get_exception_pattern(issue)
            if exception_pattern:
                options.append(f"       Add pattern: {self._code(exception_pattern)}")
        else:
            suggested_name = issue['name'].upper().replace('-', '_')
            options.append(f"    1. {self._success('Rename')}: Change to {self._code(suggested_name)}")
        
        options.append(f"    2. {self._gray('Skip')}: Leave as-is")
        
        return options
    
    def _get_exception_pattern(self, issue: Dict) -> Optional[str]:
        """Get exception pattern for the issue."""
        if issue['type'] == 'singleton':
            return f"{issue['name']} = {issue['current_value']}"
        elif issue['type'] == 'typevar':
            return f"^{issue['name']} = TypeVar\\\\("
        elif issue['type'] == 'logger':
            return f"^{issue['name']} = logging\\\\.getLogger"
        return None
    
    def generate_summary(self, all_issues: Dict) -> str:
        """Generate a summary report."""
        lines = []
        
        lines.append(f"\n{self._bold('Grammar-Ops Analysis Summary')}")
        lines.append("=" * 50)
        
        total = sum(len(issues) for issues in all_issues.values())
        
        if total == 0:
            lines.append(f"\n{self._emoji('success')} {self._success('No issues found!')}")
            lines.append(self._gray("Your code follows all configured naming conventions."))
        else:
            lines.append(f"\n{self._emoji('info')} Total issues: {self._bold(str(total))}")
            
            # Breakdown by type
            for issue_type, issues in all_issues.items():
                if issues:
                    lines.append(f"  • {issue_type.title()}: {len(issues)}")
            
            # Context breakdown for functions
            if 'functions' in all_issues and all_issues['functions']:
                context_counts = {}
                for issue in all_issues['functions']:
                    ctx = issue.get('context', 'unknown')
                    context_counts[ctx] = context_counts.get(ctx, 0) + 1
                
                lines.append(f"\n{self._bold('Function contexts:')}")
                for ctx, count in sorted(context_counts.items()):
                    ctx_info = self._get_context_info(ctx)
                    lines.append(f"  • {ctx_info['description']}: {count}")
            
            # Recommendations
            lines.append(f"\n{self._emoji('suggestion')} {self._bold('Recommendations:')}")
            lines.extend(self._generate_recommendations(all_issues))
        
        # Timestamp
        lines.append(f"\n{self._gray(f'Report generated: {datetime.now().strftime("%Y-%m-%d %H:%M:%S")}')}")
        
        return '\n'.join(lines)
    
    def _generate_recommendations(self, all_issues: Dict) -> List[str]:
        """Generate smart recommendations based on issues."""
        recommendations = []
        
        # Check for patterns
        func_issues = all_issues.get('functions', [])
        const_issues = all_issues.get('constants', [])
        
        # CLI command pattern
        cli_commands = [i for i in func_issues if i.get('context') == 'cli_command']
        if len(cli_commands) > 3:
            recommendations.append(
                f"  • {self._info('CLI Style')}: Found {len(cli_commands)} CLI commands. "
                f"Consider setting {self._code('\"cli_commands\": \"rails_style\"')} in config."
            )
        
        # Singleton pattern
        singletons = [i for i in const_issues if i.get('type') == 'singleton']
        if singletons:
            recommendations.append(
                f"  • {self._info('Singletons')}: Found {len(singletons)} singleton instances. "
                f"These are valid lowercase names."
            )
        
        # TypeVar pattern
        typevars = [i for i in const_issues if i.get('type') == 'typevar']
        if typevars:
            recommendations.append(
                f"  • {self._info('TypeVars')}: Found {len(typevars)} TypeVar declarations. "
                f"Add {self._code('\"allow_typevar\": true')} to config."
            )
        
        # Gradual adoption
        if len(func_issues) + len(const_issues) > 50:
            recommendations.append(
                f"  • {self._warning('Gradual Adoption')}: With {len(func_issues) + len(const_issues)} issues, "
                f"consider gradual adoption. Use {self._code('grammar-ops-migrate.py')} for assistance."
            )
        
        return recommendations
    
    # Color/style helpers
    def _bold(self, text: str) -> str:
        return f"{self.COLORS['bold']}{text}{self.COLORS['reset']}" if self.use_color else text
    
    def _error(self, text: str) -> str:
        return f"{self.COLORS['red']}{text}{self.COLORS['reset']}" if self.use_color else text
    
    def _success(self, text: str) -> str:
        return f"{self.COLORS['green']}{text}{self.COLORS['reset']}" if self.use_color else text
    
    def _warning(self, text: str) -> str:
        return f"{self.COLORS['yellow']}{text}{self.COLORS['reset']}" if self.use_color else text
    
    def _info(self, text: str) -> str:
        return f"{self.COLORS['blue']}{text}{self.COLORS['reset']}" if self.use_color else text
    
    def _code(self, text: str) -> str:
        return f"{self.COLORS['cyan']}{text}{self.COLORS['reset']}" if self.use_color else f"`{text}`"
    
    def _gray(self, text: str) -> str:
        return f"{self.COLORS['gray']}{text}{self.COLORS['reset']}" if self.use_color else text
    
    def _emoji(self, name: str) -> str:
        return self.EMOJI.get(name, '') if self.use_color else ''


# Example usage in other scripts
def enhance_error_reporting(issues: Dict, config: Optional[Dict] = None) -> None:
    """Enhanced error reporting for grammar-ops tools."""
    reporter = EnhancedReporter(config)
    
    # Show individual issues
    if 'functions' in issues:
        for issue in issues['functions'][:10]:  # Limit to first 10
            print(reporter.format_function_issue(issue))
    
    if 'constants' in issues:
        for issue in issues['constants'][:10]:  # Limit to first 10
            print(reporter.format_constant_issue(issue))
    
    # Show summary
    print(reporter.generate_summary(issues))


if __name__ == "__main__":
    # Demo the enhanced reporter
    sample_issues = {
        'functions': [
            {
                'file': '/project/cli.py',
                'line': 42,
                'function': 'start',
                'context': 'cli_command',
                'issue': 'Missing verb prefix',
                'suggestion': 'start_service',
                'decorators': ['@cli.command()']
            },
            {
                'file': '/project/test_user.py',
                'line': 15,
                'function': 'test_user_can_login',
                'context': 'test_function',
                'issue': 'Missing verb prefix',
                'decorators': []
            }
        ],
        'constants': [
            {
                'file': '/project/app.py',
                'line': 10,
                'name': 'app',
                'type': 'singleton',
                'issue': 'should be UPPER_CASE',
                'current_value': 'FastAPI()',
                'auto_fixable': False
            },
            {
                'file': '/project/types.py',
                'line': 5,
                'name': 'T',
                'type': 'typevar',
                'issue': 'should be UPPER_CASE',
                'current_value': 'TypeVar("T")',
                'auto_fixable': False
            }
        ]
    }
    
    reporter = EnhancedReporter()
    
    # Show sample outputs
    print(reporter.format_function_issue(sample_issues['functions'][0]))
    print(reporter.format_constant_issue(sample_issues['constants'][0]))
    print(reporter.generate_summary(sample_issues))