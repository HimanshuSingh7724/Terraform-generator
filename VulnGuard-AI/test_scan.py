# cli/vgai_post.py

import requests

url = "http://localhost:8000/scan"
data = {
    "path": "/app/examples/vulnerable_app",
    "dockerfile": "/app/examples/vulnerable_app/Dockerfile",
    "requirements": "/app/examples/vulnerable_app/requirements.txt",
    "apply": False
}

try:
    response = requests.post(url, headers={"Content-Type": "application/json"}, json=data)
    print(response.json())
except requests.exceptions.RequestException as e:
    print(f"Error: {e}")
