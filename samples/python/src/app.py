"""Minimal Flask application for SonarQube analysis sample."""

from flask import Flask, jsonify

app = Flask(__name__)


def greet(name: str) -> str:
    """Return a greeting string."""
    if not name or not name.strip():
        name = "world"
    return f"Hello, {name}!"


def add(a: int | float, b: int | float) -> int | float:
    """Add two numbers."""
    return a + b


@app.get("/health")
def health():
    return jsonify({"status": "ok"})


@app.get("/greet/<name>")
def greet_endpoint(name: str):
    return jsonify({"message": greet(name)})


@app.get("/add/<int:a>/<int:b>")
def add_endpoint(a: int, b: int):
    return jsonify({"a": a, "b": b, "result": add(a, b)})


if __name__ == "__main__":
    app.run(port=5000)
