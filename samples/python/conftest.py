# conftest.py — makes pytest add the project root to sys.path
# so `from src.app import ...` works without installing the package.
import sys
import os

sys.path.insert(0, os.path.dirname(__file__))
