#!/usr/bin/env python3
"""
Grammar-Ops Migration Tool

Helps migrate existing codebases to grammar-ops conventions gradually.
Supports interactive fixing, safe transformations, and rollback.
"""

import ast
import json
import shutil
import argparse
import sys
from pathlib import Path
from datetime import datetime
from typing import Dict, List, Tuple, Optional, Set
import difflib

# Add parent directory to path for imports
sys.path.insert(0, str(Path(__file__).parent.parent))

from lib.core import FrameworkDetector
from lib.analyzers import ContextAwareFunctionAnalyzer, SmartConstantAnalyzer


class CodeMigrator:
    """Handles code migration to grammar-ops conventions."""
    
    def __init__(self, project_root: Path, config_path: Optional[Path] = None):
        self.project_root = Path(project_root)
        self.config = self._load_config(config_path)
        self.framework_detector = FrameworkDetector(project_root)
        
        # Migration state
        self.backup_dir = self.project_root / '.grammar-ops-backup'
        self.migration_log = []
        self.fixed_files = set()
        self.skipped_files = set()
        
        # Analyzers
        self.function_analyzer = ContextAwareFunctionAnalyzer(self.framework_detector)
        self.constant_analyzer = SmartConstantAnalyzer(self.framework_detector)
    
    def _load_config(self, config_path: Optional[Path]) -> Dict:
        """Load grammar-ops configuration."""
        if config_path and config_path.exists():
            with open(config_path) as f:
                return json.load(f)
        
        # Look for default locations
        default_paths = [
            self.project_root / '.grammarops.config.json',
            self.project_root / '.grammarops.learned.json',
            self.project_root / 'grammar-ops.json'
        ]
        
        for path in default_paths:
            if path.exists():
                with open(path) as f:
                    return json.load(f)
        
        # Return minimal config
        return {
            "rules": {
                "python": {
                    "functions": {"require_verb_prefix": {"enabled": True}},
                    "constants": {"style": "UPPER_CASE"}
                }
            },
            "enforcement": {"level": "warning"}
        }
    
    def analyze(self, file_pattern: str = "**/*.py") -> Dict:
        """Analyze files and identify needed changes."""
        print(f"Analyzing {self.project_root} with pattern: {file_pattern}")
        
        issues = {
            'functions': [],
            'constants': [],
            'total': 0
        }
        
        py_files = list(self.project_root.glob(file_pattern))
        
        for py_file in py_files:
            if self._should_skip_file(py_file):
                continue
            
            # Analyze functions
            func_issues = self.function_analyzer.analyze_file(py_file)
            issues['functions'].extend(func_issues)
            
            # Analyze constants
            const_issues = self.constant_analyzer.analyze_file(py_file)
            issues['constants'].extend(const_issues)
        
        issues['total'] = len(issues['functions']) + len(issues['constants'])
        return issues
    
    def _should_skip_file(self, file_path: Path) -> bool:
        """Check if file should be skipped."""
        skip_patterns = self.config.get('paths', {}).get('exclude', [])
        skip_patterns.extend(['.git', '__pycache__', 'migrations', '.grammar-ops-backup'])
        
        return any(pattern in str(file_path) for pattern in skip_patterns)
    
    def migrate_interactive(self, issues: Dict, dry_run: bool = False):
        """Interactively migrate code with user confirmation."""
        if not issues['total']:
            print("No issues found!")
            return
        
        print(f"\nFound {issues['total']} issues to fix")
        print("=" * 50)
        
        # Create backup directory
        if not dry_run:
            self.backup_dir.mkdir(exist_ok=True)
        
        # Group issues by file
        files_to_fix = self._group_issues_by_file(issues)
        
        for file_path, file_issues in files_to_fix.items():
            self._migrate_file_interactive(Path(file_path), file_issues, dry_run)
    
    def _group_issues_by_file(self, issues: Dict) -> Dict[str, List]:
        """Group all issues by file."""
        files_to_fix = {}
        
        for func_issue in issues['functions']:
            file_path = func_issue['file']
            if file_path not in files_to_fix:
                files_to_fix[file_path] = []
            files_to_fix[file_path].append(('function', func_issue))
        
        for const_issue in issues['constants']:
            file_path = const_issue['file']
            if file_path not in files_to_fix:
                files_to_fix[file_path] = []
            files_to_fix[file_path].append(('constant', const_issue))
        
        return files_to_fix
    
    def _migrate_file_interactive(self, file_path: Path, issues: List[Tuple], dry_run: bool):
        """Migrate a single file interactively."""
        print(f"\n{file_path.relative_to(self.project_root)}")
        print("-" * len(str(file_path.relative_to(self.project_root))))
        
        # Read file content
        original_content = file_path.read_text()
        modified_content = original_content
        
        # Sort issues by line number (reverse order to avoid offset issues)
        issues.sort(key=lambda x: x[1].get('line', 0), reverse=True)
        
        changes_made = []
        
        for issue_type, issue in issues:
            if issue_type == 'function' and issue.get('can_auto_fix'):
                # Show the issue
                print(f"\nLine {issue['line']}: Function '{issue['function']}'")
                print(f"  Context: {issue['context']}")
                print(f"  Issue: {issue['issue']}")
                
                if issue.get('suggestion'):
                    print(f"  Suggestion: {issue['function']} → {issue['suggestion']}")
                    
                    # Show diff preview
                    self._show_diff_preview(
                        modified_content,
                        issue['function'],
                        issue['suggestion'],
                        issue['line']
                    )
                    
                    # Ask user
                    response = self._ask_user("Apply this fix?", ['y', 'n', 's', 'q'])
                    
                    if response == 'y':
                        modified_content = self._apply_function_fix(
                            modified_content,
                            issue['function'],
                            issue['suggestion']
                        )
                        changes_made.append(f"Renamed {issue['function']} to {issue['suggestion']}")
                    elif response == 's':
                        print("Skipped")
                    elif response == 'q':
                        print("Quitting migration")
                        return
            
            elif issue_type == 'constant' and issue.get('auto_fixable'):
                print(f"\nLine {issue['line']}: Constant '{issue['name']}'")
                print(f"  Type: {issue['type']}")
                print(f"  Issue: {issue['issue']}")
                
                suggestion = self._suggest_constant_name(issue['name'])
                print(f"  Suggestion: {issue['name']} → {suggestion}")
                
                # Show diff preview
                self._show_diff_preview(
                    modified_content,
                    issue['name'],
                    suggestion,
                    issue['line']
                )
                
                # Ask user
                response = self._ask_user("Apply this fix?", ['y', 'n', 's', 'q'])
                
                if response == 'y':
                    modified_content = self._apply_constant_fix(
                        modified_content,
                        issue['name'],
                        suggestion
                    )
                    changes_made.append(f"Renamed {issue['name']} to {suggestion}")
                elif response == 's':
                    print("Skipped")
                elif response == 'q':
                    print("Quitting migration")
                    return
        
        # Save changes if any were made
        if changes_made and not dry_run:
            # Backup original
            backup_path = self.backup_dir / file_path.relative_to(self.project_root)
            backup_path.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(file_path, backup_path)
            
            # Write modified content
            file_path.write_text(modified_content)
            
            self.fixed_files.add(str(file_path))
            self.migration_log.append({
                'file': str(file_path.relative_to(self.project_root)),
                'changes': changes_made,
                'timestamp': datetime.now().isoformat()
            })
            
            print(f"\n✓ Fixed {len(changes_made)} issues")
        else:
            self.skipped_files.add(str(file_path))
    
    def _show_diff_preview(self, content: str, old_name: str, new_name: str, line_num: int):
        """Show a diff preview of the change."""
        lines = content.splitlines()
        
        # Find the actual line (line numbers are 1-indexed)
        if 0 <= line_num - 1 < len(lines):
            old_line = lines[line_num - 1]
            # Simple replacement for preview
            new_line = old_line.replace(old_name, new_name, 1)
            
            print("\n  Diff preview:")
            print(f"  - {old_line.strip()}")
            print(f"  + {new_line.strip()}")
    
    def _ask_user(self, prompt: str, options: List[str]) -> str:
        """Ask user for input."""
        options_str = "/".join(options)
        while True:
            response = input(f"\n  {prompt} ({options_str}): ").lower()
            if response in options:
                return response
            print(f"  Please enter one of: {options_str}")
    
    def _apply_function_fix(self, content: str, old_name: str, new_name: str) -> str:
        """Apply function renaming fix."""
        # Use regex for more precise replacement
        import re
        
        # Replace function definition
        pattern = rf'\bdef\s+{re.escape(old_name)}\s*\('
        content = re.sub(pattern, f'def {new_name}(', content)
        
        # Replace function calls (basic - could be improved)
        pattern = rf'\b{re.escape(old_name)}\s*\('
        content = re.sub(pattern, f'{new_name}(', content)
        
        return content
    
    def _apply_constant_fix(self, content: str, old_name: str, new_name: str) -> str:
        """Apply constant renaming fix."""
        import re
        
        # Replace constant definition and usage
        pattern = rf'\b{re.escape(old_name)}\b'
        content = re.sub(pattern, new_name, content)
        
        return content
    
    def _suggest_constant_name(self, name: str) -> str:
        """Suggest UPPER_CASE version of constant name."""
        # Convert camelCase or lowercase to UPPER_CASE
        import re
        
        # Insert underscores before capitals
        s1 = re.sub('(.)([A-Z][a-z]+)', r'\1_\2', name)
        # Insert underscores before number sequences
        s2 = re.sub('([a-z0-9])([A-Z])', r'\1_\2', s1)
        # Convert to uppercase
        return s2.upper()
    
    def rollback(self):
        """Rollback all changes made during migration."""
        if not self.backup_dir.exists():
            print("No backup found!")
            return
        
        print(f"\nRolling back {len(self.fixed_files)} files...")
        
        for file_path in self.fixed_files:
            original = Path(file_path)
            backup = self.backup_dir / original.relative_to(self.project_root)
            
            if backup.exists():
                shutil.copy2(backup, original)
                print(f"  Restored: {original.relative_to(self.project_root)}")
        
        # Clean up backup directory
        shutil.rmtree(self.backup_dir)
        print("\n✓ Rollback complete!")
    
    def save_migration_log(self):
        """Save migration log for reference."""
        log_path = self.project_root / '.grammar-ops-migration.log'
        
        with open(log_path, 'w') as f:
            json.dump({
                'migration_date': datetime.now().isoformat(),
                'files_fixed': len(self.fixed_files),
                'files_skipped': len(self.skipped_files),
                'changes': self.migration_log
            }, f, indent=2)
        
        print(f"\nMigration log saved to: {log_path}")


def main():
    parser = argparse.ArgumentParser(
        description="Migrate code to grammar-ops conventions"
    )
    parser.add_argument(
        "project_root",
        help="Path to project root directory"
    )
    parser.add_argument(
        "--config",
        "-c",
        help="Path to grammar-ops configuration file"
    )
    parser.add_argument(
        "--pattern",
        "-p",
        default="**/*.py",
        help="File pattern to migrate (default: **/*.py)"
    )
    parser.add_argument(
        "--dry-run",
        "-d",
        action="store_true",
        help="Show what would be changed without modifying files"
    )
    parser.add_argument(
        "--auto",
        "-a",
        action="store_true",
        help="Automatically apply all safe fixes without asking"
    )
    parser.add_argument(
        "--rollback",
        "-r",
        action="store_true",
        help="Rollback previous migration"
    )
    
    args = parser.parse_args()
    
    # Create migrator
    migrator = CodeMigrator(
        Path(args.project_root),
        Path(args.config) if args.config else None
    )
    
    # Handle rollback
    if args.rollback:
        migrator.rollback()
        return
    
    # Analyze project
    print("Analyzing project...")
    issues = migrator.analyze(args.pattern)
    
    if not issues['total']:
        print("No issues found!")
        return
    
    # Show summary
    print(f"\nFound {issues['total']} issues:")
    print(f"  Functions: {len(issues['functions'])}")
    print(f"  Constants: {len(issues['constants'])}")
    
    # Migrate
    if args.auto:
        print("\nAuto-migration not yet implemented")
        # TODO: Implement auto migration
    else:
        migrator.migrate_interactive(issues, args.dry_run)
    
    # Save log
    if not args.dry_run and migrator.fixed_files:
        migrator.save_migration_log()
        
        print(f"\nMigration complete!")
        print(f"  Files fixed: {len(migrator.fixed_files)}")
        print(f"  Files skipped: {len(migrator.skipped_files)}")
        print(f"\nTo rollback: {sys.argv[0]} {args.project_root} --rollback")


if __name__ == "__main__":
    main()