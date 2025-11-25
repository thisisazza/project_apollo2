from fastapi.testclient import TestClient
from src.main import app
import os
import pytest

client = TestClient(app)

def test_read_main():
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"message": "Welcome to Project Apollo API", "status": "active"}

def test_model_loading():
    # This test assumes the model file exists. 
    # If the model is lazy loaded or loaded on startup, we might need to trigger the lifespan.
    # TestClient with lifespan should handle startup.
    with TestClient(app) as client:
        # Just checking if the app starts up without error implies model loaded (if we raise on failure)
        response = client.get("/")
        assert response.status_code == 200
