#!/usr/bin/env python3
"""
Framework Detection Module for Grammar-Ops

Detects common frameworks and libraries to apply appropriate naming conventions.
This allows grammar-ops to be context-aware and respect framework idioms.
"""

import ast
import re
from pathlib import Path
from typing import Dict, List, Set, Optional, Tuple


class FrameworkDetector:
    """Detects frameworks and libraries used in a Python project."""
    
    # Framework patterns and their associated idioms
    FRAMEWORK_PATTERNS = {
        'fastapi': {
            'imports': ['fastapi', 'FastAPI', 'APIRouter'],
            'singletons': {
                'app': 'FastAPI()',
                'router': 'APIRouter()'
            },
            'decorators': ['@app.', '@router.'],
            'idioms': {
                'response_factories': True,  # success_response, error_response
                'dependency_injection': True,  # Depends() pattern
            }
        },
        'django': {
            'imports': ['django', 'from django'],
            'patterns': ['urlpatterns', 'INSTALLED_APPS', 'MIDDLEWARE'],
            'special_names': ['Meta', 'DoesNotExist'],
            'idioms': {
                'meta_classes': True,
                'manager_methods': True,
            }
        },
        'flask': {
            'imports': ['flask', 'Flask'],
            'singletons': {
                'app': 'Flask(__name__)',
            },
            'decorators': ['@app.route'],
        },
        'typer': {
            'imports': ['typer', 'Typer'],
            'singletons': {
                'app': 'Typer()',
                'cli': 'Typer()',
            },
            'decorators': ['@app.command', '@cli.command'],
            'idioms': {
                'cli_style': 'rails',  # start, stop, build instead of verb_noun
            }
        },
        'click': {
            'imports': ['click'],
            'decorators': ['@click.command', '@click.group'],
            'idioms': {
                'cli_style': 'rails',
            }
        },
        'pytest': {
            'imports': ['pytest'],
            'decorators': ['@pytest.fixture', '@pytest.mark'],
            'idioms': {
                'fixture_names': 'noun',  # user, client, db
                'test_prefix': 'test_',
            }
        },
        'pydantic': {
            'imports': ['pydantic', 'BaseModel', 'Field'],
            'idioms': {
                'validator_names': True,  # @validator pattern
                'field_validators': True,
            }
        },
        'sqlalchemy': {
            'imports': ['sqlalchemy', 'declarative_base', 'sessionmaker'],
            'patterns': ['Base = declarative_base()', '__tablename__'],
            'idioms': {
                'table_models': True,
                'relationship_names': True,
            }
        }
    }
    
    # Typing patterns that should be recognized
    TYPING_PATTERNS = {
        'typevar': r'^[A-Z]\s*=\s*TypeVar\(',
        'paramspec': r'^[A-Z]\s*=\s*ParamSpec\(',
        'generic': r'^[A-Z]\s*=\s*(?:Type|List|Dict|Optional|Union|Generic)\[',
    }
    
    def __init__(self, project_root: Path):
        self.project_root = Path(project_root)
        self.detected_frameworks: Set[str] = set()
        self.framework_evidence: Dict[str, List[str]] = {}
        self._scan_project()
    
    def _scan_project(self):
        """Scan the project to detect frameworks."""
        py_files = list(self.project_root.rglob("*.py"))
        
        for py_file in py_files[:50]:  # Sample first 50 files for performance
            try:
                content = py_file.read_text(encoding='utf-8')
                self._analyze_file(content, py_file)
            except Exception:
                continue
    
    def _analyze_file(self, content: str, filepath: Path):
        """Analyze a single file for framework indicators."""
        # Check imports
        import_pattern = re.compile(r'^(?:from\s+(\S+)|import\s+(\S+))', re.MULTILINE)
        imports = import_pattern.findall(content)
        
        for framework, patterns in self.FRAMEWORK_PATTERNS.items():
            # Check import patterns
            if 'imports' in patterns:
                for imp in imports:
                    imp_str = imp[0] or imp[1]
                    if any(pattern in imp_str for pattern in patterns['imports']):
                        self.detected_frameworks.add(framework)
                        self._add_evidence(framework, f"Import found: {imp_str} in {filepath.name}")
            
            # Check code patterns
            if 'patterns' in patterns:
                for pattern in patterns['patterns']:
                    if pattern in content:
                        self.detected_frameworks.add(framework)
                        self._add_evidence(framework, f"Pattern found: {pattern} in {filepath.name}")
            
            # Check decorators
            if 'decorators' in patterns:
                for decorator in patterns['decorators']:
                    if decorator in content:
                        self.detected_frameworks.add(framework)
                        self._add_evidence(framework, f"Decorator found: {decorator} in {filepath.name}")
    
    def _add_evidence(self, framework: str, evidence: str):
        """Add evidence for framework detection."""
        if framework not in self.framework_evidence:
            self.framework_evidence[framework] = []
        self.framework_evidence[framework].append(evidence)
    
    def get_frameworks(self) -> Set[str]:
        """Get detected frameworks."""
        return self.detected_frameworks
    
    def get_idioms(self) -> Dict[str, any]:
        """Get combined idioms from all detected frameworks."""
        idioms = {}
        for framework in self.detected_frameworks:
            if framework in self.FRAMEWORK_PATTERNS:
                framework_idioms = self.FRAMEWORK_PATTERNS[framework].get('idioms', {})
                idioms.update(framework_idioms)
        return idioms
    
    def should_allow_singleton(self, name: str, value: str) -> bool:
        """Check if a singleton pattern should be allowed."""
        for framework in self.detected_frameworks:
            if framework in self.FRAMEWORK_PATTERNS:
                singletons = self.FRAMEWORK_PATTERNS[framework].get('singletons', {})
                if name in singletons:
                    # Check if the value matches the expected pattern
                    expected = singletons[name]
                    if expected in value:
                        return True
        return False
    
    def get_cli_style(self) -> str:
        """Get the preferred CLI command style."""
        idioms = self.get_idioms()
        return idioms.get('cli_style', 'verb_noun')  # Default to verb_noun
    
    def is_typing_pattern(self, line: str) -> bool:
        """Check if a line matches a typing pattern."""
        for pattern_type, regex in self.TYPING_PATTERNS.items():
            if re.match(regex, line.strip()):
                return True
        return False
    
    def get_report(self) -> str:
        """Generate a detection report."""
        report = ["Framework Detection Report", "=" * 50]
        
        if self.detected_frameworks:
            report.append(f"\nDetected Frameworks: {', '.join(sorted(self.detected_frameworks))}")
            report.append("\nEvidence:")
            for framework in sorted(self.detected_frameworks):
                if framework in self.framework_evidence:
                    report.append(f"\n{framework}:")
                    for evidence in self.framework_evidence[framework][:3]:  # Show first 3
                        report.append(f"  - {evidence}")
                    if len(self.framework_evidence[framework]) > 3:
                        report.append(f"  ... and {len(self.framework_evidence[framework]) - 3} more")
        else:
            report.append("\nNo frameworks detected")
        
        idioms = self.get_idioms()
        if idioms:
            report.append("\nActive Idioms:")
            for key, value in idioms.items():
                report.append(f"  - {key}: {value}")
        
        return "\n".join(report)


def detect_frameworks(project_root: str) -> FrameworkDetector:
    """Main entry point for framework detection."""
    return FrameworkDetector(Path(project_root))


if __name__ == "__main__":
    import sys
    
    if len(sys.argv) < 2:
        print("Usage: framework-detector.py <project_root>")
        sys.exit(1)
    
    detector = detect_frameworks(sys.argv[1])
    print(detector.get_report())