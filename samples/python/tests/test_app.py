"""Tests for the sample application."""

import pytest
from src.app import add, greet, app as flask_app
from src.showcase import classify, describe_role, hash_password


@pytest.fixture
def client():
    flask_app.config["TESTING"] = True
    with flask_app.test_client() as c:
        yield c


def test_greet_with_name():
    assert greet("Bertrand") == "Hello, Bertrand!"


def test_greet_empty_falls_back():
    assert greet("") == "Hello, world!"


def test_greet_whitespace_falls_back():
    assert greet("   ") == "Hello, world!"


def test_add_integers():
    assert add(2, 3) == 5


def test_add_floats():
    assert add(1.5, 2.5) == 4.0


def test_add_negative():
    assert add(-1, 1) == 0


def test_health_endpoint(client):
    response = client.get("/health")
    assert response.status_code == 200
    assert response.get_json() == {"status": "ok"}


def test_greet_endpoint(client):
    response = client.get("/greet/world")
    assert response.status_code == 200
    assert "message" in response.get_json()


def test_add_endpoint(client):
    response = client.get("/add/3/4")
    assert response.status_code == 200
    data = response.get_json()
    assert data["result"] == 7


def test_describe_role():
    assert describe_role("administrator") == "administrator"


def test_classify_all_positive():
    assert classify(1, 1, 1, 1) == "all-positive"


def test_classify_unclassified():
    assert classify(0, 0, 0, 0) == "unclassified"


def test_hash_password_is_hex():
    assert len(hash_password("x")) == 32
