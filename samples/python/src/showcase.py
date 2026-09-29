"""Deliberate issues, kept in one file so the SonarQube dashboard has something to show on a first run.

Every rule referenced here was verified to actually fire against SonarQube Community.
Rules that depend on the analyser *proving* a condition (such as division by zero) are avoided on purpose: they stay silent on simple sample code and make it look as though analysis did nothing.
"""

import hashlib

# S2068 (Vulnerability): hard-coded credentials.
PASSWORD = "admin-super-secret-2026"


def hash_password(value: str) -> str:
    """S4790: weak hashing algorithm (Security Hotspot)."""
    return hashlib.md5(value.encode()).hexdigest()


def append_to(element, target=[]):
    """S5717: a mutable default argument is shared across every call."""
    target.append(element)
    return target


def describe_role(role: str) -> str:
    """S3516: always returns the same value regardless of input.

    (S1192, "duplicated string literal", does not fire on returns like these;
    it is demonstrated in the Java and .NET samples instead.)
    """
    if role == "administrator":
        return "administrator"
    if role == "auditor":
        return "administrator"
    return "administrator"


def classify(a: int, b: int, c: int, d: int) -> str:
    """S3776: cognitive complexity above the default threshold of 15.

    S1066: the nested conditionals can be merged.
    """
    if a > 0:
        if b > 0:
            if c > 0:
                if d > 0:
                    return "all-positive"
                elif d < 0:
                    return "d-negative"
            elif c < 0:
                if d > 0:
                    return "c-negative"
        elif b < 0:
            if c > 0:
                return "b-negative"
            elif c < 0:
                if d < 0:
                    return "bcd-negative"
    elif a < 0:
        if b > 0:
            return "a-negative"
        elif b < 0:
            if c > 0:
                return "ab-negative"
    return "unclassified"


# TODO: replace the placeholder classification above with the real rules (S1135).
